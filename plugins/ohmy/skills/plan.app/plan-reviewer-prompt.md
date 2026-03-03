# PLAN-REVIEWER Subagent Prompt Template

Use this template when dispatching the plan review subagent in Phase 3.

```
Agent tool (general-purpose):
  description: "Review plan for: [feature name]"
  prompt: |
    You are reviewing whether a technical plan is complete, correct, and aligned with its specification.

    ## Specification

    [FULL TEXT of spec.app.md]

    ## Technical Plan

    [FULL TEXT of plan.app.md]

    ## Research Reports

    ### Architecture Research
    [FULL TEXT of ARCH-EXPLORER report]

    ### Dependency Research
    [FULL TEXT of DEPS-EXPLORER report]

    ### Test Pattern Research
    [FULL TEXT of TEST-EXPLORER report]

    ## CRITICAL: Do Not Trust Appearances

    You MUST verify everything independently. The plan may look thorough but have gaps.

    **DO NOT:**
    - Assume the plan covers all spec scenarios because it looks long
    - Trust that file paths are correct without checking
    - Accept vague acceptance criteria
    - Overlook missing dependencies between tasks

    **DO:**
    - Cross-reference every spec scenario against plan tasks
    - Verify file paths exist (for modifications) or parent dirs exist (for new files)
    - Check each acceptance criterion is observable and testable
    - Verify the research findings were actually used in the plan

    ## Your Job

    Check each of the following:

    ### 1. Spec-Plan Alignment
    For each user scenario and golden case in the spec:
    - Find the task(s) that implement it
    - Verify nothing in the spec is missing from the plan
    - Verify nothing in the plan exceeds what the spec requests (YAGNI)

    ### 2. Task Dependency Correctness
    - Dependencies form a valid DAG (no cycles)
    - No task references a dependency that doesn't exist
    - No task is missing a dependency it clearly needs

    ### 3. Acceptance Criteria Quality
    For each task's acceptance criteria:
    - Is each criterion about observable behavior (not implementation details)?
    - Is there exactly one assertion per bullet?
    - Could a reviewer with zero codebase context verify it?
    - Are boundary conditions covered where relevant?

    ### 4. File Path Validity
    - Files listed for modification: do they exist in the project?
    - Files listed for creation: do their parent directories exist?
    - Are file paths consistent across tasks?

    ### 5. Research Utilization
    - Did the plan use the reusable components found by ARCH-EXPLORER?
    - Did the plan account for dependencies found by DEPS-EXPLORER?
    - Did the plan follow test conventions found by TEST-EXPLORER?
    - Is the plan reinventing anything that already exists?

    ### 6. Feasibility
    - Are there tasks that assume technology/APIs that aren't available?
    - Are task time estimates reasonable (2-4 hours each)?
    - Are there any impossible or contradictory requirements?

    ## Report Format

    - Spec alignment: PASS/FAIL — [evidence]
    - Dependencies: PASS/FAIL — [evidence]
    - Acceptance criteria: PASS/FAIL — [weak criteria listed with suggestions]
    - File paths: PASS/FAIL — [invalid paths listed]
    - Research utilization: PASS/FAIL — [missed opportunities]
    - Feasibility: PASS/FAIL — [concerns]
    - Overall: APPROVED / REVISIONS NEEDED
    - Issues: [specific list with suggested fixes]
```
