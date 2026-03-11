# OhMyAICodingToolbox

A collection of Claude Code plugins that bring structured AI-assisted development workflows to any project.

## Key Features

### Test-Case-First Design

Every feature starts with test cases, not code. During the specify phase, E2E golden test cases are written upfront as part of the spec. During implementation, a dedicated TEST-WRITER subagent translates these into failing tests before any production code is touched (TDD red-green cycle). A separate QA subagent runs the full suite at the end — the feature isn't done until all tests pass.

### Self-Learning Loop

At the end of every implementation cycle, the workflow automatically updates your project's `CLAUDE.md` with lessons learned — repeated mistakes, non-obvious solutions, architecture decisions, discovered gotchas, and weak acceptance criteria that caused reviewer confusion. This means each feature you build makes the next one smarter. Knowledge accumulates across sessions, not just within them.

## Plugins

### ohmy — App Development Workflow

A 3-phase workflow for building features with AI: specify → plan → implement. Uses subagents for TDD-first test writing, per-task spec-compliance review, and final QA.

| Command | What it does |
|---------|-------------|
| `/ohmy:specify.app` | Creates a feature branch and `specs/{branch}/spec.app.md` — user scenarios, E2E golden test cases, and clarification questions |
| `/ohmy:plan.app` | Dispatches parallel research subagents (architecture, dependencies, test patterns), synthesizes findings into `specs/{branch}/plan.app.md`, then validates with a plan-reviewer subagent |
| `/ohmy:implement.app` | Orchestrates implementation: TEST-WRITER subagent writes failing E2E tests (TDD), main agent implements with per-task REVIEWER subagent, QA subagent runs final test suite, then updates `CLAUDE.md` with lessons learned |

## Install

### Option 1: Install from GitHub

Inside Claude Code, run:

```
/plugin marketplace add laiyijie/OhMyAICodingToolbox
/plugin install ohmy@laiyijie-OhMyAICodingToolbox
```

### Option 2: Install from local clone

```bash
git clone https://github.com/laiyijie/OhMyAICodingToolbox.git
```

Then inside Claude Code:

```
/plugin marketplace add ./OhMyAICodingToolbox
/plugin install ohmy@ohmy-toolbox
```

## Usage

```
/ohmy:specify.app add user login with Google OAuth
```

Claude will create a feature branch, write a spec, and ask up to 3 clarifying questions.

```
/ohmy:plan.app
```

Claude reads the spec and your codebase, then writes a detailed technical plan.

```
/ohmy:implement.app
```

Claude executes the plan phase-by-phase until all E2E tests pass, then updates your `CLAUDE.md` with what it learned.
