---
name: sync-tickets
description: >
  Preview and sync Alexandria plan tickets to GitHub issues using the existing
  sync CLI. Use after planning work is written to disk and you want to create or
  update the corresponding GitHub issues without leaving the conversation.
requires:
  adherence: medium
  reasoning: low
  precision: low
  volume: low
---

# Sync Tickets

Preview and sync Alexandria plan tickets to GitHub issues. This skill wraps the
existing sync CLI so the user can see a dry run, confirm, and then perform the
live sync from the plugin surface.

## When to Use

Use this skill when:
- A plan already exists on disk with a `tickets/` directory
- The user wants those tickets mirrored into GitHub issues
- The user just finished planning and wants to sync the new plan without leaving the conversation

Do not use this skill to create or edit the plan itself. Planning stays in the
planning workflow; this skill only syncs already-written tickets.

## How It Works

### Step 1: Detect the Plan to Sync

First determine the plan directory.

Use the user's explicit path or plan name if they provided one.

If they did not, infer from context:
- If the user just finished planning, use that plan directory
- Otherwise look for likely candidates under:
  - `docs/alexandria/implementation-plans/*`
  - `docs/alexandria/plans/*`
- Only treat a directory as a valid candidate if it contains `tickets/`

If there is exactly one obvious candidate, propose it to the user before running
anything live.

If there are multiple plausible candidates, ask a short clarifying question and
do not guess.

If repo detection for GitHub is ambiguous, ask for the target repo and pass
`--repo owner/repo` to the CLI. GitHub is the default target for now.

### Step 2: Run a Dry-Run Preview

Before any live sync, run:

```bash
ax sync-issues <plan-dir> --dry-run
```

If the user specified a repo explicitly or auto-detection failed, run:

```bash
ax sync-issues <plan-dir> --dry-run --repo owner/repo
```

Show the user a concise preview of what would happen:
- tickets that would be created
- tickets that already exist
- anything that would need `--update` to refresh issue bodies
- any parse errors, repo-detection errors, or other failures

Do not jump straight to live sync. The dry run is mandatory.

### Step 3: Confirm Before Proceeding

After showing the dry-run results, ask the user whether to proceed.

If existing issues were found and the user wants GitHub issue bodies refreshed,
ask whether to include `--update`.

If the dry run shows only failures, stop and explain what needs fixing before a
live sync can succeed.

### Step 4: Run the Live Sync

Only after explicit user confirmation, run the live command:

```bash
ax sync-issues <plan-dir>
```

If needed, include the same flags confirmed during preview:

```bash
ax sync-issues <plan-dir> --update --repo owner/repo
```

Keep the plan directory exactly the same as the dry-run preview unless the user
changes it explicitly.

### Step 5: Report the Result

Summarize the final outcome in conversation using the CLI result categories:
- `created`
- `exists`
- `updated`
- `failed`
- `error`

Call out:
- which plan was synced
- which repo was targeted
- whether `--update` was used
- any tickets that failed and the error shown by the CLI

If everything already existed and nothing changed, say so clearly instead of
implying new work happened.

## Guardrails

- Never run the live sync without showing a dry run first
- Never run the live sync without explicit user confirmation
- Never invent ticket status; report what the CLI actually returned
- Treat the filesystem plan as the source of truth and GitHub issues as derived artifacts
