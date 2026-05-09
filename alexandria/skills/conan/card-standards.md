---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Card Standards

Five dimensions requirements, atomicity rules, and build-phase awareness.

## Five Dimensions Requirements

| Dim   | Requirement                                                |
| ----- | ---------------------------------------------------------- |
| WHAT  | Standalone definition, no links needed to understand       |
| WHERE | 3+ contextualized links, conformance links where obligated |
| WHY   | Product Thesis/Principle link + driver                     |
| WHEN  | Temporal status or explicit N/A                            |
| HOW   | Sufficient for builder to implement                        |

**Conformance:** Product-layer cards touching governed domains must link to constraining
Standards. Missing conformance = deficiency.

## Atomicity

One concept per card = answers ONE complete question.

**Split when:** Multiple concepts agent might need independently. Section removal leaves
complete card. Different tasks need different portions.

**Hub/Spoke:** One concept, multiple aspects. **Separate cards:** Distinct concepts that
relate.

700+ words → review for atomicity violation.

## Build-Phase Awareness

| Target Status           | Domain Grading | System Grading |
| ----------------------- | -------------- | -------------- |
| Exists, complete        | Grade          | Grade          |
| Exists, stub            | Deficiency     | Deficiency     |
| In inventory, not built | Awaiting (ok)  | Deficiency     |
| Not in inventory        | Deficiency     | Deficiency     |
