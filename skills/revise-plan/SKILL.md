---
name: revise-plan
description: >
  Revise an existing implementation plan when re-planning triggers fire. Reviews the
  release doc plus affected outcomes and tickets, incorporates completed enabler
  findings or milestone learnings, identifies remaining tickets that need revision,
  and updates the plan artifacts in place.
  Use mid-flight when new evidence changes the execution plan.
requires:
  adherence: high
  reasoning: high
  precision: high
  volume: medium
---

# Revise Plan

Revise an existing implementation plan in place after new execution evidence changes
the remaining work.

This skill is the mid-flight companion in the planning lifecycle:

1. `/implementation-planning` creates the plan
2. implementation produces enabler findings or milestone evidence
3. `/revise-plan` updates the plan when those findings change what should happen next
4. `/complete-plan` records what actually shipped

**IMPORTANT: This skill updates PLANNING ARTIFACTS. It does not write implementation
code, sync tracker state, or mutate library cards directly.**

## When To Use

Use this skill when:

- a re-planning trigger in `release.md` has fired
- a spike or prototype has completed and resolved a previously deferred decision
- milestone learnings invalidate assumptions behind remaining tickets
- the user wants the existing plan updated before execution continues

Do not use this skill to create a new plan. Use `/implementation-planning` for that.
Do not use it to close out finished work. Use `/complete-plan` for that.

## Output Contract

The canonical artifacts are the existing plan files:

- `docs/alexandria/implementation-plans/<plan-name>/release.md`
- `docs/alexandria/implementation-plans/<plan-name>/tickets/*.md`
- `docs/alexandria/implementation-plans/<plan-name>/outcomes/*.md` when an outcome itself changes

Update the existing files in place. Do **not** create a second artifact like
`revised-plan.md`, `replan.md`, `notes.md`, or `decision-log.md` unless the user
explicitly asks for one.

Preserve the original planning context where it still matters:

- goal
- scope
- original planning decisions
- success outcomes that still stand
- ticket traceability
- library-updates reference

The source of truth rule still applies: if a ticket changes, update the ticket file
first and then refresh the release doc snapshot so the bundle stays consistent.

## Workflow

### Step 1: Resolve the target plan

Identify which implementation plan should be revised.

If the user gave a direct path, use it. Otherwise:

1. look for `docs/alexandria/implementation-plans/*/release.md`
2. if exactly one plausible plan exists, use it
3. if multiple plans exist, ask the user which one to revise

Do not guess when several plans are plausible.

### Step 2: Read the plan bundle and revision evidence

Read at minimum:

1. `release.md`
2. `outcomes/*.md`
3. `tickets/*.md`

Also read any execution notes, spike findings, milestone results, or user-provided
constraints that explain why the revision is needed.

Focus on:

- `## Re-planning Triggers`
- planning-time decisions that were deferred to enablers
- risks and assumptions now proven true or false
- which tickets are blocked by the newly resolved learning

### Step 3: Determine what actually changed

Build the revision picture:

1. which trigger fired
2. what evidence is now known
3. which planning assumption or open decision is now resolved
4. which remaining tickets and outcomes are affected
5. whether any existing ticket should be revised, split, deferred, replaced, or added

Do not revise shipped work just because it appears in the plan. Focus on remaining
work, unless the completed enabler itself needs a brief note for context.

If the evidence is too ambiguous to revise responsibly, ask concise follow-up
questions instead of inventing facts.

### Step 4: Choose the smallest honest revision

Prefer surgical updates over rewriting the whole plan.

Use these defaults:

1. revise an existing ticket when the goal is the same but the approach changed
2. split a ticket when one deferred decision created two clearly different work items
3. add a new ticket only when required work is genuinely missing from the current plan
4. defer remaining work when the new evidence shows it should move out of the current slice
5. update outcomes only when the observable result changed, not just the implementation path

When the revision changes dependency order, keep `blocked-by` and `blocks` honest.
Completed enablers should no longer remain as future blockers once their findings are
absorbed into the revised plan.

### Step 5: Update source-of-truth plan files

Update every affected ticket or outcome file in place.

For ticket revisions, update whatever changed:

- frontmatter fields such as `blocked-by`, `blocks`, `tier`, `outcome`, or `cards`
- title, motivation, description, and acceptance criteria

Keep ticket text grounded in the newly learned evidence. Do not leave stale wording
from the superseded approach.

### Step 6: Update `release.md`

Once the source-of-truth files are updated, refresh `release.md` so the snapshot matches.

At minimum, make sure `release.md` reflects:

1. which trigger fired and what was learned
2. `## Decisions Made During Revision`
3. updated risks / assumptions when the new evidence changed them
4. updated execution phases if dependency order changed
5. updated `## Re-planning Triggers` for the remaining work
6. updated `## Ticket Index`

If the revision adds or removes work, make that explicit in the release doc. If the
evidence confirms the current plan still stands, document that decision instead of
silently changing nothing.

### Step 7: Finish with files, not a chat summary

Do not stop after describing what should change.

If you have enough information, your next action must be updating the affected plan
files. The skill fails if it only talks about revision without actually producing the
revised artifacts.

## Writing Guidance

- Use concrete ticket and outcome IDs when describing what changed.
- Keep the revision language reusable across products; avoid Alexandria-specific jargon.
- Preserve the original goal and scope unless the new evidence truly changes them.
- Prefer concise revision notes that explain the delta rather than rewriting every
  unchanged section.

## Anti-Patterns

1. Creating `replan.md` instead of updating the existing plan files
2. Editing only `release.md` while leaving stale ticket files untouched
3. Treating the release doc as the source of truth over outcomes and tickets
4. Rewriting the whole plan when only a few remaining tickets changed
5. Closing out shipped work instead of revising the unfinished plan
