# TypeScript Pro & Next.js Architecture

Best practices for strict TypeScript and scalable Next.js App Router applications.

## 1. Strict TypeScript Rules
*   **NO `any`:** Use `unknown` + narrowing if input is uncertain.
*   **Validation:** All external data (API, User Input, URL params) MUST be validated with **Zod**.
*   **Generics:** Use `<T>` for reusable components/functions.
*   **Immutability:** Prefer `const`, spread syntax, and readonly types.

## 2. Next.js App Router Structure
*   `app/` - Routing (Pages, Layouts).
*   `components/` - Reusable UI (Button, Card).
*   `lib/` - Utilities (utils, helpers).
*   `hooks/` - Custom React hooks.
*   `types/` - Shared type definitions (if not colocated).

## 3. Server vs Client Components
*   **Server Components (`default`):**
    *   Fetching data (DB, API).
    *   Sensitive logic (Secrets).
    *   Heavy dependencies.
*   **Client Components (`'use client'`):**
    *   Interactivity (`onClick`, `onChange`).
    *   State (`useState`, `useEffect`).
    *   Browser APIs (`window`, `localStorage`).

## 4. Data Fetching
*   Use `fetch` with caching options (`{ next: { revalidate: 3600 } }`).
*   Use `Suspense` for streaming UI while loading.
*   Validate responses with Zod schemas: `UserSchema.parse(data)`.

## 5. Route Handlers (API)
*   Validate request body/params immediately.
*   Return typed `NextResponse`.
*   Handle errors gracefully (try/catch + appropriate status codes).
