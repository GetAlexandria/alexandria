---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Source Templates

Structured formats for Solomon's three output types. These are not library cards — they
are pipeline artifacts that feed downstream agents (Conan assesses, Sam builds from).

Load this file during Steps 6, 7, and 8 of job-signal-triage.md.

---

## 1. Source Material (Settled Claims)

Write to `docs/alexandria/sources/` as a markdown file. This is what Conan receives
in Play 5.2 — the better the source material, the better Conan's assessment.

**Filename:** `solomon-source-YYYY-MM-DD-<slug>.md`

### Template

```markdown
# Source Material: <Topic>

**Date:** <ISO-8601>
**Origin:** <meeting | slack | email | conversation | document | raven-handoff>
**Origin detail:** <specific source — e.g., "Q1 strategy review, 2026-03-25">
**Triaged by:** Solomon + <human name/role>

## Settled Claims

### Claim 1: <claim stated as a single assertion>

**Authority:** <who decided this, their role, and their scope>
**Evidence:** <what supports this claim>
**Evidence tier:** <E1 data | E2 expert judgment | E3 anecdote | E4 assertion>
**Source reliability:** <A-F>
**Content credibility:** <1-6>
**Tensions checked:** <which T1-T7 were checked, which fired, how they resolved>

**Library impact:**
- **Affected cards:** <list of cards that need updating>
- **Impact type:** <net-new | update | correction>
- **Blast radius:** <low: 0-2 cards | medium: 3-5 cards | high: 6+ cards>

### Claim 2: ...

## Context for Conan

<2-3 sentences giving Conan the bigger picture. Why were these claims triaged now? What
was the human's intent? Are these claims part of a larger strategic shift or isolated
updates? This section saves Conan from having to re-derive context.>

## Raw Signal Reference

<Where to find the original signal if Conan needs to check context. Path to meeting notes,
link to Slack thread, or "verbal — no written record.">
```

### What Makes Good Source Material

- **Specific claims, not summaries.** "We decided to use Postgres" is good. "We discussed
  database options" is not source material — it's still raw signal.
- **Evidence cited.** Even if the evidence is thin, name it. "No supporting data was
  presented" is more useful to Conan than silence.
- **Authority named.** "The CTO decided" gives Conan authority provenance. "The team
  discussed" does not.
- **Tensions documented.** If T1 fired but resolved (the contradiction was acknowledged
  and the new claim supersedes), say so. Conan needs to know what was checked.

---

## 2. Source Material with Supersession Header (Supersedes Claims)

Same format as Section 1, with an additional supersession block after each claim.

### Supersession Block

Add this immediately after the claim details for any claim classified as Supersedes:

```markdown
**Supersedes:**
- **Previous position:** <what the library currently says>
- **Previous card:** <Type - Name>
- **Previous authority:** <who established the current position>
- **Previous evidence:** <what supported the current position>
- **Reason for change:** <why the new claim overrides the old — new data, new authority,
  changed context>
- **Cards to update:** <specific list of cards that need modification>
- **Cards to check:** <cards that reference the superseded card — may need cascading
  updates>
```

### Why Supersession Headers Matter

Without them, Conan has to rediscover the blast radius during Play 5.2. Solomon already
did this work during tension detection — the supersession header hands it to Conan
explicitly. This is the handoff that prevents duplicate work across the pipeline.

---

## 3. Triage Report

The triage report is Solomon's session summary. It gives the human a complete picture of
what happened and where things stand.

**Output:** Display in conversation at the end of the triage session. Also optionally
write to `docs/alexandria/sources/` as `solomon-triage-YYYY-MM-DD-<slug>.md` if
the human wants a record.

### Template

```markdown
# Triage Report: <Source Description>

**Date:** <ISO-8601>
**Signal type:** <meeting | slack | email | conversation | document | raven-handoff>
**Signal description:** <one-line description>

## Summary

| Category | Count |
|----------|-------|
| Claims extracted | N |
| Settled (→ source material) | M |
| Supersedes (→ source material) | S |
| Contested (→ signal queue) | P |
| Open questions (→ signal queue) | Q |
| Noise (dropped) | R |

## Settled Claims → Source Material

<For each settled/supersedes claim, one line: the claim + where the source material was
written.>

1. **<Claim>** → `sources/solomon-source-YYYY-MM-DD-<slug>.md`

## Parked Claims → Signal Queue

<For each contested/open-question claim, one line: the claim + when to revisit.>

1. **<Claim>** — Status: contested. Revisit by: <date>. Resolution needs: <what>

## Dropped (Noise)

<For each dropped claim, one line: the claim + why it was dropped.>

1. **<Claim>** — Reason: <why>

## Signal Queue Activity

<If any parked claims were resolved, reinforced, or complicated by this session's signal,
note them here.>

- **Resolved:** <list of queue items resolved by this session>
- **Reinforced:** <list of queue items that got new supporting evidence>
- **Complicated:** <list of queue items that got new contradicting evidence>

## Observations

<Optional. Any meta-observations about the signal: unusually high tension rate, pattern
across claims, evidence quality concerns, authority gaps. Keep to 2-3 sentences max.>
```

### Triage Report Anti-Patterns

- **Missing counts.** Every triage report must have the summary table. If the numbers
  don't add up (settled + supersedes + contested + open + noise ≠ total extracted),
  something was lost.
- **Vague routing.** "Some claims were settled" is not a report. Name every claim and
  where it went.
- **Editorializing.** The Observations section is for factual meta-observations, not
  Solomon's opinions about whether the meeting was productive. Stick to patterns in the
  data.
- **Missing revisit dates.** Every contested/open-question claim needs a revisit date.
  If the human didn't specify one, suggest one (default: 2 weeks for contested, 1 month
  for open questions).

---

## 4. Signal Queue Entry Supplement

Signal queue entries follow the schema in `signal-queue-schema.md`. This section adds
guidance for writing the narrative fields that the schema leaves open.

### Writing `tension_detail`

Bad: "T1 fired."
Good: "T1 (direct contradiction): The meeting notes assert 'we are dropping Feature X.'
The library's Decision card establishes Feature X as a planned capability. These are
incompatible positions."

Include: which tension, what the claim says, what the library says, why they conflict.

### Writing `resolution_criteria`

Bad: "Needs more discussion."
Good: "Needs a decision from the founding team on whether the Feature X roadmap is
being formally abandoned. Specifically: is the distribution strategy changing,
or just the timeline?"

Include: who needs to decide, what specific question needs answering, what evidence would
resolve it.

### Setting `revisit_by`

| Claim Type | Default Revisit | Reasoning |
|-----------|----------------|-----------|
| Contested with identified decider | 2 weeks | Someone can settle this soon |
| Contested without clear path | 1 month | Check if context has changed |
| Open question with investigation plan | Timeline of the investigation | Revisit when the investigation should be complete |
| Open question without plan | 1 month | General check-in |

The human can override any default. If they say "revisit next quarter," use that.
