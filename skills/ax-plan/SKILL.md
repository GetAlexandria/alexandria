---
name: ax-plan
description: >
  Create an implementation plan for a product goal. Takes a goal, gathers context
  from the context library, proposes success outcomes with scope tiers, and produces
  dependency-ordered tickets as markdown files.
  Use when asked to "plan a feature", "break down into tickets", "create an
  implementation plan", or "plan the release".
  Proactively suggest when a user describes a large feature they want to build.
requires:
  adherence: medium
  reasoning: medium
  precision: medium
  volume: high
---

# Implementation Planning

Create an implementation plan for a product goal. The plan starts from the context
library (what the product IS today), identifies the gap to the goal (what the user
WANTS), and produces dependency-ordered tickets organized by success outcomes.

**IMPORTANT: This skill produces PLANNING ARTIFACTS (markdown ticket files, outcome
files, and a release doc). It does NOT write implementation code. The output is a
plan that an implementer will follow, not the implementation itself.**

## When to Use

Use this skill when:
- Planning a new feature or capability
- Breaking down a large goal into implementation tickets
- Creating a release plan with dependency ordering
- Asked to "plan", "break down", or "create tickets for" a product goal

## How It Works

The skill has a multi-step planning conversation with the user. Each step builds
on the previous one. Don't rush — this is a planning partner, not a ticket generator.

**Interaction mode for finite choices:** When the next user reply should come from
a bounded set of valid answers, use `AskUserQuestion` (or the host's equivalent
multi-choice question UI) instead of a free-form prompt. Only fall back to plain
text when the host does not support that UI or when the user picks a revision path
that needs custom input.

### Step 1: Understand the Goal

Have a conversation with the user to understand what they want to build.

Start from the information the user already gave you. Do not re-ask for scope,
timeline, constraints, or ticket format if the answer is already in the conversation
or saved config. Ask only for net-new information that changes the plan.

**Ask about:**
- **What** they want to exist that doesn't exist yet
- **Why** — strategic context, user need, deadline
- **Scope boundaries** — what's explicitly out of scope
- **Constraints** — tech stack, timeline, dependencies on other work
- **First demoable slice** — the minimum user-visible scenario that would prove the
  primary Must outcome is working

**Check for prior plans.** Look for existing implementation plans in
`docs/alexandria/implementation-plans/*/release.md`. If any have a "Deferred" section with
unresolved items, surface them:

> "Your previous plan for [X] deferred [Y] and [Z]. Should this plan pick them up?"

**Don't assume — ask.** If the goal is vague, ask clarifying questions before
proceeding. Keep this tight: ask at most 3 net-new questions before the first
goal confirmation, and prefer specific tradeoff questions over generic prompts.
Never ask a catch-all like "what scope, timeline, and format work best?" when the
user has already supplied those inputs.

Once you can summarize the goal, confirm it with a multi-choice question before
moving to Step 2. Use options like:
- `Goal is correct — proceed`
- `Revise scope / constraints`
- `Missing context — ask another question`

If the user chooses a revision path, continue the conversation normally, then
re-confirm with the multi-choice UI.

### Step 2: Context Gathering

Request a **context briefing** for the goal area by invoking Bridget (the context
briefing agent). Do NOT skip this step or wing it by reading library files directly.
Bridget assembles primary cards, supporting cards, relationship map, gap manifest,
and anti-patterns using her retrieval profiles and traversal rules.

**Bridget writes `CONTEXT_BRIEFING.md`** to the plan output directory. This file is
part of the plan bundle — it's referenced from release.md and checked in alongside
outcomes and tickets. If the project has no context library, Bridget reports that
honestly in the briefing.

If no context library exists, note it honestly and work with what the user provides.

Present the key findings to the user and wait for confirmation before proceeding.

### Step 3: Propose Success Outcomes

Based on the goal and context briefing, propose 3-5 success outcomes — observable,
validatable statements tiered as Must / Should / Could with reasoning.

Not everything should be Must. Push for at least one Should or Could.

Wait for the user to confirm outcomes and tiers before proceeding. Start with a
multi-choice confirmation such as:
- `Accept outcomes as proposed`
- `Re-tier outcomes`
- `Add, remove, or rewrite outcomes`

