---
description: Execute E2E test plan, complete all tasks until tests pass
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the task list in plan.e2e.md, execute E2E test implementation step by step until all test cases pass.

## Execution Steps

### 1. Load Context (Required)

1. Read `specs/{branch-name}/spec.e2e.md` and `specs/{branch-name}/plan.e2e.md` for the current branch
2. Read project's `{{MEMORY_PATH}}` to understand architecture and conventions
3. Parse the task list from plan.e2e.md

### 2. Task Execution

Execute tasks according to the phases and order defined in plan.e2e.md:

#### Execution Rules

1. **Execute by phase**: Complete all tasks in current phase before moving to the next
2. **Follow dependencies**: Execute tasks in order based on task dependencies
3. **Real-time updates**: Mark task as `[x]` in plan.e2e.md immediately after completion
4. **Reference existing code**: When writing new code, reference the existing patterns listed in plan.e2e.md
5. **Error handling**: Stop and report when encountering issues, wait for user instructions

#### Task Completion Criteria

Each task completion requires:
- Code written and saved
- No syntax errors
- Consistent with project's existing code style

### 3. Test Execution

#### 3.1 Running Tests

Run tests according to project's test configuration (refer to README or package.json for test commands).

#### 3.2 Test Result Handling

**If tests pass**:
- Mark all test tasks as complete
- Continue with regression testing

**If tests fail**:
1. Analyze failure cause (check error messages and stack traces)
2. Locate problematic code
3. Fix the issue
4. Re-run tests
5. Repeat until passing

#### 3.3 Regression Testing (Required)

Run the project's complete test suite to ensure new code doesn't break existing functionality.

### 4. Intelligent Memory Update (Required)

After all tasks complete and tests pass, perform intelligent memory update.

#### 4.1 Memory Update Trigger Conditions

Update `{{MEMORY_PATH}}` when ANY of the following occurs:

| Condition | Priority |
|-----------|----------|
| Same error made 2+ times | High |
| Solution required significant debugging | High |
| Existing memory content no longer accurate | High |
| Discovered unexpected framework/tool behavior | Medium |
| Found effective patterns or strategies | Medium |

#### 4.2 What to Record

- Issues that required significant debugging time and their solutions
- Behavior that contradicts documentation
- Effective selector strategies or wait patterns
- Project-specific testing conventions
- Reusable patterns

#### 4.3 What NOT to Record

- General testing knowledge
- Content already detailed in official framework documentation
- One-time temporary fixes
- Specific test case details

### 5. Progress Report

After completing each task phase, report:
- Completed tasks / Total tasks
- Current phase status
- Issues encountered (if any)

## Implementation Principles

### Code Quality

- Stay consistent with project's existing code style
- Reference existing test patterns listed in plan.e2e.md
- Reuse existing base classes and utility functions

### Test Isolation

- Each test case should run independently
- No dependency on other test execution order
- Manage test data according to the strategy in plan.e2e.md

### Problem Handling

- Ask user when encountering unclear issues
- Don't assume or skip problems
- Keep error logs for debugging

## Completion Criteria

Implementation is complete when all of the following conditions are met:

1. **All tasks complete**: All tasks in plan.e2e.md marked as `[x]`
2. **New tests pass**: All test cases defined in spec.e2e.md pass
3. **Regression tests pass**: Entire existing test suite passes
4. **Memory updated**: Self-learning updates applied to `{{MEMORY_PATH}}`

> **Warning**: After task completion, please return to check if all tasks in plan.e2e.md are completed (marked as `[x]`). If there are incomplete tasks, you must continue execution until all are complete!

## Output

Upon completion, report:
1. Task completion statistics
2. Test execution results
3. List of modified/created files
4. **Memory updates made** (what was learned and recorded)
