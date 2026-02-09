---
description: Create test plan based on specification, including architecture analysis, implementation strategy, and task list
---

## User Input

```text
$ARGUMENTS
```

Before proceeding, you **must** consider the user input (if not empty).

## Overview

Based on the spec.e2e.md test specification document, combined with the project's existing architecture, create a test implementation plan.

## Execution Steps

### 1. Load Context (Required)

1. Read `specs/{branch-name}/spec.e2e.md` for the current branch
2. Read project's `CLAUDE.md` to understand architecture and conventions
3. **Explore the project's existing test code** to understand:
   - Test framework and version being used
   - Existing test architecture patterns (Page Object / API Client / other)
   - Test data management approach
   - Configuration file locations and structure
   - Helper utilities and common functions

### 2. Write Plan File

Write the following content in `specs/{branch-name}/plan.e2e.md`:

```markdown
# {Test Target Name} - E2E Test Plan

## 1. Existing Architecture Analysis

### 1.1 Project Test Architecture

Based on project exploration, describe the existing test architecture:

- **Test Framework**: {framework and version used by project}
- **Architecture Pattern**: {Page Object / API Client / other pattern}
- **Directory Structure**: {how test files are organized}
- **Configuration Files**: {main config file paths}

### 1.2 Reusable Resources

List existing resources that can be reused:

| Resource Type | Path | Purpose |
|---------------|------|---------|
| Base Class | {path} | {purpose} |
| Utility Functions | {path} | {purpose} |
| Test Data | {path} | {purpose} |

### 1.3 Existing Pattern References

List existing test cases or patterns to reference:

- {file path}: {pattern description to reference}
- {file path}: {pattern description to reference}

## 2. Implementation Strategy

### 2.1 Test Case to Implementation Mapping

Map test cases from spec.e2e.md to concrete implementation:

| Test Case | Implementation Approach | Dependencies |
|-----------|------------------------|--------------|
| TC001: {name} | {how to implement} | {required Page/Client/data} |
| TC002: {name} | {how to implement} | {required Page/Client/data} |

### 2.2 New Abstractions (If Needed)

If existing architecture doesn't meet requirements, list new abstractions needed:

| Type | Name | Responsibility | Reason |
|------|------|----------------|--------|
| Page Object | {name} | {responsibility} | {why needed} |
| API Client | {name} | {responsibility} | {why needed} |
| Fixture | {name} | {responsibility} | {why needed} |

### 2.3 Test Data Strategy

Describe test data preparation and cleanup strategy:

- **Data Preparation**: {how to prepare test data}
- **Data Isolation**: {how to ensure test independence}
- **Data Cleanup**: {how to clean up after tests}

## 3. File Modification Plan

### 3.1 New Files

| File Path | Purpose |
|-----------|---------|
| {path} | {purpose} |

### 3.2 Modified Files

| File Path | Modification | Reason |
|-----------|--------------|--------|
| {path} | {modification} | {reason} |

## 4. Task List

### 4.1 Detailed Tasks

#### Phase 1: Preparation

- [ ] **T1.1**: {task description}
  - Files: {involved files}
  - Key points: {implementation points}

#### Phase 2: Test Implementation

- [ ] **T2.1**: Implement test case TC001
  - Files: {test file path}
  - Key points: {implementation points, which existing test to reference}

- [ ] **T2.2**: Implement test case TC002
  - Files: {test file path}
  - Key points: {implementation points}

#### Phase 3: Validation

- [ ] **T3.1**: Run and pass all new tests
  - Command: {test run command}
  - Key points: Ensure all cases pass

- [ ] **T3.2**: Run and pass all existing tests (regression)
  - Command: {full test suite command}
  - Key points: Ensure new code doesn't break existing tests

- [ ] **T3.3**: Intelligent Memory Update - Self-Learning (Required)
  - Files: `CLAUDE.md`
  - Key points: Record selector strategies, wait patterns, framework gotchas, etc.

### 4.2 Execution Order

```
T1.1 → T2.1 → T2.2 → ... → T3.1 → T3.2 → T3.3
```
```

## Plan Writing Principles

### Architecture Analysis

- **Must explore project first**: Don't assume what framework or patterns the project uses
- **Reuse first**: Prioritize using existing base classes, utility functions, and patterns
- **Stay consistent**: New code should maintain consistency with existing code style

### Implementation Strategy

- **Reference existing tests**: Find similar test cases as reference
- **Minimal additions**: Only add new abstractions when necessary, avoid over-engineering
- **Clear dependencies**: Clearly list resources needed for each test case

### Task List

- **Concrete and actionable**: Each task should be clear and executable
- **Include regression testing**: Ensure existing functionality isn't broken
- **Include memory update**: Form self-learning loop

## Output

Upon completion, report:
1. Plan file path
2. Test framework and architecture pattern used by project
3. Number of reusable resources
4. Total task count

**Next Step**: After user confirms the plan, run `/oh.implement.e2e` to execute implementation
