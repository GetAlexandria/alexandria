---
name: ax-complete-plan
description: >
  Close out an executed implementation plan. Reviews an existing release doc plus
  outcomes and tickets, determines what shipped versus what was deferred, captures
  decisions made during execution, and updates release.md with completion status and
  retrospective learnings.
  Use after a plan has been executed and needs a durable close-out artifact.
requires:
  adherence: high
  reasoning: medium
  precision: high
  volume: medium
---

# Complete Plan

Close out an existing implementation plan by updating its `release.md` in place.

This skill finishes the planning lifecycle:

1. `/ax-plan` creates the plan
2. implementation happens
3. `/ax-complete-plan` records what actually happened

**IMPORTANT: This skill updates PLANNING ARTIFACTS. It does not write implementation
code, create new tickets, or mutate library cards directly. Surgery plans are transient
execution handoffs, so this skill must not create or preserve `surgery-plan.md` as part
of the durable plan bundle.**

## When To Use

Use this skill when:

- a plan has finished execution and needs a close-out record
- the user wants to capture what shipped and what did not
- the user wants a retrospective attached to the original plan
- future planning should be able to scan prior deferred scope

Do not use this skill to create a new plan. Use `/ax-plan` for that.

## Output Contract

The canonical artifact is the existing release doc:

`docs/alexandria/implementation-plans/<plan-name>/release.md`

Update that file in place. Do **not** create a second summary file like
`closeout.md`, `retrospective.md`, or `release-final.md` unless the user explicitly
asks for one.

Preserve the original planning context where it is still useful:

- goal
- scope
- success outcomes
- decisions made during planning
- risks / assumptions
- ticket index
- library updates reference

Layer the close-out information on top of that plan.

## Workflow

### Step 1: Resolve the target plan

Identify which implementation plan is being closed.

If the user gave a direct path, use it. Otherwise:

1. look for `docs/alexandria/implementation-plans/*/release.md`
2. if exactly one plausible plan exists, use it
3. if multiple plans exist, ask the user which one to close out

Do not guess when several plans are plausible.

### Step 2: Read the plan bundle

Read at minimum:

1. `release.md`
2. `outcomes/*.md`
3. `tickets/*.md`

Read `library-updates.md` only if it helps interpret the plan or deferred work. Do **not**
expect or create `surgery-plan.md`; that handoff is transient and not part of the durable
close-out artifact set.

If the user provides execution notes, PR notes, release notes, or manual status
updates, use them as execution evidence. The release doc tells you what was planned;
the execution notes tell you what actually happened.

### Step 3: Build the execution picture

Determine:

1. which tickets shipped
2. which tickets did not ship
3. which outcomes were fully met, partially met, or not met
4. what decisions were made during execution that were **not** already planning-time decisions
5. what the execution taught the team

Do not invent status. If execution state is ambiguous, ask concise follow-up questions.

Good follow-ups:

- "Which ticket IDs actually shipped?"
- "Did any Must outcomes miss the release?"
- "What important implementation-time decisions emerged that were not made during planning?"
- "What should future plans learn from this execution?"

### Step 4: Classify shipped vs deferred scope

Use these rules:

1. **Shipped** means the ticket or outcome actually landed in the executed slice.
2. **Deferred** means it was planned but intentionally left for later.
3. Unshipped **Should/Could** items belong in `## Deferred`.
4. If a **Must** item did not ship, do not hide it in Deferred alone. Call it out in
   `## Completion Status` and in the retrospective as a miss or partial completion.

The Deferred section should help the *next* `/ax-plan` run pick up
useful leftovers. Phrase items so they can be reused without rereading the whole
transcript.

### Step 5: Capture execution-only decisions

`## Decisions Made During Execution` is for decisions that emerged while building,
testing, sequencing, or shipping.

Include:

- what changed from the plan
- what actually happened
- why the team chose that path

Do **not** duplicate decisions already recorded in the planning section unless the
execution invalidated or refined them.

### Step 6: Write the retrospective

Keep the retrospective lightweight and useful.

Include:

1. **Planned vs actual** — what changed in scope, order, sizing, timing, or execution
2. **What was learned** — lessons future plans should absorb

Focus on operational learning, not narration.

Good retrospective observations:

- dependency order failed in practice even though the plan was sound
- a planned enabler turned out unnecessary
- a thin vertical slice shipped faster than expected
- a shared implementation pattern emerged during execution and should be planned for next time

### Step 7: Update `release.md`

Once you have enough execution context, update `release.md` in place.

At minimum, ensure the file has these close-out sections:

1. `## Completion Status`
2. `## Decisions Made During Execution`
3. `## Retrospective`
4. `## Deferred`

Expected close-out details:

- frontmatter `status:` updated from planning to `complete` or `partial`
- `completed:` date filled when known
- concise shipped summary with ticket/outcome evidence
- explicit note when nothing was deferred
- explicit note when Must scope missed

Use this frontmatter shape when present:

```yaml
---
plan: <plan-name>
status: complete | partial
version: <preserve existing value if present>
started: <preserve existing value if present>
completed: YYYY-MM-DD | ~
tickets: <count>
outcomes: <count>
---
```

### Step 8: Finish with the file, not a chat summary

Do not stop after describing what should be written.

If you have enough information, your next action must be updating `release.md`.
The skill fails if it only talks about close-out without actually producing the
updated artifact.

## Writing Guidance

- Keep the original plan readable; this is a close-out, not a rewrite from scratch.
- Prefer concrete ticket IDs and outcome IDs when describing shipped or deferred work.
- Keep retrospective language reusable across products; avoid repo-specific jargon unless
  the plan itself is repo-specific.
- Preserve generic product applicability. Do not inject Alexandria-only taxonomy into a
  downstream user's plan.

## Anti-Patterns

1. Creating a new summary file instead of updating `release.md`
2. Repeating planning-time decisions under execution decisions
3. Listing unshipped Should/Could work nowhere, leaving Deferred as a placeholder
4. Marking a plan `complete` when Must outcomes actually missed
5. Writing code or new tickets instead of closing the plan artifact
6. Creating or preserving `surgery-plan.md` as if it were a durable implementation-plan artifact
