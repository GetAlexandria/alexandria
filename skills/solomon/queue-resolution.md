---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Queue Resolution

How Solomon manages the signal queue lifecycle. The signal queue is not a write-once log —
it's a living staging area for unsettled knowledge. Claims enter as contested or open
questions. Over time, they resolve, compound, or go stale.

Load Section 1 during Step 1 of job-signal-triage.md (orient).
Load Section 2 during Step 4 (tension detection — needed when T5 fires).
Load Section 3 during Step 7 (queue writes and lifecycle management).

---

## Section 1: Pre-Triage Queue Check

Every triage session starts by reading the queue. This is not optional — the queue is
institutional memory about what's still contested.

### Step 1: Read the queue

```
Read: docs/alexandria/signal-queue.jsonl
```

Parse all entries. Identify:
- **Active items:** `resolved: false`
- **Stale items:** `revisit_by` date has passed and item is still unresolved
- **High-tension items:** Items with T1 or T2 tensions (foundational disagreements)

### Step 2: Surface stale items

If any items are past their `revisit_by` date, surface them to the human at the start
of the session:

```
Before we triage the new signal, the queue has [N] stale items past their revisit dates:

1. [Claim summary] — parked [date], revisit was [date]. Status: [contested/open_question].
   Resolution needed: [resolution_criteria]

2. ...

Want to address any of these now, or proceed with the new signal?
```

**Why surface stale items first:** The new signal may resolve a stale item. If the human
knows what's stale before seeing new claims, they can spot connections.

### Step 3: Note standing requirements

From the active queue items, identify what the library is currently trying to learn. These
are the "standing requirements" — open questions and contested claims that new signal
could address.

Keep these in working memory during the triage session. When extracting and analyzing new
claims, check each against standing requirements.

---

## Section 2: Echo Detection Protocol

When a new claim connects to a parked queue item, Solomon identifies the relationship
type and presents it.

### Four Echo Types

| Type | Signal | What Solomon Says |
|------|--------|-------------------|
| **Resolves** | New claim provides the evidence, authority, or decision that the parked claim was waiting for | "This new claim may resolve the [date] contested item. The parked item needed [resolution_criteria]. This claim provides [what it provides]." |
| **Reinforces** | New claim adds evidence or a new voice supporting one side of a contested claim | "This adds [a new voice / new evidence] supporting [which side] of the [date] contested item. It doesn't settle it alone, but the balance has shifted." |
| **Contradicts** | New claim takes the opposite side of a parked position, or provides counter-evidence | "This claim contradicts the [position] side of the [date] contested item. The debate deepens — we now have [N] voices/evidence on each side." |
| **Compounds** | New claim + parked claim together imply something neither says alone | "This claim, combined with the parked [date] item, implies [emergent implication]. Neither claim says this on its own." |

### Presenting Echoes

When an echo is detected, present it DURING claim analysis (Step 4), not after:

```
CLAIM: [the claim]
...
ECHO: This connects to a parked item from [date]:
  Parked claim: [claim summary]
  Relationship: [resolves | reinforces | contradicts | compounds]
  Implication: [what this means]
```

### Resolution Through Echo

If a new claim RESOLVES a parked item (and the human confirms), update the queue entry:

```json
{
  "resolved": true,
  "resolution": {
    "timestamp": "<ISO-8601>",
    "outcome": "settled",
    "detail": "Resolved by new signal from [source]. [One sentence on what settled it.]",
    "source_material": "docs/alexandria/sources/solomon-source-YYYY-MM-DD-<slug>.md"
  }
}
```

The resolved claim also goes into the current session's source material. One claim, two
outputs: queue resolution + source material draft.

---

## Section 3: Queue Lifecycle Management

### Resolution Types

When a parked claim is resolved, it gets one of four outcomes:

| Outcome | Meaning | What Happens |
|---------|---------|-------------|
| **Settled** | Evidence or authority arrived. The claim is now decided. | Draft source material. Update queue entry with resolution. |
| **Withdrawn** | The original claimant or a comparable authority says "never mind." | Update queue entry. No source material needed. |
| **Superseded** | A new decision or claim replaces this one entirely. | Draft source material for the new claim with supersession header. Update old queue entry. |
| **Deferred** | Still contested but not worth active attention. Push revisit date. | Update `revisit_by`. Add note on why deferred. |

### Stale Claim Handling

Claims past their `revisit_by` date need one of three treatments:

1. **Re-evaluate.** Has new information arrived since the claim was parked? Check the
   library for changes in the affected area. If the landscape has shifted, re-run tension
   detection with current context.

2. **Escalate.** If the claim has been stale for more than one revisit cycle, it may need
   the human to actively seek resolution: schedule a meeting, make a decision, run an
   experiment. Solomon surfaces this: "This claim has been parked since [date] and is past
   its second revisit. It may need active resolution — a decision meeting or an experiment
   to generate the missing evidence."

3. **Defer.** If the claim is genuinely not resolvable now and not blocking anything,
   push the revisit date forward. Add a note: "Deferred [date] — still contested, not
   blocking current work."

### Queue Hygiene

**What Solomon does at the START of every triage session:**
- Count active items
- Flag stale items
- Note standing requirements

**What Solomon does at the END of every triage session:**
- Report any queue items resolved, reinforced, or complicated by new signal
- Update stale items that were addressed
- Note the current queue state in the triage report

**What Solomon does NOT do:**
- Resolve queue items without human confirmation
- Delete queue items (even noise stays as a record with `resolved: true`)
- Change a claim's status without presenting the evidence to the human first

### Queue Size Warnings

| Active Items | What It Means | What Solomon Says |
|-------------|---------------|-------------------|
| 0-3 | Healthy. Few open questions. | Nothing — this is normal. |
| 4-7 | Moderate. Some unresolved debates. | "The queue has [N] active items. Here's a quick summary of what's parked." |
| 8-12 | Heavy. Significant contested territory. | "The queue has [N] active items, [M] past revisit date. We may want to do a dedicated resolution session." |
| 13+ | Overloaded. Institutional decision debt. | "The queue has [N] active items. This suggests systemic decision-making gaps. Consider scheduling a decision sprint to clear the backlog." |
