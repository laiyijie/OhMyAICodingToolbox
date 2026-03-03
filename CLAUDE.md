# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

OhMyAICodingToolbox is a collection of installable Claude Code plugins that provide structured AI coding workflows. Each plugin lives under `plugins/{plugin-name}/` and contains skill definitions used by Claude Code's Skill system.

## Plugin Structure

Each plugin follows this layout:

```
plugins/{plugin-name}/
  .claude-plugin/plugin.json   # Plugin manifest (name, description, version, author, homepage)
  skills/{skill-name}/SKILL.md # One directory per skill
```

**`plugin.json` required fields**: `name`, `description`, `version`, `author.name`, `homepage`

**`SKILL.md` required frontmatter**:
```yaml
---
description: <one-line description used for skill triggering>
---
```

Skills accept `$ARGUMENTS` (passed from skill invocation) and must document their execution steps, output format, and what the next step is.

## ohmy Plugin Workflow

The `ohmy` plugin implements a 3-phase feature development workflow, invoked as `/ohmy:specify.app`, `/ohmy:plan.app`, `/ohmy:implement.app`:

1. **`specify.app`** — Creates a git branch and `specs/{branch-name}/spec.app.md` with user scenarios, E2E golden test cases, and clarification questions (max 3).

2. **`plan.app`** — Reads `spec.app.md` + `CLAUDE.md`, explores the codebase, writes `specs/{branch-name}/plan.app.md` with architecture analysis, technology decisions, data models, file modification table, and a phased task list.

3. **`implement.app`** — Reads both spec and plan, executes tasks phase-by-phase, marks tasks `[x]` in `plan.app.md` as they complete, runs E2E tests, and updates `CLAUDE.md` with learned lessons (self-learning loop).

### Branch and Spec Naming Convention

Branches and spec directories follow `{number}-{short-kebab-name}` (e.g., `1-add-user-auth`). The number increments from the highest existing branch/spec with the same base name across local branches, remote branches, and the `specs/` directory.

### Self-Learning Loop

`implement.app` is required to update `CLAUDE.md` at the end of every implementation cycle when it encounters repeated mistakes, non-obvious solutions, new architecture decisions, or discovered gotchas. This keeps project knowledge accurate across future sessions.
