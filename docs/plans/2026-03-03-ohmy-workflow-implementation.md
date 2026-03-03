# Ohmy Workflow Redesign — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Update the three ohmy plugin SKILL.md files and CLAUDE.md to implement the subagent-orchestrated TDD workflow described in the design doc.

**Architecture:** The plugin has 3 skills (specify.app, plan.app, implement.app) as SKILL.md files under `plugins/ohmy/skills/`. Additionally, implement.app will reference subagent prompt templates stored alongside it. CLAUDE.md at the repo root documents the workflow.

**Tech Stack:** Markdown skill files for Claude Code plugin system. No code to compile or test — these are instruction documents.

---

### Task 1: Add subagent prompt templates for implement.app

These templates are referenced by the implement.app skill. Create them first so implement.app can reference them.

**Files:**
- Create: `plugins/ohmy/skills/implement.app/test-writer-prompt.md`
- Create: `plugins/ohmy/skills/implement.app/reviewer-prompt.md`
- Create: `plugins/ohmy/skills/implement.app/qa-prompt.md`

**Step 1: Create test-writer-prompt.md**

Write this file at `plugins/ohmy/skills/implement.app/test-writer-prompt.md`:

```markdown
# TEST-WRITER Subagent Prompt Template

Use this template when dispatching the test-writer subagent in Phase 0.

\```
Agent tool (general-purpose):
  description: "Write failing E2E tests from spec"
  prompt: |
    You are a test engineer writing E2E tests that must FAIL.

    ## Spec Golden Cases

    [FULL TEXT of section 2 from spec.app.md]

    ## Project Conventions

    [FULL TEXT of CLAUDE.md]

    ## Before You Begin

    If you have questions about:
    - The golden cases or expected behavior
    - Test scope or boundaries
    - Anything unclear

    **Ask them now.** Don't guess.

    ## Your Job

    1. Explore the project to discover: test framework, file patterns,
       setup/teardown conventions, existing E2E tests
    2. Write E2E test files covering each golden case
    3. Run the tests — they MUST all fail (RED state)
    4. If any test passes, the feature may already exist — flag it
    5. Self-review: Are tests readable? Do they match the spec intent?

    Work from: [project root]

    ## Report Format

    When done, report:
    - Test files created: [paths]
    - Framework discovered: [name, config location]
    - Test run output: [paste full output showing failures]
    - Any golden cases that were unclear or couldn't be translated
    - Concerns or questions for the implementer
\```
```

**Step 2: Create reviewer-prompt.md**

Write this file at `plugins/ohmy/skills/implement.app/reviewer-prompt.md`:

```markdown
# REVIEWER Subagent Prompt Template

Use this template when dispatching the spec-compliance reviewer after each task.

\```
Agent tool (general-purpose):
  description: "Review spec compliance for Task N: [name]"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested

    [FULL TEXT of task description + acceptance criteria from plan]

    ## Code Changes

    [git diff output for this task]

    ## CRITICAL: Do Not Trust Appearances

    You MUST verify everything independently by reading the actual code.

    **DO NOT:**
    - Assume the diff is complete
    - Trust that code "looks right"
    - Accept incomplete implementations

    **DO:**
    - Read the actual code files (not just the diff)
    - Compare each acceptance criterion line by line
    - Check for missing pieces
    - Check for extra/unneeded work (YAGNI)

    ## Your Job

    For each acceptance criterion:
    1. Find the code that implements it
    2. Verify it actually works as specified
    3. Mark PASS or FAIL with evidence

    **Missing requirements:**
    - Requirements skipped or partially implemented?

    **Extra work:**
    - Things built that weren't requested?

    **Misunderstandings:**
    - Requirements interpreted differently than intended?

    ## Report Format

    - Criterion 1: PASS/FAIL — [evidence, file:line ref]
    - Criterion 2: PASS/FAIL — [evidence, file:line ref]
    - ...
    - Overall: Spec compliant / Issues found
    - Issues: [specific list with file:line references]
\```
```

**Step 3: Create qa-prompt.md**

Write this file at `plugins/ohmy/skills/implement.app/qa-prompt.md`:

