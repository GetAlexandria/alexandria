---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Provenance Log Schema

Append-only markdown log tracking context assembly and decision provenance.

**File:** `provenance-log.md`

---

## File Structure

Use one heading block per assembly or follow-up outcome:

```markdown
# Provenance Log

## Assembly: Implement Notification Engine toggle in Settings Panel

**Date:** 2026-02-11
**Assembler:** Bridget (Context Briefing)
**Task:** Implement Notification Engine toggle in Settings Panel
**Target type:** Component
**Task type:** feature

### Seed Cards

| Seed | How Found | Role |
| --- | --- | --- |
| Component - Dashboard Widget | Direct name match | Primary target |
| Section - Settings Panel | WHERE link from seed | Parent container |

### Retrieval Path

- Profile: Component
- CLI call or fallback method used. When the CLI path is used, record the routed command
  surface as `ax retrieve` in current product-facing output rather than the legacy
  `bin/alexandria-retrieve` wrapper name.
- WHY-chain or mandatory-category follow-up performed

### Cards Considered

| Card | Decision | Reason |
| --- | --- | --- |
| Component - Dashboard Widget | Primary | Direct target |
| Section - Settings Panel | Supporting | Parent container |

### Mandatory Category Check

| Mandatory | Required | Found |
| --- | --- | --- |
| Parent container | Yes | Section - Settings Panel |
| Governing Standard | Yes | Standard - Widget Slot Behaviors |

### Queries / Follow-up

| Round | Technique | Terms / Path | Result | Action |
| --- | --- | --- | --- | --- |
| 1 | Grep | "Notification Engine toggle states" in `docs/alexandria/` | 0 matches | Reported HOW gap |

### Decisions / Outcomes

- `decision-001` — Used binary toggle instead of multi-state selector. Confidence: medium. Cards used: `Component - Dashboard Widget`. Default used: yes. Outcome: pending.
```

---

## Outcome Updates

After task completion, append an outcome subsection to the same assembly block or add a
new `## Outcome Update: ...` section:

```markdown
### Outcome Update

- **Decision:** `decision-001`
- **Outcome:** success | failure | partial
- **Notes:** PR approved without changes to toggle implementation
- **Updated:** 2026-02-11T16:00:00Z
```

---

## Required Content

Each assembly entry should capture:

| Content | Required | Description |
| ------- | -------- | ----------- |
| Task metadata | yes | Date, assembler, task, target type, task type |
| Seed cards | yes | Initial cards and how they were found |
| Retrieval path | yes | CLI call or fallback traversal, profile used, special follow-up |
| Cards considered | yes | Primary/supporting/skipped decisions with reasons |
| Mandatory category check | yes | What the profile required and whether it was found |
| Queries / follow-up | no | Extra searches or targeted reads triggered by uncertainty |
| Decisions / outcomes | no | Builder or Sam decisions informed by the briefing |

---

## Weekly Review Queries

Analyze `provenance-log.md` weekly to answer:

1. **Which cards correlate with success?** Cards in successful sessions → validate quality. Cards in failures → review accuracy.
2. **Which cards are retrieved but unused?** High retrieval + low decision reference → over-weighted or poorly structured.
3. **What gaps repeat?** Same topic in multiple gap reports → priority for card creation.
4. **Where does confidence fail?** Medium confidence + failure → calibration needed. High confidence + failure → serious review.
5. **Which profiles under/over-retrieve?** Count cards per profile. Profiles with consistently large candidate sets may need narrowing.
