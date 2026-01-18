---
name: saga-orchestration
description: Реализация saga patterns для распределенных транзакций и cross-aggregate workflows. Применяется при координации multi-step бизне�...
---
# Saga Orchestration

## Назначение

Реализация saga patterns для распределенных транзакций и cross-aggregate workflows. Применяется при координации multi-step бизнес-процессов, обработке compensating transactions или управлении long-running workflows.

## Когда использовать

- Координация multi-service транзакций
- Реализация compensating transactions
- Управление long-running бизнес-workflows
- Обработка failures в распределенных системах
- Построение order fulfillment процессов
- Реализация approval workflows
- Выбор между choreography и orchestration
- Distributed transactions без 2PC

## Core Concepts

### 1. Saga Types

```
Choreography                    Orchestration
┌─────┐  ┌─────┐  ┌─────┐     ┌─────────────┐
│Svc A│─►│Svc B│─►│Svc C│     │ Orchestrator│
└─────┘  └─────┘  └─────┘     └──────┬──────┘
   │        │        │               │
   ▼        ▼        ▼         ┌─────┼─────┐
 Event    Event    Event       ▼     ▼     ▼
                            ┌────┐┌────┐┌────┐
                            │Svc1││Svc2││Svc3│
                            └────┘└────┘└────┘
```

### 2. Saga Execution States

| State            | Description                    |
| ---------------- | ------------------------------ |
| **Started**      | Saga initiated                 |
| **Pending**      | Waiting for step completion    |
| **Compensating** | Rolling back due to failure    |
| **Completed**    | All steps succeeded            |
| **Failed**       | Saga failed after compensation |

## Templates

### Template 1: Saga Orchestrator Base

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from enum import Enum
from typing import List, Dict, Any, Optional
from datetime import datetime
import uuid

class SagaState(Enum):
    STARTED = "started"
    PENDING = "pending"
    COMPENSATING = "compensating"
    COMPLETED = "completed"
    FAILED = "failed"


@dataclass
class SagaStep:
    name: str
    action: str
    compensation: str
    status: str = "pending"
    result: Optional[Dict] = None
    error: Optional[str] = None
    executed_at: Optional[datetime] = None
    compensated_at: Optional[datetime] = None


@dataclass
class Saga:
    saga_id: str
    saga_type: str
    state: SagaState
    data: Dict[str, Any]
    steps: List[SagaStep]
    current_step: int = 0
    created_at: datetime = field(default_factory=datetime.utcnow)
    updated_at: datetime = field(default_factory=datetime.utcnow)


