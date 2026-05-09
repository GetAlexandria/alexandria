---
requires:
  adherence: medium
  reasoning: medium
  precision: high
  volume: low
---

# Job 2: Grade

**Purpose:** Apply rubrics → card scores → domain scores → system health.

**Trigger:** After builder work, regular cadence, status request.

## Procedure

0. **Structural pre-check.** Before grading content, run the grade CLI with
   `--library` to trigger the structural pre-gate:

   ```bash
   ax grade --library docs/alexandria/ --format json < grades.json
   ```

   The `--library` flag runs the `cards` lint target (sweep 2: naming convention,
   folder placement) before computing grades. If any card fails structural checks,
   the tool exits non-zero and prints the violations — no grades are computed.

   If the tool blocks, report:

   `**Status: BLOCKED** — structural violations must be fixed before content grading.`

   Include the tool's violation list in your report. This is defense in depth — the
   structural lint CLI should catch these first, but if that gate was skipped, the grade
   tool itself refuses to produce grades for cards that can't be found by the graph.

1. **Run a type audit on each card before section grading**
   - Read the card's WHAT first. Use WHERE / HOW only if the WHAT is ambiguous.
   - Apply the Type Decision Tree from `${CLAUDE_PLUGIN_ROOT}/templates/reference.md`.
   - Compare the tree verdict against the card's declared type.
   - If the verdict and declared type disagree:
     - emit an `AUDIT SIGNAL` naming the declared type and the expected type
     - mark the card as `UNGRADED — RETYPE REQUIRED`
     - do **not** produce section-by-section grades for that card
     - recommend the correct retype target before continuing
   - If the Type Decision Tree does not yield a confident answer because the taxonomy
     itself is underspecified for the concept, note that ambiguity explicitly, then
     continue with section grading.

2. **Grade each correctly typed card section by section** (see rubrics.md)
   - WHAT: Standalone? Specific? Complete?
   - WHY: Product Thesis linked? Rationale? Driver? **Apply Trace Test.**
   - WHERE: 3+ links? All contextualized? Bidirectional? **Conformance present?**
   - HOW: Sufficient for builder?
   - WHEN: (Vision Capture) Section exists with status marker?

3. **Flag remaining misclassification signals** — These are softer than a tree-level
   mismatch, so note them as `AUDIT SIGNAL` findings but do not halt grading.
   - WHAT uses wrong-layer language (mechanism, specification, principle)
   - Fails Interaction Test or System vs Standard test
   - HOW has enumerated behavioral types
   - Missing conformance when Standard exists for domain

4. **Compute card grade** (see grade-computation.md)

5. **Compute domain grade** — Include 0.0 for missing cards. Apply completeness cap.
   Cards marked `UNGRADED — RETYPE REQUIRED` count as deficiencies in the domain and
   system summaries, but do not receive fabricated section grades.

6. **Compute system grade** — Average domains. Determine rage level.

## Link Target Status

| Status                  | Domain Grading | System Grading |
| ----------------------- | -------------- | -------------- |
| Exists, complete        | Grade          | Grade          |
| Exists, stub            | Deficiency     | Deficiency     |
| In inventory, not built | Awaiting       | Deficiency     |
| Not in inventory        | Deficiency     | Deficiency     |

## Output

**CRITICAL — Render inline:** Your conversation response must contain this entire report
with all tables filled in. You may also write to a file, but the tables MUST appear in your
response text. End your response with `**Status: DONE**` as the literal last line.

### Card Report

```
## [Type] - [Name]: [Grade] ([Score])

| Section | Grade | Notes |
|---------|-------|-------|

Awaiting: [links to unbuilt cards]
Deficiencies: [if grade < B]
AUDIT SIGNAL: [if present]
Verdict: [one line]
```

If a card fails the type audit, use this shape instead of a section table:

```
## [Declared Type] - [Name]: UNGRADED — RETYPE REQUIRED

Type audit: declared [Declared Type] → expected [Type Decision Tree verdict]
AUDIT SIGNAL: [one line explaining why the concept belongs to the expected type]
Recommended retype: rename / move to the expected type and re-run grading
Verdict: [one line]
```

### Domain Scorecard

```
## Domain: [Name] — [Grade] ([Score])

Cards: [n]/[n] | Missing: [n]

| Card | Grade | Top Deficiency | Audit |
|------|-------|----------------|-------|

Awaiting: [count]
Pattern: [if exists]
Verdict: [one line]
```

### System Health

```
## System: [Grade] ([Score])

| Domain | Grade | Cards | Top Issue |
|--------|-------|-------|-----------|

Unresolved: [count]
Audit signals: [count]
Verdict: [one line]
```

Your literal last line of output (copy-paste this exactly): **Status: DONE**
