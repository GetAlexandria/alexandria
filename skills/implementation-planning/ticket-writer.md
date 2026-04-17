---
name: ticket-writer
description: >
  Write implementation plan output files (tickets, outcomes, release doc) from planning
  data. Called by the implementation planning skill in Step 7, or directly when given
  structured planning input. Produces markdown files with YAML frontmatter — never code.
requires:
  adherence: low
  reasoning: medium
  precision: high
  volume: medium
---

# Ticket Writer

Write implementation plan artifacts from structured planning data. This skill produces
**markdown planning documents** — tickets, outcomes, a release doc, and a library-updates
file. It NEVER produces implementation code.

## CRITICAL CONSTRAINT

**You write PLANNING ARTIFACTS, not implementation code.**

Your output is ONLY:
- `outcomes/O-*.md` — outcome files with YAML frontmatter
- `tickets/FEAT-*.md`, `SPIKE-*.md`, `PROTO-*.md` — ticket files with YAML frontmatter
- `release.md` — the release summary document
- `library-updates.md` — card updates for Conan/Sam

You NEVER write:
- Source code files (`.ts`, `.py`, `.rb`, `.go`, `.js`, etc.)
- Configuration files (`package.json`, `Dockerfile`, `.env`, etc.)
- Test files (`*.test.ts`, `*_test.py`, etc.)
- Any file outside the plan directory

If you find yourself about to write a `.ts` or `.py` file, STOP. You are off track.
Re-read this constraint and write the ticket file instead.

## When to Use

- Called by the implementation planning skill during Step 7 (Write Output)
- Called directly when given outcomes and ticket descriptions to format
- Called when reformatting existing tickets into a different format

## Input

The ticket writer expects structured planning data, either from the planning
conversation or provided directly:

**Required:**
- Plan name (lowercase, hyphens, URL-friendly)
- Output directory (default: `docs/alexandria/implementation-plans/<plan-name>/`)
- List of outcomes with: id, title, tier, validation criteria, motivation
- List of tickets with: id, title, outcome, tier, enabler, blocked-by, blocks,
  cards, motivation, description, acceptance criteria, implementation notes, context

**Required (format selection):**
- Ticket format: Minimal, Standard, BDD, or Custom
- If Custom: path to the template file

## Output Structure

```
<output-dir>/
  release.md
  CONTEXT_BRIEFING.md
  library-updates.md
  outcomes/
    O-1.md
    O-2.md
    ...
  tickets/
    FEAT-001.md
    SPIKE-001.md
    ...
```

## How to Write Each File Type

### Outcome Files

Each outcome gets a file in `outcomes/`:

```markdown
---
id: <outcome-id>
title: <short observable description>
tier: must | should | could
cards: [<library card references>]
---

## Validation Criteria

<How to verify the outcome is achieved — observable conditions, not implementation steps>

## Motivation

<Why this outcome matters for the goal>
```

### Ticket Files

Each ticket gets a file in `tickets/`. The YAML frontmatter is ALWAYS the same
regardless of format:

```yaml
---
id: <ticket-id>
title: <ticket title>
outcome: <outcome-id>
tier: must | should | could
enabler: false | spike | prototype
blocked-by: [<ticket-ids>]
blocks: [<ticket-ids>]
cards: [<library card references>]
---
```

The BODY varies by format. Load the format templates from
`${CLAUDE_PLUGIN_ROOT}/skills/implementation-planning/ticket-formats.md`.

Regardless of format, each ticket body should make the smallest independently
verifiable change legible to the implementer. If the planning data implies a
large horizontal slice, prefer rewriting the description around the user-visible
step it unlocks rather than reinforcing the layer split.

#### Minimal Format

```markdown
---
<frontmatter>
---

## Description
<What to build and why — 2-3 sentences>

## Acceptance Criteria
- [ ] <specific, testable criterion>
- [ ] <specific, testable criterion>
```

#### Standard Format

