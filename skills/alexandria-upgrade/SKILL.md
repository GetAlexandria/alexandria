---
name: upgrade
description: >
  Upgrade Alexandria to the latest version. Detects install type
  (git clone vs vendored), pulls updates, and verifies the upgrade.
  Use when the update check reports a new version is available, or when
  asked to "upgrade the context library" or "update the plugin".
requires:
  adherence: low
  reasoning: low
  precision: medium
  volume: low
---

# Alexandria Upgrade

Upgrade Alexandria to the latest installed release.

## When to Use

- When the update check reports a new version is available
- When the user asks to upgrade or update the context library
- When troubleshooting and wanting to ensure the latest version

## How It Works

### Step 1: Check Current Version

Read the current version from `${CLAUDE_PLUGIN_ROOT}/VERSION`.
Run `ax update-check` to see if an upgrade
is available. The output format is one of:
- `up_to_date`
- `upgrade_available|<version>|<download_url>` (download URL included when available)
- `upgrade_available|<version>`
- `check_failed`

Report the current and available versions. If a download URL is present in the output,
show it to the user.

If already up to date, tell the user and stop.

### Step 2: Use the Public CLI Upgrade Path

If `ax update` is available, treat it as the canonical in-place upgrade path.

1. Ask the user for permission if the session requires confirmation.
2. Run:
   ```
   ax update
   ```
   Or, when the user has already approved a non-interactive run:
   ```
   ax update --yes
   ```
3. If `ax update` succeeds, move to verification.
4. If `ax update` is unavailable or fails before installing, fall back to install-type diagnosis below.

### Step 3: Detect Install Type (Fallback)

Check how Alexandria was installed:

**Git clone** (`.git` directory exists in `${CLAUDE_PLUGIN_ROOT}`):
```
Alexandria was installed via git clone.
Upgrade path: git pull from origin.
```

**Vendored** (no `.git` directory):
```
Alexandria was vendored (copied) into this project.
Upgrade path: manual update or copy from a global git install.
```

### Step 4: Perform Fallback Upgrade

**For git installs:**

1. Check for uncommitted local changes:
   ```
   cd ${CLAUDE_PLUGIN_ROOT} && git status --porcelain
   ```
   If there are local changes, warn the user and ask whether to proceed
   (changes will be preserved if they're on a different branch, but could
   conflict if they've modified plugin files directly).

2. Fetch and show what's new:
   ```
   git fetch origin main
   git log --oneline HEAD..origin/main
   ```
   Present a summary of new commits.

3. Pull the update:
   ```
   git pull origin main
   ```

4. If a `setup` script exists, ask the user if they want to re-run it.

**For vendored installs:**

1. Check if a global git install exists:
   - `~/.claude/plugins/alexandria/.git`
   - `~/.claude/plugins/alexandria/.git`

2. If a global install exists:
   - Upgrade the global install first (git pull)
   - Then copy updated files to the vendored location
   - Preserve any local customizations in CLAUDE.md or config

3. If no global install:
   ```
   No git-based install found. To upgrade manually:
   1. Download the latest release from: <download_url from update-check output>
   2. Replace the files in [vendored path]
   3. Verify with: cat [vendored path]/VERSION
   ```

### Step 5: Verify

After upgrade:

1. Read the new `VERSION` file and confirm it matches the expected version
2. Run `ax update-check` to confirm
   it now reports `up_to_date`
3. Report success:
   ```
   Alexandria upgraded: [old version] → [new version]
   ```

### Error Recovery

If the git pull fails (merge conflict, network error):

1. Report the error clearly
2. Do NOT run `git reset --hard` without asking
3. Suggest:
   ```
   The upgrade failed. Options:
   1. Resolve the conflict manually, then re-run this skill
   2. Back up local changes and reset: git stash && git pull origin main
   3. Re-clone: rm -rf [path] && git clone [repo url] [path]
   ```
