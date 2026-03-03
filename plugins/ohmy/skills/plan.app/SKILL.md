---
description: Create technical plan with parallel research, data models, file modification plan, and task list
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the spec.app.md specification document, create a complete technical implementation plan. Three parallel research subagents (ARCH-EXPLORER, DEPS-EXPLORER, TEST-EXPLORER) explore the codebase first, then the main agent synthesizes their findings into `plan.app.md`. A PLAN-REVIEWER subagent validates the plan against the spec before delivery.

## Subagent Roles

| Role | When | Does | Prompt Template |
|------|------|------|-----------------|
| ARCH-EXPLORER | Phase 1, parallel research | Explores architecture: related modules, design patterns, reusable components, similar implementations | `./arch-explorer-prompt.md` |
| DEPS-EXPLORER | Phase 1, parallel research | Explores dependencies: existing packages, external APIs, integration points, potential conflicts | `./deps-explorer-prompt.md` |
| TEST-EXPLORER | Phase 1, parallel research | Explores test infrastructure: framework, conventions, E2E patterns, test utilities | `./test-explorer-prompt.md` |
| PLAN-REVIEWER | Phase 3, after plan is written | Validates spec-plan alignment, dependency correctness, acceptance criteria quality, file paths, research utilization | `./plan-reviewer-prompt.md` |

## Execution Steps

### 1. Load Context

1. Read `specs/{branch-name}/spec.app.md` corresponding to the current branch
2. Read project's `CLAUDE.md` to understand architecture and conventions

### 2. Dispatch Parallel Research (Phase 1)

Dispatch all three research subagents **simultaneously** using the Agent tool:

1. **ARCH-EXPLORER** — dispatch using the template in `./arch-explorer-prompt.md`:
   - Provide **full text** of section 1 (User Scenarios) from spec.app.md
   - Provide **full text** of CLAUDE.md
   - Do NOT provide file paths for the subagent to read — paste everything it needs

2. **DEPS-EXPLORER** — dispatch using the template in `./deps-explorer-prompt.md`:
   - Provide **full text** of section 1 (User Scenarios) from spec.app.md
   - Provide **full text** of CLAUDE.md
   - Do NOT provide file paths for the subagent to read — paste everything it needs

3. **TEST-EXPLORER** — dispatch using the template in `./test-explorer-prompt.md`:
   - Provide **full text** of section 1 (User Scenarios) from spec.app.md
   - Provide **full text** of CLAUDE.md
   - Do NOT provide file paths for the subagent to read — paste everything it needs

**After all three subagents return:**

1. Collect each subagent's report
2. Note any contradictions between reports (e.g., ARCH-EXPLORER says "use pattern X" but DEPS-EXPLORER flags a version conflict with it)
3. If a subagent returned unclear or incomplete results, re-dispatch it with clarified instructions (max 1 retry per subagent)

### 3. Synthesize & Write Plan File (Phase 2)

Synthesize findings from all three research reports and write `specs/{branch-name}/plan.app.md`:

````markdown
# {Feature Name} - Technical Plan

## 1. Technical Research and Solution Selection

### 1.1 Existing Architecture Analysis

*(Informed by ARCH-EXPLORER report)*

Analyze existing code related to this feature:
- Related modules: {list related modules/files}
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

```typescript
interface {EntityName} {
  field1: type;
  field2: type;
}
```

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

```
{Data flow diagram, using ASCII or simple description}
```

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

```
T0.1 → T1.x → T2.x (with REVIEWER subagent per task) → T3.x
```
````

### 4. Dispatch Plan Review (Phase 3)

Dispatch a PLAN-REVIEWER subagent using the template in `./plan-reviewer-prompt.md`:

- Provide **full text** of spec.app.md
- Provide **full text** of the plan.app.md just written
- Provide **full text** of all three research reports (ARCH-EXPLORER, DEPS-EXPLORER, TEST-EXPLORER)
- Do NOT provide file paths for the subagent to read — paste everything it needs

**After the subagent returns:**

1. If **APPROVED** → proceed to Output
2. If **REVISIONS NEEDED** → apply the reviewer's suggested fixes to plan.app.md, then re-dispatch the PLAN-REVIEWER
3. **Max 3 review rounds** → if still not approved after 3 rounds, present the remaining issues to the user and ask for guidance

## Subagent Dispatch Principles

1. **Full text, not file paths**: Paste everything the subagent needs into the prompt. Subagents should not need to read spec or plan files.
2. **Parallel research**: All three Phase 1 subagents are dispatched simultaneously — they are independent of each other.
3. **"Before You Begin"**: All subagent prompts include a section for asking questions. Answer them before letting the subagent proceed.
4. **Independent verification**: The PLAN-REVIEWER reads actual file paths and cross-references the spec — it never trusts the plan at face value.

## Plan Writing Principles

### Technical Research

- Incorporate findings from ARCH-EXPLORER, DEPS-EXPLORER, and TEST-EXPLORER reports
- Prioritize reusing existing code and patterns identified by research subagents
- Maintain consistency with project architecture
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

- **Unclear research results** → Ask user for guidance before synthesizing a plan based on ambiguous findings
- **Reviewer inconclusive** → Flag the specific sections and ask user whether to proceed or revise
- **3 review failures** → Stop and escalate to user; don't loop forever
- **Research contradicts CLAUDE.md** → Prioritize CLAUDE.md; note the contradiction in the plan for user awareness

## Output

Upon completion, report:
1. Plan file path
2. Research highlights (key findings from each subagent)
3. Summary of key technical decisions
4. Total task count and phase breakdown
5. Plan review result (APPROVED or issues remaining)

**Next Step**: After user confirms the plan, run `/ohmy:implement.app` to execute implementation
