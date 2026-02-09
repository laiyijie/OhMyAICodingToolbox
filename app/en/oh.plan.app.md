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

**Option C: {Option Name}** (if more options, continue adding)
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
4. {Reason 4: if applicable, explain why other options were not chosen}

Risks and Mitigations:
- {Potential risk 1} → {Mitigation}
- {Potential risk 2} → {Mitigation}

#### 1.2.2 {Decision Point 2 Name}

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
1. {Reason 1}
2. {Reason 2}
3. {Reason 3}

Risks and Mitigations:
- {Potential risk 1} → {Mitigation}

---

#### Technology Selection Summary Table

| Decision Point | Choice | Rationale | Alternatives |
|----------------|--------|-----------|--------------|
| {Decision 1} | {Choice} | {Rationale} | {Alternatives} |
| {Decision 2} | {Choice} | {Rationale} | {Alternatives} |

### 1.3 Technical Constraints

- {Constraint 1}
- {Constraint 2}

## 2. Data Model Design

### 2.1 New/Modified Data Structures

```typescript
// Example: TypeScript interface definition
interface {EntityName} {
  field1: type;
  field2: type;
}
```

```python
# Example: Python dataclass
@dataclass
class {EntityName}:
    field1: type
    field2: type
```

### 2.2 Database Design (if applicable)

#### 2.2.1 Table Structure Design

**{Table Name 1}**

| Field | Type | Constraints | Description | Index |
|-------|------|-------------|-------------|-------|
| `field1` | {type} | PRIMARY KEY | {description} | Yes |
| `field2` | {type} | NOT NULL, UNIQUE | {description} | Yes |
| `field3` | {type} | NULL / DEFAULT {value} | {description} | No |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Created time | No |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Updated time | No |

**Table Description**: {describe the purpose and business meaning of this table}

**{Table Name 2}**

| Field | Type | Constraints | Description | Index |
|-------|------|-------------|-------------|-------|
| ... | ... | ... | ... | ... |

#### 2.2.2 ER Diagram (Entity Relationship Diagram)

```
+-------------+       +-------------+       +-------------+
|  {Table A}  |       |  {Table B}  |       |  {Table C}  |
+-------------+       +-------------+       +-------------+
| PK id       |<----->| FK a_id     |       | PK id       |
| field1      |       | PK id       |<----->| FK b_id     |
| field2      |       | field1      |       | field1      |
+-------------+       +-------------+       +-------------+
      |                                       |
      | 1:N                                   | 1:1
      v                                       v
+-------------+
|  {Table D}  |
+-------------+
| PK id       |
| FK a_id     |
| field1      |
+-------------+

Legend:
|---- : One-to-one relationship (1:1)
|<---> : One-to-many relationship (1:N)
|<#>   : Many-to-many relationship (M:N), via junction table
```

#### 2.2.3 Index Strategy

| Table | Index Name | Fields | Index Type | Purpose |
|-------|------------|--------|------------|---------|
| `{table}` | `idx_{field}` | `{field}` | BTREE | {query scenario} |
| `{table}` | `uniq_{field}` | `{field}` | UNIQUE | {uniqueness constraint} |
| `{table}` | `idx_{field1}_{field2}` | `{field1}, {field2}` | COMPOSITE | {composite query} |

#### 2.2.4 Data Migration Plan

**New Table Migration**

```sql
-- migration: {timestamp}_create_{table_name}.sql
CREATE TABLE {table_name} (
    id INT PRIMARY KEY AUTO_INCREMENT,
    field1 VARCHAR(255) NOT NULL,
    field2 INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_field1 (field1),
    INDEX idx_field2 (field2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Alter Table Migration**

```sql
-- migration: {timestamp}_alter_{table_name}.sql
-- Add new field
ALTER TABLE {table_name} ADD COLUMN new_field VARCHAR(100);

-- Add index
ALTER TABLE {table_name} ADD INDEX idx_new_field (new_field);