class SagaOrchestrator(ABC):
    """Base class for saga orchestrators."""

    def __init__(self, saga_store, event_publisher):
        self.saga_store = saga_store
        self.event_publisher = event_publisher

    @abstractmethod
    def define_steps(self, data: Dict) -> List[SagaStep]:
        """Define the saga steps."""
        pass

    @property
    @abstractmethod
    def saga_type(self) -> str:
        """Unique saga type identifier."""
        pass

    async def start(self, data: Dict) -> Saga:
        """Start a new saga."""
        saga = Saga(
            saga_id=str(uuid.uuid4()),
            saga_type=self.saga_type,
            state=SagaState.STARTED,
            data=data,
            steps=self.define_steps(data)
        )
        await self.saga_store.save(saga)
        await self._execute_next_step(saga)
        return saga

    async def handle_step_completed(self, saga_id: str, step_name: str, result: Dict):
        """Handle successful step completion."""
        saga = await self.saga_store.get(saga_id)

        # Update step
        for step in saga.steps:
            if step.name == step_name:
                step.status = "completed"
                step.result = result
                step.executed_at = datetime.utcnow()
                break

        saga.current_step += 1
        saga.updated_at = datetime.utcnow()

        # Check if saga is complete
        if saga.current_step >= len(saga.steps):
            saga.state = SagaState.COMPLETED
            await self.saga_store.save(saga)
            await self._on_saga_completed(saga)
        else:
            saga.state = SagaState.PENDING
            await self.saga_store.save(saga)
            await self._execute_next_step(saga)

    async def handle_step_failed(self, saga_id: str, step_name: str, error: str):
        """Handle step failure - start compensation."""
        saga = await self.saga_store.get(saga_id)

        # Mark step as failed
        for step in saga.steps:
            if step.name == step_name:
                step.status = "failed"
                step.error = error
                break

        saga.state = SagaState.COMPENSATING
        saga.updated_at = datetime.utcnow()
        await self.saga_store.save(saga)

        # Start compensation from current step backwards
        await self._compensate(saga)

    async def _execute_next_step(self, saga: Saga):
        """Execute the next step in the saga."""
        if saga.current_step >= len(saga.steps):
            return

        step = saga.steps[saga.current_step]
        step.status = "executing"
        await self.saga_store.save(saga)

        # Publish command to execute step
        await self.event_publisher.publish(
            step.action,
            {
                "saga_id": saga.saga_id,
                "step_name": step.name,
                **saga.data
            }
        )

    async def _compensate(self, saga: Saga):
        """Execute compensation for completed steps."""
        # Compensate in reverse order
        for i in range(saga.current_step - 1, -1, -1):
            step = saga.steps[i]
            if step.status == "completed":
                step.status = "compensating"
                await self.saga_store.save(saga)

                await self.event_publisher.publish(
                    step.compensation,
                    {
                        "saga_id": saga.saga_id,
                        "step_name": step.name,
                        "original_result": step.result,
                        **saga.data
                    }
                )

    async def handle_compensation_completed(self, saga_id: str, step_name: str):
        """Handle compensation completion."""
        saga = await self.saga_store.get(saga_id)

        for step in saga.steps:
            if step.name == step_name:
                step.status = "compensated"
                step.compensated_at = datetime.utcnow()
                break

        # Check if all compensations complete
        all_compensated = all(
            s.status in ("compensated", "pending", "failed")
            for s in saga.steps
        )

        if all_compensated:
            saga.state = SagaState.FAILED
            await self._on_saga_failed(saga)

        await self.saga_store.save(saga)

    async def _on_saga_completed(self, saga: Saga):
        """Called when saga completes successfully."""
        await self.event_publisher.publish(
            f"{self.saga_type}Completed",
            {"saga_id": saga.saga_id, **saga.data}
        )

    async def _on_saga_failed(self, saga: Saga):
        """Called when saga fails after compensation."""
        await self.event_publisher.publish(
            f"{self.saga_type}Failed",
            {"saga_id": saga.saga_id, "error": "Saga failed", **saga.data}
        )
```

### Template 2: Order Fulfillment Saga

```python
class OrderFulfillmentSaga(SagaOrchestrator):
    """Orchestrates order fulfillment across services."""

    @property
    def saga_type(self) -> str:
        return "OrderFulfillment"

    def define_steps(self, data: Dict) -> List[SagaStep]:
        return [
            SagaStep(
                name="reserve_inventory",
                action="InventoryService.ReserveItems",
                compensation="InventoryService.ReleaseReservation"
            ),
            SagaStep(
                name="process_payment",
                action="PaymentService.ProcessPayment",
                compensation="PaymentService.RefundPayment"
            ),
            SagaStep(
                name="create_shipment",
                action="ShippingService.CreateShipment",
                compensation="ShippingService.CancelShipment"
            ),
            SagaStep(
                name="send_confirmation",
                action="NotificationService.SendOrderConfirmation",
                compensation="NotificationService.SendCancellationNotice"
            )
        ]


# Usage
async def create_order(order_data: Dict):
    saga = OrderFulfillmentSaga(saga_store, event_publisher)
    return await saga.start({
        "order_id": order_data["order_id"],
        "customer_id": order_data["customer_id"],
        "items": order_data["items"],
        "payment_method": order_data["payment_method"],
        "shipping_address": order_data["shipping_address"]
    })


