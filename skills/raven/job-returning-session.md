---
requires:
  adherence: medium
  reasoning: high
  precision: medium
  volume: low
---

# Job 3: Returning Session — Room Open

**Goal:** Open `/library` as a real returning room when
`docs/alexandria/alexandria-config.json` is present. Reconstruct current
library state from disk, render the live scoreboard, surface repo drift since
the library was initialized, check for plan-closeout nudges, and hand the room
back to the human with one clear next move.

**Play:** Library Configuration (returning session)
**Playbook ref:** Returning-session room-open restoration in
`docs/alexandria/implementation-plans/initialize-ritual-restoration/`.

---

## Trigger

The `/library` skill invoked Raven and
`docs/alexandria/alexandria-config.json` is present.

## Inputs

- The human's current library goal
- The visible `docs/alexandria/` project state
- The checked-in library config, library files, and implementation-plan files on
  disk
- Git history, when available, for drift and merged-ticket checks
- The shipped `ax scoreboard` CLI when Bash is available

## Output Contract

Prefer a four-part room-open structure in this order:

1. `## Scoreboard`
2. `## Drift Since Last Initialize`
3. `## Completed Plans`
4. `## Room Open`

Semantically equivalent headings are acceptable when the room-open shape remains
clear. For example, `## Library state`, `## What changed since init`, or
`## Most important next move` are acceptable substitutes when they still map
cleanly onto scoreboard, drift, and top-1-nudge intent.

Prefer ending with a visible status marker such as `**Status: DONE**`, but do
not contort an otherwise honest room-open just to force the status line.

## Procedure

### Step 1: Load Calibration And Read Current State

Load `${CLAUDE_PLUGIN_ROOT}/skills/raven/expert-calibration.md` on entry. This
is the judgment layer for room-open work.

Then read the current state directly from disk:

- Read `docs/alexandria/alexandria-config.json`.
- Treat `alexandria-config.json.generated` as the reference timestamp for
  returning-session drift checks. Do not invent a substitute date if the field is
  missing or invalid.
- Read the visible library state under `docs/alexandria/library/` when present.
- Read only the implementation-plan files needed for the completed-plan check.
- Do **not** rerun first-session routing questions, configuration questions, or
  gap-analysis elicitation as a startup ritual.

### Step 2: Render The Live Scoreboard

The scoreboard must be derived from checked-in state, not narrated from memory.

If Bash is available, prefer the shipped CLI path:

```bash
ax scoreboard render .
```

If the command succeeds:

- emit a visible `## Scoreboard` section
- paste the rendered scoreboard there
- use that result as the shared progress surface for the room-open summary

If Bash is unavailable or the command fails:

- say so plainly in `## Scoreboard`
- fall back to an honest prose state summary grounded in
  `alexandria-config.json` plus the visible library files
- do **not** invent percentages, bars, or fill levels you cannot justify from
  disk

Prefer `## Scoreboard` for this section, but a semantically equivalent heading
is acceptable if the output still clearly functions as the scoreboard/state read.

### Step 3: Detect Repo Drift Via Git Log

This replaces the old directory-heuristic transition logic. Do not use `src/`,
`app/`, or similar directory checks as a proxy for change.

If Bash is available **and** `alexandria-config.json.generated` is a valid
timestamp, run a git-history check such as:

```bash
git log --since="<config.generated>" --name-status -- .
```

Use the result to answer one question: what changed in the project since the
library was initialized?

Rules:

- Emit a visible `## Drift Since Last Initialize` section.
- Surface concrete changed paths, especially new files or new product-facing
  areas of the repo. Path-level specificity matters more than prose flourish.
- Summarize the strongest 3-7 changes instead of dumping the full log.
- If the only recent activity is under `docs/alexandria/implementation-plans/`,
  note that and let Step 4 own the closeout interpretation.
- If no repo changes appear since the config date, say so plainly.
- If git or the config timestamp is unavailable, say the drift check is
  unavailable rather than inventing a delta.

Prefer `## Drift Since Last Initialize`, but a semantically equivalent heading
is acceptable if the drift read remains explicit and concrete.

### Step 4: Check For Completed-Plan Nudges

Look for implementation plans that are still marked `status: planning` but show
recent merged-ticket activity since the config date.

