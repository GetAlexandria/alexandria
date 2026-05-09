---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Task-Type Modifiers

How the type of task affects which dimensions to prioritize during context assembly.

The current `ax retrieve` CLI does **not** have separate flags for
task-type-specific behaviors like "temporal," "upstream," or "lateral" emphasis.
Those behaviors are implemented as a combination of:

- target classification -> `--profile <target-type>`
- task classification -> default `--complexity <tier>`
- Bridget follow-up -> targeted reads, WHY-chain checks, and blast-radius `Grep`

If the real task scope is clearly smaller or larger than the default below, use the honest
complexity tier instead of forcing the task type into the wrong budget.

## Retrieve CLI Mapping

Use this template for all task types:

```bash
ax retrieve --seeds "<seed cards>" --profile <target-type> --complexity <tier> --library docs/alexandria/library --format json
```

`--profile` comes from the **target type**, not the task type. Task modifiers only change
the default `--complexity` tier and the manual follow-up Bridget must do after the CLI
returns candidates.

Current complexity budgets in the CLI are:

- `simple` -> 3 primary / 5 supporting cards
- `medium` -> 5 primary / 8 supporting cards
- `complex` -> 6 primary / 10 supporting cards
- `architecture` -> 8 primary / 12 supporting cards

| Task type | `--profile` | Default `--complexity` | What the flag is doing | Required follow-up after CLI |
| --- | --- | --- | --- | --- |
| Feature addition | Target-type profile | `medium` | Standard briefing budget for adding behavior to an existing surface | If adjacent cards are missing, do targeted lateral follow-up for neighboring capabilities, sections, or systems |
| Bug fix | Target-type profile | `simple` | Narrower initial budget because the fix usually centers on one expected behavior | Read WHEN sections on related cards for recent divergences, reality notes, and implications |
| Refactor | Target-type profile | `complex` | Larger budget to preserve WHY-chain and blast-radius context during structural changes | Follow WHY links to Product Thesis level and `Grep` broadly for reverse-edge blast radius |
| New component / new surface | Target-type profile | `medium` | Standard budget plus room for sibling-pattern comparison | Read 2-3 sibling cards of the same type and check related WHEN gaps before final selection |
| Architecture change | Target-type profile | `architecture` | Maximum briefing budget in the current CLI (`8` primary / `12` supporting) | Read all governing Principles / Product Theses surfaced by WHY links and `Grep` the full library for affected references |

---

## Feature Addition

**What you're doing:** Adding new functionality to an existing card/concept.

**Dimension emphasis:**

- **WHERE** (high) — Understand all the connections. A new feature touches existing relationships. What else uses this? What depends on it?
- **HOW** (high) — Need implementation patterns and anti-patterns from existing cards. What does "following this looks like"?
- **WHY** (normal) — Rationale matters but is usually stable for feature additions.
- **WHEN** (normal) — Check implementation status of related cards.

**Retrieval adjustment:** Start with the target-derived `--profile` and `--complexity medium`.
Features often touch adjacent cards that the base profile may skip, so do targeted lateral
follow-up for neighboring cards if the initial candidate set is too narrow.

---

## Bug Fix

**What you're doing:** Fixing something that doesn't match expected behavior.

**Dimension emphasis:**

- **HOW** (high) — What SHOULD be happening? Read HOW sections carefully for expected behavior.
- **WHEN** (very high) — What changed recently? Reality notes may explain the divergence. Check WHEN sections (Reality + Implications) on related cards for known gaps.
- **WHERE** (normal) — Understand connections but don't over-expand.
- **WHY** (normal) — Unless the bug is a design misalignment, in which case WHY becomes critical.

**Retrieval adjustment:** Start with the target-derived `--profile` and `--complexity simple`.
Prioritize temporal context after retrieval: read WHEN sections (Reality + Implications) of
all related cards for known vision-vs-reality divergences that might explain the bug.

---

## Refactoring

**What you're doing:** Changing structure without changing behavior.

**Dimension emphasis:**

- **WHY** (very high) — You MUST understand the rationale before restructuring. Refactoring that preserves behavior but breaks strategic alignment is worse than the original.
- **WHERE** (high) — Understand the full blast radius. What references what you're changing?
- **HOW** (low) — You're changing the HOW, so current HOW is less useful.
- **WHEN** (normal) — Stability markers help — don't refactor evolving cards.

**Retrieval adjustment:** Start with the target-derived `--profile` and `--complexity complex`.
Then expand upstream manually: follow the full WHY chain to Product Thesis level, and read
anti-patterns carefully. "What Breaks This" lists are especially relevant during refactoring.

---

## New Component (Creating Something New)

**What you're doing:** Building a card/concept that doesn't yet exist in the codebase.

**Dimension emphasis:**

- **WHY** (high) — Strategic alignment is critical for new things. Why does this need to exist?
- **HOW** (high) — Look at sibling cards for implementation patterns. How were similar things built?
- **WHERE** (normal) — Understand where this fits in the graph.
- **WHEN** (normal) — Check if related cards are implemented (you may be building on vision, not reality).

**Retrieval adjustment:** Start with the target-derived `--profile` and `--complexity medium`.
Then look for sibling cards of the same type. If building a new System, read 2-3 existing
System cards to understand the pattern. Check WHEN sections on related cards for reality
notes about gaps — the gap itself is context.

---

## Architecture Change

**What you're doing:** Changing fundamental structure, patterns, or contracts.

**Dimension emphasis:**

- **WHY** (very high) — Every architectural decision must trace to strategic rationale. Missing WHY = risk of misalignment.
- **WHERE** (very high) — Full blast radius assessment. Everything connected to what you're changing.
- **WHEN** (high) — Stability matters. Don't change stable foundations without strong justification. Check what's evolving vs settled.
- **HOW** (normal) — Current implementation matters less since you're changing it.

**Retrieval adjustment:** Start with the target-derived `--profile` and `--complexity architecture`.
This is the maximum briefing budget in the current CLI (`8` primary / `12` supporting).
Then do maximum upstream and lateral follow-up: read ALL related Product Theses and
Principles, and assess blast radius by `Grep`-ing for the concept name across the entire
library — every match is something potentially affected.

---

## Quick Reference

| Task Type | Primary Dimensions | Default Complexity | Retrieval Width | Upstream Depth |
| --------- | ------------------ | ------------------ | --------------- | -------------- |
| Feature | WHERE, HOW | `medium` | Broad lateral | Profile default |
| Bug fix | HOW, WHEN | `simple` | Narrow + temporal | Profile default |
| Refactor | WHY, WHERE | `complex` | Broad + blast radius | Maximum (to Product Thesis) |
| New | WHY, HOW + siblings | `medium` | Medium + patterns | Profile default |
| Architecture | WHY, WHERE, WHEN | `architecture` | Maximum | Maximum (to Product Thesis) |
