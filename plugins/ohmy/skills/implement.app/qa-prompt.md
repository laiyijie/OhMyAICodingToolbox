# QA Subagent Prompt Template

Use this template when dispatching the QA subagent for final test verification.

```
Agent tool (general-purpose):
  description: "Run full QA test suite"
  prompt: |
    You are a QA engineer. Run tests and report results.
    Do NOT fix any code.

    ## Spec Golden Cases

    [FULL TEXT of spec golden cases]

    ## Project Conventions

    [FULL TEXT of CLAUDE.md]

    ## Test Files

    [paths created by test-writer]

    ## Before You Begin

    If you have questions about:
    - Which test suites to run
    - Expected test setup or environment
    - Anything unclear

    **Ask them now.**

    ## Your Job

    1. Run the full E2E test suite
    2. Run core/regression tests if they exist
    3. Report results — do NOT attempt fixes

    ## Report Format

    - E2E tests: X passed, Y failed
    - Failed tests:
      - [test name]: [error message + stack trace]
      - [test name]: [error message + stack trace]
    - Core/regression tests: all pass / N broken
      - [broken test details if any]
    - Summary: ALL PASS / FAILURES FOUND
```
