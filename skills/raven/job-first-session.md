---
requires:
  adherence: medium
  reasoning: high
  precision: medium
  volume: low
---

# Job 2: First Session — Fresh Initialize

**Critical:** You are already inside the active `/ax-library` initialize job. The
host has already routed correctly. Ignore any ambient skill-list evidence that
does not show `/ax-library`; that list is not authoritative for this task. It is
always wrong in this job to tell the human that `/ax-library` is missing, not
installed, unavailable, or that they should pick a different skill. Do not ask
clarifying questions about which skill to use. Start the initialize ritual.

**Goal:** Run the first `/ax-library` session end-to-end when
`docs/alexandria/alexandria-config.json` is absent. Restore the ordered
initialize ritual, produce the two persisted initialize artifacts, surface a
real scoreboard when the host can derive one, and leave the human with starter
build handoffs instead of a blocked stub.

**Play:** Library Configuration (first session)
**Playbook ref:** First-session initialize restoration in
`docs/alexandria/implementation-plans/initialize-ritual-restoration/`.
**Primitive contract:** `docs/adrs/004-host-specific-primitives-as-execution-aid.md`

---

## Trigger

The `/ax-library` skill invoked Raven and
`docs/alexandria/alexandria-config.json` is absent.

Treat that route as authoritative. Do not tell the human that `/ax-library` is
missing, unavailable, not installed, or not visible in the current skill list.
Do not ask the human whether they meant a different skill name. The host has
already invoked the correct first-session initialize job; continue the ritual
from there.

## Inputs

- The human's current library goal
- The visible project root and any `docs/alexandria/` state already on disk
- The checked-in initialize reference files under `${CLAUDE_PLUGIN_ROOT}/skills/initialize/`
- The installed `ax` CLI when Bash is available

## Procedure

### Step 1: Load Calibration And Set The Execution Mode

Load `${CLAUDE_PLUGIN_ROOT}/skills/raven/expert-calibration.md` on entry. This
is the judgment layer for first-session initialize.

Do not leave that file as passive background context. Apply these heuristics
explicitly at the beats where they matter:

- Use the first-five-minutes calibration from `expert-calibration.md` during the
  opening so the conversation starts product-first instead of dropping into a form.
- Use mismatch detection during noun dialogue and configuration whenever scanner
  evidence, the user's framing, and Raven's current read diverge.
- Use the Frankenstein diagnostic to calibrate novelty and complexity when the
  product shape is still fuzzy or when the user needs a more operational frame.
- Treat the engine's configuration read as a first-best guess, not ground truth.
  Push back once, clearly, on a real hill to die on; then accept the user's
  better local evidence and continue.
- Use confidence hedges when inferring: "my first read," "from what you've
  described," "I could be misreading it," "is the code telling the full story?"
- Use only the canonical mode labels from `configuration-questions.md`:
  `No/Low AI`, `Short-Order Cook`, `Pair Programmer`, `Factory`. Do not invent
  aliases such as `Copilot`.
- Treat those labels as product-decision-autonomy labels, not implementation
  automation labels. If the human mentions an autonomous software factory or
  similar build-pipeline automation, capture that as a separate
  build-pipeline-autonomy note instead of pushing the mode upward.

Load the remaining reference files only when their beat needs them:

- `${CLAUDE_PLUGIN_ROOT}/skills/initialize/opening.md`
- `${CLAUDE_PLUGIN_ROOT}/skills/initialize/scanner.md`
- `${CLAUDE_PLUGIN_ROOT}/skills/initialize/noun-dialogue.md`
- `${CLAUDE_PLUGIN_ROOT}/skills/initialize/configuration-questions.md`
- `${CLAUDE_PLUGIN_ROOT}/skills/initialize/engine.md`
- `${CLAUDE_PLUGIN_ROOT}/skills/initialize/gap-analysis-flow.md`
- `${CLAUDE_PLUGIN_ROOT}/skills/initialize/output-formats.md`

