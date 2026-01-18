---
name: nextjs-app-router-patterns
description: Паттерны Next.js 14+ App Router с Server Components, streaming, parallel routes и продвинутым data fetching. Используется frontend агентами при рабо�...
---
# Next.js App Router Patterns Skill

## Назначение

Паттерны Next.js 14+ App Router с Server Components, streaming, parallel routes и продвинутым data fetching. Используется frontend агентами при работе с Next.js приложениями.

## Когда использовать

- Создание новых Next.js приложений с App Router
- Миграция с Pages Router на App Router
- Реализация Server Components и streaming
- Настройка parallel и intercepting routes
- Оптимизация data fetching и caching
- Создание full-stack features с Server Actions

## Основные концепции

### Режимы рендеринга

| Режим | Где | Когда использовать |
|-------|-----|-------------------|
| **Server Components** | Только сервер | Data fetching, тяжёлые вычисления, секреты |
| **Client Components** | Браузер | Интерактивность, хуки, browser APIs |
| **Static** | Build time | Контент, который редко меняется |
| **Dynamic** | Request time | Персонализированные или real-time данные |
| **Streaming** | Progressive | Большие страницы, медленные источники данных |

### File Conventions

```
app/
├── layout.tsx       # Shared UI wrapper
├── page.tsx         # Route UI
├── loading.tsx      # Loading UI (Suspense)
├── error.tsx        # Error boundary
├── not-found.tsx    # 404 UI
├── route.ts         # API endpoint
├── template.tsx     # Re-mounted layout
├── default.tsx      # Parallel route fallback
└── opengraph-image.tsx  # OG image generation
```

## Quick Start

```typescript
// app/layout.tsx
import { Inter } from 'next/font/google'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: { default: 'My App', template: '%s | My App' },
  description: 'Built with Next.js App Router',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>{children}</body>
    </html>
  )
}

// app/page.tsx - Server Component по умолчанию
async function getProducts() {
  const res = await fetch('https://api.example.com/products', {
    next: { revalidate: 3600 }, // ISR: revalidate каждый час
  })
  return res.json()
}

export default async function HomePage() {
  const products = await getProducts()

  return (
    <main>
      <h1>Products</h1>
      <ProductGrid products={products} />
    </main>
  )
}
```

## Паттерны

### Pattern 1: Server Components с Data Fetching

```typescript
// app/products/page.tsx
import { Suspense } from 'react'

interface SearchParams {
  category?: string
  sort?: 'price' | 'name' | 'date'
  page?: string
}

export default async function ProductsPage({
  searchParams,
}: {
  searchParams: Promise<SearchParams>
}) {
  const params = await searchParams

  return (
    <div className="flex gap-8">
      <FilterSidebar />
      <Suspense
        key={JSON.stringify(params)}
        fallback={<ProductListSkeleton />}
      >
        <ProductList
          category={params.category}
          sort={params.sort}
          page=Number(params.page) || 1}
        />
      </Suspense>
    </div>
  )
}

// components/products/ProductList.tsx - Server Component
async function getProducts(filters: ProductFilters) {
  const res = await fetch(
    `${process.env.API_URL}/products?${new URLSearchParams(filters)}`,
    { next: { tags: ['products'] } }
  )
  if (!res.ok) throw new Error('Failed to fetch products')
  return res.json()
}

export async function ProductList({ category, sort, page }: ProductFilters) {
  const { products, totalPages } = await getProducts({ category, sort, page })

  return (
    <div>
      <div className="grid grid-cols-3 gap-4">
        {products.map((product) => (
          <ProductCard key={product.id} product={product} />
        ))}
      </div>
      <Pagination currentPage={page} totalPages={totalPages} />
    </div>
  )
}
```

### Pattern 2: Client Components с 'use client'

