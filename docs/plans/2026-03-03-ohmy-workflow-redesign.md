# Ohmy Workflow Redesign — Subagent-Orchestrated TDD

## Goal

Redesign the ohmy 3-phase workflow (specify.app → plan.app → implement.app) to use subagents for TDD-first test writing, per-task spec-compliance review, and final QA — making `implement.app` an orchestrator rather than a monolithic executor.

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Architecture | Orchestrator pattern (Approach A) | Main agent keeps implementation context across tasks (efficient), while review and testing are done by independent subagents (rigorous) |
| Per-task review | Subagent reviewer | Independent verification is stronger than self-review; reviewer reads actual code, not just reports |
| QA failure handling | QA reports, main agent fixes | Clean separation of concerns; QA stays independent |
| E2E skills | Folded into app workflow | TDD-first makes tests a first-class part of the flow; separate E2E skills are redundant |
| Spec format | Keep human-readable, subagent translates | Keeps specs accessible; test-writer discovers project patterns independently |
| Testing context | Discovered by subagent, stored in CLAUDE.md via self-learning | Project-level knowledge, not feature-specific |
| AC principles | Emergent via self-learning loop | No upfront rules; principles accumulate from real reviewer/QA friction |

## Subagent Roles

### TEST-WRITER
- **When**: Phase 0, before any implementation
- **Input**: Full text of spec golden cases + CLAUDE.md
- **Does**: Explores project test patterns, writes failing E2E tests, confirms RED state
- **Returns**: Test file paths, framework discovered, full failure output

### REVIEWER (per-task)
- **When**: After each task is implemented
- **Input**: Task description + acceptance criteria + git diff
- **Does**: Verifies each acceptance criterion against actual code (not reports)
- **Returns**: Per-criterion PASS/FAIL with file:line evidence, overall verdict
- **Principle**: "Do Not Trust" — reads code independently, never trusts appearances

### QA (final)
- **When**: After all implementation phases complete
- **Input**: Spec golden cases + CLAUDE.md + test file paths
- **Does**: Runs full E2E suite + core/regression tests
- **Returns**: Structured pass/fail report with failure details
- **Principle**: Read-only — never fixes code, only reports

## Phase 1: specify.app (Unchanged)

No changes. Main agent interactively creates:

- Branch `{number}-{short-kebab-name}`
- `specs/{branch}/spec.app.md` containing:
  - User scenarios (As a / I want to / So that + Flow)
  - E2E golden test cases (human-readable, Happy Path only)
  - Clarification questions (max 3)

## Phase 2: plan.app (Enhanced)

Main agent creates `specs/{branch}/plan.app.md` with existing sections plus:

### New: Acceptance criteria per task

Each task now includes explicit acceptance criteria for the reviewer subagent:

```markdown
- [ ] **T2.1**: Implement user login endpoint
  - Files: `src/auth/login.ts`
  - Key points: JWT token generation, password hashing
  - Dependencies: T1.1
  - **Acceptance criteria**:
    - POST /api/login accepts email + password
    - Returns JWT token on success
    - Returns 401 on invalid credentials
```

Acceptance criteria principles:
- Observable behavior only (what the system does, not how)
- One assertion per bullet
- Include boundary conditions when relevant
- Testable by a reviewer who hasn't seen the code

### New: Phase 0 and restructured Phase 3

```markdown
#### Phase 0: E2E Test Scaffolding (before implementation)

- [ ] **T0.1**: Write failing E2E tests from golden cases
  - Executor: TEST-WRITER subagent
  - Source: spec.app.md golden cases + CLAUDE.md test conventions
  - Key points: Tests must fail (RED) before implementation begins

#### Phase 1-2: [existing preparation + core implementation]

#### Phase 3: Final QA

- [ ] **T3.1**: Run full E2E test suite
  - Executor: QA subagent
- [ ] **T3.2**: Verify core tests not broken
  - Executor: QA subagent
- [ ] **T3.3**: Intelligent Memory Update - Self-Learning
  - Files: `CLAUDE.md`
  - Key points:
    - Review & correct existing content, record lessons learned
    - Update acceptance criteria principles based on reviewer findings
```

Execution order: `T0.1 → T1.x → T2.x (with reviewer per task) → T3.x`

## Phase 3: implement.app (Major Redesign)

The main agent becomes a lightweight orchestrator that delegates to subagents.

