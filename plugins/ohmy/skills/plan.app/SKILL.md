---
description: Create technical plan with research, data models, file modification plan, and task list
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the spec.app.md specification document, create a complete technical implementation plan. All content goes in a single `plan.app.md` file.

## Execution Steps

### 1. Load Context

1. Read `specs/{branch-name}/spec.app.md` corresponding to the current branch
2. Read project's `CLAUDE.md` to understand architecture and conventions
3. Explore related code files to understand existing implementation

### 2. Write Plan File

Write the following content in `specs/{branch-name}/plan.app.md`:

```markdown
# {Feature Name} - Technical Plan

## 1. Technical Research and Solution Selection

### 1.1 Existing Architecture Analysis

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
```

## Plan Writing Principles

### Technical Research

- Prioritize reusing existing code and patterns
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

## Output

Upon completion, report:
1. Plan file path
2. Summary of key technical decisions
3. Total task count and phase breakdown

**Next Step**: After user confirms the plan, run `/ohmy:implement.app` to execute implementation
