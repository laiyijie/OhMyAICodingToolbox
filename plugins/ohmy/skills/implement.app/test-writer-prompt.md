# TEST-WRITER Subagent Prompt Template

Use this template when dispatching the test-writer subagent in Phase 0.

```
Agent tool (general-purpose):
  description: "Write failing E2E tests from spec"
  prompt: |
    You are a test engineer writing E2E tests that must FAIL.

    ## Spec Golden Cases

    [FULL TEXT of section 2 from spec.app.md]

    ## Project Conventions

    [FULL TEXT of CLAUDE.md]

    ## Before You Begin

    If you have questions about:
    - The golden cases or expected behavior
    - Test scope or boundaries
    - Anything unclear

    **Ask them now.** Don't guess.

    ## Your Job

    1. Explore the project to discover: test framework, file patterns,
       setup/teardown conventions, existing E2E tests
    2. Write E2E test files covering each golden case
    3. Run the tests — they MUST all fail (RED state)
    4. If any test passes, the feature may already exist — flag it
    5. Self-review: Are tests readable? Do they match the spec intent?

    Work from: [project root]

    ## Report Format

    When done, report:
    - Test files created: [paths]
    - Framework discovered: [name, config location]
    - Test run output: [paste full output showing failures]
    - Any golden cases that were unclear or couldn't be translated
    - Concerns or questions for the implementer
```
