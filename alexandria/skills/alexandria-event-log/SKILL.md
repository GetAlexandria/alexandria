---
name: alexandria-event-log
description: >
  Interpret Alexandria event log wake payloads from the local web UI/runtime,
  decide whether action is needed, and use AX commands to inspect or write
  event-log state.
---

# Alexandria Event Log

Use this skill when a monitor injects an Alexandria event log update into the
session.

The injected payload is a wake signal, not a complete task brief. It includes a
ledger event with:

- `id`: event id in the Alexandria event log
- `type`: event type, such as `canvas.review.requested` or
  `play.started`
- `at`: event timestamp
- `actor`: who or what emitted the event
- `payload`: event-specific data

## How To Respond

1. Read the injected `event` object first.
2. Decide whether the event asks for agent action.
3. Inspect projected state only when the event does not include enough context:

   ```bash
   ax inspect state --json
   ```

4. Use recent raw events only for audit/debug or correlation:

   ```bash
   ax inspect events list --json --limit 20
   ```

5. Do not edit `events.jsonl`, cursor files, connection leases, or subscription
   files directly. Use AX commands so validation, idempotency, and projection
   stay consistent.

## Common Event Types

Use `ax inspect events schema --json` to inspect the supported event types and
payload shapes programmatically.

- `canvas.review.requested`: inspect the referenced canvas/step context, perform
  the requested review, then write back a useful result when appropriate.
- `play.started`, `play.completed`, and `play.failed`: play run lifecycle audit
  events. Inspect them for status/debug context; do not treat them as requests
  to start another play.
- `canvas.step.saved`: context was saved. Do not wake or respond unless another
  event asks for action.
- `raven.vision.source_attached`: source context changed. Do not draft from
  this event. Acknowledge briefly, for example: "I see you added a source. Let
  me know when you're ready for me to draft The Shift."
- `raven.vision.drafting_requested`: the director explicitly asked Raven to
  begin drafting from the attached Vision sources. Use `raven-vision-drafting`
  to draft exactly one current Vision slot if no slot is already waiting for
  review.
- `raven.vision.slot.updated`: a Vision slot draft changed. Inspect projected
  state before acting; if the actor is Raven, wait for user review rather than
  writing another slot. If the actor is the Viewer/user, preserve Raven's notes
  and wait for approval or an explicit revision request.
- `raven.vision.slot.approved` and `raven.vision.slot.skipped`: user review
  feedback. Use `raven-vision-drafting` to draft the next empty Vision slot,
  then stop for Viewer review.
- `raven.source_of_truth.updated`: Raven's internal Source of Truth document was
  written or refreshed. Inspect `raven.sourceOfTruth` in projected state before
  using it as durable context.
- `raven.vision.banked`: Vision is banked into Raven's Knowledge Bank. Treat the
  banked Source of Truth as context only; do not generate Library cards from this
  event.

## Writing Back

When writing an agent result to the event log, use
`ax inspect events append`. Run `ax inspect events append --help` to see the
supported event types and append options.

For Raven Vision slot collaboration, prefer the narrower runtime command over a
generic event append:

```bash
ax raven vision slot update --slot <slot-id> --text "<draft text>" --notes "<markdown notes>" --json
ax raven vision slot approve --slot <slot-id> --json
ax raven vision slot skip --slot <slot-id> --json
```

Do not create temporary files just to pass Raven Vision draft text or notes.
This command writes the validated state event through AX.

Use `update` for one Raven-authored draft with user-visible notes, then stop
until the director edits, approves, or skips it. Raven must not self-approve.
If the director explicitly approves or skips in Claude Code, record that
decision with `approve` or `skip` instead of `ax inspect events append`; after
the command succeeds, continue only from the projected state and the current
drafting trigger rules.
