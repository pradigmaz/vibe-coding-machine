# Tailwind 4 Skill

## Назначение

Tailwind CSS 4 patterns и best practices. Используется frontend агентами при работе со стилями.

## Критические правила

### Never Use var() in className

```typescript
// ❌ BAD: var() в className
<div className="bg-[var(--color-primary)]" />
<div className="text-[var(--text-color)]" />

// ✅ GOOD: Tailwind semantic classes
<div className="bg-primary" />
<div className="text-slate-400" />
```

### Never Use Hex Colors

```typescript
// ❌ BAD: Hex colors в className
<p className="text-[#ffffff]" />
<div className="bg-[#1e293b]" />

// ✅ GOOD: Tailwind color classes
<p className="text-white" />
<div className="bg-slate-800" />
```

### Never Use Inline Styles (кроме dynamic values)

```typescript
// ❌ BAD: Inline styles для статичных значений
<div style={{ padding: '16px', display: 'flex' }} />

// ✅ GOOD: Tailwind classes
<div className="p-4 flex" />

// ✅ GOOD: Inline styles только для dynamic values
<div style={{ width: `${percentage}%` }} />
<div style={{ opacity: isVisible ? 1 : 0 }} />
```

## cn() Utility

```typescript
import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

### Когда использовать cn()

```typescript
// ✅ GOOD: Conditional classes
<div className={cn("base-class", isActive && "active-class")} />

// ✅ GOOD: Merging с потенциальными конфликтами
<button className={cn("px-4 py-2", className)} />

// ✅ GOOD: Multiple conditions
<div className={cn(
  "rounded-lg border",
  variant === "primary" && "bg-blue-500 text-white",
  variant === "secondary" && "bg-gray-200 text-gray-800",
  disabled && "opacity-50 cursor-not-allowed"
)} />

// ❌ BAD: Статичные классы - не нужен wrapper
<div className={cn("flex items-center gap-2")} />

// ✅ GOOD: Просто className
<div className="flex items-center gap-2" />
```

## Common Patterns

### Layout

```typescript
// Flexbox
<div className="flex items-center justify-between gap-4" />
<div className="flex flex-col gap-2" />
<div className="inline-flex items-center" />

// Grid
<div className="grid grid-cols-3 gap-4" />
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6" />

// Container
<div className="container mx-auto px-4" />
<div className="max-w-7xl mx-auto" />
```

### Spacing

```typescript
// Padding
<div className="p-4" />           // All sides
<div className="px-4 py-2" />     // Horizontal, vertical
<div className="pt-4 pb-2" />     // Top, bottom

// Margin
<div className="m-4" />
<div className="mx-auto" />       // Center horizontally
<div className="mt-8 mb-4" />

// Gap (для flex/grid)
<div className="flex gap-4" />
<div className="grid gap-x-4 gap-y-2" />
```

### Typography

```typescript
// Размеры
<h1 className="text-2xl font-bold" />
<p className="text-sm text-slate-400" />
<span className="text-xs font-medium uppercase tracking-wide" />

// Цвета
<p className="text-white" />
<p className="text-slate-400" />
<p className="text-red-500" />

// Выравнивание
<p className="text-center" />
<p className="text-left" />
<p className="text-right" />

// Line height
<p className="leading-tight" />
<p className="leading-normal" />
<p className="leading-loose" />
```

### Colors

```typescript
// Background
<div className="bg-white" />
<div className="bg-slate-900" />
<div className="bg-blue-500" />

// Text
<p className="text-white" />
<p className="text-slate-400" />
<p className="text-blue-500" />

// Border
<div className="border border-slate-700" />
<div className="border-2 border-blue-500" />
```

### Borders & Shadows

```typescript
// Borders
<div className="border border-slate-700" />
<div className="border-t border-b" />
<div className="border-2 border-blue-500" />

// Rounded
<div className="rounded" />
<div className="rounded-lg" />
<div className="rounded-full" />

// Shadows
<div className="shadow" />
<div className="shadow-lg" />
<div className="shadow-xl" />

// Ring (для focus states)
<input className="ring-2 ring-blue-500 ring-offset-2" />
```

### States

```typescript
// Hover
<button className="hover:bg-blue-600" />
<a className="hover:underline" />

// Focus
<input className="focus:border-blue-500 focus:outline-none" />
<button className="focus:ring-2 focus:ring-blue-500" />

// Active
<button className="active:scale-95" />

// Disabled
<button className="disabled:opacity-50 disabled:cursor-not-allowed" />

// Group hover
<div className="group">
  <span className="group-hover:opacity-100" />
