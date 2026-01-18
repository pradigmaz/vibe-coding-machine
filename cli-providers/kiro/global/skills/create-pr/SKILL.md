# Create Pull Request Skill

## Назначение

Создание GitHub pull requests с правильно отформатированными titles. Используется всеми агентами при создании PRs.

## PR Title Format

```
<type>(<scope>): <summary>
```

### Types (required)

| Type | Description | Changelog |
|------|-------------|-----------|
| `feat` | New feature | Yes |
| `fix` | Bug fix | Yes |
| `perf` | Performance improvement | Yes |
| `test` | Adding/correcting tests | No |
| `docs` | Documentation only | No |
| `refactor` | Code change (no bug fix or feature) | No |
| `build` | Build system or dependencies | No |
| `ci` | CI configuration | No |
| `chore` | Routine tasks, maintenance | No |

### Scopes (optional but recommended)

- `API` - Public API changes
- `core` - Core/backend/private API
- `editor` - Editor UI changes
- `auth` - Authentication/authorization
- `database` - Database changes
- `* Node` - Specific node (e.g., `Slack Node`, `GitHub Node`)

### Summary Rules

- Use imperative present tense: "Add" not "Added"
- Capitalize first letter
- No period at the end
- No ticket IDs (e.g., JIRA-1234)
- Add `(no-changelog)` suffix to exclude from changelog

## Steps

### 1. Check Current State

```bash
git status
git diff --stat
git log origin/main..HEAD --oneline
```

### 2. Analyze Changes

Определи:
- **Type**: Какой тип изменения?
- **Scope**: Какой package/area затронут?
- **Summary**: Что делает изменение?

### 3. Push Branch

```bash
git push -u origin HEAD
```

### 4. Create PR

```bash
gh pr create --draft --title "<type>(<scope>): <summary>" --body "
## Summary

<Describe what the PR does and how to test>

## Related Issues

<!-- Use 'closes #123', 'fixes #456', or 'resolves #789' -->

## Checklist

- [ ] PR title follows conventions
- [ ] Tests included
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
"
```

## PR Body Guidelines

### Summary Section
- Describe what the PR does
- Explain how to test the changes
- Include screenshots/videos for UI changes

### Related Links Section
- Link to issues using keywords to auto-close:
  - `closes #123` / `fixes #123` / `resolves #123`
- Link to related PRs or discussions

### Checklist
- PR title follows conventions
- Tests included (bugs need regression tests, features need coverage)
- Documentation updated or follow-up ticket created
- Breaking changes documented

## Examples

### Feature in editor
```
feat(editor): add workflow performance metrics display
```

### Bug fix in core
```
fix(core): resolve memory leak in execution engine
```

### Node-specific change
```
fix(Slack Node): handle rate limiting in message send
```

### Breaking change (add exclamation mark before colon)
```
feat(API)!: remove deprecated v1 endpoints
```

### No changelog entry
```
refactor(core): simplify error handling (no-changelog)
```

### No scope (affects multiple areas)
```
chore: update dependencies to latest versions
```

## Validation

PR title должен соответствовать pattern:
```
^(feat|fix|perf|test|docs|refactor|build|ci|chore|revert)(\([a-zA-Z0-9 ]+( Node)?\))?!?: [A-Z].+[^.]$
```

Key validation rules:
- Type должен быть один из allowed types
- Scope опционален, но должен быть в скобках
- Exclamation mark для breaking changes идёт перед двоеточием
- Summary должен начинаться с заглавной буквы
- Summary не должен заканчиваться точкой

## GitHub CLI Commands

```bash
# Create draft PR
gh pr create --draft --title "feat: add feature" --body "Description"

# Create PR and mark ready for review
gh pr create --title "fix: bug fix" --body "Description"

# Create PR with reviewers
gh pr create --title "feat: feature" --reviewer @user1,@user2

# Create PR with labels
gh pr create --title "fix: bug" --label bug,priority-high

# View PR in browser
gh pr view --web

# List PRs
gh pr list

# Check PR status
gh pr status
```

## PR Size Best Practices

### Keep PRs Small
- **Ideal**: < 200 lines changed
- **Maximum**: < 500 lines changed
- **If larger**: Split into multiple PRs

### Benefits of Small PRs
- Faster reviews
- Easier to understand
- Less likely to introduce bugs
- Easier to revert if needed

### How to Split Large PRs
1. **By feature**: Split into logical features
2. **By layer**: Split by frontend/backend/database
3. **By refactoring**: Separate refactoring from new features

## Checklist

```
PR Creation Checklist:
- [ ] Branch name follows convention
- [ ] All commits follow Conventional Commits
- [ ] PR title follows format: <type>(<scope>): <summary>
- [ ] PR description explains "what" and "why"
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No merge conflicts
- [ ] CI passes
- [ ] Reviewers assigned
```

## Common Mistakes

### ❌ BAD PR Titles

```
Update code
Fix bug
WIP
Changes
Implement feature
```

### ✅ GOOD PR Titles

```
feat(auth): add OAuth2 login support
fix(api): handle null response from payment gateway
refactor(core): simplify error handling logic
docs(readme): update installation instructions
test(auth): add tests for password reset flow
```

## Ресурсы

- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub CLI](https://cli.github.com/)
- [Writing Good PR Descriptions](https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/)
