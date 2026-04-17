# Alexandria

A construction system for product knowledge. AI agents that build and maintain structured knowledge graphs so your AI-assisted production process stays aligned with your vision.

## What Is This?

Alexandria is a **Claude Code plugin** that creates and maintains a product knowledge graph in any software project. It gives your AI builder agents the product context they need to make aligned decisions, not just technically correct ones.

A **context library** is a set of typed markdown cards organized as a knowledge graph. Each card documents a concept in your product with five dimensions:

- **WHAT** — Standalone definition
- **WHERE** — Relationships to other concepts via `[[wikilinks]]`
- **WHY** — Strategic rationale (links to principles and strategies)
- **WHEN** — Implementation status, timeline, reality notes
- **HOW** — Implementation guidance, examples, anti-patterns

The graph is encoded in the filesystem:
- **Folder paths** = type taxonomy
- **File names** = card identifiers (`Type - Name.md`)
- **`[[wikilinks]]`** = relationship edges
- **Section headers** = dimension boundaries

## Why?

Without specification context, AI agents produce technically correct but contextually wrong code. They implement features that work but don't fit — wrong naming, wrong UX patterns, wrong architectural assumptions.

Alexandria makes implicit product knowledge explicit and queryable. When an agent needs to implement a feature, it gets a context briefing assembled from the relevant cards so it makes aligned decisions.

**Think of it as onboarding documentation that AI agents actually read.**

## Quick Start

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- A Git repository for your project

### 1. Install the plugin

Run the installer from your project directory:

```bash
curl -fsSL https://sociotechnica.org/alexandria/install.sh | bash
```

The installer:

- **Detects context** — inside a Git repo it installs to `.claude/plugins/alexandria/`
  (project-local, version-pinned per project); outside a repo it falls back to
  `~/.claude/plugins/alexandria/` (global, shared across all projects)
- **Prompts for confirmation** before writing anything, showing the target path
- **Auto-installs Bun** if it is not already present (Bun compiles the CLI tools
  on first setup; plugin consumers do not need Bun for day-to-day use after that)

After installation, launch Claude Code. For project-local installs:

```bash
claude --plugin-dir .claude/plugins/alexandria
```

Add the plugin directory to `.gitignore` to keep it out of version control:

```bash
echo '.claude/plugins/alexandria/' >> .gitignore
```

For global installs, the plugin is auto-discovered — no flag needed:

```bash
claude
```

You can pin a specific version by setting `ALEXANDRIA_VERSION` before running
the installer:

```bash
curl -fsSL https://sociotechnica.org/alexandria/install.sh | ALEXANDRIA_VERSION=0.6.0 bash
```

<details>
<summary>Alternative: clone for contributors</summary>

If you are contributing to this repository or want the full source (tests, docs, evals):

```bash
git clone https://github.com/sociotechnica-org/alexandria.git
cd alexandria
bun install
./scripts/setup-dev
```

`./scripts/setup-dev` installs `shellcheck` and `shfmt` when missing, runs
product setup, and additionally symlinks `contributor-skills/` into
`~/.claude/skills/` and `~/.codex/skills/`.

Formatting policy on this repo is intentionally split:

- Prettier formats only TypeScript, JSON, and YAML
- Shell files are checked with `shfmt` and `shellcheck`
- Markdown is linted separately with `markdownlint-cli2` plus repo-specific
  semantic checks

</details>

### 2. Configure your library

In Claude Code, open the library room:

```
Run /library to configure a context library for this project
```

`/library` is the single Raven-led entry point for library configuration. On a
first visit, Raven initializes the library automatically. On return visits, she
reconstructs the current state and continues the room from there. The
configuration still captures AI mode, domain novelty, and product complexity to
produce a prioritized list of knowledge areas to build first.

### 3. Add your source material

Drop your product spec, design doc, or GDD into `docs/alexandria/sources/`:

```bash
cp my-product-spec.md your-project/docs/alexandria/sources/
```

### 4. Build the library