```typescript
// components/products/AddToCartButton.tsx
'use client'

import { useState, useTransition } from 'react'
import { addToCart } from '@/app/actions/cart'

export function AddToCartButton({ productId }: { productId: string }) {
  const [isPending, startTransition] = useTransition()
  const [error, setError] = useState<string | null>(null)

  const handleClick = () => {
    setError(null)
    startTransition(async () => {
      const result = await addToCart(productId)
      if (result.error) {
        setError(result.error)
      }
    })
  }

  return (
    <div>
      <button
        onClick={handleClick}
        disabled={isPending}
        className="btn-primary"
      >
        {isPending ? 'Adding...' : 'Add to Cart'}
      </button>
      {error && <p className="text-red-500 text-sm">{error}</p>}
    </div>
  )
}
```

### Pattern 3: Server Actions

```typescript
// app/actions/cart.ts
'use server'

import { revalidateTag } from 'next/cache'
import { cookies } from 'next/headers'
import { redirect } from 'next/navigation'

export async function addToCart(productId: string) {
  const cookieStore = await cookies()
  const sessionId = cookieStore.get('session')?.value

  if (!sessionId) {
    redirect('/login')
  }

  try {
    await db.cart.upsert({
      where: { sessionId_productId: { sessionId, productId } },
      update: { quantity: { increment: 1 } },
      create: { sessionId, productId, quantity: 1 },
    })

    revalidateTag('cart')
    return { success: true }
  } catch (error) {
    return { error: 'Failed to add item to cart' }
  }
}

export async function checkout(formData: FormData) {
  const address = formData.get('address') as string
  const payment = formData.get('payment') as string

  if (!address || !payment) {
    return { error: 'Missing required fields' }
  }

  const order = await processOrder({ address, payment })
  redirect(`/orders/${order.id}/confirmation`)
}
```

### Pattern 4: Parallel Routes

```typescript
// app/dashboard/layout.tsx
export default function DashboardLayout({
  children,
  analytics,
  team,
}: {
  children: React.ReactNode
  analytics: React.ReactNode
  team: React.ReactNode
}) {
  return (
    <div className="dashboard-grid">
      <main>{children}</main>
      <aside className="analytics-panel">{analytics}</aside>
      <aside className="team-panel">{team}</aside>
    </div>
  )
}

// app/dashboard/@analytics/page.tsx
export default async function AnalyticsSlot() {
  const stats = await getAnalytics()
  return <AnalyticsChart data={stats} />
}

// app/dashboard/@analytics/loading.tsx
export default function AnalyticsLoading() {
  return <ChartSkeleton />
}
```

### Pattern 5: Intercepting Routes (Modal Pattern)

```typescript
// Структура для photo modal
// app/
// ├── @modal/
// │   ├── (.)photos/[id]/page.tsx  # Intercept
// │   └── default.tsx
// ├── photos/
// │   └── [id]/page.tsx            # Full page
// └── layout.tsx

// app/@modal/(.)photos/[id]/page.tsx
import { Modal } from '@/components/Modal'

export default async function PhotoModal({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  const photo = await getPhoto(id)

  return (
    <Modal>
      <PhotoDetail photo={photo} />
    </Modal>
  )
}

// app/layout.tsx
export default function RootLayout({
  children,
  modal,
}: {
  children: React.ReactNode
  modal: React.ReactNode
}) {
  return (
    <html>
      <body>
        {children}
        {modal}
      </body>
    </html>
  )
}
```

### Pattern 6: Streaming с Suspense

```typescript
// app/product/[id]/page.tsx
import { Suspense } from 'react'

export default async function ProductPage({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  const product = await getProduct(id) // Загружается первым (blocking)

  return (
    <div>
      {/* Немедленный рендер */}
      <ProductHeader product={product} />

      {/* Stream reviews */}
      <Suspense fallback={<ReviewsSkeleton />}>
        <Reviews productId={id} />
      </Suspense>

      {/* Stream recommendations */}
      <Suspense fallback={<RecommendationsSkeleton />}>
        <Recommendations productId={id} />
      </Suspense>
    </div>
  )
}

// Эти компоненты загружают свои данные
async function Reviews({ productId }: { productId: string }) {
  const reviews = await getReviews(productId) // Медленный API
  return <ReviewList reviews={reviews} />
}
```

