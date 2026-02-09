---
description: Execute technical plan, complete all tasks until E2E tests pass
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the task list in plan.app.md, execute implementation step by step until both core and current feature E2E test cases pass.

## Execution Steps

### 1. Load Context

1. Read `specs/{branch-name}/spec.app.md` and `specs/{branch-name}/plan.app.md` for the current branch
2. Read project's `CLAUDE.md` to understand architecture and conventions
3. Parse the task list from plan.app.md

### 2. Task Execution

Execute tasks according to the phases and order defined in plan.app.md:

#### Execution Rules

1. **Execute by phase**: Complete all tasks in current phase before moving to the next
2. **Follow dependencies**: Execute tasks in order based on task dependencies
3. **Real-time updates**: Mark task as `[x]` in plan.app.md immediately after completion
4. **Error handling**: Stop and report when encountering issues, wait for user instructions

#### Task Completion Criteria

Each task completion requires:
- Code written and saved
- No syntax errors
- Follows project code style (reference CLAUDE.md)

### 3. E2E Test Execution

#### 3.1 Testing Method

Refer to README.md to begin E2E testing. If there's no relevant E2E testing plan, confirm with user and create one.

#### 3.2 Test Result Handling

**If tests pass**:
- Mark all test tasks as complete
- Report success

**If tests fail**:
1. Analyze failure cause
2. Locate problematic code
3. Fix the issue
4. Re-run tests
5. Repeat until passing

### 4. Intelligent Memory Update (Self-Learning)

After all tasks complete and tests pass, perform intelligent memory update to form a self-learning loop.

#### 4.1 Memory Update Trigger Conditions

Update `CLAUDE.md` when ANY of the following occurs:

| Condition | Example | Priority |
|-----------|---------|----------|
| **Repeated mistakes** | Same error made 2+ times during development | High |
| **Non-obvious solutions** | Solution that required significant debugging | High |
| **Architecture decisions** | New patterns, conventions, or tech choices | Medium |
| **Gotchas & pitfalls** | Unexpected behavior, edge cases discovered | Medium |
| **Outdated information** | Existing memory content no longer accurate | High |
| **New best practices** | Better approaches discovered during implementation | Medium |

#### 4.2 Memory Content Categories

Organize memory updates into these categories:

```markdown
## Project Architecture
- Tech stack and versions
- Directory structure conventions
- Key design patterns used

## Development Conventions
- Coding style rules
- Naming conventions
- File organization patterns

## Common Pitfalls (Auto-learned)
- [Date] Issue: {description}
  - Symptom: {what went wrong}
  - Root cause: {why it happened}
  - Solution: {how to fix/avoid}

## API & Integration Notes
- External service quirks
- Authentication patterns
- Data format requirements

## Testing Guidelines
- Test file locations
- Test commands
- Common test failures and fixes

## Performance Considerations
- Known bottlenecks
- Optimization techniques used
```

#### 4.3 Memory Update Principles

**DO update memory when:**
- You made a mistake that cost significant debugging time
- You discovered behavior that contradicts documentation
- You found a pattern that should be reused
- Existing memory content is wrong or outdated
- You learned something project-specific that future development needs

**DO NOT update memory with:**
- General programming knowledge (e.g., "use async/await for promises")
- One-time fixes unlikely to recur
- Personal preferences without team consensus
- Temporary workarounds that should be properly fixed

#### 4.4 Self-Learning Loop

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT CYCLE                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐              │
│  │ oh.spec  │───►│ oh.plan  │───►│oh.implmt │              │
│  └──────────┘    └──────────┘    └────┬─────┘              │
│       ▲                               │                     │
│       │         ┌─────────────────────┘                     │
│       │         ▼                                           │
│       │    ┌─────────┐     ┌──────────────┐                │
│       │    │ Testing │────►│ Learn Errors │                │
│       │    └─────────┘     └──────┬───────┘                │
│       │                          │                          │
│       │                          ▼                          │
│       │              ┌───────────────────┐                  │
│       │              │ Update CLAUDE.md │                  │
│       │              └─────────┬─────────┘                  │
│       │                        │                            │
│       └────────────────────────┘                            │
│            (Next cycle benefits from learned knowledge)     │
└─────────────────────────────────────────────────────────────┘
```

#### 4.5 Memory Update Checklist

Before completing implementation, verify:

- [ ] **Review development journey**: What mistakes were made? What took longer than expected?
- [ ] **Check for repeated patterns**: Did similar issues occur multiple times?
- [ ] **Validate existing memory**: Is any current content now incorrect?
- [ ] **Document non-obvious solutions**: Would another developer struggle with the same issue?
- [ ] **Record architecture decisions**: Any new patterns that should be standard?

### 5. Progress Report

After completing each task phase, report:
- Completed tasks / Total tasks
- Current phase status
- Issues encountered (if any)

## Implementation Principles

### Code Quality

- Follow code style defined in readme.md

### Error Handling

- Ask user when encountering unclear issues
- Don't assume or skip problems
- Keep error logs for debugging

### Test-Driven

- E2E tests are the final acceptance criteria
- When tests fail, first analyze if test code is correct
- Ensure tests cover Golden Cases defined in spec.app.md
- **Must implement all test cases**: Don't skip test cases designed in spec due to cost or time, these cases are key criteria for verifying functionality

## Completion Criteria

Implementation is complete when all of the following conditions are met:

1. **All tasks complete**: All tasks in plan.app.md marked as `[x]`
2. **E2E tests pass**: All test cases defined in spec.app.md pass
3. **Memory updated**: Self-learning updates applied to `CLAUDE.md`

> **Warning**: After task completion, please return to check if all tasks in plan.app.md are completed (marked as `[x]`). If there are incomplete tasks, you must continue execution until all are complete!

## Output

Upon completion, report:
1. Task completion statistics
2. E2E test results
3. List of modified files
4. **Memory updates made** (what was learned and recorded)
