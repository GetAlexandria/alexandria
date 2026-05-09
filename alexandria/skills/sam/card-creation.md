---
requires:
  adherence: medium
  reasoning: medium
  precision: high
  volume: high
---

# Card Creation

Step-by-step procedure for building cards.

## Before You Start

Have these open:

- Conan's inventory for the domain
- Relevant SOT (Source of Truth document) sections and companion docs
- Library Reference (templates, conformance obligations)
- Link patterns reference
- Library Organization (`${CLAUDE_PLUGIN_ROOT}/skills/sam/library-organization.md`) — type-to-folder mapping

Critical closeout rule for create, fix, and self-check work:

```markdown
Ready for Conan review.
**Status: DONE**  # or DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT
```

When there are forward references or non-blocking gaps, switch the status line to
`**Status: DONE_WITH_CONCERNS**`. These must be the final two lines of the response.

---

## Product-Layer Card Procedure

This procedure applies to all product-layer types: Domains, Sections, Governance, Templates, Components, Artifacts, Capabilities, Primitives, Systems, Agents, and Prompts. Use the type-specific template from Library Reference (`reference.md`) for section structure.

### Step 1: Read

1. Find the inventory entry
2. Read the source sections listed
3. Note: What is this? What does it do? What does it connect to?

Don't write yet. Absorb.

### Step 2: WHAT First

Start with WHAT. It anchors the card.

Write 2-4 sentences:

- What is this thing?
- What does it do?
- Who uses it?

**Test:** Cover the title. Does WHAT make sense alone? If not, rewrite.

### Step 3: WHERE

Map the ecosystem.

Use the WHERE template from Library Reference for your card's type. Key patterns:

- **Sections** → link parent Domain, resident Agent, contained Templates/Artifacts/Capabilities
- **Templates** → link parent Section, contained Components
- **Components** → link parent Template/Section/Governance
- **Governance** → link visibility scope (which Domains)
- **Artifacts** → link Section where created/edited
- **Capabilities** → link Section(s) where performed
- **Agents** → link home Section, coordinating Agents
- **Prompts** → link parent Agent
- **Primitives** → link Sections/Capabilities that serve them

All types: include Conforms to links where obligated (see below).

**Conformance check:** Does this card touch a governed domain? Check the conformance obligations table in `docs/alexandria/reference.md` for the full list of governed domains and their constraining Standards. If yes, add a conformance link in WHERE.

Every link gets context phrase. Use link-patterns.md.

**Check:** 3+ links? Context on each? Conformance present?

### Step 4: WHY

Trace the rationale.

```markdown
## WHY: Rationale

- Product Thesis: [[Product Thesis]] — [how this implements it]
- Principle: [[Principle]] — [what guidance it follows]
- Driver: [[Signal/Pressure]] or Exploratory — [hypothesis]
```

**Critical:** Check that product thesis/principle notes exist and aren't stubs.

If note doesn't exist → Create it now.
If note is stub → Enrich it now.

### Step 5: WHEN

Mark temporal status.

```markdown
## WHEN: Timeline

New concept — no past. Planned for v1.0.
```

Or if predecessor exists:

```markdown
Supersedes [[Past - Old Approach]] which [why it changed].
```

### Step 6: HOW

Describe intended behavior with examples.

```markdown
## HOW: Implementation

### Behavior

[What it does. User-observable behavior. State transitions.]

### Examples

[Concrete input → output. At least 2.]

- Example 1: [input] → [output]
- Example 2: [input] → [output]

### Anti-Examples

[What wrong implementation looks like. At least 1.]

- Wrong: [what it shouldn't do and why]
```

**Check:** Could someone implement from this? Are examples concrete?

**If source lacks examples:** Flag for human input, or derive from behavior spec.

### Step 7: Quick Self-Check

- [ ] All five sections present?
- [ ] WHAT standalone?
- [ ] 5+ links with context?
- [ ] Conformance links where obligated?
- [ ] Product Thesis note exists and is substantive?
- [ ] WHEN has temporal status?
- [ ] HOW has ≥2 examples?
- [ ] HOW has ≥1 anti-example?

Issues? Fix now. Unclear? Flag and move on.

---

## Standard Card Procedure

Standards are specifications that constrain product-layer cards. No runtime state.

**Standards belong in `/rationale/standards/`** — they are part of the rationale layer, not the product layer.

### Step 1: Read

Identify specification content in source:

- Tables of values (colors, thresholds, formulas)
- Rules with testable criteria
- Constraints multiple cards must follow

### Step 2: WHAT

```markdown
## WHAT: Definition

[What this standard specifies. What it constrains.]
```

Standards don't "do" — they define what implementations must match.

### Step 3: WHERE

```markdown
## WHERE: Ecosystem

- Implements:
  - [[Principle]] — [what guidance this makes testable]
- Conforming:
  - [[Section]] — [must follow this]
  - [[Template]] — [must follow this]
  - [[Component]] — [must follow this]
  - [[Governance]] — [must follow this]
  - [[Agent]] — [must follow this]
- Related:
  - [[Standard]] — [complementary or overlapping standards]
```

**Audit existing cards:** What product-layer cards should conform to this? Add links both directions.

### Step 4: WHY

```markdown
## WHY: Rationale

- Principle: [[Principle]] — [what guidance it makes concrete]
- Driver: [What goes wrong without this spec — the "Angry Birds" problem]
```

