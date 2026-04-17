---
requires:
  adherence: low
  reasoning: medium
  precision: medium
  volume: medium
---

# Job 8: Health Check

**Purpose:** Assess quality of existing library. Distinguish upstream gaps from card-level issues.

**Trigger:** Periodic (quarterly), after major source updates, "How healthy is the library?"

Health Check ≠ Grading. Grading scores cards. Health Check diagnoses the system and traces root causes.

## Procedure

Follow build order — upstream before downstream.

### CLI Pre-flight

Before Phase 1, try the deterministic fast path.

1. Run `ax health-check <library-path>` where `<library-path>`
   resolves to the Alexandria library root (usually
   `docs/alexandria/library`)
2. Capture the JSON report and use it as pre-computed substrate, not as the
   final diagnosis
3. Read these sections first:
   - `inventory` — Phase 2 inventory reconciliation
   - `standards_health` — Phase 3 structural Standards checks
   - `metrics` — Phase 1 quantitative backdrop and Phase 5 sample sizing
   - `findings` — grouped mechanical hotspots that may explain drift or
     sampling priority
   - `signal_queue` — unresolved claims whose `revisit_by` dates are due or
     overdue and may indicate decision debt or pending card drift
4. Keep judgment with Conan:
   - The CLI reports structure and counts
   - Conan still decides whether content is substantive, outdated,
     strategically weak, or urgent enough to escalate in the repair agenda
5. Graceful degradation:
   - If `ax` is unavailable, the command fails, or the JSON is malformed,
     continue through all six phases manually
   - State explicitly in the report that the CLI pre-flight was unavailable
     and Conan performed the mechanical work directly

### Phase 1: Source Alignment

1. **List current source materials** — SOT (Source of Truth document),
   companion docs, brand standards, strategy docs
2. **If CLI pre-flight is available, read `metrics`, `findings`, and
   `signal_queue` first** — use them as quantitative backdrop for graph
   health, broken links, orphan counts, terminology drift, stale contested
   claims, and other mechanical hotspots. This does NOT replace source
   comparison.
3. **Compare to library contents:**
   - Cards without source backing? → Orphan or outdated
   - Source content without cards? → Gap
   - Source changed since card created? → Drift risk
   - Signal-queue claims due or overdue for `revisit_by`? → Pending decision debt or
     possible stale guidance in affected cards

**Output:**

```
## Source Alignment

| Status | Count |
|--------|-------|
| Aligned | [n] |
| Drift risk | [n] |
| Orphaned | [n] |
| Source gaps | [n] |
```

Stale signal-queue claims due or overdue for revisit: [n]
- [claim] — revisit was [date]; affected cards: [list]

### Phase 2: Inventory Reconciliation

1. **If CLI pre-flight is available, read `inventory` first**
   - Use `inventory.expected_cards` and `inventory.actual_cards` for
     headline counts
   - Use `inventory.missing_cards` and `inventory.unexpected_cards`
     instead of manual recounting
   - Use `inventory.by_type` for type-level deltas
   - Use `inventory.expected_card_names` and
     `inventory.actual_card_names` when you need exact lists
2. **Check whether expectation data exists**
   - If `inventory.expectations_available` is `false` or
     `inventory.manifest_count` is `0`, say the CLI has no manifest-backed
     expectation set and run the inventory manually from current sources
3. **If CLI pre-flight is unavailable, run inventory on current sources
   manually** — What SHOULD exist?
4. **Compare to what DOES exist:**
   - Missing cards
   - Unexpected cards (not in source)
   - Misclassified cards

**Output:**

```
## Inventory Status

Expected: [n] | Exists: [n] | Missing: [n] | Unexpected: [n]

Missing by type:
| Type | Count | Examples |
|------|-------|----------|
```

### Phase 3: Standards Health

Spot-check ALL Standards.

| Check         | Pass Criteria                             |
| ------------- | ----------------------------------------- |
| WHAT          | Specifies something concrete              |
| WHY           | Links to ≥1 Principle                     |
| HOW           | Has actual spec (values/rules/thresholds) |
| Anti-examples | Shows what violation looks like           |
| Conformance   | ≥1 product-layer card links to it         |

1. **If CLI pre-flight is available, read `standards_health` first**
   - Use `standards_health.total_standards`, `passing_standards`, and
     `failing_standards` for the overall picture
   - Use `standards_health.standards[*]` for per-Standard structural
     evidence
   - Use `standards_missing_principle_links`,
     `standards_missing_how_spec`,
     `standards_missing_anti_examples`, and
     `standards_without_conforming_cards` for roll-up lists
2. **Treat the CLI as structural evidence only**
   - `why_links.pass` and `why_links.principles` tell you whether
     Principle links exist
   - `how_spec.pass` tells you whether HOW contains non-example spec
     content
   - `anti_examples.pass` and `anti_examples.count` tell you whether
     anti-examples exist
   - `conforming_cards.pass`, `conforming_cards.count`, and
     `conforming_cards.cards` tell you whether downstream cards link back
