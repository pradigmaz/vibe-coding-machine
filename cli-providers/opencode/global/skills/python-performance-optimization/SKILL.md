---
name: python-performance-optimization
description: Profile и optimize Python code. Используется backend агентами для debugging slow code, оптимизации bottlenecks, улучшения performance.
---
# Python Performance Optimization Skill

## Назначение

Profile и optimize Python code. Используется backend агентами для debugging slow code, оптимизации bottlenecks, улучшения performance.

## Core Concepts

### Profiling Types
- **CPU Profiling**: Identify time-consuming functions
- **Memory Profiling**: Track memory allocation
- **Line Profiling**: Profile line-by-line
- **Call Graph**: Visualize function calls

## Quick Start

### Basic Timing

```python
import time

def measure_time():
    """Simple timing measurement."""
    start = time.time()
    
    result = sum(range(1000000))
    
    elapsed = time.time() - start
    print(f"Execution time: {elapsed:.4f} seconds")
    return result

# Better: use timeit
import timeit

execution_time = timeit.timeit(
    "sum(range(1000000))",
    number=100
)
print(f"Average time: {execution_time/100:.6f} seconds")
```

## Profiling Tools

### Pattern 1: cProfile - CPU Profiling

```python
import cProfile
import pstats
from pstats import SortKey

def slow_function():
    """Function to profile."""
    total = 0
    for i in range(1000000):
        total += i
    return total

def main():
    """Main function to profile."""
    result = slow_function()
    return result

# Profile the code
if __name__ == "__main__":
    profiler = cProfile.Profile()
    profiler.enable()
    
    main()
    
    profiler.disable()
    
    # Print stats
    stats = pstats.Stats(profiler)
    stats.sort_stats(SortKey.CUMULATIVE)
    stats.print_stats(10)  # Top 10 functions
```

**Command-line profiling:**
```bash
# Profile a script
python -m cProfile -o output.prof script.py

# View results
python -m pstats output.prof
```

### Pattern 2: memory_profiler

```python
# Install: pip install memory-profiler

from memory_profiler import profile

@profile
def memory_intensive():
    """Function that uses lots of memory."""
    big_list = [i for i in range(1000000)]
    big_dict = {i: i**2 for i in range(100000)}
    result = sum(big_list)
    return result

# Run with: python -m memory_profiler script.py
```


## Optimization Patterns

### Pattern 3: List Comprehensions vs Loops

```python
import timeit

# ❌ Slow: Traditional loop
def slow_squares(n):
    result = []
    for i in range(n):
        result.append(i**2)
    return result

# ✅ Fast: List comprehension
def fast_squares(n):
    return [i**2 for i in range(n)]

# Benchmark
n = 100000
slow_time = timeit.timeit(lambda: slow_squares(n), number=100)
fast_time = timeit.timeit(lambda: fast_squares(n), number=100)

print(f"Loop: {slow_time:.4f}s")
print(f"Comprehension: {fast_time:.4f}s")
print(f"Speedup: {slow_time/fast_time:.2f}x")
```

### Pattern 4: Generator Expressions

```python
import sys

# ❌ Memory-intensive list
def list_approach():
    data = [i**2 for i in range(1000000)]
    return sum(data)

# ✅ Memory-efficient generator
def generator_approach():
    data = (i**2 for i in range(1000000))
    return sum(data)

# Memory comparison
list_data = [i for i in range(1000000)]
gen_data = (i for i in range(1000000))

print(f"List size: {sys.getsizeof(list_data)} bytes")
print(f"Generator size: {sys.getsizeof(gen_data)} bytes")
```

### Pattern 5: String Concatenation

```python
import timeit

# ❌ Slow string concatenation
def slow_concat(items):
    result = ""
    for item in items:
        result += str(item)
    return result

# ✅ Fast string concatenation с join
def fast_concat(items):
    return "".join(str(item) for item in items)

items = list(range(10000))

slow = timeit.timeit(lambda: slow_concat(items), number=100)
fast = timeit.timeit(lambda: fast_concat(items), number=100)

print(f"Concatenation (+): {slow:.4f}s")
print(f"Join: {fast:.4f}s")
```

### Pattern 6: Dictionary Lookups vs List Searches

```python
import timeit

# Create test data
size = 10000
items = list(range(size))
lookup_dict = {i: i for i in range(size)}

# ❌ O(n) search in list
def list_search(items, target):
    return target in items

# ✅ O(1) search in dict
def dict_search(lookup_dict, target):
    return target in lookup_dict

target = size - 1  # Worst case

list_time = timeit.timeit(lambda: list_search(items, target), number=1000)
dict_time = timeit.timeit(lambda: dict_search(lookup_dict, target), number=1000)

print(f"List search: {list_time:.6f}s")
print(f"Dict search: {dict_time:.6f}s")
print(f"Speedup: {list_time/dict_time:.0f}x")
```

