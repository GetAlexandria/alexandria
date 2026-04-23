---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Rubrics

All sections 20% weight. Phase: Vision Capture.

## WHAT

Criteria: Standalone, Specific, Complete

| Grade | Criteria                                                |
| ----- | ------------------------------------------------------- |
| A     | All three met. 2-4 sentences. Reader fully understands. |
| B     | All three met, one weak.                                |
| C     | One criterion missing.                                  |
| D     | Two missing. Reader confused.                           |
| F     | Empty, placeholder, or pointer only.                    |

Failure example: "The settings for alert mode." → F (pointer, not definition)

## WHY

Criteria: Product Thesis linked (with explanation), Rationale present, Driver traced

| Grade | Criteria                                               |
| ----- | ------------------------------------------------------ |
| A     | Full causal chain. Alternatives/tensions acknowledged. |
| B     | Product Thesis + driver + rationale. No tensions.      |
| C     | Thin explanation OR missing driver.                    |
| D     | Vague Product Thesis reference, no real rationale.     |
| F     | Empty or no strategic connection.                      |

**Trace Test:** Follow Product Thesis/Principle links. If upstream is stub → penalize downstream card.

Failure example: "Product Thesis: [[Visual Work]]" → D (naked link)

## WHERE

Criteria: 3+ links, All contextualized, Bidirectional, Conformance present

| Grade | Criteria                                                                                |
| ----- | --------------------------------------------------------------------------------------- |
| A     | Rich ecosystem map. All categories with context. Conformance links where obligated.     |
| B     | Key relationships present. May miss one category. 3+ links. Conformance present or N/A. |
| C     | Naked links OR one direction only OR <3 links OR missing conformance.                   |
| D     | 1-2 links, mostly naked.                                                                |
| F     | Empty.                                                                                  |

Naked link: `[[Task Queue]]` → penalize
Contextualized: `[[Task Queue]] — provides candidate tasks` → credit

**Conformance Check:** Card touches governed domain? → conformance link required.

Missing conformance when obligated = C ceiling for WHERE.

See Library Reference → Conformance Obligations table.

## HOW

Criteria: Sufficient for builder, Examples present, Anti-examples present, Separated (no rationale)

| Grade | Criteria                                                                    |
| ----- | --------------------------------------------------------------------------- |
| A     | Builder could implement. ≥2 examples. ≥1 anti-example. Clear behavior spec. |
| B     | Clear direction. Has examples OR anti-examples but not both.                |
| C     | Vague. Missing examples. Significant clarification needed.                  |
| D     | Restates WHAT, no implementation detail, no examples.                       |
| F     | Empty.                                                                      |

**Examples check:** Concrete input → output? Not abstract descriptions?
**Anti-examples check:** Shows what wrong implementation looks like?

**Enumeration flag:** Table of types/modes in HOW → note AUDIT SIGNAL.

## WHEN (Vision Capture)

Binary pass/fail — structural readiness only.

| Grade    | Criteria                                                                 |
| -------- | ------------------------------------------------------------------------ |
| PASS (A) | Section exists. Temporal status marked. Known predecessors acknowledged. |
| FAIL (F) | Section missing OR ignores known predecessors.                           |

## Type Audit

Run the Type Decision Tree from `reference.md` before section grading.

- If the tree yields a clear verdict that disagrees with the card's declared type,
  stop card-level grading for that card.
- Emit `AUDIT SIGNAL: declared [Type] but the concept routes to [Expected Type]`.
- Mark the card `UNGRADED — RETYPE REQUIRED`.
- Recommend the correct type before continuing the broader report.

If the tree is genuinely ambiguous because the current taxonomy does not cleanly
cover the concept, note that ambiguity explicitly and continue with grading.

## Misclassification Signals

Use these signals to support the Type Audit and to catch softer cases where the
tree is not fully decisive. These are non-blocking unless they reinforce a clear
Type Decision Tree mismatch.