3. **Apply Conan judgment for content quality**
   - Manually assess whether WHAT is concrete
   - Manually assess whether WHY and HOW are substantive, not merely
     present
   - Do not re-count structural checks unless the CLI is unavailable or
     clearly wrong
4. **If CLI pre-flight is unavailable, perform all Standards checks
   manually**

**Output:**

```
## Standards Health

| Standard | WHAT | WHY | HOW | Anti-ex | Conforming | Verdict |
|----------|------|-----|-----|---------|------------|---------|

Standards without conforming cards: [list]
Standards missing anti-examples: [list]
```

### Phase 4: Product Thesis/Principle Health

Spot-check ALL Product Thesis and Principle notes.

| Check         | Pass Criteria                                   |
| ------------- | ----------------------------------------------- |
| WHAT          | Clear statement, not placeholder                |
| WHY           | Reasoning present ("because..."), not assertion |
| Anti-patterns | Shows what violating looks like                 |
| Downstream    | ≥1 downstream card links to it                  |

**Output:**

```
## Product Thesis/Principle Health

| Card | WHAT | WHY | Anti-patterns | Downstream | Verdict |
|------|------|-----|---------------|------------|---------|

Orphaned (no downstream links): [list]
Missing anti-patterns: [list]
Stub notes (assertion only): [list]
```

### Phase 5: Product Layer Sampling

Full grade on sample of product-layer cards (20% or 10 cards, whichever larger).

1. **If CLI pre-flight is available, use `metrics` as the sampling
   substrate**
   - Use `metrics.total_cards` to size the sample
   - Use `metrics.by_type`, `metrics.by_layer`,
     `metrics.orphan_count`, `metrics.broken_link_count`, and relevant
     `findings` groups as the quantitative backdrop for where risk
     clusters
2. **Select the actual cards manually**
   - Highest-linked (most depended on)
   - Recently created
   - One from each domain
   - The CLI does not currently choose the card list for you
3. **If CLI pre-flight is unavailable, compute sample size and select the
   sample manually**

Apply full rubric including:

- Examples in HOW (≥2)?
- Anti-examples in HOW (≥1)?
- Conformance links where obligated?

**Output:**

```
## Product Layer Sample

| Card | Grade | Top Deficiency |
|------|-------|----------------|

Patterns:
- [n] missing examples
- [n] missing anti-examples
- [n] missing conformance
```

### Phase 6: Cascade Analysis

For weak product-layer cards, trace upstream:

```
Card weak on WHY?
    └─ Check linked Product Thesis/Principle
        └─ Stub? → Upstream fix
        └─ Substantive? → Card-level fix

Card weak on HOW?
    └─ Check conforming Standard
        └─ Missing? → Standard gap
        └─ Vague? → Standard fix
        └─ Concrete? → Card-level fix
```

**Output:**

```
## Cascade Analysis

Upstream issues (fix these first):
| Upstream Card | Issue | Blast Radius |
|---------------|-------|--------------|

Card-level issues:
| Card | Issue | Fix Type |
|------|-------|----------|
```

## Output

**Present inline:** Render this entire output template in your conversation response.
Do not only write it to a file. End with `**Status: DONE**` (or DONE_WITH_CONCERNS).

```
# Library Health Check

Date: [date]
Scope: [full library / domain]

## Executive Summary

| Layer | Health | Top Issue |
|-------|--------|-----------|
| Source Alignment | [Good/Drift/Gap] | |
| Standards | [n]/[total] pass | |
| Product Thesis/Principles | [n]/[total] pass | |
| Product Layer (sampled) | [grade] | |

Overall: [Healthy / Needs Work / Critical]

## Phase 1: Source Alignment
[details]
Stale signal-queue claims:
- [claim] — revisit was [date]; affected cards: [list]

## Phase 2: Inventory
[details]

## Phase 3: Standards
[details]

## Phase 4: Product Thesis/Principles
[details]

## Phase 5: Product Layer
[details]

## Phase 6: Cascade Analysis
[details]

## Recommended Fix Order

### Tier 1: Upstream (fix first)
| Card | Issue | Blast Radius |
|------|-------|--------------|

### Tier 2: Standards gaps
| Standard | Issue |
|----------|-------|

### Tier 3: Card-level
| Card | Issue |
|------|-------|

## Flags
- HUMAN JUDGMENT NEEDED: [items]
- SOURCE GAP: [items needing human input]
```

## Health Levels

| Level      | Definition                                                                                 |
| ---------- | ------------------------------------------------------------------------------------------ |
| Healthy    | >80% Standards pass, >80% Product Thesis/Principles pass, Product layer sample averages B+ |
| Needs Work | 60-80% pass rates, or Product layer sample averages B- to C+                               |
| Critical   | <60% pass rates, or Product layer sample below C                                           |

## Principles

- Upstream before downstream — always
- Distinguish root causes from symptoms
- Standards and Product Thesis gaps hurt most — prioritize finding them
- Sample product-layer cards strategically — high-link cards reveal more
- Anti-patterns gaps are fixable — flag but don't panic