# Event handlers in each service
class InventoryService:
    async def handle_reserve_items(self, command: Dict):
        try:
            # Reserve inventory
            reservation = await self.reserve(
                command["items"],
                command["order_id"]
            )
            # Report success
            await self.event_publisher.publish(
                "SagaStepCompleted",
                {
                    "saga_id": command["saga_id"],
                    "step_name": "reserve_inventory",
                    "result": {"reservation_id": reservation.id}
                }
            )
        except InsufficientInventoryError as e:
            await self.event_publisher.publish(
                "SagaStepFailed",
                {
                    "saga_id": command["saga_id"],
                    "step_name": "reserve_inventory",
                    "error": str(e)
                }
            )

    async def handle_release_reservation(self, command: Dict):
        # Compensating action
        await self.release_reservation(
            command["original_result"]["reservation_id"]
        )
        await self.event_publisher.publish(
            "SagaCompensationCompleted",
            {
                "saga_id": command["saga_id"],
                "step_name": "reserve_inventory"
            }
        )
```

### Template 3: Choreography-Based Saga

```python
from dataclasses import dataclass
from typing import Dict, Any
import asyncio

@dataclass
class SagaContext:
    """Passed through choreographed saga events."""
    saga_id: str
    step: int
    data: Dict[str, Any]
    completed_steps: list


class OrderChoreographySaga:
    """Choreography-based saga using events."""

    def __init__(self, event_bus):
        self.event_bus = event_bus
        self._register_handlers()

    def _register_handlers(self):
        self.event_bus.subscribe("OrderCreated", self._on_order_created)
        self.event_bus.subscribe("InventoryReserved", self._on_inventory_reserved)
        self.event_bus.subscribe("PaymentProcessed", self._on_payment_processed)
        self.event_bus.subscribe("ShipmentCreated", self._on_shipment_created)

        # Compensation handlers
        self.event_bus.subscribe("PaymentFailed", self._on_payment_failed)
        self.event_bus.subscribe("ShipmentFailed", self._on_shipment_failed)

    async def _on_order_created(self, event: Dict):
        """Step 1: Order created, reserve inventory."""
        await self.event_bus.publish("ReserveInventory", {
            "saga_id": event["order_id"],
            "order_id": event["order_id"],
            "items": event["items"]
        })

    async def _on_inventory_reserved(self, event: Dict):
        """Step 2: Inventory reserved, process payment."""
        await self.event_bus.publish("ProcessPayment", {
            "saga_id": event["saga_id"],
            "order_id": event["order_id"],
            "amount": event["total_amount"],
            "reservation_id": event["reservation_id"]
        })

    async def _on_payment_processed(self, event: Dict):
        """Step 3: Payment done, create shipment."""
        await self.event_bus.publish("CreateShipment", {
            "saga_id": event["saga_id"],
            "order_id": event["order_id"],
            "payment_id": event["payment_id"]
        })

    async def _on_shipment_created(self, event: Dict):
        """Step 4: Complete - send confirmation."""
        await self.event_bus.publish("OrderFulfilled", {
            "saga_id": event["saga_id"],
            "order_id": event["order_id"],
            "tracking_number": event["tracking_number"]
        })

    # Compensation handlers
    async def _on_payment_failed(self, event: Dict):
        """Payment failed - release inventory."""
        await self.event_bus.publish("ReleaseInventory", {
            "saga_id": event["saga_id"],
            "reservation_id": event["reservation_id"]
        })
        await self.event_bus.publish("OrderFailed", {
            "order_id": event["order_id"],
            "reason": "Payment failed"
        })

    async def _on_shipment_failed(self, event: Dict):
        """Shipment failed - refund payment and release inventory."""
        await self.event_bus.publish("RefundPayment", {
            "saga_id": event["saga_id"],
            "payment_id": event["payment_id"]
        })
        await self.event_bus.publish("ReleaseInventory", {
            "saga_id": event["saga_id"],
            "reservation_id": event["reservation_id"]
        })