If the user chooses a revision path, switch back to normal conversation for the
specific edits, then re-confirm with the multi-choice UI.

### Step 4: Gap Analysis & Decision Resolution

Compare the goal against the context briefing. Start with the gap manifest.

**Classify each gap** as required (becomes tickets) or presumptive (propose to user).

**Surface decisions.** For each fork, present the bounded options through the
multi-choice UI rather than free-form text. Include the concrete approaches
(`Option A`, `Option B`, `Option C`, etc.) and only the valid meta-choices for
that fork:
1. **Defer to enabler** → create spike/prototype (justified by refactoring gut-check)
2. **Already resolved** → existing decision card covers it

If the user chooses a concrete option, treat that as **Decide now** — record it
and track card updates. If the user chooses a meta-choice, handle that disposition
explicitly and move on.

Bring meaningful planning tradeoffs back to the user instead of silently deciding
them in the final release doc. If a choice affects sequencing, scope tiers, the
first demo, or a hard-to-reverse architecture path, surface it during the planning
conversation before you decompose tickets.

**Surface risks and assumptions.** Track for the release doc.

**Track card updates** as a running list — new cards, updated WHEN sections,
decision records, anti-patterns. Don't apply directly; they'll be written to
`library-updates.md` in Step 7 for Conan/Sam to process.

### Step 5: Ticket Decomposition

Break gaps into tickets following these principles:

- **Vertical slicing** — each ticket delivers user-visible value independently
- **End-to-end first** — thin path across all layers before deepening
- **Roller-skate staging** — simpler version first for large features
- **INVEST criteria** — Independent, Negotiable, Valuable, Estimable, Small, Testable
- **Enabler discipline** — refactoring gut-check before creating spikes

Each ticket traces to an outcome, inherits its tier, and gets a context summary
from the briefing (card references + specific insights).

Treat the decomposition rules as hard constraints, not nice-to-haves:

- The critical path for the primary Must outcome should reach a demoable user-visible
  flow within the first 2-3 tickets or the first non-foundation phase.
- Avoid stacking multiple horizontal foundation tickets before the first demoable
  slice. If a pure enabler is unavoidable, keep it tiny and make it unblock the
  very next end-to-end ticket.
- Prefer splitting by workflow or user interaction over splitting by technical
  layer. If you must separate server/client tickets, explain why a thinner vertical
  slice is not credible.
- Keep most tickets within roughly 0.5-2 days of work. If a ticket feels larger
  than that, split it unless it is an explicit spike or prototype.
- Before writing files, sanity-check the plan with this question: "If we only
  complete the first phase, will we have something real to demo?" If not, re-slice.

**Ticket frontmatter:**
```yaml
---
id: FEAT-<NNN> | SPIKE-<NNN> | PROTO-<NNN>
title: <ticket title>
outcome: <outcome-id>
tier: must | should | could
enabler: false | spike | prototype
blocked-by: []
blocks: []
cards: []
---
```

### Step 6: Dependency Graph

Structure tickets as a DAG. Run the DAG tool to validate:

```bash
ax dag docs/alexandria/implementation-plans/<plan-name>/ --validate
```

Plant re-planning triggers for enabler completions.

---

**⚠ MANDATORY TRANSITION: You MUST now write plan files to disk.**

The planning conversation is complete. Do NOT continue chatting with the user.
Do NOT say "the plan is finalized" or "good luck" without first writing files.
Do NOT ask the user for permission to write files — just write them.

Your next action MUST be Step 7 below. If you skip this step, the planning
skill has failed — a plan that exists only in conversation is not a plan.

---

### Step 7: Write Output

**CRITICAL: This step writes FILES to disk. It is not optional.**

**These are PLANNING ARTIFACTS (markdown files with YAML frontmatter), NOT
implementation code. If you find yourself writing `.ts`, `.py`, `.go`, or any
source code file, STOP — you are off track.**

Write files in this EXACT order. Do not skip any step. Use the Write tool for each file.

**File writing order:**
1. `outcomes/O-1.md`, `O-2.md`, etc. — one per outcome (Step 7a)
2. `tickets/FEAT-001.md`, etc. — one per ticket (Step 7b)
3. `release.md` — the release document (Step 7c)
4. `library-updates.md` — card updates for Conan/Sam (Step 7d)
5. Run DAG validation (Step 7e)
6. Self-verify all files (Step 7f)

