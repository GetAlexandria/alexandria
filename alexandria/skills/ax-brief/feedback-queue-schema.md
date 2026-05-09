---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Feedback Queue Schema

Append-only markdown log of actionable library improvement items discovered during context
assembly.

**File:** `feedback-queue.md`

---

## File Structure

Use one section per assembly and one subheading per actionable item:

```markdown
# Feedback Queue

## Items from Assembly: Notification Engine toggle in Settings Panel (2026-02-19)

### FQ-001 — Missing: Widget interaction standard

**Type:** Gap — missing card
**Severity:** High
**Dimension:** HOW
**Discovered during:** Context briefing for Notification Engine toggle feature

**Signal:** No Standard card documents interaction patterns for widget toggles.

**Recommendation:** Sam should author `Standard - Widget Interactions` or extend an
existing Standard. Conan should review whether this should become a mandatory category for
Component assemblies.
```

---

## Required Content

Each item should capture:

| Content | Required | Description |
| ------- | -------- | ----------- |
| Item id / title | yes | Stable local label such as `FQ-001` plus a concise summary |
| Type | yes | `gap`, `weak_card`, `retrieval_miss`, or `relationship_discovery` |
| Severity | yes | `high`, `medium`, or `low` |
| Dimension | no | WHAT / WHERE / WHY / WHEN / HOW when applicable |
| Discovery context | yes | What assembly or task surfaced the issue |
| Signal | yes | What was missing, weak, or discovered |
| Recommendation | yes | Concrete next action for Sam and/or Conan |

### Feedback types

| Type                     | When to use                                                        |
| ------------------------ | ------------------------------------------------------------------ |
| `gap`                    | A card should exist but doesn't — gap manifest item is actionable  |
| `weak_card`              | Card exists but a dimension is too thin to be useful               |
| `retrieval_miss`         | Card exists but the retrieval profile didn't surface it            |
| `relationship_discovery` | Connection between cards noticed during traversal but not recorded |

### Severity guide

| Severity | Meaning                                                               |
| -------- | --------------------------------------------------------------------- |
| `high`   | Blocked assembly or forced builder to guess on a critical dimension   |
| `medium` | Degraded assembly quality — builder got context but it was incomplete |
| `low`    | Minor improvement — assembly worked fine but could be better          |

---

## Consumption

Feedback queue items are processed during library maintenance cycles:

- **Conan** reviews the queue during Health Check (Job 8) or Recommend (Job 4)
- **Sam** acts on items per Conan's recommendations
- Items are not deleted — they accumulate as a backlog for prioritization
