---
name: component-refactoring
description: Рефакторинг сложных React компонентов. Используется frontend агентами когда complexity > 50 или lineCount > 300.
---
# Component Refactoring Skill

## Назначение

Рефакторинг сложных React компонентов. Используется frontend агентами когда complexity > 50 или lineCount > 300.

## Дополнительные материалы (steering)

Для детальных workflow guides смотри:
- `steering/complexity-patterns.md` - Паттерны определения сложности
- `steering/component-splitting.md` - Разделение компонентов
- `steering/hook-extraction.md` - Извлечение custom hooks

## Когда рефакторить

### Complexity Thresholds

| Score | Level | Action |
|-------|-------|--------|
| 0-25 | 🟢 Simple | Готов к тестированию |
| 26-50 | 🟡 Medium | Рассмотреть minor рефакторинг |
| 51-75 | 🟠 Complex | **Рефакторить перед тестированием** |
| 76-100 | 🔴 Very Complex | **Обязательно рефакторить** |

### Признаки необходимости рефакторинга

- Complexity > 50
- Line count > 300
- Множество useState/useEffect
- Глубокая вложенность (> 3 уровня)
- Смешанная бизнес-логика и UI
- Множество условных рендерингов
- Дублирование кода

## Core Refactoring Patterns

### Pattern 1: Extract Custom Hooks

**Когда**: Сложное управление состоянием, множество useState/useEffect.

```typescript
// ❌ BAD: Сложная логика состояния в компоненте
const Configuration: FC = () => {
  const [modelConfig, setModelConfig] = useState<ModelConfig>({});
  const [datasetConfigs, setDatasetConfigs] = useState<DatasetConfigs>({});
  const [completionParams, setCompletionParams] = useState<FormValue>({});
  
  useEffect(() => {
    // 50+ строк логики управления состоянием...
  }, []);
  
  return <div>...</div>;
};

// ✅ GOOD: Извлечь в custom hook
// hooks/use-model-config.ts
export const useModelConfig = (appId: string) => {
  const [modelConfig, setModelConfig] = useState<ModelConfig>({});
  const [completionParams, setCompletionParams] = useState<FormValue>({});
  
  useEffect(() => {
    // Логика управления состоянием здесь
  }, [appId]);
  
  return { 
    modelConfig, 
    setModelConfig, 
    completionParams, 
    setCompletionParams 
  };
};

// Компонент становится чище
const Configuration: FC = () => {
  const { modelConfig, setModelConfig } = useModelConfig(appId);
  return <div>...</div>;
};
```

### Pattern 2: Extract Sub-Components

**Когда**: Один компонент имеет множество UI секций.

```typescript
// ❌ BAD: Монолитный JSX
const AppInfo = () => {
  return (
    <div>
      {/* 100 строк header UI */}
      {/* 100 строк operations UI */}
      {/* 100 строк modals */}
    </div>
  );
};

// ✅ GOOD: Разделить на focused компоненты
// app-info/
//   ├── index.tsx           (orchestration)
//   ├── app-header.tsx      (header UI)
//   ├── app-operations.tsx  (operations UI)
//   └── app-modals.tsx      (modal management)

const AppInfo = () => {
  const { showModal, setShowModal } = useAppInfoModals();
  
  return (
    <div>
      <AppHeader appDetail={appDetail} />
      <AppOperations onAction={handleAction} />
      <AppModals show={showModal} onClose={() => setShowModal(null)} />
    </div>
  );
};
```

### Pattern 3: Simplify Conditional Logic

**Когда**: Глубокая вложенность (> 3 уровня), сложные тернарники.

```typescript
// ❌ BAD: Глубоко вложенные условия
const Template = useMemo(() => {
  if (appDetail?.mode === AppModeEnum.CHAT) {
    switch (locale) {
      case LanguagesSupported[1]:
        return <TemplateChatZh />;
      case LanguagesSupported[7]:
        return <TemplateChatJa />;
      default:
        return <TemplateChatEn />;
    }
  }
  if (appDetail?.mode === AppModeEnum.ADVANCED_CHAT) {
    // Ещё 15 строк...
  }
  // Больше условий...
}, [appDetail, locale]);

// ✅ GOOD: Lookup tables + early returns
const TEMPLATE_MAP = {
  [AppModeEnum.CHAT]: {
    [LanguagesSupported[1]]: TemplateChatZh,
    [LanguagesSupported[7]]: TemplateChatJa,
    default: TemplateChatEn,
  },
  [AppModeEnum.ADVANCED_CHAT]: {
    [LanguagesSupported[1]]: TemplateAdvancedChatZh,
    default: TemplateAdvancedChatEn,
  },
};

const Template = useMemo(() => {
  const modeTemplates = TEMPLATE_MAP[appDetail?.mode];
  if (!modeTemplates) return null;
  
  const TemplateComponent = modeTemplates[locale] || modeTemplates.default;
  return <TemplateComponent appDetail={appDetail} />;
}, [appDetail, locale]);
```

### Pattern 4: Extract API/Data Logic

**Когда**: Компонент напрямую обрабатывает API calls.

