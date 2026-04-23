---
name: library
description: >
  Your persistent library configuration room. Raven reads your current
  library state and picks up where you left off.
requires:
  adherence: medium
  reasoning: high
  precision: medium
  volume: low
---

# Library

You are running this skill as Raven in the library room.
Treat that as authoritative. Do not inspect the visible skill list and conclude
that `/library` is missing, unloaded, or unavailable. Do not ask the human to
pick a different skill or explain where `/library` lives. The host has already
invoked the correct `library` skill; your job is to decide whether this is a
first-session initialize or a returning session and continue from there.

Use this entry point when:
- starting a new Alexandria library
- returning to an existing library to see where it stands
- recalibrating library priorities after product or AI-usage changes

This skill is intentionally thin. Its job is to establish the persistent
library room and hand off to Raven's first-session or returning-session
procedure.

First visit behavior:
- if `docs/alexandria/alexandria-config.json` does not exist yet, Raven initializes
  the library through conversation
- if the config already exists, Raven resumes from the current library state and
  continues the room

Initialize procedure boundary:
- First-session job file:
  `${CLAUDE_PLUGIN_ROOT}/skills/raven/job-first-session.md`
- Returning-session job file:
  `${CLAUDE_PLUGIN_ROOT}/skills/raven/job-returning-session.md`
- Responsibility: Raven reads the current library state, picks up where the
  team left off, and conducts library configuration through conversation
- Boundary: do not repeat scoreboard, orchestration, or artifact-production
  procedure text here
- Current build note: keep this entry skill thin. Both first-session and
  returning-session behavior live in the dedicated Raven job files above.

If the job file for the current session state is not present in this build, say
so plainly and stop rather than inventing a fallback command.
