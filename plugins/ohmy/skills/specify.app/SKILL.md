---
description: Create feature specification with user scenarios, E2E test cases, and clarification questions
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the feature description provided by the user, create a concise feature specification document.

## Execution Steps

### 1. Generate Branch Name

Analyze the feature description and generate a short 2-4 word name:
- Use kebab-case format (e.g., `add-user-auth`, `fix-payment-bug`)
- Preserve technical terms and abbreviations

### 2. Create Branch and Specification File

```bash
# Fetch latest remote branches
git fetch --all --prune

# Find the highest number for branches with the same name
# Check remote branches, local branches, specs/ directory

# Create new branch (increment number by 1)
git checkout -b {number}-{short-name}

# Create specification directory and file
mkdir -p specs/{number}-{short-name}
```

### 3. Write Specification File

Write the following content in `specs/{number}-{short-name}/spec.app.md`:

```markdown
# {Feature Name}

## 1. User Scenarios

Describe the complete flow of how users will use this feature.

### Scenario 1: {Primary Scenario Name}

**As a** {user role}
**I want to** {action to perform}
**So that** {expected outcome}

**Flow**:
1. User {action step 1}
2. System {response step 1}
3. ...

### Scenario 2: {Secondary Scenario Name} (if applicable)

...

## 2. E2E Test Cases (Golden Cases)

Include only core Happy Path test cases, excluding error handling and edge cases.

### TC1: {Test Case Name}

**Preconditions**:
- {Condition 1}
- {Condition 2}

**Test Steps**:
1. {User action 1}
2. {User action 2}
3. {User action 3}

**Expected Results**:
- {Expected system response 1}
- {Expected system response 2}

### TC2: {Test Case Name} (if applicable)

**Preconditions**:
- ...

**Test Steps**:
1. ...

**Expected Results**:
- ...

## 3. Clarification Questions

> **Note**: Maximum 3 questions, only for critical decisions that cannot be reasonably inferred.

### Q1: {Question Title}

**Context**: {Why clarification is needed}

**Options**:
| Option | Description | Impact |
|--------|-------------|--------|
| A | {Option A} | {Impact} |
| B | {Option B} | {Impact} |

### Q2: {Question Title} (if applicable)

...
```

## Specification Writing Principles

### User Scenarios

- Focus on **what** the user needs and **why**
- Avoid implementation details (no tech stack, API, code structure)
- Cover main usage flows

### E2E Test Cases

- Include only Golden Cases (Happy Path)
- Exclude error handling and edge cases
- Describe user actions and expected results, no code
- Test cases should be end-to-end, validating complete user flows

### Clarification Questions

Limit to maximum 3 questions, only ask when:
- Significantly impacts feature scope
- Multiple reasonable interpretations with different impacts exist
- Cannot make reasonable default choice based on context

**No need to ask about** (use reasonable defaults):
- Standard error handling approaches
- Industry-standard performance metrics
- Common UI interaction patterns

## Output

Upon completion, report:
1. Branch name
2. Specification file path
3. Clarification questions requiring user response (if any)

**Next Step**: After user confirms the specification, run `/ohmy:plan.app` to create the technical plan
