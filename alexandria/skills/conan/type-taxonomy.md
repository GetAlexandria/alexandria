---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Type Taxonomy

Decision tree, containment relationships, and classification guardrails for card typing.

## Decision Tree

**Step 1: Is this about WHY we build?**

- Guiding philosophy (a bet) → Product Thesis
- Judgment guidance (a rule of thumb) → Principle
- Testable spec (concrete rules) → Standard

**Step 2: Do builders consciously interact with this?**
_Gate: "Do builders say 'I'm using X'?" If NO → skip to Step 3 (System)._

- Navigate TO it? Top-level (header nav) → Domain. Nested within domain → Section.
- Persistent across ALL domains? → Governance
- Interact WITHIN? Spatial canvas → Template. Specific widget → Component. Content object → Artifact. Action/workflow → Capability.
- Core data entity → Primitive

**Step 3: Is this invisible infrastructure?** Mechanism/rule → System

**Step 4: Is this an AI team member?** The agent → Agent. Its implementation → Prompt.

**Step 5: Is this about the user experience over time?**

- Repeating activity cycle → Loop
- Multi-phase progression arc → Journey
- Target emotional state → Experience Goal
- Emergent cross-system behavior → Force

## Containment Relationships

| Type            | Must Link To                            | Relationship          |
| --------------- | --------------------------------------- | --------------------- |
| Section         | Domain                                  | Parent workspace      |
| Template        | Section                                 | Where it lives        |
| Component       | Template or Section or Governance       | Parent element        |
| Artifact        | Section                                 | Where it's edited     |
| Capability      | Section(s)                              | Where it's performed  |
| Prompt          | Agent                                   | What it implements    |
| Governance      | Domain(s)                               | Where it's visible    |
| Loop            | Section(s), Capability(ies)             | Where cycle plays out |
| Journey         | Loop(s), Agent(s)                       | What composes it      |
| Experience Goal | Section(s), Loop(s), Component(s)       | Where feeling applies |
| Force           | System(s)                               | What produces it      |

Missing containment link = structural deficiency.

## Classification Guardrails

Apply IN ORDER. Each gate catches a common error pattern.

**Gate 1 — Interaction Test (FIRST):** "Do builders say 'I'm using X'?" NO → System.
**Gate 2 — Component Litmus Test:** Can you point at ONE discrete widget? NO → not Component.
**Gate 3 — Governance = cross-DOMAIN persistence:** Persistence within one domain ≠ Governance.
**Gate 4 — Action-words → Capability:** Verbs (zooming, filtering, planning) → Capability, not Component.

| Often Misclassified As | Actually        | Example                                    | Why                                   |
| ---------------------- | --------------- | ------------------------------------------ | ------------------------------------- |
| Component              | System          | Adaptation, Service Level Progression      | Fails Interaction Test                |
| Component              | Capability      | Zoom Navigation, Multi-Tier Filtering      | Action/workflow, not widget           |
| Component              | System          | Clustering, Notification Engine            | Mechanism with state                  |
| Template               | Governance      | Active Projects                            | Cross-domain persistence              |
| Capability             | Loop            | Weekly Planning rhythm                     | Not a single action — repeating cycle |
| System                 | Journey         | Onboarding progression                     | Builder consciously lives the arc     |
| Principle              | Experience Goal | "Feeling in control of my day"             | Target feeling, not judgment guidance |
| System                 | Force           | Alert Fatigue, Rest Deficit Spiral         | Emergent from system interaction      |