```

### Template 4: Saga with Timeouts

```python
class TimeoutSagaOrchestrator(SagaOrchestrator):
    """Saga orchestrator with step timeouts."""

    def __init__(self, saga_store, event_publisher, scheduler):
        super().__init__(saga_store, event_publisher)
        self.scheduler = scheduler

    async def _execute_next_step(self, saga: Saga):
        if saga.current_step >= len(saga.steps):
            return

        step = saga.steps[saga.current_step]
        step.status = "executing"
        step.timeout_at = datetime.utcnow() + timedelta(minutes=5)
        await self.saga_store.save(saga)

        # Schedule timeout check
        await self.scheduler.schedule(
            f"saga_timeout_{saga.saga_id}_{step.name}",
            self._check_timeout,
            {"saga_id": saga.saga_id, "step_name": step.name},
            run_at=step.timeout_at
        )

        await self.event_publisher.publish(
            step.action,
            {"saga_id": saga.saga_id, "step_name": step.name, **saga.data}
        )

    async def _check_timeout(self, data: Dict):
        """Check if step has timed out."""
        saga = await self.saga_store.get(data["saga_id"])
        step = next(s for s in saga.steps if s.name == data["step_name"])

        if step.status == "executing":
            # Step timed out - fail it
            await self.handle_step_failed(
                data["saga_id"],
                data["step_name"],
                "Step timed out"
            )
```

## CLI Commands для Saga Orchestration

### Event Store Management

```bash
# EventStoreDB
docker run -d -p 2113:2113 -p 1113:1113 \
  eventstore/eventstore:latest \
  --insecure --run-projections=All

# Просмотр событий
curl http://localhost:2113/streams/saga-order-123 \
  -H "Accept: application/json"

# Append событие
curl -X POST http://localhost:2113/streams/saga-order-123 \
  -H "Content-Type: application/json" \
  -d '[{"eventType":"OrderCreated","data":{"orderId":"123"}}]'
```

### Kafka для Saga Events

```bash
# Создать топики для saga
kafka-topics --create --topic saga-commands --bootstrap-server localhost:9092
kafka-topics --create --topic saga-events --bootstrap-server localhost:9092

# Publish saga command
echo '{"sagaId":"123","command":"StartOrder"}' | \
  kafka-console-producer --topic saga-commands --bootstrap-server localhost:9092

# Consume saga events
kafka-console-consumer --topic saga-events \
  --from-beginning --bootstrap-server localhost:9092
```

### Saga State Monitoring

```bash
# PostgreSQL saga state
psql -d mydb -c "SELECT * FROM sagas WHERE state = 'COMPENSATING';"

# Redis saga state
redis-cli HGETALL saga:order-123

# MongoDB saga state
mongo mydb --eval "db.sagas.find({state: 'PENDING'}).pretty()"
```

### Testing Saga Failures

```bash
# Simulate service failure
curl -X POST http://localhost:8001/api/test/fail-next-request

# Trigger saga
curl -X POST http://localhost:8000/api/orders \
  -H "Content-Type: application/json" \
  -d '{"items":[{"productId":"123","quantity":2}]}'

