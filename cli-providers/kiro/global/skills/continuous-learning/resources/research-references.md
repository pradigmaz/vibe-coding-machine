# Research References

Академические исследования которые легли в основу Continuous Learning Skill.

## Основные работы

### Voyager: An Open-Ended Embodied Agent with Large Language Models

**Авторы**: Wang, Xie, Jiang, Mandlekar, Xiao, Zhu, Fan, Anandkumar  
**Опубликовано**: May 2023  
**URL**: https://arxiv.org/abs/2305.16291

**Ключевой вклад**: Первый LLM-powered embodied lifelong learning агент с архитектурой skill library.

**Применённые концепции**:

1. **Ever-Growing Skill Library**: Voyager поддерживает "постоянно растущую библиотеку навыков из исполняемого кода для хранения и извлечения сложного поведения." Это вдохновило наш подход извлечения skills как executable knowledge packages.

2. **Compositional Skills**: "Навыки разработанные Voyager temporally extended, interpretable, и compositional, что быстро увеличивает способности агента и облегчает catastrophic forgetting." Наша структура skill нацелена на похожую composability.

3. **Self-Verification**: Voyager использует "self-verification для улучшения программы" перед добавлением skills в библиотеку. Мы реализуем похожие quality gates перед extraction.

4. **Iterative Prompting**: "Iterative prompting механизм который включает environment feedback, execution errors" повлиял на дизайн нашего retrospective mode.

---

### CASCADE: Cumulative Agentic Skill Creation through Autonomous Development and Evolution

**Опубликовано**: December 2024  
**URL**: https://arxiv.org/abs/2512.23880

**Ключевой вклад**: Self-evolving agentic framework демонстрирующий переход от "LLM + tool use" к "LLM + skill acquisition."

**Применённые концепции**:

1. **Meta-Skills для обучения**: CASCADE демонстрирует "continuous learning через web search и code extraction, и self-reflection через introspection." Наш skill сам является meta-skill для приобретения skills.

2. **Knowledge Codification**: "CASCADE накапливает executable skills которые можно делить между агентами" - этот принцип движет нашим подходом к extraction и storage skills.

3. **Memory Consolidation**: Framework использует memory consolidation для предотвращения forgetting и enable reuse. Наша skill library служит похожей цели.

---

### SEAgent: Self-Evolving Computer Use Agent with Autonomous Learning from Experience

**Авторы**: Sun et al.  
**Опубликовано**: August 2025  
**URL**: https://arxiv.org/abs/2508.04700

**Ключевой вклад**: Framework позволяющий агентам автономно эволюционировать через взаимодействия с незнакомым software.

**Применённые концепции**:

1. **Experiential Learning**: "SEAgent empowers computer-use агентов автономно осваивать новые software окружения через experiential learning, где агенты исследуют новый software, учатся через iterative trial-and-error." Наш retrospective mode захватывает это trial-and-error обучение.

2. **Learning from Failures and Successes**: "Политика агента оптимизируется через experiential learning из failures и successes." Мы извлекаем skills из успешных решений и debugging процессов.

3. **Curriculum Generation**: SEAgent использует "Curriculum Generator" для increasingly diverse задач. Наши skill descriptions enable semantic matching для surface relevant skills.

---

### Reflexion: Language Agents with Verbal Reinforcement Learning

**Авторы**: Shinn et al.  
**Опубликовано**: March 2023  
**URL**: https://arxiv.org/abs/2303.11366

**Ключевой вклад**: Framework для verbal reinforcement через linguistic feedback и self-reflection.

**Применённые концепции**:

1. **Self-Reflection Prompts**: "Reflexion конвертирует feedback из окружения в linguistic feedback, также называемый self-reflection." Наши self-reflection prompts напрямую вдохновлены этим.

2. **Memory для будущих попыток**: "Эти experiences (хранимые в long-term memory) используются агентом для быстрого улучшения decision-making." Skills служат как long-term memory.

3. **Verbal Reinforcement**: Вместо scalar rewards, Reflexion использует "nuanced feedback" на естественном языке. Наши skill descriptions захватывают это nuanced knowledge.

---

### EvoFSM: Controllable Self-Evolution for Deep Research with Finite State Machines

**Опубликовано**: 2024

**Ключевой вклад**: Self-evolving framework с experience pools для continuous learning.

**Применённые концепции**:

1. **Self-Evolving Memory**: "EvoFSM интегрирует Self-Evolving Memory механизм, который distills успешные стратегии и failure patterns в Experience Pool для enable continuous learning и warm-starting для будущих queries."

2. **Experience Pools**: Концепция хранения стратегий для последующего retrieval напрямую повлияла на дизайн нашей skill library.

---

## Поддерживающие исследования

### Professional Agents: Evolving LLMs into Autonomous Experts

**URL**: https://arxiv.org/abs/2402.03628

Описывает framework для создания агентов со специализированной экспертизой через continuous learning. Повлиял на наши quality критерии для того что делает skill достойным extraction.

### Self-Reflection in LLM Agents: Effects on Problem-Solving Performance

**URL**: https://arxiv.org/abs/2405.06682

Эмпирическое исследование показывающее что self-reflection улучшает performance. Подтвердило наше использование reflection prompts для идентификации extractable knowledge.

### Building Scalable and Reliable Agentic AI Systems

Comprehensive survey покрывающий memory architectures, tool use, и continuous learning в agentic AI. Предоставил более широкий архитектурный контекст для нашего дизайна.

---

## Design Patterns Applied

### Из Voyager
- Skill library как executable code
- Self-verification перед добавлением в library
- Compositional skill building

### Из CASCADE
- Meta-skills для обучения
- Knowledge codification в shareable формат
- Memory consolidation

### Из SEAgent
- Learning из successes и failures
- Experiential learning через trial-and-error
- Progressive skill complexity

### Из Reflexion
- Self-reflection prompts
- Verbal feedback вместо scalar rewards
- Long-term memory storage

### Из EvoFSM
- Experience pools
- Distilling стратегий из сессий
- Warm-starting будущей работы

---

## Citation Format

Если ссылаешься на этот skill в академической работе:

```
@misc{kiro-continuous-learning,
  title={Kiro Continuous Learning Skill: Autonomous Skill Extraction for LLM Agents},
  author={Kiro AI},
  year={2026},
  note={Implements continuous learning patterns from Voyager, CASCADE, SEAgent, and Reflexion research}
}
```
