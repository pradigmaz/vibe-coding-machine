---
name: concept-workflow
description: End-to-end workflow для создания complete concept documentation. Используется documentation агентами для orchestrating всех skills от research до final rev...
---
# Concept Workflow Skill

## Назначение

End-to-end workflow для создания complete concept documentation. Используется documentation агентами для orchestrating всех skills от research до final review.

## Workflow Overview

```
┌─────────────────────────────────────────┐
│     COMPLETE CONCEPT WORKFLOW            │
├─────────────────────────────────────────┤
│                                          │
│  INPUT: Concept name                     │
│                                          │
│  Phase 1: Research (resource-curator)    │
│           ▼                              │
│  Phase 2: Write (write-concept)          │
│           ▼                              │
│  Phase 3: Test (test-writer)             │
│           ▼                              │
│  Phase 4: Verify (fact-check)            │
│           ▼                              │
│  Phase 5: Optimize (seo-review)          │
│           ▼                              │
│  OUTPUT: Complete concept page           │
│                                          │
└─────────────────────────────────────────┘
```

## Phase 1: Resource Curation

**Goal:** Gather high-quality external resources

### What to Do

1. Identify concept category
2. Search для MDN references
3. Find quality articles (4-6)
4. Find quality videos (3-4)
5. Evaluate each resource
6. Write specific descriptions
7. Format as Card components

### Deliverables

- 2-4 MDN/reference links с descriptions
- 4-6 article links с descriptions
- 3-4 video links с descriptions

### Quality Gates

```
Phase 1 Validation:
- [ ] All links verified working
- [ ] All resources JavaScript-focused
- [ ] Descriptions specific, не generic
- [ ] Mix beginner и advanced content
```

## Phase 2: Concept Writing

**Goal:** Create full documentation page

### What to Do

1. Determine category
2. Create frontmatter
3. Write opening hook
4. Add opening code example
5. Write "What you'll learn" box
6. Write main content sections
7. Add Key Takeaways
8. Add Test Your Knowledge
9. Add Related Concepts
10. Add Resources

### Deliverables

- Complete `.mdx` file
- File added to navigation

### Quality Gates

```
Phase 2 Validation:
- [ ] Frontmatter complete
- [ ] Opens с question hook
- [ ] Code example в first 200 words
- [ ] All required sections present
- [ ] 1,500+ words
```


## Phase 3: Test Writing

**Goal:** Create comprehensive tests

### What to Do

1. Scan concept page для code examples
2. Categorize examples
3. Create test file
4. Write tests с source line references
5. Run tests

### Deliverables

- Test file: `tests/{category}/{concept}.test.js`
- All tests passing

### Quality Gates

```
Phase 3 Validation:
- [ ] All testable examples have tests
- [ ] Source line references в comments
- [ ] Tests pass
- [ ] DOM tests в separate file
```

## Phase 4: Fact Checking

**Goal:** Verify technical accuracy

### What to Do

1. Verify code examples
2. Verify MDN/spec claims
3. Verify external resources
4. Audit technical claims
5. Generate fact-check report

### Deliverables

- Fact-check report
- All issues fixed

### Quality Gates

```
Phase 4 Validation:
- [ ] All tests passing
- [ ] All MDN links valid
- [ ] All external resources accessible
- [ ] No technical inaccuracies
- [ ] No common misconceptions
```

## Phase 5: SEO Review

**Goal:** Optimize для search visibility

### What to Do

1. Audit title tag (50-60 chars)
2. Audit meta description (150-160 chars)
3. Audit keyword placement
4. Audit content structure
5. Audit featured snippet optimization
6. Audit internal linking
7. Calculate score

### Deliverables

- SEO audit report с score
- All high-priority fixes implemented

### Quality Gates

```
Phase 5 Validation:
- [ ] Score 24+ out of 27 (90%+)
- [ ] Title optimized
- [ ] Meta description optimized
- [ ] Keywords placed naturally
- [ ] Featured snippet optimized
- [ ] Internal links complete
```

## Complete Workflow Checklist

```markdown
# Concept Workflow: [Concept Name]

## Phase 1: Resource Curation
- [ ] MDN references found (2-4)
- [ ] Articles found (4-6)
- [ ] Videos found (3-4)
- [ ] All links verified
Status: ⬜ Not Started | 🟡 In Progress | ✅ Complete

## Phase 2: Concept Writing
- [ ] Frontmatter complete
- [ ] Opening hook written
- [ ] Main content sections written
- [ ] Resources added
Status: ⬜ Not Started | 🟡 In Progress | ✅ Complete

## Phase 3: Test Writing
- [ ] Test file created
- [ ] All tests passing
Status: ⬜ Not Started | 🟡 In Progress | ✅ Complete

## Phase 4: Fact Checking
- [ ] Code verified
- [ ] Links checked
- [ ] Technical claims audited
Status: ⬜ Not Started | 🟡 In Progress | ✅ Complete

## Phase 5: SEO Review
- [ ] Title optimized
- [ ] Meta description optimized
- [ ] SEO Score: X/27
Status: ⬜ Not Started | 🟡 In Progress | ✅ Complete

## Final Status
All Phases Complete: ⬜ No | ✅ Yes
Ready to Publish: ⬜ No | ✅ Yes
```

## Time Estimates

| Phase | Time | Notes |
|-------|------|-------|
| Phase 1 | 15-30 min | Resource availability |
| Phase 2 | 1-3 hours | Concept complexity |
| Phase 3 | 30-60 min | Number of examples |
| Phase 4 | 15-30 min | Automated via tests |
| Phase 5 | 15-30 min | Checklist verification |
| **Total** | **2-5 hours** | Complete concept page |

## Ресурсы

- [MDN Web Docs](https://developer.mozilla.org/)
- [JavaScript.info](https://javascript.info/)
- [Web.dev](https://web.dev/)
