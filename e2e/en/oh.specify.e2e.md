---
description: Create E2E test specification with system under test description, test scope, and test cases
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the feature/API description provided by the user, create an E2E test specification document. This command is for **projects that specifically manage E2E test cases**.

## Execution Steps

### 1. Explore Project (Required)

Before creating the specification, understand the project's current state:

1. **Find existing specifications**: Check if the project has existing test specs, requirements docs, or similar files
2. **Understand spec format**: If the project has existing specs, analyze their format and structure
3. **Review test directory**: Understand how tests are organized in the project

### 2. Generate Branch Name

Analyze the test target and generate a short 2-4 word name:
- Use kebab-case format (e.g., `test-user-login`, `test-payment-api`)
- Preserve technical terms and abbreviations

### 3. Create Branch and Specification File

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

### 4. Write Test Specification File

Write the specification in `specs/{number}-{short-name}/spec.e2e.md`.

#### 4.1 Core Specification Elements

Regardless of format, the specification must contain these core elements:

| Element | Description | Required |
|---------|-------------|----------|
| System Under Test | What system/feature to test, where is the entry point | ✓ |
| Test Scope | What's included, what's excluded | ✓ |
| Test Cases | Specific test scenarios and expected results | ✓ |
| Test Data | What data is needed, how to prepare | Depends |
| Environment Dependencies | What environment and services are needed | Depends |
| Clarification Questions | Decision points requiring user confirmation | Depends |

#### 4.2 Specification Format Selection

- **If project has existing spec format**: Follow the existing format
- **If project has no existing format**: Choose appropriate detail level based on test complexity

#### 4.3 Test Case Writing Principles

- Include only Golden Cases (Happy Path)
- Sort by priority (P0 > P1 > P2)
- Test steps should be specific and executable
- Expected results must be verifiable

## Specification Writing Principles

### System Under Test Description

- Clearly describe the target system being tested
- Include necessary access information and documentation links
- Specify test entry points

### Test Scope

- Clearly define test boundaries to avoid scope creep
- List exclusions with their reasons

### Test Cases

- Describe user action steps and expected results
- Don't include implementation details (selectors, code, etc.)
- Include necessary test data examples

### Clarification Questions

Limit to maximum 3 questions, only ask when:
- Significantly impacts test scope
- Multiple reasonable interpretations with different impacts exist
- Cannot make reasonable default choice based on context

## Output

Upon completion, report:
1. Branch name
2. Specification file path
3. Number of test cases and priority distribution
4. Clarification questions requiring user response (if any)

**Next Step**: After user confirms the specification, run `/oh.plan.e2e` to create the test plan