### Pattern 7: NumPy для Numerical Operations

```python
import timeit
import numpy as np

# ❌ Pure Python
def python_sum(n):
    return sum(range(n))

# ✅ NumPy
def numpy_sum(n):
    return np.arange(n).sum()

n = 1000000

python_time = timeit.timeit(lambda: python_sum(n), number=100)
numpy_time = timeit.timeit(lambda: numpy_sum(n), number=100)

print(f"Python: {python_time:.4f}s")
print(f"NumPy: {numpy_time:.4f}s")
print(f"Speedup: {python_time/numpy_time:.2f}x")
```

### Pattern 8: Caching с functools.lru_cache

```python
from functools import lru_cache
import timeit

# ❌ Without caching
def fibonacci_slow(n):
    if n < 2:
        return n
    return fibonacci_slow(n-1) + fibonacci_slow(n-2)

# ✅ With caching
@lru_cache(maxsize=None)
def fibonacci_fast(n):
    if n < 2:
        return n
    return fibonacci_fast(n-1) + fibonacci_fast(n-2)

n = 30

slow_time = timeit.timeit(lambda: fibonacci_slow(n), number=1)
fast_time = timeit.timeit(lambda: fibonacci_fast(n), number=1000)

print(f"Without cache (1 run): {slow_time:.4f}s")
print(f"With cache (1000 runs): {fast_time:.4f}s")
```

### Pattern 9: Using __slots__

```python
import sys

# ❌ Regular class с __dict__
class RegularClass:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

# ✅ Class с __slots__
class SlottedClass:
    __slots__ = ['x', 'y', 'z']
    
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

regular = RegularClass(1, 2, 3)
slotted = SlottedClass(1, 2, 3)

print(f"Regular class size: {sys.getsizeof(regular)} bytes")
print(f"Slotted class size: {sys.getsizeof(slotted)} bytes")
```

### Pattern 10: Multiprocessing для CPU-Bound

```python
import multiprocessing as mp
import time

def cpu_intensive_task(n):
    """CPU-intensive calculation."""
    return sum(i**2 for i in range(n))

def sequential_processing():
    """Process tasks sequentially."""
    start = time.time()
    results = [cpu_intensive_task(1000000) for _ in range(4)]
    elapsed = time.time() - start
    return elapsed, results

def parallel_processing():
    """Process tasks in parallel."""
    start = time.time()
    with mp.Pool(processes=4) as pool:
        results = pool.map(cpu_intensive_task, [1000000] * 4)
    elapsed = time.time() - start
    return elapsed, results

if __name__ == "__main__":
    seq_time, _ = sequential_processing()
    par_time, _ = parallel_processing()
    
    print(f"Sequential: {seq_time:.2f}s")
    print(f"Parallel: {par_time:.2f}s")
    print(f"Speedup: {seq_time/par_time:.2f}x")
```

## Best Practices

```python
# ✅ GOOD: Profile before optimizing
import cProfile
cProfile.run('main()')

# ✅ GOOD: Use appropriate data structures
user_map = {}  # O(1) lookup
user_set = set()  # O(1) membership

# ✅ GOOD: List comprehensions
squares = [x**2 for x in range(100)]

# ✅ GOOD: Generators для large datasets
data = (x**2 for x in range(1000000))

# ✅ GOOD: Cache expensive computations
@lru_cache(maxsize=None)
def expensive_function(n):
    pass

# ✅ GOOD: NumPy для numerical operations
import numpy as np
result = np.array([1, 2, 3]).sum()

# ❌ BAD: String concatenation в loop
result = ""
for item in items:
    result += str(item)  # Slow!

# ❌ BAD: List search
if item in large_list:  # O(n)
    pass

# ❌ BAD: Nested loops
for i in range(n):
    for j in range(n):  # O(n²)
        pass
```

## Checklist

```
Python Performance Review:
- [ ] Code profiled
- [ ] Bottlenecks identified
- [ ] Appropriate data structures используются
- [ ] List comprehensions вместо loops
- [ ] Generators для large datasets
- [ ] Caching реализован
- [ ] NumPy для numerical operations
- [ ] Multiprocessing для CPU-bound
- [ ] __slots__ для memory optimization
- [ ] String join вместо concatenation
```

## Ресурсы

- [cProfile](https://docs.python.org/3/library/profile.html)
- [memory_profiler](https://pypi.org/project/memory-profiler/)
- [NumPy](https://numpy.org/)
- [py-spy](https://github.com/benfred/py-spy)
