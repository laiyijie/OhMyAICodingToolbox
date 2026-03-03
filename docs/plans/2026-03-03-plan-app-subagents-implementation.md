# plan.app Subagent-Orchestrated Planning — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add parallel research subagents (ARCH-EXPLORER, DEPS-EXPLORER, TEST-EXPLORER) and a PLAN-REVIEWER subagent to the ohmy `plan.app` skill.

**Architecture:** Create 4 new prompt template files alongside the existing `SKILL.md`, then rewrite `SKILL.md` to orchestrate a 4-phase workflow: parallel research → synthesis → plan review → output. Update project docs to reflect the new subagent roles.

**Tech Stack:** Claude Code plugins (Markdown skill definitions), Agent tool for subagent dispatch

---

## Task 1: Create arch-explorer-prompt.md

**Files:**
- Create: `plugins/ohmy/skills/plan.app/arch-explorer-prompt.md`
- Reference: `plugins/ohmy/skills/implement.app/test-writer-prompt.md` (for prompt template style)

**Step 1: Write the prompt template**

Create `plugins/ohmy/skills/plan.app/arch-explorer-prompt.md` with this exact content:

```markdown
# ARCH-EXPLORER Subagent Prompt Template

Use this template when dispatching the architecture research subagent in Phase 1.

\```
Agent tool (general-purpose):
  description: "Explore architecture for: [feature name]"
  prompt: |
    You are a codebase architect exploring an existing project to inform a technical plan.

    ## Feature Being Planned

    [FULL TEXT of section 1 (User Scenarios) from spec.app.md]

    ## Project Conventions

    [FULL TEXT of CLAUDE.md]

    ## Before You Begin

    If you have questions about:
    - The feature scope or intended behavior
    - Which areas of the codebase to focus on
    - Anything unclear

    **Ask them now.** Don't guess.

    ## Your Job

    Explore the codebase to find everything relevant to this feature:

    1. **Related modules**: Find files/modules that implement similar or adjacent functionality
    2. **Design patterns**: Identify patterns used in the codebase (e.g., repository pattern, middleware chains, event-driven, etc.)
    3. **Reusable components**: Find existing code that the new feature should reuse rather than reinvent
    4. **Similar implementations**: Find features that were built similarly to what's being planned — these are the best guide for how to implement the new one
    5. **Architectural constraints**: Identify conventions or constraints that the plan must respect (e.g., "all routes go through middleware X", "state is managed via Y")

    Work from: [project root]

    ## Report Format

    When done, report:

    ### Related Modules
    - `path/to/file.ts` — [what it does, why it's relevant]
    - ...

    ### Design Patterns Found
    - [pattern name]: [where it's used, how it works]
    - ...

    ### Reusable Components
    - `path/to/component.ts:functionName` — [what it provides, how to reuse it]
    - ...

    ### Similar Implementations (Best Reference)
    - `path/to/similar/feature/` — [what it does, why it's a good model]
    - ...

    ### Architectural Constraints
    - [constraint]: [evidence from codebase]
    - ...
\```
```

Note: The triple backticks inside the file should NOT be escaped — the backslash-backticks above are only to prevent markdown rendering issues in this plan document. Write actual triple backticks in the file.

**Step 2: Verify the file exists and matches the template structure**

Run: `head -5 plugins/ohmy/skills/plan.app/arch-explorer-prompt.md`
Expected: Shows `# ARCH-EXPLORER Subagent Prompt Template` and preamble

**Step 3: Commit**

```bash
git add plugins/ohmy/skills/plan.app/arch-explorer-prompt.md
git commit -m "feat: add arch-explorer subagent prompt template for plan.app"
```

---

## Task 2: Create deps-explorer-prompt.md

**Files:**
- Create: `plugins/ohmy/skills/plan.app/deps-explorer-prompt.md`

**Step 1: Write the prompt template**

Create `plugins/ohmy/skills/plan.app/deps-explorer-prompt.md` with this exact content:

