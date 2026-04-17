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

1. **Grade each card section by section** (see rubrics.md)
   - WHAT: Standalone? Specific? Complete?
   - WHY: Product Thesis linked? Rationale? Driver? **Apply Trace Test.**
   - WHERE: 3+ links? All contextualized? Bidirectional? **Conformance present?**
   - HOW: Sufficient for builder?
   - WHEN: (Vision Capture) Section exists with status marker?

2. **Flag misclassification signals** — Don't halt. Note AUDIT SIGNAL.
   - WHAT uses wrong-layer language (mechanism, specification, principle)
   - Fails Interaction Test or System vs Standard test
   - HOW has enumerated behavioral types
   - Missing conformance when Standard exists for domain

3. **Compute card grade** (see grade-computation.md)

4. **Compute domain grade** — Include 0.0 for missing cards. Apply completeness cap.

5. **Compute system grade** — Average domains. Determine rage level.

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