```
Use the Conan agent to inventory cards from the source material in docs/alexandria/sources/
```

Conan reads your source material and produces an inventory. Then:

```
Use the Sam agent to build the cards from Conan's inventory
```

Sam creates the cards. Conan grades them. You iterate.

### 5. Use the library during development

When implementing a feature:

```
Use the Bridget agent to assemble a context briefing for implementing the user dashboard
```

Bridget pulls relevant cards into a `CONTEXT_BRIEFING.md`. Your implementing agent reads it and builds with full product context.

## The Agent Team

Five active agents with separated responsibilities — the critic cannot build, the builder cannot grade, and mechanical checks run through `ax lint ...`.

| Agent | Role | Job |
|-------|------|-----|
| **Conan** | Librarian | Grades cards, diagnoses gaps, plans surgery, runs health checks. Produces transient surgery handoffs for Sam. |
| **Sam** | Scribe | Builds cards, fixes cards, runs self-checks. The only agent that writes card content. |
| **Bridget** | Briefer | Assembles context briefings for builder agents. Logs gaps as demand signal back to the library. |
| **Raven** | Maven | Product thinking partner. Brainstorms, pressure-tests, traces implications. Produces handoffs. |
| **Solomon** | Sorter | Signal intake and triage. Classifies raw signal by epistemic status before it enters the library. |

## Type Taxonomy

Cards are organized into 18 types across four layers:

### Why Layer (product rationale)

| Type | Purpose |
|------|---------|
| Product Thesis | Guiding philosophy — a bet the product makes |
| Principle | Judgment guidance — a rule of thumb |
| Standard | Testable specification — concrete rules |

### Builder-Facing Layer (things builders interact with)

| Type | Purpose |
|------|---------|
| Domain | Top-level navigation destination |
| Section | Nested area within a Domain |
| Governance | Persistent across all Domains |
| Template | Spatial canvas within a Section |
| Component | Discrete widget or UI element |
| Artifact | Content object |
| Capability | Action or workflow |
| Primitive | Core data entity |

### Infrastructure Layer

| Type | Purpose |
|------|---------|
| System | Invisible mechanism or rule |
| Agent | AI team member |
| Prompt | Agent implementation |

### Experience-Over-Time Layer

| Type | Purpose |
|------|---------|
| Loop | Repeating activity cycle |
| Journey | Multi-phase progression arc |
| Experience Goal | Target emotional state |
| Force | Emergent cross-system behavior |

Not every type applies to every product. Library initialization helps you figure out which ones matter for yours.

## Library Initialization

Initialization determines which knowledge areas your project needs based on three inputs:

1. **AI Mode** — How much product decision authority do AI builders have? (No AI → Short-Order Cook → Pair Programmer → Factory)
2. **Novelty** — How well-understood is your product category? (Low → Moderate → High)
3. **Complexity** — How much structural coupling exists? (Low → Moderate → High)

Output: each of the 22 knowledge areas is assigned to a tier — **Foundation** (build first), **Core** (primary value), **Amplifier** (multiplies value), or **Deprioritized** (build later if at all).

## Model Routing

Skills declare capability requirements instead of hardcoding model names. Four dimensions — `adherence`, `reasoning`, `precision`, `volume` — scored low/medium/high. The routing config maps these to models automatically:

| Capability Level | Model |
|-----------------|-------|
| Any primary dimension = high | opus |
| Any primary dimension = medium | sonnet |
| All primary dimensions = low | haiku |

## CLI Surface

Start with `ax --help` for the unified public CLI. The public surface includes
`lint`, `grade`, `dag`, `health-check`, `scoreboard`, `scan`, `retrieve`,
`sync-issues`, `tensions`, `version`, `update-check`, and `viewer`.

## The Workflow

```
Source material → Conan inventories → Sam builds → `ax lint ...` → Conan grades
                                                                          ↓
                                                                    Sam fixes → repeat
```