### Step 1: Load Context

Read spec, plan, and CLAUDE.md. Parse the task list.

### Step 2: Dispatch TEST-WRITER Subagent (Phase 0)

```
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
```

Main agent then verifies tests exist and are reasonable, marks T0.1 complete.

### Step 3: Task Execution Loop (Phases 1-2)

For each task in phase order:

1. **Main agent implements** the task
2. **Dispatch REVIEWER subagent**:

```
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
```

3. **If FAIL** → main agent fixes → re-dispatch REVIEWER → repeat until PASS
4. **Mark task [x]** in plan.app.md

### Step 4: Dispatch QA Subagent (Phase 3)

```
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
```

- If all pass → proceed to Step 5
- If failures → main agent fixes → re-dispatch QA
- Max 3 QA rounds → stop and escalate to user

### Step 5: Self-Learning Update

Update `CLAUDE.md` when any of these occur:

| Condition | Example | Priority |
|-----------|---------|----------|
| Repeated mistakes | Same error made 2+ times | High |
| Non-obvious solutions | Significant debugging required | High |
| Architecture decisions | New patterns, conventions, tech choices | Medium |
| Gotchas & pitfalls | Unexpected behavior, edge cases | Medium |
| Outdated information | Existing memory content inaccurate | High |
| Weak acceptance criteria | Reviewer couldn't determine compliance | High |

## Guardrails

- **Tests pass before implementation** → Reject test-writer output; tests must be RED
- **Reviewer inconclusive** → Flag weak acceptance criteria for self-learning
- **3 QA failures** → Stop and escalate to user; don't loop forever
- **Subagent returns unclear results** → Main agent asks user for guidance

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    /ohmy:specify.app                             │
│                    (unchanged)                                   │
│                                                                  │
│  Main agent interactively creates:                               │
│  - Branch {number}-{short-kebab-name}                           │
│  - specs/{branch}/spec.app.md                                   │
│    - User scenarios                                              │
│    - E2E golden test cases (human-readable)                     │
│    - Clarification questions (max 3)                            │
└──────────────────────┬──────────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    /ohmy:plan.app                                │
│                    (enhanced)                                    │
│                                                                  │
│  Main agent creates specs/{branch}/plan.app.md:                 │
│  - Architecture analysis, tech decisions, data models           │
│  - File modification plan                                       │
│  - Phase 0: E2E test scaffolding (TEST-WRITER subagent)        │
│  - Phase 1-2: Implementation tasks                              │
│    - Each task now has acceptance criteria                       │
│  - Phase 3: Final QA + self-learning                           │
│  - Execution order: T0 → T1.x → T2.x → T3.x                  │
└──────────────────────┬──────────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    /ohmy:implement.app                           │
│                    (orchestrator)                                │
│                                                                  │
│  Step 1: Load context (spec + plan + CLAUDE.md)                 │
│                                                                  │
│  Step 2: Dispatch TEST-WRITER subagent                          │
│    - Explores project test patterns                              │
│    - Writes failing E2E tests from golden cases                 │
│    - Confirms all tests FAIL (RED)                              │
│    - Returns: test file paths + failure output                  │
│                                                                  │
│  Step 3: Task execution loop (per task)                         │
│    a. Main agent implements task                                │
│    b. Dispatch REVIEWER subagent                                │
│       - Checks acceptance criteria vs code                      │
│       - Returns PASS or FAIL with evidence                      │
│    c. If FAIL → fix → re-dispatch REVIEWER                     │
│    d. Mark task [x] in plan.app.md                              │
│                                                                  │
│  Step 4: Dispatch QA subagent                                   │
│    - Runs full E2E suite + core/regression tests                │
│    - Returns structured pass/fail report                        │
│    - If FAIL → main agent fixes → re-dispatch QA               │
│    - Max 3 QA rounds, then escalate to user                     │
│                                                                  │
│  Step 5: Self-learning update                                   │
│    - Lessons learned → CLAUDE.md                                │
│    - AC principles update based on reviewer friction            │
│                                                                  │
│  Guardrails:                                                    │
│    - Tests pass before implementation = reject test-writer      │
│    - Reviewer inconclusive = flag weak AC for self-learning     │
│    - 3 QA failures = stop and ask user                          │
└─────────────────────────────────────────────────────────────────┘
```
