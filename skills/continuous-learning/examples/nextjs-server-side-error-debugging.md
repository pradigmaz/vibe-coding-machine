# Next.js Server-Side Error Debugging Skill

## Назначение

Debug getServerSideProps и getStaticProps ошибок в Next.js. Используется когда:
- Страница показывает generic error но browser console пустой
- API routes возвращают 500 без деталей
- Server-side код падает silently
- Ошибка только при refresh, не при client navigation

## Проблема

Server-side ошибки в Next.js не появляются в browser console. Browser показывает generic error page или 500 status, но нет stack trace или полезной информации в DevTools.

## Trigger Conditions

- Страница показывает "Internal Server Error" или custom error page
- Browser console пустой или только generic fetch failure
- Используется `getServerSideProps`, `getStaticProps`, или API routes
- Ошибка только при page refresh или direct navigation (не client-side transitions)
- Ошибка intermittent и сложно воспроизвести в browser

**Misleading симптомы**:
- "Unhandled Runtime Error" modal без реальной причины
- Network tab показывает 500 но response body пустой
- Ошибка исчезает когда добавляешь console.log (timing issue)

## Решение

### Шаг 1: Проверь терминал

Реальная ошибка с полным stack trace в терминале где запущен `npm run dev` или `next dev`. Это **первое место куда смотреть**.

```bash
# Если не видишь терминал, найди процесс
ps aux | grep next
# Или перезапусти с видимым output
npm run dev
```

### Шаг 2: Добавь явный error handling

Для persistent debugging оберни server-side код в try-catch:

```typescript
export async function getServerSideProps(context) {
  try {
    const data = await fetchSomething();
    return { props: { data } };
  } catch (error) {
    console.error('getServerSideProps error:', error);
    // Верни error state вместо throw
    return { props: { error: error.message } };
  }
}
```

### Шаг 3: Production ошибки

Проверь логи хостинг провайдера:
- **Vercel**: Dashboard → Project → Logs (Functions tab)
- **AWS**: CloudWatch Logs
- **Netlify**: Functions tab в dashboard
- **Self-hosted**: Логи Node.js процесса

### Шаг 4: Частые причины

1. **Environment variables**: Отсутствуют в production но есть локально
2. **Database connections**: Проблемы с connection string, cold starts
3. **Import errors**: Server-only код случайно импортирован на client
4. **Async/await**: Пропущен await на async операциях
5. **JSON serialization**: Объекты которые нельзя serialize (dates, functions)

## Проверка

После проверки терминала должен увидеть:
- Полный stack trace с именем файла и номером строки
- Реальное error message (не generic 500)
- Значения переменных если добавил console.log

## Пример

**Симптом**: Пользователь сообщает что страница показывает "Internal Server Error" после клика на ссылку.

**Исследование**:
1. Открыл browser DevTools → Console: Пусто
2. Network tab показывает: `GET /dashboard → 500`
3. Проверил терминал где запущен `npm run dev`:

```
Error: Cannot read property 'id' of undefined
    at getServerSideProps (/app/pages/dashboard.tsx:15:25)
    at renderToHTML (/app/node_modules/next/dist/server/render.js:428:22)
```

**Причина найдена**: Database query вернул `null` вместо user объекта.

## Заметки

- В development Next.js иногда показывает error overlay, но часто с меньшими деталями чем terminal output
- `reactStrictMode: true` в `next.config.js` вызывает double-execution server функций в development, что может запутать debugging
- Для API routes ошибка появляется в том же терминале что и page errors
- Client-side ошибки (в useEffect, event handlers) ПОЯВЛЯЮТСЯ в browser console — этот skill только для server-side кода
- Если используешь `next start` (production mode локально), ошибки могут быть менее verbose; проверь `NODE_ENV` и добавь custom error logging

## References

- [Next.js Data Fetching: getServerSideProps](https://nextjs.org/docs/pages/building-your-application/data-fetching/get-server-side-props)
- [Next.js Error Handling](https://nextjs.org/docs/pages/building-your-application/routing/error-handling)