### Pattern 7: Route Handlers (API Routes)

```typescript
// app/api/products/route.ts
import { NextRequest, NextResponse } from 'next/server'

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams
  const category = searchParams.get('category')

  const products = await db.product.findMany({
    where: category ? { category } : undefined,
    take: 20,
  })

  return NextResponse.json(products)
}

export async function POST(request: NextRequest) {
  const body = await request.json()
  const product = await db.product.create({ data: body })
  return NextResponse.json(product, { status: 201 })
}

// app/api/products/[id]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params
  const product = await db.product.findUnique({ where: { id } })

  if (!product) {
    return NextResponse.json(
      { error: 'Product not found' },
      { status: 404 }
    )
  }

  return NextResponse.json(product)
}
```

### Pattern 8: Metadata и SEO

```typescript
// app/products/[slug]/page.tsx
import { Metadata } from 'next'
import { notFound } from 'next/navigation'

type Props = {
  params: Promise<{ slug: string }>
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params
  const product = await getProduct(slug)

  if (!product) return {}

  return {
    title: product.name,
    description: product.description,
    openGraph: {
      title: product.name,
      description: product.description,
      images: [{ url: product.image, width: 1200, height: 630 }],
    },
    twitter: {
      card: 'summary_large_image',
      title: product.name,
      images: [product.image],
    },
  }
}

export async function generateStaticParams() {
  const products = await db.product.findMany({ select: { slug: true } })
  return products.map((p) => ({ slug: p.slug }))
}

export default async function ProductPage({ params }: Props) {
  const { slug } = await params
  const product = await getProduct(slug)

  if (!product) notFound()

  return <ProductDetail product={product} />
}
```

## Caching Strategies

```typescript
// No cache (всегда свежие данные)
fetch(url, { cache: 'no-store' })

// Cache forever (static)
fetch(url, { cache: 'force-cache' })

// ISR - revalidate после 60 секунд
fetch(url, { next: { revalidate: 60 } })

// Tag-based invalidation
fetch(url, { next: { tags: ['products'] } })

// Invalidate через Server Action
'use server'
import { revalidateTag, revalidatePath } from 'next/cache'

export async function updateProduct(id: string, data: ProductData) {
  await db.product.update({ where: { id }, data })
  revalidateTag('products')
  revalidatePath('/products')
}
```

## Best Practices

### ✅ DO

- **Начинай с Server Components** - Добавляй 'use client' только когда нужно
- **Colocate data fetching** - Загружай данные там, где используешь
- **Используй Suspense boundaries** - Включай streaming для медленных данных
- **Используй parallel routes** - Независимые loading states
- **Используй Server Actions** - Для mutations с progressive enhancement

### ❌ DON'T

- **Не передавай non-serializable data** - Server → Client boundary ограничения
- **Не используй хуки в Server Components** - Нет useState, useEffect
- **Не fetch в Client Components** - Используй Server Components
- **Не over-nest layouts** - Каждый layout добавляет в component tree
- **Не игнорируй loading states** - Всегда предоставляй loading.tsx или Suspense

## Checklist

```
Next.js App Router Review:
- [ ] Server Components по умолчанию
- [ ] 'use client' только когда нужно (state, effects, events)
- [ ] Data fetching в Server Components
- [ ] Suspense для streaming
- [ ] Loading states (loading.tsx или Suspense)
- [ ] Error boundaries (error.tsx)
- [ ] Metadata для SEO
- [ ] Caching strategy определена
- [ ] Server Actions для mutations
```

## Ресурсы

- [Next.js App Router Documentation](https://nextjs.org/docs/app)
- [Server Components RFC](https://github.com/reactjs/rfcs/blob/main/text/0188-server-components.md)
- [Vercel Templates](https://vercel.com/templates/next.js)
