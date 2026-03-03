# plan.app Subagent-Orchestrated Planning — Design

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add parallel research subagents and a plan-reviewer subagent to plan.app, improving research quality and plan validation before implementation.

**Architecture:** Redesign plan.app from single-agent to 4-phase subagent-orchestrated workflow: parallel research → synthesis → plan review → output.

---

## 1. Problem Statement

Currently `plan.app` is entirely single-agent — the main agent does all research, analysis, and plan writing by itself. This leads to:

- **Shallow research**: The main agent may miss patterns, dependencies, or existing code that should inform the plan
- **Unvalidated plans**: Plans sometimes have issues (unrealistic tasks, missing dependencies, weak acceptance criteria) that only surface during implementation
- **Inconsistent quality**: Plan quality varies depending on how thoroughly the main agent explores

## 2. Design

### 2.1 New Workflow Overview

```
spec.app.md + CLAUDE.md
        │
        ▼
┌────────────────────────────────┐
│ Phase 1: PARALLEL RESEARCH     │
│                                │
│  ARCH-EXPLORER (architecture)  │
│  DEPS-EXPLORER (dependencies)  │  ← all dispatched simultaneously
│  TEST-EXPLORER (test patterns) │
│                                │
└───────────────┬────────────────┘
                ▼
┌────────────────────────────────┐
│ Phase 2: SYNTHESIS             │
│ Main agent reads all research  │
│ reports, writes plan.app.md    │
└───────────────┬────────────────┘
                ▼
┌────────────────────────────────┐
│ Phase 3: PLAN REVIEW           │
│ PLAN-REVIEWER checks spec      │
│ alignment, criteria quality,   │
│ feasibility (max 3 rounds)     │
└───────────────┬────────────────┘
                ▼
           plan.app.md
```

### 2.2 Subagent Roles

| Role | Count | Dispatched | Purpose | Prompt Template |
|------|-------|-----------|---------|-----------------|
| ARCH-EXPLORER | 1 | Phase 1 (parallel) | Existing architecture, patterns, reusable code | `arch-explorer-prompt.md` |
| DEPS-EXPLORER | 1 | Phase 1 (parallel) | Dependencies, APIs, integration points, conflicts | `deps-explorer-prompt.md` |
| TEST-EXPLORER | 1 | Phase 1 (parallel) | Test framework, conventions, fixtures, utilities | `test-explorer-prompt.md` |
| PLAN-REVIEWER | 1 | Phase 3 | Spec-plan alignment, criteria quality, feasibility | `plan-reviewer-prompt.md` |

### 2.3 RESEARCHER Subagents (Phase 1)

All three are dispatched in a single message (parallel execution). Each receives spec.app.md feature description + CLAUDE.md as context.

#### ARCH-EXPLORER
- **Does**: Finds related modules, design patterns, reusable components, similar implementations
- **Returns**: Structured report — related files (with paths), patterns found, reusable code, architectural constraints

#### DEPS-EXPLORER
- **Does**: Checks package manifests / imports, finds external APIs, identifies services the feature touches, spots potential conflicts
- **Returns**: Structured report — required packages, API endpoints, integration points, potential conflicts

#### TEST-EXPLORER
- **Does**: Finds test framework, discovers file naming patterns, setup/teardown conventions, fixture patterns, coverage config
- **Returns**: Structured report — framework + config, naming conventions, example test snippets, test utilities available

### 2.4 PLAN-REVIEWER Subagent (Phase 3)

Receives full text of spec.app.md + plan.app.md + all three research reports.

**Checks:**

| Check | What It Means |
|-------|---------------|
| Spec-plan alignment | Every scenario/golden case has corresponding tasks; nothing extra |
| Task dependency correctness | Dependencies form valid DAG; no circular or missing deps |
| Acceptance criteria quality | Each criterion is observable, one assertion per bullet, testable by reviewer with zero context |
| File path validity | Modified files exist; new files have valid parent dirs |
| Research utilization | Plan uses discovered patterns/components; doesn't reinvent the wheel |
| Feasibility | No tasks assuming unavailable tech or impossible constraints |

**Report format:**
```
- Spec alignment: PASS/FAIL — [evidence]
- Dependencies: PASS/FAIL — [evidence]
- Acceptance criteria: PASS/FAIL — [weak criteria + suggestions]
- File paths: PASS/FAIL — [invalid paths]
- Research utilization: PASS/FAIL — [missed opportunities]
- Feasibility: PASS/FAIL — [concerns]
- Overall: APPROVED / REVISIONS NEEDED
- Issues: [specific list with suggested fixes]
```

**On failure**: Main agent revises → re-dispatches reviewer → max 3 rounds.

### 2.5 What Stays the Same

- Task format (2-4 hour blocks with acceptance criteria)
- plan.app.md template structure (sections 1-4)
- Phase 0/3 in task list (TEST-WRITER and QA from implement.app)
- Branch/spec naming convention
- Subagent dispatch principles (full text, not file paths)

## 3. Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `plugins/ohmy/skills/plan.app/SKILL.md` | Rewrite | New 4-phase workflow with subagent dispatch steps |
| `plugins/ohmy/skills/plan.app/arch-explorer-prompt.md` | Create | Architecture research subagent template |
| `plugins/ohmy/skills/plan.app/deps-explorer-prompt.md` | Create | Dependency research subagent template |
| `plugins/ohmy/skills/plan.app/test-explorer-prompt.md` | Create | Test pattern research subagent template |
| `plugins/ohmy/skills/plan.app/plan-reviewer-prompt.md` | Create | Plan review subagent template |
| `CLAUDE.md` | Update | Add plan.app subagent roles to workflow docs |
| `README.md` | Update | Reflect new plan.app workflow |

## 4. Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Researcher prompt organization | 3 separate templates | Each explorer has distinct scope and return format |
| Task granularity | Keep current 2-4hr format | implement.app already handles TDD via TEST-WRITER; bite-sized in plan is redundant |
| Review loop limit | Max 3 rounds | Prevents infinite loops; escalate to user after 3 |
| Research parallelism | All 3 dispatched simultaneously | Independent scopes, no shared state |
