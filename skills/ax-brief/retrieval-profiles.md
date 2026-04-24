---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Retrieval Profiles

Type-specific instructions for assembling context briefings. Each profile describes what cards to include when building/modifying a card of that type.

**Exclusion: `sources/`** — Source documents in `docs/alexandria/sources/` are frozen provenance material (GDDs, research notes, strategic memos). Never include sources in context briefings. Only Conan in audit mode reads sources for drift detection and error checking. See `sources/README.md` for conventions.

---

## System

**Examples:** Notification Engine, Pipeline Architecture, Scheduling Service, Clustering, Adaptation

**Always include:**

- The System card itself (full content)
- At least 1 governing Product Thesis (follow WHY links)
- All Principles referenced in the card's WHY section
- All Capabilities that invoke this system — `Grep` for the system name across `docs/alexandria/product/capabilities/`
- All Sections where this system is visible — `Grep` for the system name across `docs/alexandria/product/sections/`
- Any Standards this system must conform to

**Traversal depth:** 3 hops upstream via wikilinks.
Read the card → follow its `[[links]]` → follow THOSE cards' `[[links]]` → one more hop for Product Thesis/Principle chains.

**Dimension priority:** WHY (high) > WHERE (high) > HOW (medium) > WHAT (low).
When summarizing supporting cards, preserve WHY and WHERE content. Compress HOW to key points.

**Anti-pattern check:** Always read the HOW section's "What Breaks This" for the System card and all referenced Principles.

**Lateral scope:** Broad — Systems affect many parts of the product. Check for sibling Systems that interact.

---

## Component

**Examples:** Dashboard Widget, Status Badge, Navigation Tab, Grid Tile, Sidebar Card

**Always include:**

- The Component card itself (full content)
- Parent Template or Section (the container this lives in)
- All Standards this component must conform to — check WHERE section for `[[Standard -` links
- Sibling Components in the same container

**Traversal depth:** 1 hop. Components are leaf nodes — go up to parent, across to siblings, but not deeper.

**Dimension priority:** HOW (high) > WHAT (high) > WHERE (medium) > WHY (low).
Components are implementation-heavy. Focus on HOW details and conforming Standards.

**Anti-pattern check:** Read parent Template's anti-patterns. Component violations often trace to Template-level mistakes.

**Lateral scope:** Narrow — focus on the immediate container and siblings.

---

## Section

**Examples:** Editor, Settings Panel, Project Board, Team Roster, Admin Console

**Always include:**

- The Section card itself (full content)
- Parent Domain (Sections are always contained by a Domain)
- Resident Agent (if one exists for this Section)
- All Templates contained in this Section — `Grep` for the section name across `docs/alexandria/product/templates/`
- All Capabilities performed in this Section — `Grep` for the section name across `docs/alexandria/product/capabilities/`
- Artifacts created/edited in this Section

**Traversal depth:** 2 hops. Section → Domain and Section → contained elements.

**Dimension priority:** WHY (medium) > WHERE (high) > HOW (medium) > WHAT (medium).
Sections are relationship-heavy — WHERE context (what connects to what) is critical.

**Anti-pattern check:** Read the Section's own anti-patterns plus the Agent's anti-patterns (if resident Agent exists).

**Lateral scope:** Medium — include adjacent Sections in the same Domain for navigation context.

---

## Domain

**Examples:** Dashboard, Archives, Planning Studio

**Always include:**

- The Domain card itself (full content)
- All Sections contained in this Domain — `Glob` for cards referencing this domain
- Visible Governance — `Grep` for the domain name across `docs/alexandria/product/governance/`
- Governing Product Theses (at least 1)
- Adjacent Domains for navigation context

**Traversal depth:** 2 hops. Domain → contained Sections → their key elements.

**Dimension priority:** WHY (high) > WHERE (medium) > WHAT (medium) > HOW (medium).
Domains are strategic — WHY they exist matters more than HOW they work.

**Lateral scope:** Medium — include other Domains for contrast and navigation relationships.

---

## Template

**Examples:** Grid Layout, Kanban Board

**Always include:**

- The Template card itself (full content)
- Parent Section (where this Template lives)
- All Components contained in this Template — `Grep` for the template name across `docs/alexandria/product/components/`
- Primitives displayed by this Template — check WHERE section
- All Standards this Template must conform to

