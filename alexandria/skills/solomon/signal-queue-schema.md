---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Signal Queue Schema

**File:** `docs/alexandria/signal-queue.jsonl`

Analogous to `feedback-queue.jsonl` but for external signal rather than assembly feedback.
The feedback queue captures "what the library is missing" discovered during service. The
signal queue captures "what the world is saying" discovered during intake.

---

## Schema

Each line in `signal-queue.jsonl` is a JSON object representing one triage session:

```json
{
  "timestamp": "2026-03-26T10:00:00Z",
  "source": "meeting | slack | email | conversation | document | raven-handoff",
  "source_description": "Q1 strategy review, 2026-03-25",
  "triaged_by": "solomon + human",
  "items": [
    {
      "claim": "The exact claim, stated as a single assertion",
      "status": "contested | open_question",
      "tensions": ["T1:direct_contradiction", "T4:evidence_gap"],
      "tension_detail": "Concise description of what fired and why",
      "positions": [
        {
          "holder": "Who holds this position (role, not necessarily name)",
          "position": "What they assert",
          "evidence": "What supports it (or 'none')",
          "authority": "Role/standing of the position holder"
        }
      ],
      "library_position": {
        "card": "Type - Name (the card that currently represents the library's position)",
        "says": "What the library currently asserts"
      },
      "affected_cards": ["Type - Name", "Type - Name"],
      "resolution_criteria": "What would resolve this — a decision, an experiment, data",
      "revisit_by": "2026-04-15",
      "resolved": false,
      "resolution": null
    }
  ],
  "dropped": [
    {
      "claim": "Claims classified as noise",
      "reason": "Why it was dropped"
    }
  ]
}
```

## Field Reference

### Session-level fields

| Field | Type | Description |
|-------|------|-------------|
| `timestamp` | ISO 8601 | When the triage was performed |
| `source` | enum | Signal origin type: meeting, slack, email, conversation, document, raven-handoff |
| `source_description` | string | Human-readable description of the specific source |
| `triaged_by` | string | Always "solomon + human" |
| `items` | array | Contested and open-question claims (settled claims route to source material, not here) |
| `dropped` | array | Claims classified as noise, with reasons |

### Item-level fields

| Field | Type | Description |
|-------|------|-------------|
| `claim` | string | The exact claim as a single assertion |
| `status` | enum | `contested` or `open_question` |
| `tensions` | array of strings | Which T1-T7 signals fired, in `T#:name` format |
| `tension_detail` | string | Concise description of what fired and why |
| `positions` | array | Each position held on this claim (at least 2 for contested) |
| `positions[].holder` | string | Who holds this position (role, not name) |
| `positions[].position` | string | What they assert |
| `positions[].evidence` | string | What supports it, or "none" |
| `positions[].authority` | string | Role/standing of the position holder |
| `library_position` | object | What the library currently says (null if library has nothing) |
| `library_position.card` | string | Card reference in `Type - Name` format |
| `library_position.says` | string | The library's current assertion |
| `affected_cards` | array of strings | Cards that would change if this claim resolves |
| `resolution_criteria` | string | What would resolve this |
| `revisit_by` | ISO 8601 date | When to check back on this claim |
| `resolved` | boolean | Whether this claim has been resolved |
| `resolution` | object or null | Resolution details when resolved |

### Resolution fields (when resolved)

When a parked claim is resolved, update:

```json
{
  "resolved": true,
  "resolution": {
    "timestamp": "2026-04-10T14:00:00Z",
    "outcome": "settled | withdrawn | superseded | deferred",
    "detail": "What was decided and why",
    "source_material": "path to source material if settled"
  }
}
```

## Consumption

| Agent | When | What They Do With It |
|-------|------|---------------------|
| **Solomon** | Start of every triage | Check for echoes (T5), flag stale claims |
| **Raven** | During product conversations | Surface contested claims relevant to the topic |
| **Conan** | During health check (Job 8) | Flag claims past their revisit date |
| **Human** | When evidence arrives | Resolve parked claims → route to Play 5.2 |
