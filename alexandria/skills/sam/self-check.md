---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Self-Check

Run before handing cards to Conan. Catches obvious issues.

Before running the manual checklist, invoke the structural lint gate:

```bash
ax lint cards docs/alexandria/library/ --json
ax lint graph docs/alexandria/library/ --json
```

Fix any linter errors first. If the CLI is unavailable, keep going with the manual
checklist and explicitly flag any unresolved broken-link risks for Conan.

When `lint graph` reports a broken wikilink, repair the current card before inventing
new library surface. Prefer one of these responses, in order:

1. Replace the target with an existing card that already covers the concept.
2. Remove the unsupported link and rewrite the sentence so it stays true.
3. Flag the missing card for Conan or a human if the concept is real but not yet grounded.

Create a new card during self-check only when the current source material or an explicit
inventory item already establishes that card. Do not fabricate a new card just to make
the lint error disappear.

For self-check responses, the closeout footer is mandatory. The literal final two lines
must always be:

```markdown
Ready for Conan review.
**Status: DONE**  <!-- or DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT -->
```

Do not end with only "PASS", a concern table, or a prose summary. A self-check response
is incomplete until that footer is present as the literal ending.

## Per-Card Checklist

### Structure

- [ ] All five sections present? (WHAT, WHERE, WHEN, WHY, HOW)
- [ ] Section headers match template?
- [ ] No empty sections?

### WHAT Section

- [ ] **Standalone test:** Cover title. Read only WHAT. Understand what this is?
- [ ] 2-4 sentences?
- [ ] No unexplained jargon?

### WHERE Section

- [ ] At least 3 links?
- [ ] **Every link has context?** (No naked `[[Note]]`)
- [ ] **Containment parent linked?** (see below)
- [ ] At least one dependency?
- [ ] At least one dependent? (or noted as leaf)
- [ ] **Conformance links present?** (see below)

### Conformance Check

Does this card touch a governed domain? Verify conformance against the canonical table in `docs/alexandria/reference.md`. Each product-layer card touching a governed domain must link to the constraining Standard listed there.

If yes → conformance link must be in WHERE.
If Standard doesn't exist yet → flag for creation.

### Containment Check

