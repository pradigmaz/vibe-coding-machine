# Async Python Patterns Skill

## Назначение

Python asyncio и async/await patterns. Используется backend агентами для создания асинхронных API, concurrent систем, I/O-bound приложений.

## Основные концепции

### Event Loop
Сердце asyncio - управляет и планирует асинхронные задачи.

### Coroutines
Функции с `async def`, которые можно приостанавливать и возобновлять.

### Tasks
Запланированные coroutines, которые выполняются конкурентно.

## Quick Start

```python
import asyncio

async def main():
    print("Hello")
    await asyncio.sleep(1)
    print("World")

# Python 3.7+
asyncio.run(main())
```

## Fundamental Patterns

### Pattern 1: Basic Async/Await

```python
import asyncio

async def fetch_data(url: str) -> dict:
    """Fetch data асинхронно."""
    await asyncio.sleep(1)  # Simulate I/O
    return {"url": url, "data": "result"}

async def main():
    result = await fetch_data("https://api.example.com")
    print(result)

asyncio.run(main())
```

### Pattern 2: Concurrent Execution с gather()

```python
import asyncio
from typing import List

async def fetch_user(user_id: int) -> dict:
    """Fetch user data."""
    await asyncio.sleep(0.5)
    return {"id": user_id, "name": f"User {user_id}"}

async def fetch_all_users(user_ids: List[int]) -> List[dict]:
    """Fetch multiple users конкурентно."""
    tasks = [fetch_user(uid) for uid in user_ids]
    results = await asyncio.gather(*tasks)
    return results

async def main():
    user_ids = [1, 2, 3, 4, 5]
    users = await fetch_all_users(user_ids)
    print(f"Fetched {len(users)} users")

asyncio.run(main())
```


### Pattern 3: Error Handling

```python
import asyncio
from typing import List, Optional

async def risky_operation(item_id: int) -> dict:
    """Operation that might fail."""
    await asyncio.sleep(0.1)
    if item_id % 3 == 0:
        raise ValueError(f"Item {item_id} failed")
    return {"id": item_id, "status": "success"}

async def safe_operation(item_id: int) -> Optional[dict]:
    """Wrapper с error handling."""
    try:
        return await risky_operation(item_id)
    except ValueError as e:
        print(f"Error: {e}")
        return None

async def process_items(item_ids: List[int]):
    """Process multiple items с error handling."""
    tasks = [safe_operation(iid) for iid in item_ids]
    results = await asyncio.gather(*tasks, return_exceptions=True)
    
    successful = [r for r in results if r is not None and not isinstance(r, Exception)]
    failed = [r for r in results if isinstance(r, Exception)]
    
    print(f"Success: {len(successful)}, Failed: {len(failed)}")
    return successful

asyncio.run(process_items([1, 2, 3, 4, 5, 6]))
```

### Pattern 4: Timeout Handling

```python
import asyncio

async def slow_operation(delay: int) -> str:
    """Operation that takes time."""
    await asyncio.sleep(delay)
    return f"Completed after {delay}s"

async def with_timeout():
    """Execute operation с timeout."""
    try:
        result = await asyncio.wait_for(slow_operation(5), timeout=2.0)
        print(result)
    except asyncio.TimeoutError:
        print("Operation timed out")

asyncio.run(with_timeout())
```

## Advanced Patterns

### Pattern 5: Async Context Managers

```python
import asyncio
from typing import Optional

class AsyncDatabaseConnection:
    """Async database connection context manager."""
    
    def __init__(self, dsn: str):
        self.dsn = dsn
        self.connection: Optional[object] = None
    
    async def __aenter__(self):
        print("Opening connection")
        await asyncio.sleep(0.1)
        self.connection = {"dsn": self.dsn, "connected": True}
        return self.connection
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        print("Closing connection")
        await asyncio.sleep(0.1)
        self.connection = None

async def query_database():
    """Use async context manager."""
    async with AsyncDatabaseConnection("postgresql://localhost") as conn:
        print(f"Using connection: {conn}")
        await asyncio.sleep(0.2)
        return {"rows": 10}

asyncio.run(query_database())
```

### Pattern 6: Async Iterators

```python
import asyncio
from typing import AsyncIterator

async def async_range(start: int, end: int, delay: float = 0.1) -> AsyncIterator[int]:
    """Async generator."""
    for i in range(start, end):
        await asyncio.sleep(delay)
        yield i

async def fetch_pages(url: str, max_pages: int) -> AsyncIterator[dict]:
    """Fetch paginated data асинхронно."""
    for page in range(1, max_pages + 1):
        await asyncio.sleep(0.2)
        yield {
            "page": page,
            "url": f"{url}?page={page}",
            "data": [f"item_{page}_{i}" for i in range(5)]
        }

async def consume_async_iterator():
    """Consume async iterator."""
    async for number in async_range(1, 5):
        print(f"Number: {number}")
    
    async for page_data in fetch_pages("https://api.example.com/items", 3):
        print(f"Page {page_data['page']}: {len(page_data['data'])} items")

asyncio.run(consume_async_iterator())
```

