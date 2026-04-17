---
name: brief
description: >
  Assemble context from Alexandria for implementation tasks. Use when starting
  a feature, fixing a bug, or making changes that touch product concepts in the library.
requires:
  adherence: low
  reasoning: medium
  precision: medium
  volume: medium
---

# Context Briefing Skill

Assemble context from Alexandria for implementation tasks.

## When to Use

Use this skill when implementing features, fixing bugs, or making changes that touch product concepts described in Alexandria — rooms, agents, capabilities, systems, primitives, etc.

**Do not use** for pure infrastructure tasks (CI/CD, dependency updates, tooling) that don't touch product-layer concepts.

## Alexandria

Location: `docs/alexandria/`

Markdown cards organized by type:

| Layer      | Folder                              | Types                        |
| ---------- | ----------------------------------- | ---------------------------- |
| Rationale  | `/rationale/product-thesis/`        | Product Thesis               |
| Rationale  | `/rationale/principles/`            | Principle                    |
| Rationale  | `/rationale/standards/`             | Standard                     |
| Product    | `/product/domains/`                 | Domain                       |
| Product    | `/product/sections/`                | Section                      |
| Product    | `/product/governance/`              | Governance                   |
| Product    | `/product/templates/`               | Template                     |
| Product    | `/product/components/`              | Component                    |
| Product    | `/product/artifacts/`               | Artifact                     |
| Product    | `/product/capabilities/`            | Capability                   |
| Product    | `/product/primitives/`              | Primitive                    |
| Product    | `/product/systems/`                 | System                       |
| Product    | `/product/agents/`                  | Agent                        |
| Experience | `/experience/loops/`                | Loop                         |
| Experience | `/experience/journeys/`             | Journey                      |
| Experience | `/experience/experience-goals/`     | Experience Goal              |
| Experience | `/experience/forces/`               | Force                        |
| Temporal   | `/temporal/`                        | Decision, Initiative, Future |

## Card Anatomy

Every card has 5 dimensions:

- **WHAT** — Standalone definition
- **WHERE** — Ecosystem relationships via `[[wikilinks]]`
- **WHY** — Strategic rationale (links to Product Theses/Principles)
- **WHEN** — Build phase, implementation status, reality notes
- **HOW** — Implementation guidance, examples, anti-patterns

## How the Graph Works

The library IS a knowledge graph encoded in the file system:

- **Folder paths** = type taxonomy
- **File names** = card identifiers (e.g., `System - Notification Engine.md`)
- **`[[wikilinks]]`** = relationship edges with context phrases
- **Card headers** = dimension boundaries (`## WHAT:`, `## WHY:`, etc.)

### Navigating the graph

| Need                          | Technique                                                    |
| ----------------------------- | ------------------------------------------------------------ |
| Find a card by name           | `Glob` for `docs/alexandria/**/[Type] - [Name].md`      |
| Find cards about a topic      | `Grep` for topic terms across `docs/alexandria/`        |
| Find a card's relationships   | Read the card, extract its `[[wikilinks]]`                   |
| Find cards referencing a card | `Grep` for `[[Card Name]]` across the library                |
| Search within a dimension     | `Grep` for content under `## WHY:` or `## HOW:` headers      |
| Check implementation status   | Read the card's WHEN section                                 |
| Find known divergences        | Read WHEN sections (Reality + Implications) on related cards |

## Assembly Process

See `retrieval-profiles.md` for type-specific instructions.
See `traversal.md` for detailed graph navigation techniques.
See `task-modifiers.md` for how task type affects retrieval emphasis.
See `protocol.md` for the CONTEXT_BRIEFING.md format.

## Quick Reference: Upstream Chain

```
Product Thesis (WHY we care)
    ↓ generates
Principle (judgment guidance)
    ↓ implemented by
Standard (testable specification)
    ↓ constrains
Product layer (Domains, Sections, Components, etc.)
    ↑ powered by
System (invisible mechanism)
    ↑ operates on
Primitive (core data entity)
    ↑ supported by
Agent (AI team member)
```

Every product-layer card should trace back to at least one Product Thesis via its WHY chain. If it can't, that's a gap worth noting.
