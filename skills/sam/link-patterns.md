---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Link Patterns

Standard phrases for relationship context. No naked links — every `[[Note]]` gets a phrase.

---

## Conformance (Product-Layer Cards → Standards)

```markdown
- [[Standard - X]] — constrains [what aspect]
- [[Standard - X]] — specifies [colors/thresholds/states] used here
- [[Standard - X]] — defines [values/rules] this implements
```

**Examples:**

```markdown
- [[Standard - Visual Language]] — constrains color and indicator rendering
- [[Standard - Priority Score]] — specifies ranking formula used here
- [[Standard - Multi-Tier Portfolio]] — defines tier classification this implements
- [[Standard - Project States]] — constrains lifecycle state handling
```

---

## Conforming Elements (Standards → Product-Layer Cards)

```markdown
- [[Section - X]] — must conform to this spec
- [[Template - X]] — renders according to this standard
- [[Component - X]] — implements this specification
- [[Governance - X]] — must conform to this spec
- [[Agent - X]] — must conform to this spec
```

**Examples:**

```markdown
- [[Template - Active Projects]] — must conform to this spec
- [[Component - State Indicator]] — implements this specification
- [[Governance - Agent Capability Matrix]] — renders according to this standard
```

---

## Dependencies (What This Needs)

```markdown
- [[X]] — provides [data/state] for [function]
- [[X]] — must exist before this can [function]
- [[X]] — supplies [input] that this [processes/displays/uses]
- [[X]] — handles [capability] that this relies on
```

**Examples:**

```markdown
- [[Task Queue]] — provides candidate tasks for filtering
- [[User Preferences]] — stores selected mode between sessions
- [[Review Cycle]] — determines when notification queue refreshes
```

---

## Dependents (What Needs This)

```markdown
- [[X]] — uses this to [function]
- [[X]] — displays/renders output from this
- [[X]] — breaks if this [changes/disappears]
- [[X]] — built on top of this [mechanism/data]
```

**Examples:**

```markdown
- [[Work at Hand]] — uses this to populate daily focus
- [[Active Projects]] — displays priorities this system ranks
- [[AI Suggestions]] — built on top of this scoring mechanism
```

---

## Systems (Cross-Cutting Mechanisms)

```markdown
- [[X]] — foundational mechanism for [what it enables]
- [[X]] — cross-cutting system handling [function]
- [[X]] — architectural layer providing [capability]
```

**Examples:**

```markdown
- [[Task Queue]] — foundational mechanism for all task ordering
- [[Review Cycle]] — cross-cutting system handling weekly rhythm
```

---

## Containment (Parent → Child)

Every card with a containment relationship must link to its parent.

```markdown
# Section → Domain

- [[Domain - X]] — parent workspace

# Template → Section

- [[Section - X]] — where this template lives

# Component → Template/Section/Governance

- [[Template - X]] — parent element

# Artifact → Section

- [[Section - X]] — where this is created/edited

# Capability → Section(s)

- [[Section - X]] — where this is performed

# Prompt → Agent

- [[Agent - X]] — the agent this implements

# Governance → Domain(s)

- [[Domain - X]] — where this is visible
```

---

## Domains and Sections

```markdown
- [[Domain - X]] — parent workspace
- [[Section - X]] — [what you do there]
- [[Section - X]] — adjacent section for [navigation flow]
```

---

## Templates (Spatial Fabric)

```markdown
- [[Template - X]] — spatial canvas for [what it provides]
- [[Template - X]] — layout handling [arrangement]
```

---

## Components (UI Widgets)

```markdown
- [[Component - X]] — UI element handling [interaction]
- [[Component - X]] — widget providing [function]
```

---

## Artifacts (Content Objects)

```markdown
- [[Artifact - X]] — content object for [what it captures]
- [[Artifact - X]] — created during [workflow]
```

---

## Capabilities (Actions/Workflows)

```markdown
- [[Capability - X]] — action enabling [what builders do]
- [[Capability - X]] — workflow for [process]
```

---

## Agents and Prompts

```markdown
- [[Agent - X]] — AI team member handling [responsibility]
- [[Agent - X]] — coordinates with this agent on [handoff]
- [[Prompt - X]] — implementation of [[Agent - X]]
```

---

## Loops (Engagement Cycles)

```markdown
- [[Loop - X]] — repeating cycle driving [engagement pattern]
- [[Loop - X]] — rhythm that structures [activity]
```

---

## Journeys (Progression Arcs)

```markdown
- [[Journey - X]] — multi-phase arc progressing through [what]
- [[Journey - X]] — progression path from [start] to [end]
```

---

## Experience Goals (Target Feelings)

```markdown
- [[Experience Goal - X]] — target emotional experience for [context]
- [[Experience Goal - X]] — feeling this should evoke during [interaction]
```

---

## Forces (Emergent Behaviors)

```markdown
- [[Force - X]] — emergent behavior arising from [system interactions]
- [[Force - X]] — cross-system pattern producing [effect]
```

---

## Product Thesis/Principle Links (WHY Section)

```markdown
- [[Product Thesis - X]] — this implements [principle] by [how]
- [[Principle - X]] — guidance driving [aspect] of this card
- [[Product Thesis - X]] — philosophy behind [design choice]
```

**Examples:**

```markdown
- [[Product Thesis - Visual Work]] — this implements visibility by showing queue state
- [[Principle - Visual Recognition]] — guidance driving indicator design
```

---

## Standard → Principle Links

```markdown
- [[Principle - X]] — this standard makes [principle] testable
- [[Principle - X]] — judgment-based guidance this specification implements
```

**Examples:**

```markdown
- [[Principle - Visual Recognition]] — this standard makes instant recognition testable
```

---

## Decision Links (WHY Section)

```markdown
- [[Decision - X]] — key choice that [shaped/constrained] this card
- [[Decision - X]] — decision determining [specific aspect]
```

---

## Temporal Links (WHEN Section)

```markdown
Supersedes: [[X]] — replaced [old approach] because [reason]
Enables: [[X]] — foundation for [future capability]
Blocked by: [[X]] — can't proceed until [dependency resolved]
```

---

## Peer Relationships

```markdown
- [[X]] — complements this by [how they work together]
- [[X]] — alternative approach to [same problem]
- [[X]] — sibling card sharing [common parent/system]
```

---

## Quick Reference

| Relationship    | Pattern Start                                                     |
| --------------- | ----------------------------------------------------------------- |
| Conforms to     | "constrains", "specifies", "defines [values]"                     |
| Conforming      | "must conform", "implements this spec"                            |
| Containment     | "parent workspace", "where this lives", "where this is performed" |
| Domain/Section  | "parent workspace", "what you do there"                           |
| Template        | "spatial canvas", "layout handling"                               |
| Component       | "UI element", "widget providing"                                  |
| Artifact        | "content object", "created during"                                |
| Capability      | "action enabling", "workflow for"                                 |
| Agent/Prompt    | "AI team member", "implementation of"                             |
| Loop            | "repeating cycle", "rhythm that structures"                       |
| Journey         | "multi-phase arc", "progression path"                             |
| Experience Goal | "target emotional experience", "feeling this should evoke"        |
| Force           | "emergent behavior", "cross-system pattern"                       |
| Depends on      | "provides", "must exist", "supplies"                              |
| Depended on by  | "uses this to", "displays", "built on"                            |
| System          | "foundational mechanism", "cross-cutting"                         |
| Product Thesis  | "implements [principle] by"                                       |
| Principle       | "guidance driving", "makes testable"                              |
| Decision        | "key choice that", "decision determining"                         |
| Temporal        | "supersedes", "enables", "blocked by"                             |