</div>
```

### Responsive Design

```typescript
// Breakpoints: sm (640px), md (768px), lg (1024px), xl (1280px), 2xl (1536px)

// Width
<div className="w-full md:w-1/2 lg:w-1/3" />

// Display
<div className="hidden md:block" />
<div className="block md:hidden" />

// Text size
<p className="text-sm md:text-base lg:text-lg" />

// Grid columns
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3" />

// Padding
<div className="p-4 md:p-6 lg:p-8" />
```

### Dark Mode

```typescript
// Dark mode classes
<div className="bg-white dark:bg-slate-900" />
<p className="text-gray-900 dark:text-white" />
<div className="border-gray-200 dark:border-gray-700" />

// Conditional dark mode
<div className={cn(
  "bg-white text-black",
  "dark:bg-slate-900 dark:text-white"
)} />
```

## Dynamic Values

```typescript
// ✅ GOOD: style prop для truly dynamic values
<div style={{ width: `${percentage}%` }} />
<div style={{ opacity: isVisible ? 1 : 0 }} />
<div style={{ transform: `translateX(${offset}px)` }} />

// ✅ GOOD: CSS custom properties для theming
<div 
  style={{ 
    '--progress': `${value}%` 
  } as React.CSSProperties}
  className="w-full h-2 bg-gray-200"
>
  <div 
    className="h-full bg-blue-500 transition-all"
    style={{ width: 'var(--progress)' }}
  />
</div>
```

## Chart/Library Constants

Когда библиотеки не принимают className (например, Recharts):

```typescript
// ✅ GOOD: Constants с var() - ТОЛЬКО для library props
const CHART_COLORS = {
  primary: "var(--color-primary)",
  secondary: "var(--color-secondary)",
  text: "var(--color-text)",
  gridLine: "var(--color-border)",
};

// Usage с Recharts (не может использовать className)
<XAxis tick={{ fill: CHART_COLORS.text }} />
<CartesianGrid stroke={CHART_COLORS.gridLine} />
<Line stroke={CHART_COLORS.primary} />
```

## Arbitrary Values (Escape Hatch)

```typescript
// ✅ OK: Для one-off значений не в design system
<div className="w-[327px]" />
<div className="top-[117px]" />
<div className="grid-cols-[1fr_2fr_1fr]" />

// ❌ BAD: Для цветов - используй theme
<div className="bg-[#1e293b]" />  // NO! Используй bg-slate-800
```

## Component Patterns

### Button Variants

```typescript
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  className?: string;
}

function Button({ variant = 'primary', size = 'md', disabled, className, ...props }: ButtonProps) {
  return (
    <button
      className={cn(
        // Base styles
        "rounded font-medium transition-colors",
        
        // Variants
        variant === 'primary' && "bg-blue-500 text-white hover:bg-blue-600",
        variant === 'secondary' && "bg-gray-200 text-gray-800 hover:bg-gray-300",
        variant === 'ghost' && "bg-transparent hover:bg-gray-100",
        
        // Sizes
        size === 'sm' && "px-3 py-1.5 text-sm",
        size === 'md' && "px-4 py-2 text-base",
        size === 'lg' && "px-6 py-3 text-lg",
        
        // States
        disabled && "opacity-50 cursor-not-allowed",
        
        // Custom classes
        className
      )}
      disabled={disabled}
      {...props}
    />
  );
}
```

### Card Component

```typescript
function Card({ className, children, ...props }: CardProps) {
  return (
    <div
      className={cn(
        "rounded-lg border border-slate-700 bg-slate-800 p-6 shadow-lg",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}
```

## Checklist

```
Tailwind Review:
- [ ] Нет var() в className
- [ ] Нет hex colors в className
- [ ] Нет inline styles для статичных значений
- [ ] cn() используется только для conditional classes
- [ ] Responsive classes используются правильно
- [ ] Dark mode поддержан где нужно
- [ ] Semantic color classes (slate-400, не #94a3b8)
- [ ] Arbitrary values только для one-off случаев
```

## Антипаттерны

### ❌ var() в className
```typescript
// NO!
<div className="bg-[var(--color)]" />
```

### ❌ Hex colors
```typescript
// NO!
<div className="text-[#ffffff]" />
```

### ❌ Inline styles для статики
```typescript
// NO!
<div style={{ padding: '16px' }} />
```

### ❌ cn() для статичных классов
```typescript
// NO!
<div className={cn("flex items-center")} />
```

## Ресурсы

- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Tailwind UI](https://tailwindui.com/)
- [Headless UI](https://headlessui.com/)