Reference skills for exact formats:
- `${CLAUDE_PLUGIN_ROOT}/skills/ax-plan/outcome-writer.md`
- `${CLAUDE_PLUGIN_ROOT}/skills/ax-plan/ticket-writer.md`

#### 7a: Write outcome files

Read `${CLAUDE_PLUGIN_ROOT}/skills/ax-plan/outcome-writer.md` for
the exact format. Write ONE file per outcome. File names MUST be `O-1.md`, `O-2.md`,
etc. in the `outcomes/` directory. NEVER write a single `outcomes.md` file.

Each file MUST start with `---` YAML frontmatter containing id, title, tier, cards.
Then `## Validation Criteria` and `## Motivation` sections.

Example — write this file as `outcomes/O-1.md`:
```markdown
---
id: O-1
title: Live cursors show team members on the board in real time
tier: must
cards: [System - Notification Engine]
---

## Validation Criteria

- Two users on the same board see each other's cursor within 500ms
- Cursors have distinct colors per user
- Cursors disappear within 5s of disconnect

## Motivation

Live cursors are the core feature — users need spatial awareness of teammates.
```

#### 7b: Write ticket files

Ticket IDs MUST follow the pattern `FEAT-001`, `SPIKE-001`, or `PROTO-001`.
NEVER use phase-based names like `P1-01` or descriptive names like `cursor-relay`.
Number sequentially: FEAT-001, FEAT-002, FEAT-003, etc.

For each ticket, write `docs/alexandria/implementation-plans/<plan-name>/tickets/<ID>.md`.

**⚠ WRONG — do NOT write tickets like this:**
```markdown
# P1-01: Define Message Types
**Phase:** 1   **Estimate:** 0.5 day
## Summary
Define TypeScript types for WebSocket messages...
```
This has no YAML frontmatter, wrong ID format, includes estimates, and has the
wrong section structure.

**✓ RIGHT — every ticket MUST look like this:**
```markdown
---
id: FEAT-001
title: "Define WebSocket message types and shared constants"
outcome: O-1
tier: must
enabler: false
blocked-by: []
blocks: [FEAT-002, FEAT-003]
cards: [System - Notification Engine]
---

## Motivation

Core data contract — all cursor and presence features depend on these
shared types. Without them, server and client implementations will diverge.

## Description

Define TypeScript types for WebSocket message types (cursor position,
presence join/leave, heartbeat) and shared constants (color palette,
throttle intervals, timeout values) in a shared module.

## Context

The existing WebSocket layer (see [[System - Notification Engine]]) handles
task update events. This ticket extends it with presence and cursor message
types. Anti-pattern: avoid coupling message types to specific UI components.

## Acceptance Criteria

- [ ] Shared types importable by both server and client
- [ ] Message types cover: cursor position, presence join/leave, heartbeat
- [ ] Constants defined: color palette (8+ colors), throttle interval, timeout

## Implementation Notes

Place in `src/shared/realtime/types.ts`. Follow existing patterns from
the notification engine's message types.
```

The first three lines MUST be `---`, YAML fields, `---`. No exceptions.

#### 7c: Write release.md

Write `docs/alexandria/implementation-plans/<plan-name>/release.md` with these sections:
Goal, Scope, Success Outcomes table, Context Summary (from briefing), Decisions
table, Risks and Assumptions table, Execution Phases, Mermaid graph, Re-planning
Triggers, Ticket Index, Library Updates reference, Deferred section.

Execution Phases should be framed around delivered slices, not just technical
layers. Call out the first demoable milestone explicitly, and make the critical
path reflect the earliest user-visible value.

#### 7d: Write library-updates.md

**This file is REQUIRED. Do not skip it.** Even if there are no library updates,
write the file with an empty table and a note: "No library updates for this plan."

Write `docs/alexandria/implementation-plans/<plan-name>/library-updates.md`:

