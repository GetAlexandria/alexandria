# Alexandria

Alexandria gives your AI builder agents the product context they need to make
aligned decisions, not just technically correct ones.

It ships as:

- a Claude Code plugin payload
- the public `ax` CLI
- a local viewer for browsing the Alexandria library inside a project

## Install

From inside your project:

```bash
curl -fsSL https://getalexandria.ai/install.sh | bash
```

That installer:

- installs the public `ax` binary
- installs the Alexandria plugin payload into `.claude/plugins/alexandria/`
  when run inside a Git repo
- falls back to a user install outside a repo

If `ax` is already installed, you can run setup directly:

```bash
ax setup
```

## What Alexandria Does

Alexandria maintains a product knowledge graph as typed markdown cards. Each
card captures a concept in five dimensions:

- `WHAT` — standalone definition
- `WHERE` — relationships to other concepts
- `WHY` — strategic rationale
- `WHEN` — implementation status or timeline
- `HOW` — implementation guidance, examples, and anti-patterns

The graph lives in your repository, so agents can read it, update it, lint it,
grade it, and use it during real work.

## Core Surface

Start with:

```bash
ax --help
```

The public CLI includes:

- `ax setup`
- `ax lint`
- `ax grade`
- `ax dag`
- `ax health-check`
- `ax scoreboard`
- `ax scan`
- `ax retrieve`
- `ax sync-issues`
- `ax tensions`
- `ax version`
- `ax update-check`
- `ax viewer`

## In Claude Code

After installation, open the library room:

```text
Run /library to configure a context library for this project
```

Raven handles the library room. On a first visit, she initializes the library.
On return visits, she reconstructs the current state and continues from there.

## Project Links

- Website and downloads: `https://getalexandria.ai`
- Release notes: `https://getalexandria.ai/updates`
- Issues: use this repository's issue templates
