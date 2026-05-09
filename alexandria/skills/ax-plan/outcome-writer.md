---
name: outcome-writer
description: >
  Write outcome files for implementation plans. Each outcome gets its own file
  in the outcomes/ directory with YAML frontmatter. Called by the planning skill.
requires:
  adherence: low
  reasoning: medium
  precision: medium
  volume: medium
---

# Outcome Writer

Write ONE markdown file per outcome to the `outcomes/` directory.

## File naming

Each outcome file is named `O-<N>.md`:
- `outcomes/O-1.md`
- `outcomes/O-2.md`
- `outcomes/O-3.md`

NEVER write a single `outcomes.md` file. ALWAYS write separate files.

## File format

Every outcome file MUST follow this EXACT format:

```markdown
---
id: O-1
title: <short observable description — one line>
tier: must | should | could
cards: [<library card names, comma separated>]
---

## Validation Criteria

- <observable condition 1>
- <observable condition 2>
- <observable condition 3>

## Motivation

<1-2 paragraphs: why this outcome matters for the goal>
```

## Rules

1. The `---` YAML frontmatter delimiters are REQUIRED on the first and third lines
2. The `id` field MUST be `O-1`, `O-2`, etc. — sequential integers
3. The `title` MUST be observable and specific, not a feature label
4. The `tier` MUST be one of: `must`, `should`, `could` (lowercase)
5. Validation criteria are observable conditions, NOT implementation steps
6. Do NOT include acceptance criteria checkboxes (those belong on tickets)
7. Do NOT combine all outcomes into one file
