# React Performance Mastery

Strategies for building high-performance React applications.

## 1. Rendering Optimization
*   **React.memo:** Wrap expensive components that receive stable props.
*   **useMemo:** Cache heavy computations (`array.filter`, `sort`, complex math) so they don't run on every render.
*   **useCallback:** Stable function references to prevent child re-renders.

## 2. Bundle Optimization
*   **Code Splitting:** Use `React.lazy()` and `Suspense` for routes and heavy components.
*   **Dynamic Imports:** Import heavy libraries (charts, pdf) only when needed (`await import('...')`).
*   **Tree Shaking:** Use named exports.

## 3. Memory Management
*   **Cleanup:** ALWAYS return a cleanup function from `useEffect`.
    *   `window.removeEventListener`
    *   `clearInterval` / `clearTimeout`
    *   `socket.close()`
    *   Cancel async requests if unmounted.

## 4. Network & Assets
*   **Images:** Use `next/image` for auto-optimization (WebP, lazy load, sizing).
*   **Prefetching:** Prefetch data/routes when user hovers.
*   **Core Web Vitals:** Focus on LCP (Largest Contentful Paint), CLS (Layout Shift), FID (Input Delay).

## 5. Profiling
*   Use **React DevTools Profiler** to find "Why did this render?".
*   Use **Chrome Performance Tab** for low-level analysis.