```markdown
# DEPS-EXPLORER Subagent Prompt Template

Use this template when dispatching the dependency research subagent in Phase 1.

\```
Agent tool (general-purpose):
  description: "Explore dependencies for: [feature name]"
  prompt: |
    You are a dependency analyst exploring an existing project to inform a technical plan.

    ## Feature Being Planned

    [FULL TEXT of section 1 (User Scenarios) from spec.app.md]

    ## Project Conventions

    [FULL TEXT of CLAUDE.md]

    ## Before You Begin

    If you have questions about:
    - The feature scope or what external services it might need
    - Package management conventions
    - Anything unclear

    **Ask them now.** Don't guess.

    ## Your Job

    Explore the project's dependency landscape relevant to this feature:

    1. **Package manifests**: Check package.json, requirements.txt, go.mod, Cargo.toml, or equivalent — identify existing dependencies that the feature can leverage
    2. **External APIs/services**: Identify any external APIs, databases, or services the feature will need to interact with
    3. **Integration points**: Find where the new feature connects to existing code — entry points, hooks, event systems, routing, etc.
    4. **Potential conflicts**: Check for version constraints, peer dependency issues, or incompatible packages that could cause problems
    5. **Missing dependencies**: Identify new packages/libraries that will need to be added

    Work from: [project root]

    ## Report Format

    When done, report:

    ### Existing Dependencies (Relevant)
    - `package-name@version` — [what it provides for this feature]
    - ...

    ### External APIs / Services
    - [service name]: [how the feature interacts with it, auth requirements]
    - ...

    ### Integration Points
    - `path/to/file.ts:lineOrFunction` — [how the feature hooks in]
    - ...

    ### Potential Conflicts
    - [conflict description]: [which packages, what the risk is]
    - ...

    ### New Dependencies Needed
    - `package-name` — [why it's needed, what alternatives exist]
    - ...
\```
```

Note: Same backtick escaping caveat as Task 1.

**Step 2: Verify the file exists**

Run: `head -5 plugins/ohmy/skills/plan.app/deps-explorer-prompt.md`
Expected: Shows `# DEPS-EXPLORER Subagent Prompt Template`

**Step 3: Commit**

```bash
git add plugins/ohmy/skills/plan.app/deps-explorer-prompt.md
git commit -m "feat: add deps-explorer subagent prompt template for plan.app"
```

---

## Task 3: Create test-explorer-prompt.md

**Files:**
- Create: `plugins/ohmy/skills/plan.app/test-explorer-prompt.md`

**Step 1: Write the prompt template**

Create `plugins/ohmy/skills/plan.app/test-explorer-prompt.md` with this exact content:

```markdown
# TEST-EXPLORER Subagent Prompt Template

Use this template when dispatching the test pattern research subagent in Phase 1.

\```
Agent tool (general-purpose):
  description: "Explore test patterns for: [feature name]"
  prompt: |
    You are a test infrastructure analyst exploring an existing project to inform a technical plan.

    ## Feature Being Planned

    [FULL TEXT of section 1 (User Scenarios) from spec.app.md]

    ## Project Conventions

    [FULL TEXT of CLAUDE.md]

    ## Before You Begin

    If you have questions about:
    - What kinds of tests are expected for this feature
    - Test scope or boundaries
    - Anything unclear

    **Ask them now.** Don't guess.

    ## Your Job

    Explore the project's test infrastructure so the plan can specify correct test conventions:

    1. **Test framework**: Identify the test runner (Jest, Pytest, Go test, etc.), configuration files, and how tests are executed
    2. **File naming conventions**: How are test files named? Where do they live? (e.g., `__tests__/`, `*.test.ts`, `tests/test_*.py`)
    3. **Setup/teardown patterns**: How do existing tests set up state? Database fixtures, mocks, factory functions, beforeEach/afterAll patterns
    4. **E2E test patterns**: If E2E tests exist, how are they structured? What tools are used (Playwright, Cypress, Supertest, etc.)?
    5. **Test utilities**: Find shared helpers, custom matchers, test factories, or assertion utilities that tests should reuse
    6. **Coverage config**: Is there a coverage tool? What thresholds are set?

    Work from: [project root]

    ## Report Format

    When done, report:

    ### Test Framework
    - Framework: [name + version]
    - Config: `path/to/config`
    - Run command: `[exact command to run tests]`

    ### File Conventions
    - Test file pattern: [e.g., `*.test.ts` in `__tests__/`]
    - Naming: [e.g., `describe('ModuleName', () => { test('should ...') })`]

    ### Setup/Teardown Patterns
    - [pattern]: [example from codebase, file:line ref]
    - ...

    ### E2E Test Patterns
    - Tool: [e.g., Playwright]
    - Structure: [how E2E tests are organized]
    - Example: `path/to/e2e/test.ts` — [brief description]

    ### Test Utilities Available
    - `path/to/helper.ts:functionName` — [what it provides]
    - ...

    ### Coverage
    - Tool: [e.g., c8, istanbul]
    - Thresholds: [if configured]
\```
```