# Check compensation
curl http://localhost:8000/api/sagas/order-123/status
```

## Best Practices

### Saga Design
1. **Make steps idempotent** - Safe to retry
2. **Design compensations carefully** - Они должны работать
3. **Use correlation IDs** - Для tracing across services
4. **Implement timeouts** - Не жди вечно
5. **Log everything** - Для debugging failures

### Orchestration vs Choreography
6. **Orchestration** - Для complex workflows с central control
7. **Choreography** - Для simple workflows с loose coupling
8. **Hybrid approach** - Комбинируй оба паттерна
9. **Event sourcing** - Для audit trail
10. **CQRS** - Для read/write separation

### Error Handling
11. **Distinguish errors** - Retryable vs non-retryable
12. **Exponential backoff** - Для retries
13. **Dead letter queue** - Для failed messages
14. **Manual intervention** - Для unrecoverable errors
15. **Monitoring alerts** - Для stuck sagas

## Checklist для review

Перед деплоем saga orchestration:
- [ ] Все steps idempotent (safe to retry)
- [ ] Compensations определены для каждого step
- [ ] Compensations тестируются (не только happy path)
- [ ] Timeouts установлены для всех steps
- [ ] Correlation IDs для tracing
- [ ] Saga state persisted (database, event store)
- [ ] Error handling различает retryable/non-retryable
- [ ] Exponential backoff для retries
- [ ] Dead letter queue для failed messages
- [ ] Monitoring для stuck sagas
- [ ] Logging для всех saga events
- [ ] Tests покрывают compensation flows
- [ ] Documentation для saga workflow
- [ ] Rollback strategy определена
- [ ] Manual intervention process документирован

## Антипаттерны

❌ **Non-Idempotent Steps:**
```python
# BAD: Может выполниться дважды
async def reserve_inventory(order_id: str, items: List):
    reservation = Reservation(order_id=order_id, items=items)
    await db.save(reservation)  # Duplicate при retry!
    return reservation.id
```

✅ **Правильно - Idempotent:**
```python
# GOOD: Idempotent с unique constraint
async def reserve_inventory(order_id: str, items: List):
    # Check if already reserved
    existing = await db.reservations.find_one({"order_id": order_id})
    if existing:
        return existing.id
    
    # Reserve only if not exists
    reservation = Reservation(order_id=order_id, items=items)
    await db.save(reservation)
    return reservation.id
```

❌ **Missing Compensation:**
```python
# BAD: Нет compensation logic
class OrderSaga:
    def define_steps(self):
        return [
            SagaStep("reserve_inventory", action=self.reserve),
            SagaStep("charge_payment", action=self.charge),
            # Нет compensation!
        ]
```

✅ **Правильно - With Compensation:**
```python
# GOOD: Compensation для каждого step
class OrderSaga:
    def define_steps(self):
        return [
            SagaStep(
                "reserve_inventory",
                action=self.reserve,
                compensation=self.release_inventory
            ),
            SagaStep(
                "charge_payment",
                action=self.charge,
                compensation=self.refund_payment
            ),
        ]
```

❌ **No Timeout:**
```python
# BAD: Может висеть вечно
async def execute_step(step):
    await step.action()  # Нет timeout!
```

✅ **Правильно - With Timeout:**
```python
# GOOD: Timeout для каждого step
async def execute_step(step):
    try:
        await asyncio.wait_for(
            step.action(),
            timeout=300  # 5 minutes
        )
    except asyncio.TimeoutError:
        await self.handle_timeout(step)
```

❌ **Tight Coupling:**
```python
# BAD: Orchestrator знает детали сервисов
class OrderSaga:
    async def reserve_inventory(self, items):
        # Direct database access!
        for item in items:
            await db.inventory.update(
                {"product_id": item.id},
                {"$inc": {"reserved": item.quantity}}
            )
```

✅ **Правильно - Loose Coupling:**
```python
# GOOD: Orchestrator вызывает сервисы через API/events
class OrderSaga:
    async def reserve_inventory(self, items):
        # Call inventory service
        await self.event_bus.publish(
            "ReserveInventory",
            {"saga_id": self.saga_id, "items": items}
        )
```

## Ресурсы

- **Saga Pattern**: https://microservices.io/patterns/data/saga.html
- **Designing Data-Intensive Applications**: https://dataintensive.net/
- **Event Sourcing**: https://martinfowler.com/eaaDev/EventSourcing.html
- **CQRS**: https://martinfowler.com/bliki/CQRS.html
- **Temporal Sagas**: https://temporal.io/blog/saga-pattern-made-easy