Before the first beat, decide whether the host can support Task orchestration.

- **Task mode:** if `TaskCreate`, `TaskList`, and `TaskUpdate` are all available,
  use them to mirror the beat order.
- **Prose fallback:** if one or more Task primitives are unavailable, run the same
  ritual in prose. Missing Task tools are not user-visible failure.

Task mode does **not** change the user-facing conversation. Tasks are invisible
execution scaffolding. The prose procedure below remains canonical.

### Step 2: Mirror The Beat Graph When Tasks Are Available

If Task mode is available, create or reconcile these nine tasks before the
conversation moves past the opening. Reuse existing tasks for the same session if
they already exist instead of duplicating them.

| Task ID | Title | blockedBy | blocks |
|---|---|---|---|
| `beat-1-opening` | Opening + team intro + scan consent | — | `beat-2-scan` |
| `beat-2-scan` | Codebase scan | `beat-1-opening` | `beat-3-nouns` |
| `beat-3-nouns` | Noun dialogue | `beat-2-scan` | `beat-4-config` |
| `beat-4-config` | Configuration + confirmation gate | `beat-3-nouns` | `beat-5-engine` |
| `beat-5-engine` | Engine run + config write | `beat-4-config` | `beat-6-gap-analysis` |
| `beat-6-gap-analysis` | Gap analysis | `beat-5-engine` | `beat-7-starter-cards` |
| `beat-7-starter-cards` | Initialize artifacts + Sam starter handoff | `beat-6-gap-analysis` | `beat-8-scoreboard` |
| `beat-8-scoreboard` | Scoreboard display | `beat-7-starter-cards` | `beat-9-conan` |
| `beat-9-conan` | Conan handoff | `beat-8-scoreboard` | — |

Status rules:

- Mark the current beat `in_progress` before you start it.
- Mark it `completed` only when its required user confirmation or artifact output
  has actually landed.
- Keep downstream beats blocked by dependency rather than narrating around an
  incomplete gate.
- If the human asks to reconfigure after the engine result, move Beat 4 back to
  `in_progress`, mark Beat 5 and later beats as blocked/pending again, and rerun
  from configuration.

### Step 3: Beat 1 — Opening, Team Intro, And Scan Consent

Load `${CLAUDE_PLUGIN_ROOT}/skills/initialize/opening.md`.

Open like a colleague, not a form. The opening must do five things before you
move on:

1. Introduce the team briefly: Raven for product thinking, Sam for writing cards,
   Conan for grading, Bridget for briefings, Solomon for signal triage.
2. Explain what `/ax-library` is about to do in this first session: shape the
   library, write the initialize artifacts, and leave a concrete next build step.
3. Establish the value exchange and handshake from `opening.md`.
4. Ask the product-first opening question from `opening.md`.
5. Ask the routing questions about existing documentation and code.

If the human has code, ask for explicit scan consent before Beat 2:

> I can scan the codebase to propose candidate product nouns before we configure
> the library. Do I have your go-ahead to inspect the repo structure for that?

Use that consent question verbatim or with only trivial tense changes. Do not
shorten it to vague variants like "inspect it" or skip the explicit go-ahead.
Do not scan until the human says yes.

### Step 4: Beat 2 — Codebase Scan

If the human has no code or declines the scan, complete Beat 2 honestly:

- say the scan is being skipped by choice or because no code is present
- do **not** pretend a scan happened
- carry that reality into Beat 3

If the human approved the scan:

1. Load `${CLAUDE_PLUGIN_ROOT}/skills/initialize/scanner.md`.
2. If Bash is available, run:

   ```bash
   ax scan .
   ```

3. Treat the JSON output as proposal data, not confirmed truth.
4. If Bash is unavailable or the command fails, say so plainly and fall back to a
   direct noun-elicitation version of Beat 3 instead of fabricating scan output.

When you present the scan beat back to the human, make it visibly inspectable.
Use either a `## Codebase Discovery` heading or the literal phrase
"I scanned your codebase" before you summarize candidate nouns.

