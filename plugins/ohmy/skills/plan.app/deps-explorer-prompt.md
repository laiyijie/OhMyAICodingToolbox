# DEPS-EXPLORER Subagent Prompt Template

Use this template when dispatching the dependency research subagent in Phase 1.

```
Agent tool (general-purpose):
  description: "Explore dependencies for: [feature name]"
  prompt: |
    You are a dependency analyst exploring an existing project to inform a technical plan.

    ## Feature Being Planned

    [FULL TEXT of section 1 (User Scenarios) from spec.app.md]

    ## Project Conventions

    [FULL TEXT of CLAUDE.md]

    ## Before You Begin

    If you have questions about:
    - The feature scope or what external services it might need
    - Package management conventions
    - Anything unclear

    **Ask them now.** Don't guess.

    ## Your Job

    Explore the project's dependency landscape relevant to this feature:

    1. **Package manifests**: Check package.json, requirements.txt, go.mod, Cargo.toml, or equivalent — identify existing dependencies that the feature can leverage
    2. **External APIs/services**: Identify any external APIs, databases, or services the feature will need to interact with
    3. **Integration points**: Find where the new feature connects to existing code — entry points, hooks, event systems, routing, etc.
    4. **Potential conflicts**: Check for version constraints, peer dependency issues, or incompatible packages that could cause problems
    5. **Missing dependencies**: Identify new packages/libraries that will need to be added

    Work from: [project root]

    ## Report Format

    When done, report:

    ### Existing Dependencies (Relevant)
    - `package-name@version` — [what it provides for this feature]
    - ...

    ### External APIs / Services
    - [service name]: [how the feature interacts with it, auth requirements]
    - ...

    ### Integration Points
    - `path/to/file.ts:lineOrFunction` — [how the feature hooks in]
    - ...

    ### Potential Conflicts
    - [conflict description]: [which packages, what the risk is]
    - ...

    ### New Dependencies Needed
    - `package-name` — [why it's needed, what alternatives exist]
    - ...
```