**Traversal depth:** 1 hop. Like Components, Templates are contained elements.

**Dimension priority:** HOW (high) > WHERE (medium) > WHAT (medium) > WHY (low).
Templates are spatial/visual — HOW they render and behave is primary.

**Lateral scope:** Narrow — focus on the parent Section and contained elements.

---

## Capability

**Examples:** Purpose Assignment, Multi-Tier Filtering, Weekly Planning, Workspace Navigation

**Always include:**

- The Capability card itself (full content)
- Section(s) where this Capability is performed — check WHERE section
- Artifacts created or edited by this Capability
- Primitives this Capability operates on
- Systems this Capability invokes — check WHERE section for `[[System -` links
- At least 1 Principle from the WHY section

**Traversal depth:** 2 hops. Capabilities connect Sections, Artifacts, Primitives, and Systems.

**Dimension priority:** WHERE (high) > HOW (high) > WHY (medium) > WHAT (low).
Capabilities are about connections and workflows — WHERE it happens and HOW it works.

**Lateral scope:** Medium — include related Capabilities in the same Section.

---

## Artifact

**Examples:** Project Brief, Meeting Notes, Status Report

**Always include:**

- The Artifact card itself (full content)
- Section where this Artifact is edited
- Capabilities that use this Artifact
- Primitives this Artifact contains
- Governing Product Thesis (at least 1)

**Traversal depth:** 2 hops. Artifact → Section and Artifact → Capabilities.

**Dimension priority:** HOW (high) > WHERE (medium) > WHY (medium) > WHAT (medium).
Artifacts are content objects — HOW they're structured and used matters most.

**Lateral scope:** Medium.

---

## Governance

**Examples:** Agent Capability Matrix

**Always include:**

- The Governance card itself (full content)
- All Domains where this Governance is visible — check WHERE section
- Primitives displayed by this Governance
- Components contained in this Governance — `Grep` for governance name across `docs/alexandria/product/components/`
- Standards this Governance must conform to
- Navigation targets (where does interacting with the Governance take you?)

**Traversal depth:** 2 hops. Governance cards bridge domains, so lateral connections matter.

**Dimension priority:** WHERE (high) > HOW (high) > WHY (medium) > WHAT (low).
Governance is cross-domain — WHERE it applies and HOW it behaves across contexts is primary.

**Lateral scope:** Medium — include the Domains this Governance spans.

---

## Agent

**Examples:** Assistant, Scheduler

**Always include:**

- The Agent card itself (full content)
- Home Section (where this Agent lives)
- All Capabilities available to this Agent — `Grep` for agent name across `docs/alexandria/product/capabilities/`
- Artifacts this Agent manages — check WHERE section
- Coordinating Agents (agents this one hands off to or coordinates with)
- Full WHY chain — at least 1 Product Thesis, all referenced Principles
- Any Prompts that implement this Agent — `Glob` for `docs/alexandria/product/prompts/Prompt - [Agent Name]*.md`

**Traversal depth:** 3 hops. Agents are highly connected — Section, Capabilities, Artifacts, Product Thesis chain.

**Dimension priority:** WHY (high) > WHERE (high) > HOW (medium) > WHAT (low).
Agent alignment is strategic — WHY they exist and WHERE they fit matters as much as implementation.

**Anti-pattern check:** Always read the Agent card's anti-patterns AND the home Section's anti-patterns.

**Lateral scope:** Broad — include coordinating Agents and shared Capabilities.

---

## Prompt

**Examples:** (no Prompt cards exist yet)

**Always include:**

- Parent Agent card (complete, full content)
- The Agent's home Section
- The Agent carries the context — the Prompt is just the implementation

**Traversal depth:** 1 hop. The Agent card is the context; the Prompt inherits it.

**Dimension priority:** HOW (very high) > WHAT (medium) > WHERE (low) > WHY (low).
Prompts are pure implementation — HOW to write the system prompt.

**Lateral scope:** Minimal — just the parent Agent.

---

## Primitive

**Examples:** Project, Task, System (the data entity)

**Always include:**

- The Primitive card itself (full content)
- Sections that serve this Primitive — `Grep` for primitive name across `docs/alexandria/product/sections/`
- Capabilities that operate on this Primitive — `Grep` for primitive name across `docs/alexandria/product/capabilities/`
- Systems that manage this Primitive — `Grep` for primitive name across `docs/alexandria/product/systems/`
- Standards that define this Primitive's properties or states