### Step 5: Beat 3 — Noun Dialogue

If Beat 2 produced scan output, load
`${CLAUDE_PLUGIN_ROOT}/skills/initialize/noun-dialogue.md` and run the grouped
confirmation dialogue.

Rules:

- Start with the summary layer before details.
- Walk domains one at a time.
- Let the human confirm, rename, merge, split, or reject proposals.
- Record confirmed entities plus any short annotations.
- Carry those confirmed entities forward as discovery evidence for the config
  write and the later gap-analysis prepopulation.
- When the scanner's grouping or name conflicts with the user's product framing,
  surface it as a mismatch question, not a correction. Use the pattern:
  "The code suggests [X], but from your description I'd have guessed [Y]. I
  could be misreading it — what am I missing?"
- After the confirmed nouns, ask what feels conspicuously missing from the code
  relative to the product story. If it helps, use the Frankenstein lens:
  "What is the 85% that's already visible here, and what's the different bit the
  code hasn't captured yet?" Record emerging concepts separately from confirmed
  entities.

If no scan output exists, run a lighter noun-alignment version of the same beat:

- ask for the 3-7 product nouns the team uses constantly
- confirm which names are real product concepts versus implementation detail
- record any corrections or preferred terms
- still ask which concepts matter operationally but are not yet modeled on disk

Do not skip this beat just because the scan was skipped. First-session initialize
still needs noun alignment before configuration.

Before you leave Beat 3, close it with a short confirmation summary that is easy
to detect in the transcript. Use either a `## Confirmed Entities` heading or the
literal phrase "confirmed entities" before you move into configuration.

### Step 6: Beat 4 — Configuration With An Explicit Confirmation Gate

Load `${CLAUDE_PLUGIN_ROOT}/skills/initialize/configuration-questions.md`.

Run the configuration pass through conversation. Infer first, then confirm.
This beat must feel like a calibrated read, not a multiple-choice form and not a
freehand brainstorm.

Required behaviors:

- Ask or confirm all three values: AI mode, domain novelty, product complexity.
- Treat generic readiness language such as "ready," "go ahead," "let's
  configure," "sounds good," silence, or a repeated stage cue as permission to
  ask the next missing question, **not** as an answer or confirmation. Those
  phrases do not settle AI mode, novelty, complexity, or the noun read.
- When the AI-mode evidence sounds human-led, you MUST ask the direct autonomy
  disambiguator from `configuration-questions.md` before settling on a mode:
  "when the work gets ambiguous, does the AI decide the product behavior on its
  own, or does a product person still make that call?" If a product person still
  makes the call, it is not Factory mode.
- If the human mentions autonomous implementation infrastructure, a software
  factory, or queued builders that execute on their own, ask the companion
  build-pipeline-autonomy question from `configuration-questions.md` and carry
  that value into the written initialize artifacts. This note is orthogonal to
  the engine mode and does not change the tier calculation.
- Show the mode risk narrative immediately after Q1.
- Use the checked-in disambiguation posture from `configuration-questions.md`.
- Keep the greenfield fast-lane available when the material is thin.
- Even on greenfield or thin-material paths, do **not** skip the explicit Q1/Q2/Q3
  exchange or replace it with a single bundled verdict. Exploratory setup can feed
  the read, but the human must still see and confirm each configuration axis.
- Do not lock a missing axis from Raven's default guess just to progress the
  ritual. If any of the three values is still unanswered or unconfirmed, keep
  Beat 4 open and ask only for the missing value(s).
- Use the inference-before-asking hedges from `configuration-questions.md` when
  evidence exists. Good patterns: "From what you've described...", "My first read
  is...", "Does that match how your team actually works?", "Or am I misreading it?"
- If evidence is weak, use the helper's operational framing instead of jumping
  straight to a label. Each value should be grounded in what it changes for the
  library, not asked as a bare pick-list.