-- Modify constraint
ALTER TABLE {table_name} MODIFY COLUMN field1 VARCHAR(500) NOT NULL;
```

**Rollback Plan**

```sql
-- rollback: {timestamp}_rollback_{table_name}.sql
DROP TABLE IF EXISTS {table_name};
```

#### 2.2.5 Data Integrity Assurance

- **Foreign key constraints**: {list required foreign key relationships}
- **Cascade operations**: {describe cascade delete/update strategy}
- **Triggers**: {if needed, describe trigger purposes}
- **Check constraints**: {describe data validation rules}

#### 2.2.6 Query Performance Considerations

- Expected data volume: {estimate data scale for each table}
- Hot queries: {list most frequent query scenarios}
- Performance optimization strategies:
  - {Strategy 1, e.g., sharding strategy}
  - {Strategy 2, e.g., caching strategy}
  - {Strategy 3, e.g., read/write separation}

---

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

### 3.3 Key Modification Details

For complex modifications, describe the modification plan in detail:

#### {File Path}

**Current Code**:
```typescript
// Existing code snippet
```

**After Modification**:
```typescript
// Modified code snippet
```

**Modification Notes**: {why modify this way}

## 4. Task List

### 4.1 Task Overview

| Phase | Task Count | Estimated Effort |
|-------|------------|------------------|
| Preparation | {n} | {description} |
| Core Implementation | {n} | {description} |
| Testing | {n} + 3 (required) | {description} |

### 4.2 Detailed Tasks

#### Phase 1: Preparation

- [ ] **T1.1**: {task description}
  - Files: `{involved files}`
  - Key points: {implementation points}

- [ ] **T1.2**: {task description}
  - Files: `{involved files}`
  - Key points: {implementation points}

#### Phase 2: Core Implementation

- [ ] **T2.1**: {task description}
  - Files: `{involved files}`
  - Key points: {implementation points}
  - Dependencies: T1.1, T1.2

- [ ] **T2.2**: {task description}
  - Files: `{involved files}`
  - Key points: {implementation points}

#### Phase 3: E2E Testing

- [ ] **T3.1**: Write E2E test cases
  - Files: `desktop/tests/e2e/{feature}.spec.ts`
  - Key points: Based on Golden Cases defined in spec.app.md

- [ ] **T3.2**: Run and pass E2E tests
  - Command: `cd desktop && pnpm test:e2e tests/e2e/{feature}.spec.ts`

- [ ] **T3.3**: Evaluate Core test case updates (required)
  - Key points: Evaluate whether to add new feature test cases to `tests/e2e/core/`, and whether to merge or deduplicate with existing Core test cases
  - Files: `desktop/tests/e2e/core/`

- [ ] **T3.4**: Pass all Core E2E tests (required)
  - Command: `cd desktop && pnpm test:e2e tests/e2e/core/`
  - Key points: Ensure new features don't break existing core functionality

- [ ] **T3.5**: Intelligent Memory Update - Self-Learning (required)
  - Files: `CLAUDE.md`
  - Key points:
    1. **Review & Correct**: Check if existing content needs correction or deletion due to this change
    2. **Learn from Mistakes**: Record repeated errors or non-obvious solutions discovered during development
    3. **Architecture Decisions**: Document new patterns, conventions, or tech choices made
    4. **Gotchas & Pitfalls**: Record unexpected behaviors or edge cases discovered
  - Update triggers (if ANY occurred):
    - Same error made 2+ times during development
    - Solution required significant debugging time
    - Discovered behavior contradicting documentation
    - Found reusable patterns that should be standardized

### 4.3 Execution Order

```
T1.1 → T1.2 → T2.1 → T2.2 → T3.1 → T3.2 → T3.3 → T3.4 → T3.5
                ↘         ↗
                  T2.3 (parallel)
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
- Include testing tasks

## Output

Upon completion, report:
1. Plan file path
2. Summary of key technical decisions
3. Total task count and phase breakdown

**Next Step**: After user confirms the plan, run `/oh.implement.app` to execute implementation