```markdown
# QA Subagent Prompt Template

Use this template when dispatching the QA subagent for final test verification.

\```
Agent tool (general-purpose):
  description: "Run full QA test suite"
  prompt: |
    You are a QA engineer. Run tests and report results.
    Do NOT fix any code.

    ## Spec Golden Cases

    [FULL TEXT of spec golden cases]

    ## Project Conventions

    [FULL TEXT of CLAUDE.md]

    ## Test Files

    [paths created by test-writer]

    ## Before You Begin

    If you have questions about:
    - Which test suites to run
    - Expected test setup or environment
    - Anything unclear

    **Ask them now.**

    ## Your Job

    1. Run the full E2E test suite
    2. Run core/regression tests if they exist
    3. Report results — do NOT attempt fixes

    ## Report Format

    - E2E tests: X passed, Y failed
    - Failed tests:
      - [test name]: [error message + stack trace]
      - [test name]: [error message + stack trace]
    - Core/regression tests: all pass / N broken
      - [broken test details if any]
    - Summary: ALL PASS / FAILURES FOUND
\```
```

**Step 4: Commit**

```bash
git add plugins/ohmy/skills/implement.app/test-writer-prompt.md plugins/ohmy/skills/implement.app/reviewer-prompt.md plugins/ohmy/skills/implement.app/qa-prompt.md
git commit -m "feat: add subagent prompt templates for implement.app"
```

---

### Task 2: Update plan.app SKILL.md

Add acceptance criteria to the task template and restructure phases (Phase 0 + Phase 3).

**Files:**
- Modify: `plugins/ohmy/skills/plan.app/SKILL.md`

**Step 1: Update the task template in the plan template**

In the `## 4. Task List` section of the plan template, update the task format to include acceptance criteria. Also add Phase 0 and restructure Phase 3.

Replace the entire `## 4. Task List` section (from line ~139 `## 4. Task List` through line ~185 `T1.1 → T2.1 → T3.1 → T3.2 → T3.3 → T3.4 → T3.5`) with:

```markdown
## 4. Task List

### 4.1 Task Overview

| Phase | Task Count | Description |
|-------|------------|-------------|
| E2E Test Scaffolding | 1 | TEST-WRITER subagent writes failing tests |
| Preparation | {n} | {description} |
| Core Implementation | {n} | {description} |
| Final QA | 3 (required) | QA subagent + self-learning |

### 4.2 Detailed Tasks

#### Phase 0: E2E Test Scaffolding (before implementation)

- [ ] **T0.1**: Write failing E2E tests from golden cases
  - Executor: TEST-WRITER subagent
  - Source: spec.app.md golden cases + CLAUDE.md test conventions
  - Key points: Tests must fail (RED) before implementation begins

#### Phase 1: Preparation

- [ ] **T1.1**: {task description}
  - Files: `{involved files}`
  - Key points: {implementation points}
  - **Acceptance criteria**:
    - {observable behavior 1}
    - {observable behavior 2}

#### Phase 2: Core Implementation

- [ ] **T2.1**: {task description}
  - Files: `{involved files}`
  - Key points: {implementation points}
  - Dependencies: T1.1
  - **Acceptance criteria**:
    - {observable behavior 1}
    - {observable behavior 2}

#### Phase 3: Final QA

- [ ] **T3.1**: Run full E2E test suite
  - Executor: QA subagent

- [ ] **T3.2**: Verify core tests not broken
  - Executor: QA subagent

- [ ] **T3.3**: Intelligent Memory Update - Self-Learning (required)
  - Files: `CLAUDE.md`
  - Key points:
    - Review & correct existing content, record lessons learned
    - Update acceptance criteria principles based on reviewer findings

### 4.3 Execution Order

\```
T0.1 → T1.x → T2.x (with REVIEWER subagent per task) → T3.x
\```
```

**Step 2: Update the Task List principles section**

Replace the `### Task List` section (under `## Plan Writing Principles`, around line ~207) with:

```markdown
### Task List

- Appropriate task granularity (completable in 2-4 hours)
- Clear dependencies
- Every implementation task must include **acceptance criteria**:
  - Observable behavior only (what the system does, not how)
  - One assertion per bullet
  - Include boundary conditions when relevant
  - Testable by a reviewer who hasn't seen the code
- Phase 0 (test scaffolding) and Phase 3 (QA) are required
```

**Step 3: Commit**

```bash
git add plugins/ohmy/skills/plan.app/SKILL.md
git commit -m "feat: add acceptance criteria and Phase 0/3 to plan.app"
```

---

### Task 3: Rewrite implement.app SKILL.md

This is the biggest change — replace the monolithic executor with the orchestrator pattern.

**Files:**
- Modify: `plugins/ohmy/skills/implement.app/SKILL.md` (full rewrite)

**Step 1: Replace the entire SKILL.md**

Write the complete new content for `plugins/ohmy/skills/implement.app/SKILL.md`:

```markdown
---
description: Execute technical plan using subagent-orchestrated TDD until E2E tests pass
---

## User Input

\```text
$ARGUMENTS
\```

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
```