Note: Same backtick escaping caveat as Task 1.

**Step 2: Verify the file exists**

Run: `head -5 plugins/ohmy/skills/plan.app/test-explorer-prompt.md`
Expected: Shows `# TEST-EXPLORER Subagent Prompt Template`

**Step 3: Commit**

```bash
git add plugins/ohmy/skills/plan.app/test-explorer-prompt.md
git commit -m "feat: add test-explorer subagent prompt template for plan.app"
```

---

## Task 4: Create plan-reviewer-prompt.md

**Files:**
- Create: `plugins/ohmy/skills/plan.app/plan-reviewer-prompt.md`
- Reference: `plugins/ohmy/skills/implement.app/reviewer-prompt.md` (for reviewer prompt style)

**Step 1: Write the prompt template**

Create `plugins/ohmy/skills/plan.app/plan-reviewer-prompt.md` with this exact content:

```markdown
# PLAN-REVIEWER Subagent Prompt Template

Use this template when dispatching the plan review subagent in Phase 3.

\```
Agent tool (general-purpose):
  description: "Review plan for: [feature name]"
  prompt: |
    You are reviewing whether a technical plan is complete, correct, and aligned with its specification.

    ## Specification

    [FULL TEXT of spec.app.md]

    ## Technical Plan

    [FULL TEXT of plan.app.md]

    ## Research Reports

    ### Architecture Research
    [FULL TEXT of ARCH-EXPLORER report]

    ### Dependency Research
    [FULL TEXT of DEPS-EXPLORER report]

    ### Test Pattern Research
    [FULL TEXT of TEST-EXPLORER report]

    ## CRITICAL: Do Not Trust Appearances

    You MUST verify everything independently. The plan may look thorough but have gaps.

    **DO NOT:**
    - Assume the plan covers all spec scenarios because it looks long
    - Trust that file paths are correct without checking
    - Accept vague acceptance criteria
    - Overlook missing dependencies between tasks

    **DO:**
    - Cross-reference every spec scenario against plan tasks
    - Verify file paths exist (for modifications) or parent dirs exist (for new files)
    - Check each acceptance criterion is observable and testable
    - Verify the research findings were actually used in the plan

    ## Your Job

    Check each of the following:

    ### 1. Spec-Plan Alignment
    For each user scenario and golden case in the spec:
    - Find the task(s) that implement it
    - Verify nothing in the spec is missing from the plan
    - Verify nothing in the plan exceeds what the spec requests (YAGNI)

    ### 2. Task Dependency Correctness
    - Dependencies form a valid DAG (no cycles)
    - No task references a dependency that doesn't exist
    - No task is missing a dependency it clearly needs

    ### 3. Acceptance Criteria Quality
    For each task's acceptance criteria:
    - Is each criterion about observable behavior (not implementation details)?
    - Is there exactly one assertion per bullet?
    - Could a reviewer with zero codebase context verify it?
    - Are boundary conditions covered where relevant?

    ### 4. File Path Validity
    - Files listed for modification: do they exist in the project?
    - Files listed for creation: do their parent directories exist?
    - Are file paths consistent across tasks?

    ### 5. Research Utilization
    - Did the plan use the reusable components found by ARCH-EXPLORER?
    - Did the plan account for dependencies found by DEPS-EXPLORER?
    - Did the plan follow test conventions found by TEST-EXPLORER?
    - Is the plan reinventing anything that already exists?

    ### 6. Feasibility
    - Are there tasks that assume technology/APIs that aren't available?
    - Are task time estimates reasonable (2-4 hours each)?
    - Are there any impossible or contradictory requirements?

    ## Report Format

    - Spec alignment: PASS/FAIL — [evidence]
    - Dependencies: PASS/FAIL — [evidence]
    - Acceptance criteria: PASS/FAIL — [weak criteria listed with suggestions]
    - File paths: PASS/FAIL — [invalid paths listed]
    - Research utilization: PASS/FAIL — [missed opportunities]
    - Feasibility: PASS/FAIL — [concerns]
    - Overall: APPROVED / REVISIONS NEEDED
    - Issues: [specific list with suggested fixes]
\```
```