During development:
```
Task arrives → Bridget assembles context → Agent implements with full product context
                    ↓
              Assembly gaps logged → feed back into library priorities
```

After `/alexandria:plan` writes a ticketed implementation plan, you can run
`/alexandria:sync-tickets` to preview and confirm syncing that plan's `tickets/`
directory into GitHub issues.

If enablers complete or milestone findings change the remaining work, use
`/revise-plan` to update that plan's `release.md` and affected plan files before
implementation continues.

After implementation finishes, use `/complete-plan` to update that plan's
`release.md` with what shipped, what was deferred, execution-time decisions,
and a lightweight retrospective.

For work on this repository itself, the plugin also supports a repo-local issue workflow:

1. `Use /alexandria-dev-technical-planning` to translate a GitHub issue plus linked product plan into
   `docs/alexandria/plans/<issue>-<task>/plan.md`
2. `Use /alexandria-dev-issue-execution` to carry an issue from GitHub reference through branch, plan,
   implementation, local review, PR, and review follow-through
3. `Use /alexandria-dev-targeted-evals` after local review to rerun only the evals whose behavior
   surfaces changed
4. `Use /alexandria-dev-release` to validate Alexandria release path, tag a release,
   and watch the cross-repo publication workflow through completion

## Deployment

Alexandria distribution path is documented in [RELEASING.md](./RELEASING.md).

In short:

1. validate the repo locally with `bun run check`, `bun test`, and `./scripts/build-tarball.sh`
2. tag `v$(cat VERSION)` from a clean `main`
3. let `.github/workflows/release.yml` create the GitHub Release and publish
   `latest-version.txt`, `install.sh`, and the tarball into `sociotechnica-site/public/alexandria/`

The workflow intentionally fails if `install.sh` is missing, because Alexandria should not
publish a partial installer surface.

## Running Symphony On This Repo

If you want to run the `symphony-ts` factory against `alexandria`, treat
[WORKFLOW.md](./WORKFLOW.md) as the checked-in runtime contract for this repo.

### Workflow settings

`WORKFLOW.md` defines:

- the tracker repo and labels Symphony should use
- polling and retry behavior
- workspace preparation and retention
- the worker runner command
- the repository-specific prompt contract

For the general design of `WORKFLOW.md`, see the Symphony docs in the
`symphony-ts` checkout:

- `docs/guides/workflow-guide.md`
- `docs/guides/workflow-frontmatter-reference.md`

### Start the factory

From your `symphony-ts` checkout, start the `alexandria` factory with:

```bash
pnpm tsx bin/symphony.ts factory start --workflow ../alexandria/WORKFLOW.md
```

Check status with:

```bash
pnpm tsx bin/symphony.ts factory status --workflow ../alexandria/WORKFLOW.md
```

Attach the live TUI with:

```bash
pnpm tsx bin/symphony.ts factory attach --workflow ../alexandria/WORKFLOW.md
```

### Start the operator

Run the operator from the `symphony-ts` checkout against the same workflow:

```bash
pnpm operator -- --workflow ../alexandria/WORKFLOW.md
```

For a single wake-up instead of the continuous loop:

```bash
pnpm operator:once -- --workflow ../alexandria/WORKFLOW.md
```

The operator uses the same instance-scoped workflow state and should be pointed
at the same `WORKFLOW.md` as the factory.

## Updating

Check your current version:

```bash
ax version
```

Check if a newer version is available:

```bash
ax update-check
```

Or use the upgrade skill in Claude Code:

```
Run /alexandria:upgrade
```

## Customization

The library room handles initial configuration. For manual adjustment, edit `docs/alexandria/reference.md` to add or remove types. The agents adapt to whatever types exist.

## Obsidian Integration

The library works with [Obsidian](https://obsidian.md) for graph visualization. Open `docs/alexandria/` as a vault to get graph view, backlinks, and wikilink resolution.

## License

MIT

## Contributing

Maintained by [SocioTechnica](https://github.com/sociotechnica-org). Issues and PRs welcome.