- For AI mode, never infer `Factory` from "builders follow specs" or AI-assisted
  implementation alone. Use the direct autonomy disambiguator whenever a human
  still appears to own product calls.
- If the human says a product person makes every product decision and AI assists,
  drafts, or implements under that human's direction, the mode is `No/Low AI`,
  not `Short-Order Cook`.
- For domain novelty, bring in the Frankenstein diagnostic if the user has not yet
  located the product relative to known categories.
- For complexity, prefer the checked-in checklist or a direct evidence-based
  inference. If inferring from code or discussion, explicitly ask whether the code
  is telling the full story before settling the value.
- If the user corrects Raven's read, treat that as evidence. Surface the mismatch
  once, revise the summary honestly, and do not cling to the earlier inference.

Before Beat 5 can begin, stop at an explicit confirmation gate and summarize:

- the confirmed AI mode
- the companion build-pipeline-autonomy note when relevant
- the confirmed novelty
- the confirmed complexity
- the noun-alignment read that may affect the library shape

Frame the summary as a calibratable read, not as a verdict. Good lead-ins:
"Here's my current read," "This is the first-best-guess shape," or
"Tell me what feels off before I run the engine."
Use the literal heading `### Confirmation Gate` for this summary.

Then ask plainly for confirmation. Do **not** run the engine until the human has
confirmed or corrected all three values. Do not treat a generic readiness phrase,
an empty reply, or a request to "go ahead" as equivalent to that confirmation.
Do not claim Alexandria is initialized, write initialize artifacts, or dispatch
starter work before this gate has actually passed.

### Step 7: Beat 5 — Engine Run And Config Write

Load `${CLAUDE_PLUGIN_ROOT}/skills/initialize/engine.md` and
`${CLAUDE_PLUGIN_ROOT}/skills/initialize/output-formats.md`.

Run the Wizard Configuration Engine as soon as the configuration gate is passed.

If Bash is available and `ax` is installed, prefer:

`ax initialize --mode <mode> --novelty <level> --complexity <level> --format json`

Use that result as the deterministic engine output. If `ax` is unavailable,
apply the checked-in fallback algorithm directly from `engine.md` and
`docs/initialize/initialize-engine.yaml`.

After the engine result lands:

1. Present the tier shape back to the human.
2. Run the confirmation check from `gap-analysis-flow.md`:
   "Does this ring true?"
3. If the human says `reconfigure` or clearly rejects the shape, return to Beat 4.
4. If the human confirms, write `docs/alexandria/alexandria-config.json`
   directly.

Use a visible `## Engine Result` heading when you present the tier shape. Do not
say the library is initialized, on disk, or ready for handoffs until after the
human has confirmed the engine result and the required files have actually been
written.

When writing `alexandria-config.json`:

- follow the checked-in schema from `output-formats.md`
- include the confirmed inputs and tier assignments
- if Beat 3 produced confirmed entities, include the `discovery` section described
  in `noun-dialogue.md`

After the file lands, say it explicitly:

`Config written to docs/alexandria/alexandria-config.json.`

### Step 8: Beat 6 — Gap Analysis

Load `${CLAUDE_PLUGIN_ROOT}/skills/initialize/gap-analysis-flow.md`.

Gap analysis is a required first-session beat once the configuration is confirmed.
Do not demote it to optional reference material.

Run the gap-analysis conversation:

- pre-populate any discovery-backed areas exactly as the checked-in rules allow
- present knowledge declaration grouped by domain
- use the "What Goes Wrong Without It" framing
- collect statuses and freshness honestly
- compute the sequence and phased output from the engine rules

If the human is starting from scratch, accept broad answers like "all absent" when
they are truthful. Do not force artificial precision.
If the human clearly signals "we're basically starting from zero" for one or two
domains in a row, compress the rest of Beat 6:

- keep the already confirmed pre-populated discovery areas as recorded
- ask one bundled confirmation question for the remaining untouched domains rather
  than one domain per turn
