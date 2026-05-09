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
future deterministic CLI command, provisionally `ax2 init`, should create the
config file and workspace directory. It should default to the paths above and
allow parameters for custom workspace paths.

## Behavior

1. Check whether `./.alexandria-next/alexandria-config.json` exists.
2. If the config exists, say exactly: `Welcome to Alexandria!`
3. If the config does not exist, initialize the project through deterministic
   support. The intended command shape is:

   ```bash
   ax2 init
   ```

   with an eventual option like:

   ```bash
   ax2 init --workspace docs/alexandria
   ```

4. Until `ax2 init` exists, do not hand-write the config as if the deterministic
   init path exists. Say that Alexandria Next is installed but initialization
   support has not been implemented yet.
