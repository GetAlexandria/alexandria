# Alexandria Reference

Type taxonomy, card templates, naming conventions, and conformance obligations.

## Naming Conventions

- Cards: `Type - Name.md` (e.g., `System - Authentication.md`, `Principle - Progressive Disclosure.md`)
- Folders encode type taxonomy (e.g., `product/systems/`, `rationale/principles/`)
- Wikilinks: `[[Type - Name]]` with context phrase (no naked links)

## Type Decision Tree

### Step 1: Is this about WHY we build?

- Guiding philosophy (a bet) → **Product Thesis**
- Judgment guidance (a rule of thumb) → **Principle**
- Testable spec (concrete rules) → **Standard**

### Step 2: Do users consciously interact with this?

**Navigate TO it?**
- Top-level workspace → **Domain**
- Nested space within domain → **Section**

**Persistent across domains?** → **Governance**

**Interact WITHIN?**
- Spatial canvas → **Template**
- Specific widget → **Component**
- Content object → **Artifact**
- Action/workflow → **Capability**

**Core data entity?** → **Primitive**

### Step 3: Is this invisible infrastructure?

- Mechanism with state, processes inputs → **System**

### Step 4: Is this an AI team member?

- The agent → **Agent**

### Step 5: Is this about the user experience over time?

- Repeating activity cycle → **Loop**
- Multi-phase progression → **Journey**
- Target emotional state → **Experience Goal**
- Emergent cross-system behavior → **Force**

## Card Templates

### Product-Layer Card (Domain, Section, Template, Component, etc.)

```markdown
# Type - Name

## WHAT: Definition

[2-4 sentences. Standalone — no links needed to understand.]

## WHERE: Ecosystem

- Parent:
  - [[Parent Type - Name]] — [containment relationship]
- Conforms to:
  - [[Standard - Name]] — [what aspect it constrains]
- Related:
  - [[Type - Name]] — [relationship context]
- Depends on:
  - [[Type - Name]] — [what it needs]

## WHY: Rationale

- Product Thesis: [[Product Thesis - Name]] — [how this implements the thesis]
- Principle: [[Principle - Name]] — [what guidance it follows]
- Driver: [What problem this solves or hypothesis it tests]

## WHEN: Timeline

[Implementation status. Build phase. Reality notes.]

## HOW: Implementation

### Behavior

[What it does. User-observable behavior.]

### Examples

- Example 1: [input] → [output]
- Example 2: [input] → [output]

### Anti-Examples

- Wrong: [what it shouldn't do and why]
```

### Product Thesis

```markdown
# Product Thesis - Name

Type: Product Thesis (Problem | Solution | Plank)

## WHAT: The Thesis

[One sentence articulating the bet.]

Counter-thesis: [What someone who disagrees would say]

## WHERE: Ecosystem

- Parent: [[Product Thesis - Name]] (if this is a sub-thesis)
- Principles:
  - [[Principle - Name]] — [what guidance this generates]
- Domains:
  - [[Domain - Name]] — [what areas embody this]

## WHY: Rationale

[Why we believe this — reasoning, not assertion]

## Validation Criteria

- [How we'll know this thesis is right]
- [What evidence would invalidate it]

## HOW: Application

### What Following This Looks Like
[2-3 examples]

### What Violating This Looks Like
[2-3 anti-patterns]

### Decision Heuristic
[When facing a tradeoff, how does this thesis guide the choice?]
```

### Principle

```markdown
# Principle - Name

## WHAT: The Principle

[One sentence. Judgment-based guidance.]

## WHERE: Ecosystem

- Product Thesis: [[Product Thesis - Name]] — [what bet this serves]
- Governs: [[Type - Name]] — [what this shapes]

## WHY: Belief

[Why we believe this]

## HOW: Application

### What Following This Looks Like
[2-3 examples]

### What Violating This Looks Like
[2-3 anti-patterns]

### Test
[Question to evaluate if a design follows this principle]
```

### Standard

```markdown
# Standard - Name

## WHAT: Definition

[What this standard specifies. What it constrains.]

## WHERE: Ecosystem

- Implements: [[Principle - Name]] — [what guidance this makes testable]
- Conforming:
  - [[Type - Name]] — [must follow this]

## WHY: Rationale

- Principle: [[Principle - Name]] — [what it makes concrete]
- Driver: [What goes wrong without this spec]

## WHEN: Timeline

[When established. Stability status.]

## HOW: Specification

[The spec. Values, rules, thresholds. Tables preferred.]

## Anti-Examples

- Wrong: [specific violation and why it fails]
```

## Containment Relationships

| Type       | Must Link To                       |
| ---------- | ---------------------------------- |
| Section        | Domain (parent workspace)              |
| Template       | Section (where it lives)               |
| Component      | Template or Section or Governance      |
| Artifact       | Section (where it's edited)            |
| Capability     | Section(s) (where performed)           |
| Governance     | Domain(s) (where visible)              |
| Prompt         | Agent (what it implements)             |
| Loop           | Section(s), Capability(ies)            |
| Journey        | Loop(s), Agent(s)                      |
| Experience Goal | Section(s), Loop(s), Component(s)     |
| Force          | System(s)                              |

## Five Dimensions Requirements

| Dim   | Requirement                                                |
| ----- | ---------------------------------------------------------- |
| WHAT  | Standalone definition, no links needed to understand       |
| WHERE | 3+ contextualized links, conformance where obligated       |
| WHY   | Product Thesis/Principle link + driver                     |
| WHEN  | Temporal status or explicit N/A                            |
| HOW   | Sufficient for implementation, 2+ examples, 1+ anti-example |