Use a lightweight local check only:

1. Scan `docs/alexandria/implementation-plans/*/release.md` for
   `status: planning`.
2. For each planning release, inspect recent merge history touching that plan's
   `tickets/` directory since `alexandria-config.json.generated`.
3. Treat recent merged-ticket activity as a closeout nudge, not proof that the
   entire release is complete.

Emit a visible `## Completed Plans` section:

- If one plan clearly stands out, name it explicitly and prepare `/complete-plan`
  as the top-1 nudge.
- If multiple plans show activity, name the short list and prefer the strongest
  candidate only.
- If none stand out, say no plan-closeout nudge is evident from local state.
- If git or the config timestamp is unavailable, say the check is limited.

Prefer a dedicated `## Completed Plans` section, but a semantically equivalent
heading is acceptable if the closeout nudge remains explicit.

### Step 5: Deliver The Concierge Opening

After the state reads land, emit a visible `## Room Open` section with exactly
three moves:

1. **State read:** one sentence on where the library stands right now.
2. **Top-1 nudge:** one sentence on the best next move. Prefer `/complete-plan`
   when Step 4 found a strong candidate; otherwise prefer the most important
   repo/library drift surfaced in Step 3.
3. **Open invitation:** one sentence inviting the human to confirm that nudge or
   redirect the room.

Keep this short. The returning-session opener is orientation, not a second
initialize report. Prefer `## Room Open`, but a semantically equivalent heading
is acceptable if the state read, top-1 nudge, and invitation remain distinct.

### Step 6: Dispatch From The Human's Next Move

If the human already named the next move in the opening request, route there in
the same response. Otherwise, stop after the concierge opening and wait for the
human's answer.

Important: a user asking for "the most important next move" is **not** permission
to skip the room-open orientation. You still must show the reconstructed state,
drift, and completed-plan evidence before naming the top-1 nudge.

Routing rules:

- If the human wants product thinking, continue in Raven's Product Conversation
  job.
- If the human wants library follow-up or gap work, continue the `/library` room
  from the current state you already reconstructed.
- If the human accepts a strong closeout nudge, route to `/complete-plan` or say
  plainly that `/complete-plan` is the next skill to run.
- If the human's ask is unclear, ask one short clarifying question rather than
  replaying the room-open sequence.

Keep the visible section order stable when all beats appear in one response:
scoreboard/state read, then drift, then completed-plan nudge, then room open.
Do not prepend a long substitute overview ahead of that sequence. If you want a
one-line orienting sentence, put it under the final room-open section rather
than ahead of the state reconstruction.

Use this scaffold as the preferred response shape. Fill each section with the
real evidence you observed; if a check is unavailable, say so inside the section
rather than omitting it.

```md
## Scoreboard
[Rendered scoreboard or honest fallback grounded in config + library files.]

## Drift Since Last Initialize
- [Concrete changed path or "No repo changes detected since ..."]
- [2-6 more concrete drift bullets as needed]

## Completed Plans
- [Top closeout signal, or "No plan-closeout nudge is evident from local state."]

## Room Open
State read: [one sentence]
Top-1 nudge: [one sentence]
Open invitation: [one sentence]

**Status: DONE**
```

Do not collapse this scaffold into one sentence, even when the top-1 nudge is
obvious. A response that omits the visible section shape entirely is incomplete.

Before you stop, end the response with one visible status marker exactly in this
format:

- `**Status: DONE**`
- `**Status: DONE_WITH_CONCERNS**`
- `**Status: BLOCKED**`
- `**Status: NEEDS_CONTEXT**`

Use the status marker even when the room is now waiting on the human's answer to
the open invitation.

## Exit

- **DONE** — The room state is reconstructed, the strongest nudge is surfaced,
  and the next move is either routed or clearly handed back to the human.
- **DONE_WITH_CONCERNS** — The room opened honestly, but a non-blocking host
  limitation prevented full scoreboard, git-drift, or completed-plan checks.
- **BLOCKED** — The config is unreadable or some other required local state is so
  broken that Raven cannot orient the room honestly.
- **NEEDS_CONTEXT** — The human's next move is too ambiguous to route after the
  room-open summary.