| Type            | Must Link To                                                 |
| --------------- | ------------------------------------------------------------ |
| Section         | Domain (parent workspace)                                    |
| Template        | Section (where it lives)                                     |
| Component       | Template or Section or Governance (parent element)           |
| Artifact        | Section (where it's edited)                                  |
| Capability      | Section(s) (where it's performed)                            |
| Prompt          | Agent (what it implements)                                   |
| Governance      | Domain(s) (where it's visible)                               |
| Loop            | Section(s) and Capability(ies) (where cycle plays out)       |
| Journey         | Loop(s) and Agent(s) (what composes it)                      |
| Experience Goal | Section(s), Loop(s), or Component(s) (where feeling applies) |
| Force           | System(s) (what produces it)                                 |

### Folder Placement Check

- [ ] **Card in correct layer?**
  - Product Thesis, Principle, Standard → `/rationale/` subtree
  - Domain, Section, Governance, Template, Component, Artifact, Capability, Primitive, System, Agent, Prompt → `/product/` subtree
  - Loop, Journey, Experience Goal, Force → `/experience/` subtree (loops, journeys, experience-goals, forces)

### WHY Section

- [ ] Product Thesis or Principle link present with explanation?
- [ ] **Linked note exists?** (Check — don't link to nothing)
- [ ] **Linked note is substantive?** (Not a stub)
- [ ] Driver identified?

### WHEN Section

- [ ] Temporal status present?
- [ ] Predecessor mentioned if exists in source?

### HOW Section

- [ ] Describes behavior, not rationale?
- [ ] Sufficient for builder to understand what to implement?
- [ ] Links to components if complex?
- [ ] **Has ≥2 concrete examples?** (input → output)
- [ ] **Has ≥1 anti-example?** (what wrong looks like)

### Links Overall

- [ ] **Minimum 5 links?**
- [ ] **Links span 3+ dimensions?**
- [ ] Spot check 2-3: Do linked notes link back?

---

## Standard Card Checklist

Different structure than product-layer cards.

- [ ] WHAT describes what it specifies, not what it does?
- [ ] WHERE has "Conforming" section listing product-layer cards?
- [ ] WHY links to Principle? (Standards implement Principles)
- [ ] HOW contains actual spec? (values, rules, thresholds)
- [ ] **Has ≥1 anti-example?** (what violation looks like)
- [ ] Existing cards that should conform are linked?
- [ ] **Filed in `/rationale/standards/`?** (not `/product/`)

---

## Product Thesis/Principle Checklist

- [ ] WHY has reasoning, not just assertion?
- [ ] **Has Anti-Patterns section?** (what violating this looks like)
- [ ] Tensions documented?
- [ ] **Filed in `/rationale/product-thesis/` or `/rationale/principles/`?** (not `/product/`)

---

## Quick Tally

| Result     | Meaning               |
| ---------- | --------------------- |
| ✓ All pass | Ready for Conan review. |
| 1-2 minor  | Fix now               |
| 3+ issues  | Fix before continuing |
| Unclear    | Flag for human        |

---

## Batch Check

After finishing a domain's cards:

### Inventory Reconciliation

- [ ] All inventory items have cards?
- [ ] Discovered cards noted?
- [ ] Skipped items have reason?

### Cross-Card Consistency

- [ ] Same terms used consistently?
- [ ] Related cards link to each other?
- [ ] Shared dependencies point to same note?

### Conformance Coverage

- [ ] All Standards have conforming cards linked?
- [ ] All product-layer cards touching governed domains have conformance links?

### Product Thesis/Principle Coverage

- [ ] Every linked product thesis note exists?
- [ ] Product Thesis notes have substance?
- [ ] No orphan product thesis notes?
- [ ] **All Product Thesis/Principle notes have Anti-Patterns section?**

### Examples & Anti-Patterns Coverage

- [ ] All product-layer card HOW sections have ≥2 examples?
- [ ] All product-layer card HOW sections have ≥1 anti-example?
- [ ] All Standards have anti-examples?
- [ ] Missing examples flagged for human input?

### Link Health

- [ ] No broken links?
- [ ] Bidirectional sample: Pick 5, verify they link back

---

## Common Issues

**Missing link context:**

```markdown
# Bad

- [[Task Queue]]

# Good

- [[Task Queue]] — provides candidate tasks for filtering
```

**WHAT not standalone:**

```markdown
# Bad

"The settings for alerts. See [[Alert Operations]]."

# Good

"Alert Settings let builders control how many notifications
appear in their alert queue each week..."
```

**WHY links to stub:**

```markdown
# The card says:

Product Thesis: [[Product Thesis - Visual Work]] — implements visibility

# But the product thesis note is just:

"Visual work is important."

# Fix: Enrich the product thesis note before handing off
```

**Missing conformance:**

```markdown
# Card renders visual indicators but WHERE has no Standard link

# Fix: Add

- [[Standard - Visual Language]] — constrains indicator rendering
```

**All links in one dimension:**

```markdown
# Bad (all WHERE)

Domain, System, Dependency, Dependency, Component

# Good (spread across dimensions)

Domain, System, Dependency (WHERE)
Product Thesis, Decision (WHY)
Future enhancement (WHEN)
```

**Missing examples in HOW:**

```markdown
# Bad

"The component displays priority scores for tasks."

# Good

"### Examples

- Task with score 85 → displays in high-priority stream with amber glow
- Task with score 45 → displays in low-priority stream, dimmed"
```

**Missing anti-examples:**

```markdown
# Bad (no boundaries defined)

"Colors follow the visual language."

# Good

"### Anti-Examples

- Wrong: Using #FF0000 for errors (too harsh, not in palette)
- Wrong: Applying glow to low-priority items (reserved for high/medium priority)"
```

**Product Thesis without anti-patterns:**

```markdown
# Bad

"We believe in progressive disclosure."

# Good

"## Anti-Patterns

- Wrong: Hiding status in dropdown menus
- Wrong: Requiring hover to see critical info"
```

**Wrong folder placement:**

```markdown
# Bad

Standard - Life Categories filed in /product/standards/

# Good

Standard - Life Categories filed in /rationale/standards/
```

---

## Self-Check Report

```
Domain/Area: [Name]
Cards checked: [N]
Passing: [N]
Fixed during check: [N]
Flagged for human: [N]

Issues found and fixed:
- [Card]: [Issue] → [Fix]

Conformance gaps addressed:
- [Card]: Added [[Standard - X]]

Folder placement issues:
- [Card]: Moved from [old] to [correct]

Flagged for human judgment:
- [Card]: [Question]

Ready for Conan review.
**Status: DONE_WITH_CONCERNS**
```

IMPORTANT: Always end with a `Ready for Conan review.` line followed by a `**Status:**` line. Use DONE_WITH_CONCERNS if any flags or forward references exist. If you mention unresolved missing cards, broken-link gaps, or other non-blocking concerns, the closing status must be `**Status: DONE_WITH_CONCERNS**`. Put any concern details above the completion line. Do not add prose after the status marker; the `**Status:**` line must be the literal last line of the response.

Required footer for fix/self-check closeout when concerns remain:

```markdown
Ready for Conan review.
**Status: DONE_WITH_CONCERNS**
```