```markdown
# Library Updates from <Plan Name>

Ask Conan to review this list and produce a transient surgery plan for Sam in the conversation, not as a checked-in file.

| Action | Card | What Changed | Source |
|--------|------|-------------|--------|
| Create | System - <name> | <new system introduced> | Step 4 |
| Update | System - <name> (WHEN) | <planned work> | Step 5 |
| Create | Artifact - Decision: <name> | <decision made> | Step 4 |
```

Include at minimum: any decisions made during planning (Step 4) and any new
systems or entities the plan introduces.

`library-updates.md` is the durable planning artifact here. Conan's downstream surgery
handoff is transient and should not be committed as `surgery-plan.md`.

#### 7e: Validate

Run the DAG tool:

```bash
ax dag docs/alexandria/implementation-plans/<plan-name>/ --validate
```

If validation fails, fix ticket frontmatter before proceeding.

#### 7f: Self-verification checklist

Before moving to Step 8, verify you wrote ALL required files:

- [ ] `outcomes/` directory exists with O-1.md, O-2.md, etc. (one per outcome)
- [ ] Each outcome file has YAML frontmatter with id, title, tier, cards
- [ ] `tickets/` directory exists with FEAT-001.md, etc. (one per ticket)
- [ ] Each ticket file has YAML frontmatter with id, title, outcome, tier, enabler, blocked-by, blocks, cards
- [ ] Each ticket body has the required sections for the chosen format (Standard: Motivation, Description, Context, Acceptance Criteria, Implementation Notes; Minimal: Description, Acceptance Criteria)
- [ ] `release.md` exists with Goal, Scope, Outcomes table, Decisions, Risks, Phases, Ticket Index
- [ ] `library-updates.md` exists with the card update table
- [ ] DAG tool ran and validated clean
- [ ] ZERO `.ts`, `.py`, `.go`, `.rb`, `.js` files in the output directory

If ANY item is unchecked, go back and fix it before proceeding.

### Step 8: Confirm Library Updates

**Planning and the library are discrete systems.** The planner documents updates;
Conan/Sam execute them.

If you haven't already written `library-updates.md` in Step 7d, write it now.
Then tell the user:

> "This plan implies N library updates. I've written them to library-updates.md.
> To apply: ask Conan to review the list and produce a transient surgery plan for Sam in the conversation, not as a checked-in file."

### Step 9: Present Summary

```
Implementation plan: [goal]
[O] outcomes | [N] tickets ([E] enablers, [F] features)

Must: [outcomes]
Should: [outcomes]
Could: [outcomes]

Critical path: [ticket] → [ticket] → [ticket]
Library updates: N items in library-updates.md (for Conan/Sam)

See release.md for full details.
Want to sync these tickets to GitHub issues? Run `/alexandria:sync-tickets`.
```

---

**⚠ COMPLETION CHECK: You are NOT done until ALL of these are true:**
1. `outcomes/` directory has `O-\*.md` files with YAML frontmatter
2. `tickets/` directory has `FEAT-\*.md`, `SPIKE-\*.md`, and `PROTO-\*.md` files with YAML frontmatter
3. `release.md` exists with outcomes table, decisions, risks, phases, ticket index
4. `library-updates.md` exists with card update table
5. The DAG tool validated clean
6. You presented the Step 9 summary to the user
7. ZERO source code files (.ts, .py, .go, .rb, .js) in the output

**If any of these are false, go back and fix them before ending the conversation.**

---

## Output Location

All plan files are written to `docs/alexandria/implementation-plans/<plan-name>/`.
The `<plan-name>` is derived from the goal (lowercase, hyphens, URL-friendly).

## Configuration

Ticket format preference is saved to `docs/alexandria/alexandria-config.json`:

```json
{
  "implementation_planning": {
    "ticket_format": "standard",
    "custom_template": null,
    "output_dir": "docs/alexandria/implementation-plans"
  }
}
```

On first run, use the multi-choice UI to ask the user to choose:
`Minimal` / `Standard` / `BDD` / `Custom`.
If they choose `Custom`, ask a follow-up free-form question for the template path.

On subsequent runs, confirm the saved format with a multi-choice question. Offer
`Keep saved format` plus direct switch options for `Minimal`, `Standard`, `BDD`,
and `Custom`. If they switch to `Custom`, ask for the template path.

See [ticket-formats.md](ticket-formats.md) for the detailed template content
for each format option.
