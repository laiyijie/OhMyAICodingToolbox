---
description: Execute technical plan, complete all tasks until E2E tests pass
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the task list in plan.md, execute implementation step by step until both core and current feature E2E test cases pass.

## Execution Steps

### 1. Load Context

1. Read `specs/{branch-name}/spec.md` and `specs/{branch-name}/plan.md` for the current branch
2. Read project's `{{MEMORY_PATH}}` to understand architecture and conventions
3. Parse the task list from plan.md

### 2. Task Execution

Execute tasks according to the phases and order defined in plan.md:

#### Execution Rules

1. **Execute by phase**: Complete all tasks in current phase before moving to the next
2. **Follow dependencies**: Execute tasks in order based on task dependencies
3. **Real-time updates**: Mark task as `[x]` in plan.md immediately after completion
4. **Error handling**: Stop and report when encountering issues, wait for user instructions

#### Task Completion Criteria

Each task completion requires:
- Code written and saved
- No syntax errors
- Follows project code style (reference {{MEMORY_PATH}})

### 3. E2E Test Execution

#### 3.1 Testing Method

Refer to README.md to begin E2E testing. If there's no relevant E2E testing plan, confirm with user and create one.

#### 3.3 Test Result Handling

**If tests pass**:
- Mark all test tasks as complete
- Report success

**If tests fail**:
1. Analyze failure cause
2. Locate problematic code
3. Fix the issue
4. Re-run tests
5. Repeat until passing

### 4. Progress Report

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
- Ensure tests cover Golden Cases defined in spec.md
- **Must implement all test cases**: Don't skip test cases designed in spec due to cost or time, these cases are key criteria for verifying functionality

## Completion Criteria

Implementation is complete when all of the following conditions are met:

1. **All tasks complete**: All tasks in plan.md marked as `[x]`
2. **E2E tests pass**: All test cases defined in spec.md pass

> **Warning**: After task completion, please return to check if all tasks in plan.md are completed (marked as `[x]`). If there are incomplete tasks, you must continue execution until all are complete!

## Output

Upon completion, report:
1. Task completion statistics
2. E2E test results
3. List of modified files
