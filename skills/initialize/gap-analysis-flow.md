# Gap Analysis Flow

Reference material for the gap analysis conversation. Loaded on demand during
Step 5 of the initialize flow.

Apply the gap analysis algorithm from `${CLAUDE_PLUGIN_ROOT}/skills/initialize/engine.md`
(the "Gap Analysis Engine" section).
The deterministic scoring and action helpers behind that algorithm now live in the
checked-in TypeScript initialize engine; keep this conversational flow aligned with
that executable logic.

---

## 5a: Load Configuration

If running independently (not immediately after configuration), load the existing
configuration:

```
Read docs/alexandria/alexandria-config.json from the target project.
Extract: mode, novelty, complexity, and the areas array with tier assignments.
```

If the file doesn't exist, tell the user to run the initialize configuration first.

---

## 5b: Knowledge Declaration

For each area in the pool, collect the team's current knowledge state. Present areas
grouped by domain to reduce context switching.

**Pre-population from discovery:** Before presenting areas, check if
`alexandria-config.json` contains a `discovery` section (written by the scanner path). If
it does:
- Pre-populate area 2.3 (Product Entities) as "present" / "fresh" if
  `confirmed_entities` is non-empty
- Pre-populate area 2.2 (Noun Vocabulary) as "partial" / "fresh" if confirmed entities
  include annotations
- Show the user which areas were pre-populated and let them adjust:
  > "Based on your codebase scan, I've pre-populated these areas: [list]. Adjust if
  > needed."
- All other areas remain undeclared and follow the normal collection flow below

**For each domain** (Vision & Strategy, Architecture & Nouns, Experience & Feel,
Visual & Interaction, Decision History):

> **[Domain Name]** — [N] areas in your pool:
>
> | # | Area | What Goes Wrong Without It | Your Status |
> |---|------|---------------------------|-------------|
> | [id] | [name] | [when_missing text from initialize-engine.yaml catalog] | ? |
>
> For each area, what's your current state?
> - **Absent** — no documentation exists
> - **Partial** — some documentation but with significant gaps
> - **Robust** — documentation exists and adequately covers the area
>
> (Your answer is recorded as "absent", "partial", or "present" in the configuration
> data.)
>
> The "What Goes Wrong Without It" column shows real symptoms. If those problems
> sound familiar, your documentation for that area may not be as complete as you think.
>
> For Robust or Partial areas, how current is it?
> - **Fresh** — reflects current product state
> - **Stale** — exists but outdated
> - **Unknown** — not sure if it's current
>
> You can also say **"all absent"** or **"all robust + fresh"** for the whole domain.

**Defaults:** Any undeclared area is treated as Absent / Unknown.

Collect optional free-text notes if the user provides them.

---

## 5c: Score and Sequence

Apply the gap scoring and sequencing algorithms from the engine:

1. Score each area using `priority_score = tier_weight x gap_severity` (or
   `tier_weight x freshness_penalty` for present items)
2. Assign actions: create / update / refresh / none
3. Sort by priority score descending, then tier rank, then catalog order
4. Group into phases: Foundation Gaps -> Core Gaps -> Amplifier Gaps ->
   Deprioritized Gaps -> Already Covered

See `${CLAUDE_PLUGIN_ROOT}/skills/initialize/engine.md` for the complete algorithm and
edge cases.

---

## Confirmation Check

Before proceeding to gap analysis, present a confirmation check after engine results:

> **Does this ring true?** Look at the Foundation areas above — these are the ones
> your library needs most. Think about whether your team has experienced the kinds of
> problems that come from missing this knowledge. For example, if Product Vision is
> Foundation, has your team ever had builders filling the vacuum with their own
> assumptions? If the Foundation areas match real problems you've seen, the
> configuration is well-calibrated. If they seem irrelevant to your experience,
> say **"reconfigure"** to adjust your answers.

If the user says "reconfigure," return to configuration questions with their Q1
answer preserved (since AI Mode is the least likely to be wrong) and re-ask Q2 and
Q3.

If the user confirms or says anything other than "reconfigure," proceed to ask about
gap analysis as normal.

For the restored first-session `/ax-library` ritual, do **not** ask whether to run
gap analysis. Once the human confirms the engine result, gap analysis is the next
required beat.

If this flow is being used outside the first-session ritual as a standalone
follow-up, it is still acceptable to ask whether the human wants to run it.
