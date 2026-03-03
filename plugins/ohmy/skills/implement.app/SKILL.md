---
description: Execute technical plan using subagent-orchestrated TDD until E2E tests pass
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the task list in plan.app.md, orchestrate implementation using subagents: a TEST-WRITER writes failing E2E tests first (TDD), a REVIEWER checks spec compliance after each task, and a QA subagent runs the final test suite.

## Subagent Roles

| Role | When | Does | Prompt Template |
|------|------|------|-----------------|
| TEST-WRITER | Phase 0, before implementation | Explores project test patterns, writes failing E2E tests from golden cases | `./test-writer-prompt.md` |
| REVIEWER | After each implementation task | Verifies acceptance criteria against actual code | `./reviewer-prompt.md` |
| QA | Phase 3, after all implementation | Runs full E2E + regression suite, reports results | `./qa-prompt.md` |

## Execution Steps

### 1. Load Context

1. Read `specs/{branch-name}/spec.app.md` and `specs/{branch-name}/plan.app.md` for the current branch
2. Read project's `CLAUDE.md` to understand architecture and conventions
3. Parse the task list from plan.app.md

### 2. Dispatch TEST-WRITER Subagent (Phase 0)

Dispatch a general-purpose subagent using the template in `./test-writer-prompt.md`:

- Provide **full text** of spec golden cases (Section 2 of spec.app.md)
- Provide **full text** of CLAUDE.md
- Do NOT provide file paths for the subagent to read — paste everything it needs

**After the subagent returns:**

1. Verify test files were created
2. Verify all tests FAIL (RED state)
3. If any test passes → reject and re-dispatch (feature may already exist, or test is wrong)
4. Mark T0.1 as `[x]` in plan.app.md

### 3. Task Execution Loop (Phases 1-2)

Execute tasks according to phases and dependencies in plan.app.md:

#### Per-Task Flow

1. **Implement**: Main agent writes the code for the task
2. **Dispatch REVIEWER subagent** using `./reviewer-prompt.md`:
   - Provide **full text** of task description + acceptance criteria
   - Provide **git diff** of changes for this task
   - Do NOT provide file paths — paste the diff
3. **Handle review result**:
   - If **PASS** → mark task `[x]` in plan.app.md, move to next task
   - If **FAIL** → fix the issues cited by reviewer → re-dispatch REVIEWER → repeat until PASS

#### Execution Rules

1. **Execute by phase**: Complete all tasks in current phase before moving to next
2. **Follow dependencies**: Execute tasks in order based on dependencies
3. **Real-time updates**: Mark task as `[x]` in plan.app.md immediately after reviewer PASS
4. **Error handling**: Stop and report when encountering blocking issues

### 4. Dispatch QA Subagent (Phase 3)

Dispatch a general-purpose subagent using the template in `./qa-prompt.md`:

- Provide **full text** of spec golden cases
- Provide **full text** of CLAUDE.md
- Provide test file paths from Phase 0

**After the subagent returns:**

- **All tests pass** → mark T3.1 and T3.2 as `[x]`, proceed to Step 5
- **Tests fail** → main agent fixes the code → re-dispatch QA subagent
- **Max 3 QA rounds** → if still failing after 3 rounds, stop and escalate to user

### 5. Intelligent Memory Update (Self-Learning)

After all tasks complete and tests pass, update `CLAUDE.md`.

#### 5.1 Memory Update Trigger Conditions

Update `CLAUDE.md` when ANY of the following occurs:

| Condition | Example | Priority |
|-----------|---------|----------|
| **Repeated mistakes** | Same error made 2+ times during development | High |
| **Non-obvious solutions** | Solution that required significant debugging | High |
| **Architecture decisions** | New patterns, conventions, or tech choices | Medium |
| **Gotchas & pitfalls** | Unexpected behavior, edge cases discovered | Medium |
| **Outdated information** | Existing memory content no longer accurate | High |
| **Weak acceptance criteria** | Reviewer couldn't determine compliance, or criteria were ambiguous | High |

#### 5.2 Memory Update Principles

**DO update memory when:**
- You made a mistake that cost significant debugging time
- You discovered behavior that contradicts documentation
- You found a pattern that should be reused
- Existing memory content is wrong or outdated
- Acceptance criteria were too vague or caused reviewer confusion

**DO NOT update memory with:**
- General programming knowledge
- One-time fixes unlikely to recur
- Temporary workarounds that should be properly fixed

Mark T3.3 as `[x]` in plan.app.md.

### 6. Progress Report

After completing each phase, report:
- Completed tasks / Total tasks
- Current phase status
- Reviewer results summary (pass/fail per task)
- Issues encountered (if any)

## Subagent Dispatch Principles

1. **Full text, not file paths**: Paste everything the subagent needs into the prompt. Subagents should not need to read plan files.
2. **"Before You Begin"**: All subagent prompts include a section for asking questions. Answer them before letting the subagent proceed.
3. **Independent verification**: Reviewers read actual code, never trust reports or appearances.
4. **Read-only QA**: The QA subagent never fixes code — it only reports.

## Guardrails

- **Tests pass before implementation** → Reject test-writer output; tests must be RED
- **Reviewer inconclusive** → Flag weak acceptance criteria for self-learning in Step 5
- **3 QA failures** → Stop and escalate to user; don't loop forever
- **Subagent returns unclear results** → Ask user for guidance

## Implementation Principles

### Code Quality

- Follow code style defined in CLAUDE.md and project conventions

### Error Handling

- Ask user when encountering unclear issues
- Don't assume or skip problems
- Keep error logs for debugging

### Test-Driven

- E2E tests are written BEFORE implementation (Phase 0)
- E2E tests are the final acceptance criteria (Phase 3)
- When tests fail, first analyze if test code is correct
- Ensure tests cover Golden Cases defined in spec.app.md

## Completion Criteria

Implementation is complete when all of the following conditions are met:

1. **All tasks complete**: All tasks in plan.app.md marked as `[x]`
2. **All reviewers passed**: Every implementation task passed spec-compliance review
3. **E2E tests pass**: QA subagent confirms all tests pass
4. **Core tests pass**: QA subagent confirms no regressions
5. **Memory updated**: Self-learning updates applied to `CLAUDE.md`

> **Warning**: After task completion, check that ALL tasks in plan.app.md are marked `[x]`. If there are incomplete tasks, continue execution!

## Output

Upon completion, report:
1. Task completion statistics
2. Reviewer results summary (per-task pass/fail)
3. E2E test results (from QA subagent)
4. List of modified files
5. **Memory updates made** (what was learned and recorded)