```markdown
---
<frontmatter>
---

## Motivation
<Why this ticket exists — the gap it fills, the user need it serves.
Reference the outcome this ticket traces to.>

## Description
<What to build — concrete deliverable, not vague direction>

## Context
<Relevant context from the library — specific card references with insights.
Anti-patterns that apply. Pointer to release.md for full briefing.>

## Acceptance Criteria
- [ ] <specific, testable criterion>
- [ ] <specific, testable criterion>

## Implementation Notes
<Suggested approach, files likely touched, patterns to follow.
Not prescriptive — the implementer can deviate.>
```

#### BDD Format

```markdown
---
<frontmatter>
---

## Motivation
<Why this ticket exists>

## Description
<What to build>

## Context
<Relevant context from the library>

## Acceptance Criteria

\```gherkin
Feature: <feature name>

  Scenario: <happy path>
    Given <precondition>
    When <action>
    Then <expected outcome>

  Scenario: <edge case>
    Given <precondition>
    When <action>
    Then <expected outcome>
\```

## Implementation Notes
<Suggested approach>
```

#### Custom Format

Read the user's template file and fill in `{{placeholders}}`:
- `{{frontmatter}}` — the YAML frontmatter block
- `{{motivation}}` — why this ticket exists
- `{{description}}` — what to build
- `{{context}}` — relevant library context
- `{{acceptance_criteria}}` — criteria (checklist or Gherkin)
- `{{implementation_notes}}` — suggested approach
- `{{dependencies}}` — what this blocks/is blocked by

### Release Doc

Write `release.md` following this structure:

```markdown
# <Plan Name>

## Goal
<What we're building and why — 2-3 sentences>

## Scope
**In scope:** <what's included>
**Out of scope:** <what's explicitly excluded and why>

## Success Outcomes
| ID | Outcome | Tier | Tickets |
|----|---------|------|---------|
<one row per outcome>

## Context Summary

See [CONTEXT_BRIEFING.md](CONTEXT_BRIEFING.md) for the full briefing from Bridget.

<Summary of key findings — primary cards, key relationships, gap manifest, anti-patterns>

## Decisions Made During Planning
| Decision | Options Considered | Chosen | Rationale |
|----------|-------------------|--------|-----------|
<one row per decision>

## Risks and Assumptions
| Type | Description | Mitigation | Tickets Affected |
|------|-------------|-----------|-----------------|
<one row per risk/assumption>

## Execution Phases
<From DAG tool output — paste text format>

<mermaid diagram from DAG tool>

## Re-planning Triggers
<When to re-evaluate the plan>

## Ticket Index
| ID | Title | Enabler | Tier | Outcome | Blocked By | Blocks |
|----|-------|---------|------|---------|------------|--------|
<one row per ticket>

## Library Updates
See library-updates.md.

## Deferred
<Populated by /complete-plan after execution>
```

When writing `## Execution Phases`, lead with the earliest demoable milestone for
the primary Must outcome. Avoid phase labels that are only "server", "client",
or "cleanup" unless that phase itself delivers a usable slice.

### Library Updates

Write `library-updates.md`:

```markdown
# Library Updates from <Plan Name>

Ask Conan to review this list and produce a transient surgery plan for Sam in the conversation, not as a checked-in file.

| Action | Card | What Changed | Source |
|--------|------|-------------|--------|
<one row per card update>
```

`library-updates.md` is the durable artifact. Conan's surgery handoff is transient and
should not be written back into the tracked plan bundle as `surgery-plan.md`.

## Validation

After writing all files, run the DAG tool to validate:

```bash
ax dag <output-dir>/ --validate
```

If validation fails (cycles, inconsistent edges, orphans), fix the ticket files
before finalizing.

## Anti-Patterns

- **NEVER write code.** If you're writing `.ts`, `.py`, `.go` — stop. Write the ticket.
- **NEVER skip frontmatter.** Every ticket and outcome file needs YAML frontmatter.
- **NEVER invent ticket IDs.** Use the IDs provided in the planning data.
- **NEVER omit acceptance criteria.** Every ticket needs at least 2 testable criteria.
- **NEVER write vague descriptions.** "Implement the feature" is not a description.
  "Build X that does Y so that Z" is a description.