Note: Same backtick escaping caveat as Task 1.

**Step 2: Verify the file exists**

Run: `head -5 plugins/ohmy/skills/plan.app/plan-reviewer-prompt.md`
Expected: Shows `# PLAN-REVIEWER Subagent Prompt Template`

**Step 3: Commit**

```bash
git add plugins/ohmy/skills/plan.app/plan-reviewer-prompt.md
git commit -m "feat: add plan-reviewer subagent prompt template for plan.app"
```

---

## Task 5: Rewrite plan.app SKILL.md

**Files:**
- Modify: `plugins/ohmy/skills/plan.app/SKILL.md` (full rewrite)
- Reference: `plugins/ohmy/skills/implement.app/SKILL.md` (for subagent dispatch patterns)

**Step 1: Rewrite SKILL.md with the new 4-phase workflow**

Replace the entire contents of `plugins/ohmy/skills/plan.app/SKILL.md` with:

```markdown
---
description: Create technical plan with parallel research, data models, file modification plan, and task list
---

## User Input

\```text
$ARGUMENTS
\```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the spec.app.md specification document, create a complete technical implementation plan using parallel research subagents for thorough codebase exploration and a plan-reviewer subagent for quality validation. All plan content goes in a single `plan.app.md` file.

## Subagent Roles

| Role | When | Does | Prompt Template |
|------|------|------|-----------------|
| ARCH-EXPLORER | Phase 1 (parallel) | Explores existing architecture, patterns, reusable code | `./arch-explorer-prompt.md` |
| DEPS-EXPLORER | Phase 1 (parallel) | Explores dependencies, APIs, integration points | `./deps-explorer-prompt.md` |
| TEST-EXPLORER | Phase 1 (parallel) | Explores test framework, conventions, fixtures | `./test-explorer-prompt.md` |
| PLAN-REVIEWER | Phase 3 | Verifies spec alignment, criteria quality, feasibility | `./plan-reviewer-prompt.md` |

## Execution Steps

### 1. Load Context

1. Read `specs/{branch-name}/spec.app.md` corresponding to the current branch
2. Read project's `CLAUDE.md` to understand architecture and conventions

### 2. Dispatch Parallel Research (Phase 1)

Dispatch all three research subagents **simultaneously** using the Agent tool:

1. **ARCH-EXPLORER** using `./arch-explorer-prompt.md`:
   - Provide **full text** of spec.app.md section 1 (User Scenarios)
   - Provide **full text** of CLAUDE.md
   - Do NOT provide file paths — paste everything it needs

2. **DEPS-EXPLORER** using `./deps-explorer-prompt.md`:
   - Provide **full text** of spec.app.md section 1 (User Scenarios)
   - Provide **full text** of CLAUDE.md

3. **TEST-EXPLORER** using `./test-explorer-prompt.md`:
   - Provide **full text** of spec.app.md section 1 (User Scenarios)
   - Provide **full text** of CLAUDE.md

**After all subagents return:**

Collect and review all three research reports. If any report flagged questions or concerns, address them before proceeding.

### 3. Synthesize & Write Plan File (Phase 2)

Using the research reports as input, write `specs/{branch-name}/plan.app.md` with the following content:

\```markdown
# {Feature Name} - Technical Plan

## 1. Technical Research and Solution Selection

### 1.1 Existing Architecture Analysis

Analyze existing code related to this feature (informed by ARCH-EXPLORER report):
- Related modules: {list related modules/files with paths}
- Existing patterns: {describe existing design patterns}
- Reusable components: {existing code that can be reused}

### 1.2 Technology Selection

#### 1.2.1 {Decision Point 1 Name}

**Decision Background**

{Describe the business and technical background of this decision point, and why this decision needs to be made}

**Solution Research**

Researched {technical area} and analyzed the following options:

**Option A: {Option Name}**
- Advantages: {list main advantages}
- Disadvantages: {list main disadvantages}
- Use cases: {describe most suitable scenarios}
- Technical maturity: {assess technical maturity and community support}

**Option B: {Option Name}**
- Advantages: {list main advantages}
- Disadvantages: {list main disadvantages}
- Use cases: {describe most suitable scenarios}
- Technical maturity: {assess technical maturity and community support}

**Final Solution and Rationale**

Considering project requirements, technical architecture, development cost, and maintenance cost, the final choice is **{Final Option Name}**.

Reasons for selection:
1. {Reason 1: e.g., compatibility with existing tech stack}
2. {Reason 2: e.g., development efficiency, performance}
3. {Reason 3: e.g., team familiarity, community support}

Risks and Mitigations:
- {Potential risk 1} → {Mitigation}
- {Potential risk 2} → {Mitigation}

---

#### Technology Selection Summary Table

| Decision Point | Choice | Rationale | Alternatives |
|----------------|--------|-----------|--------------|
| {Decision 1} | {Choice} | {Rationale} | {Alternatives} |

### 1.3 Technical Constraints

- {Constraint 1}
- {Constraint 2}

## 2. Data Model Design

### 2.1 New/Modified Data Structures

\```typescript
interface {EntityName} {
  field1: type;
  field2: type;
}
\```

### 2.2 Database Design (if applicable)

#### 2.2.1 Table Structure Design

**{Table Name}**

| Field | Type | Constraints | Description | Index |
|-------|------|-------------|-------------|-------|
| `id` | INT | PRIMARY KEY | ID | Yes |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Created time | No |

### 2.3 State Management (if applicable)

Describe state lifecycle and transitions:
- Initial state → Intermediate state → Final state

### 2.4 Data Flow

\```
{Data flow diagram, using ASCII or simple description}
\```

## 3. File Modification Plan

### 3.1 New Files

| File Path | Purpose | Key Content |
|-----------|---------|-------------|
| `path/to/new/file.ts` | {purpose} | {key content} |

### 3.2 Modified Files

| File Path | Modification | Reason |
|-----------|--------------|--------|
| `path/to/existing/file.ts` | {modification} | {reason} |

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
\```

### 4. Dispatch Plan Review (Phase 3)

Dispatch PLAN-REVIEWER subagent using `./plan-reviewer-prompt.md`:

- Provide **full text** of spec.app.md
- Provide **full text** of plan.app.md (just written)
- Provide **full text** of all three research reports
- Do NOT provide file paths — paste everything it needs

**After the subagent returns:**

- **APPROVED** → proceed to output
- **REVISIONS NEEDED** → fix the issues cited by reviewer → re-dispatch PLAN-REVIEWER → repeat until APPROVED
- **Max 3 review rounds** → if still failing after 3 rounds, present issues to user for guidance

## Subagent Dispatch Principles

1. **Full text, not file paths**: Paste everything the subagent needs into the prompt. Subagents should not need to read plan or spec files.
2. **Parallel research**: All three research subagents are dispatched in a single message (parallel execution).
3. **"Before You Begin"**: All subagent prompts include a section for asking questions. Answer them before letting the subagent proceed.
4. **Independent verification**: The plan reviewer reads actual file paths and criteria, never trusts that the plan "looks complete."

## Plan Writing Principles

### Technical Research

- Incorporate findings from all three research subagents
- Prioritize reusing existing code and patterns (from ARCH-EXPLORER)
- Account for dependencies and integration points (from DEPS-EXPLORER)
- Follow test conventions (from TEST-EXPLORER)
- Reference architecture notes in CLAUDE.md

### Data Model

- Use project's existing data structure style
- Consider backward compatibility
- Clearly define field types and constraints

### File Modifications

- Minimize modification scope
- Avoid over-engineering
- Every modification must have a clear reason

### Task List

- Appropriate task granularity (completable in 2-4 hours)
- Clear dependencies
- Every implementation task must include **acceptance criteria**:
  - Observable behavior only (what the system does, not how)
  - One assertion per bullet
  - Include boundary conditions when relevant
  - Testable by a reviewer who hasn't seen the code
- Phase 0 (test scaffolding) and Phase 3 (QA) are required

## Guardrails

- **Research subagent returns unclear results** → Ask user for guidance before synthesizing
- **Plan reviewer inconclusive** → Flag weak sections for user review
- **3 review failures** → Stop and escalate to user; don't loop forever
- **Research contradicts CLAUDE.md** → Prioritize CLAUDE.md conventions; flag the contradiction

## Output

Upon completion, report:
1. Plan file path
2. Summary of key technical decisions
3. Total task count and phase breakdown
4. Research highlights (key findings from each explorer)
5. Plan review result (APPROVED + any revisions made)

**Next Step**: After user confirms the plan, run `/ohmy:implement.app` to execute implementation
```

