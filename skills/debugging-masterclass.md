# Debugging Masterclass (Error Detective)

Algorithm for systematic root cause analysis. "Deduction, not guessing."

## 1. The Algorithm
1.  **Gather Evidence (Сбор улик):**
    *   Logs (`docker logs`, systemd).
    *   Exceptions (Stack traces).
    *   Metrics (CPU, RAM, Disk I/O, Network).
    *   Timestamps (Correlation is key).
2.  **Analyze Context (Анализ контекста):**
    *   What changed? (Deploy, Config, Traffic spike).
    *   What broke first? (Root cause vs Cascade failure).
3.  **Formulate Hypothesis (Гипотеза):**
    *   "The service crashed because of OOM."
    *   "The timeout is due to a locked DB table."
4.  **Verify (Проверка):**
    *   Look for `Exit Code 137` (OOM).
    *   Check DB `pg_locks`.

## 2. Common Patterns
*   **Race Condition:** Intermittent bugs under load. Fix: Locks, Atomic operations.
*   **Memory Leak:** Slow degradation over time. Fix: Profiling, cleanup handles.
*   **Network Partition:** Timeouts, connection refused. Fix: Retries (with backoff), Circuit Breaker.
*   **Slow Queries:** High CPU on DB. Fix: `EXPLAIN ANALYZE`, Indexes.

## 3. Tools Strategy
*   **Grep:** `grep -C 5 "Error" logfile.log` (Context around error).
*   **Logs:** Follow the `Trace ID` across services.
*   **Code:** Don't rewrite blindly. Find the EXACT line from the stack trace first.
