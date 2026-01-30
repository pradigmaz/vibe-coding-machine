# Performance Optimization Pro

Advanced strategies for System, Algorithm, and Database optimization.

## 1. Algorithmic
*   **Complexity:** Aim for `O(1)` or `O(log n)` (HashMaps, Trees) over `O(n)` or `O(n^2)` (Nested Loops).
*   **Data Structures:** Use `Set`/`Map` for lookups instead of Arrays.

## 2. Database (SQL)
*   **N+1 Problem:** The #1 killer. Fix with `JOIN` or Batching (DataLoader).
*   **Indexes:** Index columns used in `WHERE`, `JOIN`, `ORDER BY`.
*   **Projections:** Select only needed columns (`SELECT id, name` vs `SELECT *`).
*   **Materialized Views:** Pre-calculate complex aggregations for read-heavy data.

## 3. Language Specifics
*   **Node.js:** Avoid blocking Event Loop. Offload CPU tasks to Worker Threads.
*   **Python:** Use Generators/Iterators for large data. Use Vectorization (NumPy) for math.

## 4. Caching Layers
*   **L1 (Memory):** Fast, local, volatile.
*   **L2 (Redis):** Shared, persistent, fast.
*   **L3 (DB):** Source of truth.
*   **Strategy:** Cache-Aside, Write-Through, or TTL based on volatility.

## 5. Workflow
1.  **Measure:** Profile first. Don't guess.
2.  **Bottleneck:** Identify the slowest 20% causing 80% of delay.
3.  **Optimize:** Apply specific technique.
4.  **Verify:** Measure again to prove improvement.