Note: Escaped backticks (\```) in the template above are for this plan document only. Write actual triple backticks in the file.

**Step 2: Verify the file has the new structure**

Run: `grep -c "Phase" plugins/ohmy/skills/plan.app/SKILL.md`
Expected: Multiple matches showing Phase 1, 2, 3 references

Run: `grep "Subagent Roles" plugins/ohmy/skills/plan.app/SKILL.md`
Expected: Shows the subagent roles table header

**Step 3: Commit**

```bash
git add plugins/ohmy/skills/plan.app/SKILL.md
git commit -m "feat: rewrite plan.app as subagent-orchestrated workflow with parallel research and plan review"
```

---

## Task 6: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md:30-50` (ohmy Plugin Workflow section and Subagent Roles table)

**Step 1: Update the plan.app description**

In the `## ohmy Plugin Workflow` section, replace the `plan.app` description (item 2) with:

```markdown
2. **`plan.app`** — Orchestrates planning using subagents:
   - **Phase 1**: Dispatches ARCH-EXPLORER, DEPS-EXPLORER, and TEST-EXPLORER subagents in parallel to research architecture, dependencies, and test patterns
   - **Phase 2**: Main agent synthesizes research and writes `specs/{branch-name}/plan.app.md` with architecture analysis, technology decisions, data models, file modification table, and a phased task list with acceptance criteria
   - **Phase 3**: Dispatches a PLAN-REVIEWER subagent to verify spec alignment, criteria quality, and feasibility (max 3 rounds)
```

**Step 2: Add plan.app subagents to the Subagent Roles table**

Add these rows to the existing table:

```markdown
| ARCH-EXPLORER | plan.app (Phase 1, parallel) | Explores existing architecture, design patterns, reusable components |
| DEPS-EXPLORER | plan.app (Phase 1, parallel) | Explores dependencies, APIs, integration points, potential conflicts |
| TEST-EXPLORER | plan.app (Phase 1, parallel) | Explores test framework, conventions, fixtures, utilities |
| PLAN-REVIEWER | plan.app (Phase 3) | Verifies spec-plan alignment, acceptance criteria quality, feasibility |
```

**Step 3: Verify the changes**

Run: `grep "ARCH-EXPLORER" CLAUDE.md`
Expected: Shows the new table row

Run: `grep "Phase 1" CLAUDE.md`
Expected: Shows the parallel research phase description

**Step 4: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md with plan.app subagent roles"
```

---

## Task 7: Update README.md

**Files:**
- Modify: `README.md:14` (the plan.app row in the command table)

**Step 1: Update the plan.app command description**

Replace the `/ohmy:plan.app` row in the commands table with:

```markdown
| `/ohmy:plan.app` | Dispatches parallel research subagents (architecture, dependencies, test patterns), synthesizes findings into `specs/{branch}/plan.app.md`, then validates with a plan-reviewer subagent |
```

**Step 2: Verify the change**

Run: `grep "plan.app" README.md`
Expected: Shows updated description mentioning subagents

**Step 3: Commit**

```bash
git add README.md
git commit -m "docs: update README.md with plan.app subagent workflow description"
```

---

## Summary

| Task | Files | Action |
|------|-------|--------|
| 1 | `arch-explorer-prompt.md` | Create architecture research template |
| 2 | `deps-explorer-prompt.md` | Create dependency research template |
| 3 | `test-explorer-prompt.md` | Create test pattern research template |
| 4 | `plan-reviewer-prompt.md` | Create plan review template |
| 5 | `SKILL.md` | Rewrite with 4-phase subagent workflow |
| 6 | `CLAUDE.md` | Add plan.app subagent roles |
| 7 | `README.md` | Update plan.app description |

Tasks 1-4 are independent (can be done in parallel). Task 5 depends on 1-4 (references the prompt files). Tasks 6-7 are independent of each other but should follow Task 5.
