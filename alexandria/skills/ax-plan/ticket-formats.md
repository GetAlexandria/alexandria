---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Ticket Format Templates

Referenced by the implementation planning skill when writing ticket files.
The user chooses a format (saved in alexandria-config.json) and the skill fills
in the sections using information gathered during planning.

## Minimal

```markdown
## Description
[What to build and why — 2-3 sentences]

## Acceptance Criteria
- [ ] [specific, testable criterion]
- [ ] [specific, testable criterion]
```

## Standard

```markdown
## Motivation
[Why this ticket exists — the gap it fills, the user need it serves.
Reference the outcome this ticket traces to.]

## Description
[What to build — concrete deliverable, not vague direction]

## Context
[Relevant context from the library — specific card references with insights.
Anti-patterns that apply. Pointer to release.md for full briefing.]

## Acceptance Criteria
- [ ] [specific, testable criterion]
- [ ] [specific, testable criterion]

## Implementation Notes
[Suggested approach, files likely touched, patterns to follow.
Not prescriptive — the implementer can deviate if they have a better idea.]
```

## BDD

```markdown
## Motivation
[Why this ticket exists]

## Description
[What to build]

## Context
[Relevant context from the library]

## Acceptance Criteria

\```gherkin
Feature: [feature name]

  Scenario: [happy path]
    Given [precondition]
    When [action]
    Then [expected outcome]

  Scenario: [edge case]
    Given [precondition]
    When [action]
    Then [expected outcome]
\```

## Implementation Notes
[Suggested approach]
```

## Custom

The user provides a template file with `{{placeholders}}`:

Available placeholders:
- `{{frontmatter}}` — YAML frontmatter block
- `{{motivation}}` — why this ticket exists
- `{{description}}` — what to build
- `{{context}}` — relevant library context
- `{{acceptance_criteria}}` — criteria (checklist or Gherkin)
- `{{implementation_notes}}` — suggested approach
- `{{dependencies}}` — what this blocks/is blocked by

Example custom template:

```markdown
{{frontmatter}}

## Why
{{motivation}}

## What
{{description}}

## Library Context
{{context}}

## Done When
{{acceptance_criteria}}

## Approach
{{implementation_notes}}

## Dependencies
{{dependencies}}
```