### Pattern 7: Producer-Consumer

```python
import asyncio
from asyncio import Queue

async def producer(queue: Queue, producer_id: int, num_items: int):
    """Produce items."""
    for i in range(num_items):
        item = f"Item-{producer_id}-{i}"
        await queue.put(item)
        print(f"Producer {producer_id} produced: {item}")
        await asyncio.sleep(0.1)
    await queue.put(None)

async def consumer(queue: Queue, consumer_id: int):
    """Consume items."""
    while True:
        item = await queue.get()
        if item is None:
            queue.task_done()
            break
        
        print(f"Consumer {consumer_id} processing: {item}")
        await asyncio.sleep(0.2)
        queue.task_done()

async def producer_consumer_example():
    """Run producer-consumer pattern."""
    queue = Queue(maxsize=10)
    
    producers = [
        asyncio.create_task(producer(queue, i, 5))
        for i in range(2)
    ]
    
    consumers = [
        asyncio.create_task(consumer(queue, i))
        for i in range(3)
    ]
    
    await asyncio.gather(*producers)
    await queue.join()
    
    for c in consumers:
        c.cancel()

asyncio.run(producer_consumer_example())
```

### Pattern 8: Semaphore для Rate Limiting

```python
import asyncio
from typing import List

async def api_call(url: str, semaphore: asyncio.Semaphore) -> dict:
    """Make API call с rate limiting."""
    async with semaphore:
        print(f"Calling {url}")
        await asyncio.sleep(0.5)
        return {"url": url, "status": 200}

async def rate_limited_requests(urls: List[str], max_concurrent: int = 5):
    """Make multiple requests с rate limiting."""
    semaphore = asyncio.Semaphore(max_concurrent)
    tasks = [api_call(url, semaphore) for url in urls]
    results = await asyncio.gather(*tasks)
    return results

async def main():
    urls = [f"https://api.example.com/item/{i}" for i in range(20)]
    results = await rate_limited_requests(urls, max_concurrent=3)
    print(f"Completed {len(results)} requests")

asyncio.run(main())
```

## Real-World Applications

### Web Scraping с aiohttp

```python
import asyncio
import aiohttp
from typing import List, Dict

async def fetch_url(session: aiohttp.ClientSession, url: str) -> Dict:
    """Fetch single URL."""
    try:
        async with session.get(url, timeout=aiohttp.ClientTimeout(total=10)) as response:
            text = await response.text()
            return {
                "url": url,
                "status": response.status,
                "length": len(text)
            }
    except Exception as e:
        return {"url": url, "error": str(e)}

async def scrape_urls(urls: List[str]) -> List[Dict]:
    """Scrape multiple URLs конкурентно."""
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
        return results

async def main():
    urls = [
        "https://httpbin.org/delay/1",
        "https://httpbin.org/delay/2",
        "https://httpbin.org/status/404",
    ]
    
    results = await scrape_urls(urls)
    for result in results:
        print(result)

asyncio.run(main())
```

## Best Practices

```python
# ✅ GOOD: Используй asyncio.run() для entry point
asyncio.run(main())

# ✅ GOOD: Always await coroutines
result = await async_function()

# ✅ GOOD: Use gather() для concurrent execution
results = await asyncio.gather(task1(), task2(), task3())

# ✅ GOOD: Implement proper error handling
try:
    result = await risky_operation()
except Exception as e:
    logger.error(f"Error: {e}")

# ✅ GOOD: Use timeouts
result = await asyncio.wait_for(operation(), timeout=5.0)

# ✅ GOOD: Use semaphores для rate limiting
semaphore = asyncio.Semaphore(10)
async with semaphore:
    await api_call()

# ❌ BAD: Забыли await
result = async_function()  # Returns coroutine, не выполняется!

# ❌ BAD: Blocking event loop
import time
async def bad():
    time.sleep(1)  # Blocks!

# ✅ GOOD: Non-blocking
async def good():
    await asyncio.sleep(1)
```

## Common Pitfalls

### ❌ Forgetting await
```python
# NO!
result = async_function()  # Coroutine object
```

### ❌ Blocking Event Loop
```python
# NO!
import time
async def bad():
    time.sleep(1)  # Blocks!
```

### ❌ Not Handling Cancellation
```python
# NO!
async def task():
    while True:
        await asyncio.sleep(1)
    # Не обрабатывает CancelledError
```

## Checklist

```
Async Python Review:
- [ ] Используется asyncio.run() для entry point
- [ ] Все coroutines awaited
- [ ] gather() для concurrent operations
- [ ] Error handling реализован
- [ ] Timeouts используются
- [ ] Semaphores для rate limiting
- [ ] Нет blocking operations в async code
- [ ] Cancellation обрабатывается
- [ ] Connection pools используются
- [ ] Async context managers для resources
```

## Ресурсы

- [Python asyncio documentation](https://docs.python.org/3/library/asyncio.html)
- [aiohttp](https://docs.aiohttp.org/)
- [FastAPI](https://fastapi.tiangolo.com/)
- [asyncpg](https://github.com/MagicStack/asyncpg)