**Traversal depth:** 2 hops. Primitives are referenced by many card types.

**Dimension priority:** WHERE (high) > WHAT (medium) > HOW (medium) > WHY (medium).
Primitives are the data backbone — WHERE they're used throughout the product is critical.

**Lateral scope:** Medium — include sibling Primitives that interact (e.g., Project contains Tasks).

---

## Loop

**Examples:** Sprint Retrospective, Daily Check-In, Seasonal Review

**Always include:**

- The Loop card itself (full content)
- All Sections involved in this Loop — check WHERE section
- All Capabilities that compose this Loop
- Parent Loop (if nested) and child Loops (if containing)
- Journey this Loop advances (if any)
- Agents who participate
- At least 1 Product Thesis from the WHY section

**Traversal depth:** 2 hops. Loops connect Sections, Capabilities, and Agents.

**Dimension priority:** HOW (high) > WHERE (high) > WHY (medium) > WHAT (low).
Loops are about the cycle — HOW it flows and WHERE it happens.

**Lateral scope:** Medium — include sibling Loops at the same timescale and parent/child Loops.

---

## Journey

**Examples:** User Onboarding, New User Journey

**Always include:**

- The Journey card itself (full content)
- All Loops the builder engages in during this Journey
- Sections involved across journey phases
- Agents who guide through phases
- Systems that support progression
- Capabilities unlocked during progression
- At least 1 Product Thesis from the WHY section

**Traversal depth:** 3 hops. Journeys span the full product.

**Dimension priority:** WHY (high) > HOW (high) > WHERE (medium) > WHAT (low).
Journeys are strategic — WHY they exist and HOW progression works.

**Lateral scope:** Broad — Journeys touch many parts of the product.

---

## Experience Goal

**Examples:** Flow State, Clarity, Being Known, Accomplishment, Stewardship, Momentum

**Always include:**

- The Experience Goal card itself (full content)
- All Sections/Loops/Capabilities where this feeling should exist — check WHERE section
- Components that reinforce this feeling
- Standards that govern the visual/interaction design supporting this feeling
- At least 1 Principle from the WHY section

**Traversal depth:** 1 hop. Experience Goals are target feelings — they point to contexts, not chains.

**Dimension priority:** HOW (high) > WHY (high) > WHERE (medium) > WHAT (low).
Experience Goals are about what reinforces and what breaks the feeling.

**Lateral scope:** Medium — include contrasting Experience Goals for the same context.

---

## Force

**Examples:** Alert Fatigue, Feature Creep Spiral, Momentum

**Always include:**

- The Force card itself (full content)
- All Systems that produce this emergent behavior — check WHERE section
- Loops and Capabilities that contribute
- Sections where it manifests
- Agent responses to this Force

**Traversal depth:** 2 hops. Forces arise from System interactions.

**Dimension priority:** WHY (medium) > HOW (high) > WHERE (medium) > WHAT (low).
Forces are about HOW the system responds to emergent behavior.

**Lateral scope:** Medium — include related Forces that share contributing Systems.

---

## Mandatory Categories Summary

Quick reference for what MUST be included regardless of scoring:

| Target Type     | Mandatory                                                          |
| --------------- | ------------------------------------------------------------------ |
| System          | 1+ Product Thesis, all anti-patterns, all affected Capabilities    |
| Component       | Parent Template/Section, all conforming Standards                  |
| Section         | Parent Domain, resident Agent (if exists)                          |
| Domain          | All contained Sections, 1+ Product Thesis                          |
| Template        | Parent Section, all conforming Standards                           |
| Capability      | 1+ Section, all affected Artifacts                                 |
| Agent           | Home Section, all managed Artifacts, 1+ Product Thesis          |
| Prompt          | Parent Agent (complete)                                         |
| Governance      | All visible Domains, all conforming Standards                   |
| Primitive       | All Sections that serve it, all operating Capabilities          |
| Artifact        | Host Section, all using Capabilities                            |
| Loop            | All composing Capabilities, all involved Sections               |
| Journey         | All Loops engaged, all guiding Agents                           |
| Experience Goal | All contexts where feeling applies                              |
| Force           | All contributing Systems, agent responses                       |