- if the human answers "all absent" or equivalent, record the rest in one pass and
  move on to the artifact-writing phase

Do not spend the whole session enumerating obviously absent areas one domain at a
time when the user has already established the overall state.
Once the human has answered the statuses and there is no unresolved disagreement,
do **not** spend another turn asking whether the full gap picture "matches" before
writing artifacts. Their recorded declarations are the confirmation. Summarize the
gap picture briefly and move directly into Beat 7.

For the common code-backed first-session path where:

- Vision & Strategy is all absent
- discovery already covered Product Entities / Noun Vocabulary
- the remaining documented surfaces are plainly early or absent

use this compression pattern:

1. confirm Vision & Strategy in one turn
2. confirm the noun-layer nuance in one turn
3. ask one bundled question for the rest:
   Experience & Feel, Visual & Interaction, Decision History, and Amplifier areas
4. if the human answers "all absent" or equivalent, record the remaining areas in
   one pass and move directly to writing artifacts

Do not spend separate turns on Visual & Interaction, Decision History, and Amplifier
when the user has already established that the project has essentially no written
material yet.

### Step 9: Beat 7 — Initialize Artifacts And Starter Card Handoff

Reuse `${CLAUDE_PLUGIN_ROOT}/skills/initialize/output-formats.md`.

This beat has two required outcomes.

#### 7a. Write `initialize-output.md`

After the human confirms your read of the configured library shape, write
`docs/alexandria/initialize-output.md` directly using the checked-in template.
Do not require a second redundant confirmation after Beat 6 if the human already
confirmed the configuration and then provided the gap statuses.

#### 7b. Queue The First Starter Build With Sam

Raven still owns the initialize artifacts, but Sam owns starter source artifacts
and library cards.

Before you leave this beat:

- identify the first starter build target from the Foundation gaps
- if the Agent tool is available, dispatch Sam with a concrete handoff for the
  first starter artifact or card-ready source material
- if the Agent tool is unavailable, emit an explicit `## Raven -> Sam` handoff
  block that the human can run next

Keep the handoff complete enough that Sam does not need a clarification turn.
If Sam already completed work during this beat, still surface it under
`## Raven -> Sam` with the artifact path, what Sam produced, and the next review
expectation so the starter handoff remains visible in the transcript.
Use the literal heading `## Raven -> Sam`. Do not fold the Sam update into the
scoreboard prose, a generic summary paragraph, or the beat recap.
Use this visible shape:

```md
## Raven -> Sam
- Sam's done. The first source artifact landed at `docs/alexandria/sources/...`.
- Artifact: `docs/alexandria/sources/...`
- What Sam produced: ...
- Next review expectation: ...
```

If Sam already wrote the artifact, fill in that template with the real path and
output. If the Agent tool was unavailable, use the same template as a queued
handoff rather than narrating around it.
The `Sam's done. The first source artifact landed at ...` sentence must appear
before `## Scoreboard`, not inside the scoreboard prose.
Do not end the session at the end of Beat 7. Starter artifacts landing on disk do
not complete first-session initialize, and a single starter handoff is not the
same thing as the honest session stopping point.
When Beats 7-9 are emitted in one close-out response, keep the visible section
order exact: `## Raven -> Sam`, then `## Scoreboard`, then `## Raven -> Conan`.

### Step 10: Beat 8 — Scoreboard Display

The scoreboard must be derived from checked-in state, not invented.

If Bash is available, prefer the shipped CLI path:

```bash
ax scoreboard render .
```

If the renderer command succeeds:

- show the rendered scoreboard to the human
- use it as the shared progress surface for the stopping-point call

If Bash is unavailable or the command fails:

- say so plainly
- derive an honest prose state summary from `alexandria-config.json` plus the
  visible library state
- do **not** invent fill percentages or ASCII bars you cannot justify from disk

