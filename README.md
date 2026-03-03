# OhMyAICodingToolbox

A collection of Claude Code plugins that bring structured AI-assisted development workflows to any project.

## Plugins

### ohmy — App Development Workflow

A 3-phase workflow for building features with AI: specify → plan → implement.

| Command | What it does |
|---------|-------------|
| `/ohmy:specify.app` | Creates a feature branch and `specs/{branch}/spec.app.md` — user scenarios, E2E golden test cases, and clarification questions |
| `/ohmy:plan.app` | Reads the spec, explores the codebase, writes `specs/{branch}/plan.app.md` — architecture analysis, tech decisions, data models, and a phased task list |
| `/ohmy:implement.app` | Executes the plan task-by-task, runs E2E tests, and updates `CLAUDE.md` with lessons learned |

## Install

### Option 1: Local session (no install required)

```bash
claude --plugin-dir /path/to/OhMyAICodingToolbox/plugins/ohmy
```

### Option 2: Install from GitHub

```bash
claude plugin install https://github.com/laiyijie/OhMyAICodingToolbox --plugin ohmy
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
