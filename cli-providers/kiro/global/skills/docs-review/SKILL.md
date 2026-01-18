# Documentation Review Skill

## Назначение

Review documentation для compliance с style guide. Используется reviewer агентами для reviewing PRs, files, diffs с documentation markdown.

## Review Process

1. Read changes для understanding intent
2. Check issues violating style guide
3. Only flag issues worth mentioning
4. **Number ALL feedback sequentially**

## Review Checklist

**Tone and voice:**
- [ ] Formal/corporate language
- [ ] "Users" вместо "people"
- [ ] Excessive exclamation points
- [ ] Telling вместо showing

**Structure and clarity:**
- [ ] Important info buried
- [ ] Verbose text
- [ ] Vague headings
- [ ] Tasks described as "easy"

**Links:**
- [ ] Linking "here"
- [ ] Links в headings

**Formatting:**
- [ ] Ampersands as "and"
- [ ] Inconsistent lists

**Code:**
- [ ] Examples don't work
- [ ] Commands не в order
- [ ] Excessive images

## Quick Scan Table

| Pattern | Issue |
|---------|-------|
| we can, our | Should be "Metabase" or "it" |
| click here | Need descriptive link text |
| easy, simple | Remove qualifiers |
| users | Should be "people" |

## Feedback Format

**MANDATORY: Number ALL issues sequentially starting from Issue 1.**

### Local Review Mode

```markdown
## Issues

**Issue 1: [Brief title]**
Line X: Description
Suggested fix

**Issue 2: [Brief title]**
Line Y: Description
Suggested fix
```

**Examples:**

> **Issue 1: Formal tone**
> Line 15: Could be more conversational. Consider: "You can't..." instead of "You cannot..."

> **Issue 2: Vague heading**
> Line 8: Heading could be more specific. Try: "Run migrations before upgrading"


### PR Review Mode

**Workflow:**

1. Start review: `create_pending_pull_request_review`
2. Get diff: `get_pull_request_diff`
3. Identify ALL issues
4. Add comments: `add_pull_request_review_comment_to_pending_review`
   - **Post ALL comments в single response**
   - Each comment: `**Issue N: [Brief title]**`
5. Submit: `submit_pending_pull_request_review`
   - Use event type `"COMMENT"`
   - **Do NOT include body message**

**Comment format:**

```
**Issue 1: Formal tone**

This could be more conversational. Consider: "You can't..." instead of "You cannot..."
```

**IMPORTANT:**
- Number ALL comments sequentially
- Add all comments в parallel в single response
- Do NOT output summary to conversation
- Do NOT include body when submitting

## Best Practices

```markdown
// ✅ GOOD: Specific feedback
**Issue 1: Formal tone**
Line 15: "utilize" → "use"

// ✅ GOOD: Constructive
**Issue 2: Vague heading**
Try: "Run migrations before upgrading" vs "Upgrade process"

// ✅ GOOD: Numbered sequentially
Issue 1, Issue 2, Issue 3...

// ❌ BAD: Vague
"This section needs work"

// ❌ BAD: Not numbered
Just listing issues without numbers

// ❌ BAD: Nitpicking
Flagging minor style preferences
```

## Checklist

```
Documentation Review:
- [ ] All issues numbered sequentially
- [ ] Format matches: **Issue N: [title]**
- [ ] Only material issues flagged
- [ ] Suggestions constructive
- [ ] Links checked
- [ ] Code examples verified
```

## Ресурсы

- [Metabase Style Guide](https://www.metabase.com/docs/latest/developers-guide/writing-style-guide)
- [Google Developer Documentation Style Guide](https://developers.google.com/style)