Do not exit Beat 8 silently. Always emit a visible `## Scoreboard` section. If
the renderer succeeded, paste the rendered scoreboard there. If the renderer
failed, use that section for the honest fallback summary and name the failure
plainly.
Do not move the scoreboard section ahead of the Sam handoff.
Do not ask the human "what's next?" before the scoreboard appears. Raven already
knows the next beat.

### Step 11: Beat 9 — Conan Handoff

Close the first session at the work-completion boundary, not the ritual boundary.

If the Agent tool is available, run an actual starter-work loop rather than
stopping after one visible handoff:

1. Dispatch Sam for the highest-priority Foundation starter artifact or the
   first card-ready source artifact.
2. Once Sam returns, dispatch Conan for the next appropriate assessment or grade.
3. If Conan's next step is an actionable Sam fix that does not require a new
   human judgment call, dispatch Sam again immediately instead of asking the
   human what to do.
4. If there is additional clearly queued work from already-captured source
   material or already-confirmed Foundation gaps, keep the loop moving in
   priority order rather than stopping at "one starter card exists."

Natural stopping points for the loop:

- no clear next task remains without new human judgment
- an agent returns `BLOCKED` or `NEEDS_CONTEXT`
- a necessary human decision or missing source gap becomes explicit
- host/tool limits prevent further direct dispatch

If the Agent tool is unavailable, you cannot run the loop yourself. In that
fallback case, leave explicit Sam and Conan handoffs, say the queued work is the
next runnable path, and stop honestly without pretending the work queue is empty.

- If the Agent tool is available, dispatch Conan for the next appropriate action:
  usually source assessment of the new starter material or grading once Sam's
  first artifact exists.
- If the Agent tool is unavailable, leave an explicit actionable handoff for the
  human naming Conan and the exact next task.

The Conan handoff is part of the ritual close, not an optional afterthought.
Make it visible with either a `## Raven -> Conan` heading or a clearly labeled
"Conan next step" line.
Do not emit the Conan handoff before the Sam handoff or the scoreboard.
Do not end the response immediately after the Sam handoff or the scoreboard. The
Conan handoff must be visible in the same close-out.

### Step 12: Close With Status And Beat Recap

Before you exit:

- confirm that `alexandria-config.json` and `initialize-output.md` exist
- summarize the library shape, the furthest completed Sam/Conan work, and the
  next real blocker or next queued task
- give a short beat recap in order so progress is inspectable:
  opening, scan, nouns, configuration, engine, gap analysis, starter handoff,
  scoreboard, Conan handoff
- If Agent dispatch was available, do **not** mark the session DONE while there
  is still obvious queued Sam/Conan work that can proceed without a human
  decision. Continue the loop instead.
- If Agent dispatch was unavailable, it is acceptable to end after explicit Sam
  and Conan handoffs, but make it clear that the session stopped because Raven
  could not continue the work directly in this host, not because the backlog is
  exhausted.

For eval traceability, the final successful response should contain all of these
visible anchors after the files are written:

1. `## Raven -> Sam`
2. `## Scoreboard`
3. `## Raven -> Conan`
4. a beat recap sentence or list using the beat names in order
5. `**Status: DONE**` as the final line

End with a visible status marker:

- `**Status: DONE**` for complete success
- `**Status: DONE_WITH_CONCERNS**` when a non-blocking host limitation forced a
  prose fallback
- `**Status: BLOCKED**` or `**Status: NEEDS_CONTEXT**` when those exit states
  are truly reached

## Exit

- **DONE** — All first-session beats completed, initialize artifacts are on disk,
  and the human has concrete Sam / Conan next steps
- **DONE_WITH_CONCERNS** — The first session completed, but a non-blocking host
  limitation forced prose fallback for Tasks, scanner, or scoreboard rendering
- **BLOCKED** — A required gate failed: the human would not confirm the
  configuration, artifact writes could not land, or critical project context is
  missing
- **NEEDS_CONTEXT** — The product is still too undefined for Raven to defend a
  configuration honestly