Standards must implement at least one Principle. No arbitrary rules.

### Step 5: WHEN

```markdown
## WHEN: Timeline

[Stability status. When established.]
```

### Step 6: HOW

```markdown
## HOW: Specification

[The actual spec. Values, rules, thresholds.]
[Tables preferred — scannable, unambiguous.]
```

This is what builders read to know what to produce.

### Step 7: Anti-Examples

```markdown
## Anti-Examples

[What violation looks like. Concrete wrong outputs.]

- Wrong: [specific violation and why it fails the spec]
```

**Critical for Standards:** Anti-examples define boundaries. Without them, builders may produce technically compliant but wrong outputs.

---

## Creating Supporting Notes

### Product Thesis Note

Don't stub it. Conan traces these.

**Product Thesis notes belong in `/rationale/product-thesis/`.**

```markdown
# Product Thesis - [Name]

## WHAT: The Thesis

[One sentence articulating the thesis.]

Counter-thesis: [The strongest argument against this thesis.]

## WHERE: Ecosystem

- Type: Product Thesis (Problem | Solution | Plank)
- Parent: [[Product Thesis]] — [relationship to parent thesis]
- Principles:
  - [[Principle]] — [what judgment guidance this generates]
- Standards:
  - [[Standard]] — [what specifications this generates]
- Domains:
  - [[Domain]] — [what product areas embody this]

## WHY: Belief

[Why we believe this — reasoning, not just assertion]

## Validation Criteria

[How to validate. Metrics, tests, targets, invalidation signals.]

## HOW: Application

### What Following This Looks Like

[2-3 concrete examples.]

### What Violating This Looks Like

[2-3 concrete anti-patterns.]

### Decision Heuristic

[When facing a tradeoff, how does this thesis guide the choice?]
```

**Minimum viable:** 150+ words with real reasoning in WHY. Validation criteria and anti-patterns required.

### Principle Note

**Principle notes belong in `/rationale/principles/`.**

```markdown
# Principle - [Name]

## WHAT: The Principle

[One sentence. Judgment-based guidance.]

## WHERE: Ecosystem

- Product Thesis:
  - [[Product Thesis]] — [what bet this serves]
- Standards:
  - [[Standard]] — [what specifications make this testable]
- Governs:
  - [[Domain]] — [what areas this applies to]
  - [[Section]] — [what sections this shapes]
  - [[Capability]] — [what behaviors this constrains]
- Related:
  - [[Principle]] — [complementary or contrasting principles]

## WHY: Belief

[Why we believe this]

## HOW: Application

### What Following This Looks Like

[2-3 concrete examples.]

### What Violating This Looks Like

[2-3 concrete anti-patterns.]

### Tensions

[What other principles this trades off against.]

### Test

[A question to ask when evaluating whether a design follows this principle.]
```

### Decision Note

```markdown
# Decision - [Name]

## WHAT: The Choice

[What was decided]

## WHERE: Ecosystem

- Affects:
  - [[Domain]] — [how it shapes this]
  - [[Section]] — [how it shapes this]
  - [[Capability]] — [how it shapes this]
- Governed by:
  - [[Principle]] — [what guided the choice]

## WHY: Rationale

Options considered:

- Option A: [rejected because]
- Option B: [chosen because]

## WHEN: Timeline

[When made, what phase]
```

---

## Batch Workflow

For a domain with 10 cards:

1. Read all source material
2. Create cards in build order:
   - Standards first (they constrain everything)
   - Product Thesis/Principles next (WHY upstream)
   - Systems next (cross-cutting mechanisms)
   - Domains/Sections (most-depended-on first)
   - Governance, Templates, Artifacts, Capabilities
   - Components last (implementation details)
   - Agents + Prompts
   - Experience layer (Loops, Journeys, Experience Goals, Forces)
3. After all created, batch self-check
4. Fix issues found
5. Report and hand off

**Don't:** Create one, hand to Conan, wait, fix, repeat.
**Do:** Create all, self-check batch, hand off batch.

---

## Progress Reporting

During work:

```
Starting Dashboard domain. 8 cards in inventory.
```

```
Done: 4/8 cards. Created Standard - Visual Language along the way.
```

After self-check, the response is invalid unless it ends with the exact footer.
Do not substitute a heading like "final status" or stop after saying the cards passed.

```
Self-check complete.
- 8 product-layer cards ready
- 2 standards created
- 1 flag: Task Queue — structure or system?
- Concerns: 1 forward reference (Section - Dashboard not yet built), 1 type flag for human judgment.

Ready for Conan review.
**Status: DONE_WITH_CONCERNS**
```

If there are no concerns, still end with:

```markdown
Ready for Conan review.
**Status: DONE**
```

For create, fix, or self-check jobs, keep the closeout shape consistent:

1. Brief summary of cards created or fixed
2. Any forward references, path corrections, or non-blocking concerns
3. An explicit completion line such as `Ready for Conan review.`
4. Final status marker on its own line

Use `**Status: DONE**` if no issues. Use `**Status: DONE_WITH_CONCERNS**` if there are forward references, type ambiguities, or flags. Use `**Status: BLOCKED**` if missing source material prevents card creation. State an explicit completion signal such as `Ready for Conan review.` immediately before the status line. Do not put any prose, concern list, or acknowledgments after the status line — it must be the literal last line of the response. Do not replace this footer with alternatives like "final status" or "PASS"; the exact closeout contract still applies during self-check.