```typescript
// ❌ BAD: API логика в компоненте
const MCPServiceCard = () => {
  const [basicAppConfig, setBasicAppConfig] = useState({});
  
  useEffect(() => {
    if (isBasicApp && appId) {
      (async () => {
        const res = await fetchAppDetail({ url: '/apps', id: appId });
        setBasicAppConfig(res?.model_config || {});
      })();
    }
  }, [appId, isBasicApp]);
  
  // Больше API-related логики...
};

// ✅ GOOD: Извлечь в data hook с React Query
// use-app-config.ts
import { useQuery } from '@tanstack/react-query';

const NAME_SPACE = 'appConfig';

export const useAppConfig = (appId: string, isBasicApp: boolean) => {
  return useQuery({
    enabled: isBasicApp && !!appId,
    queryKey: [NAME_SPACE, 'detail', appId],
    queryFn: () => get<AppDetailResponse>(`/apps/${appId}`),
    select: data => data?.model_config || {},
  });
};

// Компонент становится чище
const MCPServiceCard = () => {
  const { data: config, isLoading } = useAppConfig(appId, isBasicApp);
  // Только UI
};
```

### Pattern 5: Extract Modal Management

**Когда**: Компонент управляет множеством модалов.

```typescript
// ❌ BAD: Множество modal states в компоненте
const AppInfo = () => {
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDuplicateModal, setShowDuplicateModal] = useState(false);
  const [showConfirmDelete, setShowConfirmDelete] = useState(false);
  const [showSwitchModal, setShowSwitchModal] = useState(false);
  const [showImportDSLModal, setShowImportDSLModal] = useState(false);
  // 5+ больше modal states...
};

// ✅ GOOD: Извлечь в modal management hook
type ModalType = 'edit' | 'duplicate' | 'delete' | 'switch' | 'import' | null;

const useAppInfoModals = () => {
  const [activeModal, setActiveModal] = useState<ModalType>(null);
  
  const openModal = useCallback((type: ModalType) => setActiveModal(type), []);
  const closeModal = useCallback(() => setActiveModal(null), []);
  
  return {
    activeModal,
    openModal,
    closeModal,
    isOpen: (type: ModalType) => activeModal === type,
  };
};
```

### Pattern 6: Extract Form Logic

**Когда**: Сложная валидация форм, обработка submission.

```typescript
// ✅ GOOD: Используй существующую form infrastructure
import { useAppForm } from '@/app/components/base/form';

const ConfigForm = () => {
  const form = useAppForm({
    defaultValues: { name: '', description: '' },
    onSubmit: handleSubmit,
  });
  
  return <form.Provider>...</form.Provider>;
};
```

## Refactoring Workflow

### Step 1: Analyze

```bash
# Анализ complexity
pnpm analyze-component <path> --json

# Ключевые метрики:
# - complexity: normalized score 0-100 (target < 50)
# - maxComplexity: highest single function complexity
# - lineCount: total lines (target < 300)
```

### Step 2: Plan

Создай план рефакторинга на основе detected features:

| Detected Feature | Refactoring Action |
|------------------|-------------------|
| `hasState: true` + `hasEffects: true` | Extract custom hook |
| `hasAPI: true` | Extract data/service hook |
| `hasEvents: true` (many) | Extract event handlers |
| `lineCount > 300` | Split into sub-components |
| `maxComplexity > 50` | Simplify conditional logic |

### Step 3: Execute Incrementally

```
Для каждого extraction:
  ┌────────────────────────────────────────┐
  │ 1. Extract code                        │
  │ 2. Run: pnpm lint:fix                  │
  │ 3. Run: pnpm type-check                │
  │ 4. Run: pnpm test                      │
  │ 5. Test functionality manually         │
  │ 6. PASS? → Next extraction             │
  │    FAIL? → Fix before continuing       │
  └────────────────────────────────────────┘
```

### Step 4: Verify

```bash
# Повторный анализ для проверки улучшений
pnpm analyze-component <path>

# Target metrics:
# - complexity < 50
# - lineCount < 300
# - maxComplexity < 30
```

## Common Mistakes

### ❌ Over-Engineering

```typescript
// ❌ BAD: Слишком много tiny hooks
const useButtonText = () => useState('Click');
const useButtonDisabled = () => useState(false);
const useButtonLoading = () => useState(false);

// ✅ GOOD: Cohesive hook с related state
const useButtonState = () => {
  const [text, setText] = useState('Click');
  const [disabled, setDisabled] = useState(false);
  const [loading, setLoading] = useState(false);
  return { text, setText, disabled, setDisabled, loading, setLoading };
};
```

### ❌ Breaking Existing Patterns

- Следуй существующим directory structures
- Поддерживай naming conventions
- Сохраняй export patterns для совместимости

### ❌ Premature Abstraction

- Извлекай только когда есть явная польза от снижения complexity
- Не создавай абстракции для single-use кода
- Держи refactored код в той же domain area

## Checklist

```
Component Refactoring Review:
- [ ] Complexity < 50
- [ ] Line count < 300
- [ ] Custom hooks извлечены для state management
- [ ] Sub-components созданы для UI sections
- [ ] API logic в data hooks
- [ ] Modal management извлечён
- [ ] Conditional logic упрощена
- [ ] Нет дублирования кода
- [ ] Тесты проходят
- [ ] Type checking проходит
```

## Ресурсы

- [React Documentation](https://react.dev)
- [React Hook Patterns](https://react.dev/reference/react)
- [Component Composition](https://react.dev/learn/passing-props-to-a-component)