**Step 2: Commit**

```bash
git add plugins/ohmy/skills/implement.app/SKILL.md
git commit -m "feat: rewrite implement.app as subagent orchestrator with TDD-first flow"
```

---

### Task 4: Update CLAUDE.md to reflect the new workflow

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Update the ohmy Plugin Workflow section**

Replace the `## ohmy Plugin Workflow` section (lines 30-46, from `The \`ohmy\` plugin implements...` through `...accurate across future sessions.`) with updated content that describes:

- The 3-phase workflow with subagent orchestration
- Phase 0 (TDD-first), per-task review, final QA
- The three subagent roles (TEST-WRITER, REVIEWER, QA)
- Updated self-learning loop description (now includes AC principles)

New content for the section:

```markdown
## ohmy Plugin Workflow

The `ohmy` plugin implements a 3-phase feature development workflow with subagent-orchestrated TDD, invoked as `/ohmy:specify.app`, `/ohmy:plan.app`, `/ohmy:implement.app`:

1. **`specify.app`** — Creates a git branch and `specs/{branch-name}/spec.app.md` with user scenarios, E2E golden test cases, and clarification questions (max 3).

2. **`plan.app`** — Reads `spec.app.md` + `CLAUDE.md`, explores the codebase, writes `specs/{branch-name}/plan.app.md` with architecture analysis, technology decisions, data models, file modification table, and a phased task list. Each implementation task includes **acceptance criteria** for the reviewer subagent.

3. **`implement.app`** — Orchestrates implementation using subagents:
   - **Phase 0**: Dispatches a TEST-WRITER subagent to write failing E2E tests from spec golden cases (TDD — RED state)
   - **Phases 1-2**: Main agent implements tasks; after each task, dispatches a REVIEWER subagent to verify spec compliance against acceptance criteria
   - **Phase 3**: Dispatches a QA subagent to run the full test suite; main agent fixes failures (max 3 rounds)
   - **Self-learning**: Updates `CLAUDE.md` with lessons learned, including acceptance criteria principles refined through reviewer feedback

### Subagent Roles

| Role | Dispatched by | Purpose |
|------|---------------|---------|
| TEST-WRITER | implement.app (Phase 0) | Explores project test patterns, writes failing E2E tests from spec golden cases |
| REVIEWER | implement.app (per task) | Verifies each acceptance criterion against actual code with file:line evidence |
| QA | implement.app (Phase 3) | Runs full E2E + regression test suite, reports pass/fail (never fixes code) |
```

Keep the existing `### Branch and Spec Naming Convention` and `### Self-Learning Loop` subsections, but update the Self-Learning Loop to mention AC principles:

```markdown
### Self-Learning Loop

`implement.app` is required to update `CLAUDE.md` at the end of every implementation cycle when it encounters repeated mistakes, non-obvious solutions, new architecture decisions, discovered gotchas, or weak acceptance criteria that caused reviewer confusion. This keeps project knowledge accurate across future sessions.
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md to reflect subagent-orchestrated TDD workflow"
```

---

### Task 5: Update README.md to reflect the new workflow

**Files:**
- Modify: `README.md`

**Step 1: Update the ohmy plugin description**

Update the command table and description to mention the subagent-orchestrated TDD approach. Replace the current table and surrounding text (lines 7-15) with:

```markdown
### ohmy — App Development Workflow

A 3-phase workflow for building features with AI: specify → plan → implement. Uses subagents for TDD-first test writing, per-task spec-compliance review, and final QA.

| Command | What it does |
|---------|-------------|
| `/ohmy:specify.app` | Creates a feature branch and `specs/{branch}/spec.app.md` — user scenarios, E2E golden test cases, and clarification questions |
| `/ohmy:plan.app` | Reads the spec, explores the codebase, writes `specs/{branch}/plan.app.md` — architecture analysis, tech decisions, data models, and a phased task list with acceptance criteria |
| `/ohmy:implement.app` | Orchestrates implementation: TEST-WRITER subagent writes failing E2E tests (TDD), main agent implements with per-task REVIEWER subagent, QA subagent runs final test suite, then updates `CLAUDE.md` with lessons learned |
```

**Step 2: Commit**

```bash
git add README.md
git commit -m "docs: update README.md with subagent-orchestrated workflow description"
```

---

Plan complete and saved to `docs/plans/2026-03-03-ohmy-workflow-implementation.md`. Two execution options:

**1. Subagent-Driven (this session)** — I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** — Open new session with executing-plans, batch execution with checkpoints

Which approach?