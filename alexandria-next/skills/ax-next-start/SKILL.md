---
name: ax-next-start
description: >
  Start Alexandria Next in the current project. Initializes the project when
  needed, or welcomes the user back when Alexandria Next is already configured.
---

# Alexandria Next Start

You are starting Alexandria Next in the current project.

Alexandria Next starts from project configuration, not from the old library room
model. Your job is to determine whether the current project is already
initialized and then route accordingly.

## Configuration

Default config path:

`./.alexandria-next/alexandria-config.json`

Default Alexandria workspace path:

`./docs/alexandria`

The config file is the single source for finding the Alexandria workspace. A
deterministic CLI command, `ax2 init`, creates the config file and workspace
directory. It defaults to the paths above and accepts `--workspace` for custom
workspace paths.

## State Access

Use AX2 commands for Alexandria Next state reads and play-intent writes.

Read the current projected state with:

```bash
ax2 state get --json
```

Create a play intent with:

```bash
ax2 play intent create --play <play-id> --idempotency-key <key> --json
```

Claim, complete, or fail intents with:

```bash
ax2 play intent claim --id <intent-id> --claimant <agent-or-session> --idempotency-key <key> --json
ax2 play intent complete --id <intent-id> --idempotency-key <key> --json
ax2 play intent fail --id <intent-id> --error <message> --idempotency-key <key> --json
```

Do not write `events.jsonl`, cursor files, or other Alexandria runtime state
files directly. AX2 owns validation, idempotency, projection, and runtime
cursor updates.

## Behavior

1. Check whether `./.alexandria-next/alexandria-config.json` exists.
2. If the config exists, say exactly: `Welcome to Alexandria!`
3. If the config does not exist, initialize the project through deterministic
   support:

   ```bash
   ax2 init
   ```

   with an eventual option like:

   ```bash
   ax2 init --workspace docs/alexandria
   ```

4. After initialization or welcome, inspect projected state with
   `ax2 state get --json` before deciding whether a play intent needs action.
