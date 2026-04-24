---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Library Organization

Type-to-folder mapping for Alexandria.

| Type              | Folder                       |
| ----------------- | ---------------------------- |
| Product Thesis    | `/rationale/product-thesis/` |
| Principle         | `/rationale/principles/`     |
| Standard          | `/rationale/standards/`      |
| Domain            | `/product/domains/`              |
| Section           | `/product/sections/`             |
| Governance        | `/product/governance/`           |
| Template          | `/product/templates/`            |
| Component         | `/product/components/`           |
| Artifact          | `/product/artifacts/`            |
| Capability        | `/product/capabilities/`         |
| Primitive         | `/product/primitives/`           |
| System            | `/product/systems/`              |
| Agent             | `/product/agents/`               |
| Prompt            | `/product/prompts/`              |
| Loop              | `/experience/loops/`             |
| Journey           | `/experience/journeys/`          |
| Experience Goal   | `/experience/experience-goals/`  |
| Force             | `/experience/forces/`            |

## Navigating the Library

When building or fixing cards, use the context briefing skills to pull the right related
cards:

1. **Load the retrieval profile** for your target type from `${CLAUDE_PLUGIN_ROOT}/skills/ax-brief/retrieval-profiles.md` — it tells you what's mandatory (parent containers, conforming Standards, WHY chains)
2. **Follow traversal rules** from `${CLAUDE_PLUGIN_ROOT}/skills/ax-brief/traversal.md` — how to find cards by name, type, topic, and dimension
3. **Respect traversal depth** — Components are 1-hop (leaf nodes). Systems are 3-hop (broad impact). The profile says how far to look.
4. **Check mandatory categories** — the profile lists what must be present. If a mandatory category has no card, search for it specifically.

This ensures every card you build has correct links, proper containment, and complete WHY
chains — without needing Conan to pre-assemble context.