| Signal                                                              | Suggests               |
| ------------------------------------------------------------------- | ---------------------- |
| WHAT says "mechanism," "manages state," "processes"                 | System                 |
| WHAT says "specification," "defines values," "must conform"         | Standard               |
| WHAT says "principle," "guides," "judgment-based"                   | Principle              |
| Card typed as Section but builders don't navigate TO it             | Template or Component  |
| Card typed as Template but builders navigate TO it                  | Section                |
| Card typed as Section but is top-level workspace                    | Domain                 |
| Card has no state but constrains other cards                        | Standard               |
| Card typed as Component but is a content object                     | Artifact               |
| Card typed as Component but builders don't consciously invoke it    | System                 |
| Card typed as Component but name/description uses action-words      | Capability             |
| Card typed as Component but describes a process/workflow            | Capability             |
| Card typed as Template but persists across all domains              | Governance             |
| Card typed as Section but describes an action/workflow              | Capability             |
| Agent card has no Prompt card                                       | Prompt missing         |
| HOW has behavioral types table                                      | Needs decomposition    |
| Missing containment link (Section→Domain, Template→Section, etc.)  | Structural deficiency  |
| Card typed as Capability but describes a repeating cycle            | Loop                   |
| Card typed as System but builder consciously lives through it       | Journey                |
| Card typed as Principle but describes a target feeling              | Experience Goal        |
| Card typed as System but is emergent from system interactions       | Force                  |

## Type-Specific Notes

**Standards:**

- WHERE uses "Conforming:" to list constrained cards (Sections, Templates, Components, Governance, Agents)
- WHY must link to Principle (Standards implement Principles)
- HOW contains the specification itself (values, rules, thresholds)
- Must have Anti-Examples section (what violation looks like)

**Principles:**

- WHERE uses "Standards:" to link to implementing Standards
- WHY focuses on belief/evidence, not driver
- Must have "What Violating This Looks Like" section

**Product Theses:**

- Must have "What Violating This Looks Like" section
- WHY must have reasoning, not just assertion

**Domains:**

- WHERE must list contained Sections
- Must describe cognitive mode (planning vs. executing vs. reflecting)
- Must describe navigation pattern (entry/exit points)

**Sections:**

- WHERE must link to parent Domain (containment)
- WHERE must link to resident Agent (if any)
- Must describe workflow (entry → steps → exit)
- Must list contained Templates, Artifacts, Capabilities

**Governance:**

- WHERE must specify visibility scope (which domains, or "all")
- Must describe display states and update triggers
- Must explain why it needs cross-domain persistence

**Templates:**

- WHERE must link to parent Section (containment)
- Must describe layout and interaction model
- Must list contained Components

**Components:**

- WHERE must link to parent (Template, Section, or Governance)
- Must describe states, interactions, accessibility

**Artifacts:**

- WHERE must link to Section where created/edited
- Must describe lifecycle (created → updated → archived)
- Must describe ownership/permissions if relevant

**Capabilities:**

- WHERE must link to Section(s) where performed
- Must describe trigger → steps → outcome
- Must list what Primitives/Artifacts it operates on

**Agents:**

- WHERE must link to home Section
- Must describe voice/personality, responsibilities, boundaries
- Must link to Prompt card (implementation)
- Must specify handoff relationships with other agents

**Prompts:**

- WHERE must link to parent Agent
- Must include actual prompt text
- Must have version and changelog

**Loops:**

- WHERE must link to all Sections involved and all composing Capabilities
- Must describe the full cycle (trigger → steps → return)
- Must connect to parent Loop (if nested) and advancing Journey (if any)

**Journeys:**

- WHERE must link to composing Loops and guiding Agents
- Must describe phases and what progression means
- Must explain what the builder consciously experiences vs. invisible System mechanisms

**Experience Goals:**

- WHERE must link to all Sections/Loops/Components where feeling applies
- HOW must describe what reinforces and what breaks the feeling
- Must be distinguishable from a Principle (feeling, not judgment guidance)

**Forces:**

- WHERE must link to contributing Systems and Loops
- Must describe the emergent behavior pattern, not the designed mechanism
- Must distinguish from Systems (Forces are anticipated, not designed)
