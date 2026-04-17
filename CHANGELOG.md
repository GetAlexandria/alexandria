# Changelog

All notable changes to Alexandria are documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [0.8.4] — 2026-04-08

### Fixed
- Eval CLI and harness root resolution for source-mode runs in maintainer checkouts
- Raven handoff/tier signaling and card-write guidance that caused structural eval failures
- Sam and Conan eval prompt/config regressions that left `create-cards` and `surgery` failing

### Changed
- Refreshed Raven, Sam, and Conan eval baselines after the post-`0.8.3` reruns
- Tightened Raven structural checks for handoff detection, evidence-tier signaling, and card-write rejection

## [0.8.3] — 2026-04-07

### Added
- **Viewer dashboard and navigation** — dashboard overview, sidebar directory
  tree, linked plan detail viewer, and implementation plan routes
- **Viewer file watching** — live reload on library changes with static build
  checks
- **Alexandrian viewer theme** — styled viewer matching Alexandria visual
  identity
- **Library structural pipeline** — Raven composes card handoffs with library
  structure awareness, Sam validates card paths against structural reference,
  Nit structural validation gate before Conan grading, structural pre-check
  gate in Conan grading skill and grade CLI (`--library` flag)

### Fixed
- Session-start reading plugin files instead of project files (token waste)
- Tarball install broken by workspace lockfile mismatch
- Viewer plan path and heading regressions
- Queued viewer watcher reloads
- Expert calibration fallback and scoreboard exception handling

### Changed
- Setup no longer symlinks product skills (Claude plugin discovery handles it)
- Tarball build preflight now checks for `sed` dependency

## [0.8.2] — 2026-04-03

### Added
- **Viewer wikilink rendering** — card content now renders `[[wikilinks]]` as
  navigable links in the viewer
- **Five-dimension viewer card layout** — cards display all five knowledge
  dimensions in the viewer UI
- **Viewer library card content collection** — Astro content collection wired
  to library cards for the viewer workspace
- **Viewer shared graph parser** — viewer workspace connected to the shared
  graph parser for consistent graph traversal

### Fixed
- Setup script fix for clean installs

## [0.8.1] — 2026-04-03

### Added
- **Alexandria Viewer** — Astro workspace scaffold and `alexandria-viewer` CLI
  for browsing the knowledge graph locally
- Portable core + platform adapters spike artifacts (#161)

### Changed
- Decomposed wizard SKILL.md from 1193-line monolith into focused reference
  files (expert calibration, greenfield, inference, configuration questions)
- Wizard refactor review pass — tightened language, fixed cross-references

### Fixed
- Bun type resolution for clean installs
- LIB2-009 smoke test blocker record and findings

## [0.8.0] — 2026-04-03

### Added
- **Phase 1: Raven-Voiced Wizard** — rewrote the wizard skill with Raven's
  conversational voice, greenfield fast-lane for early-stage products,
  inference-before-asking on configuration questions, and expert calibration
  inline guidance
- **Phase 2: Raven Orchestrates the Wizard** — Raven gets a wizard-mode job
  with `/library` entry point, scoreboard derivation and ASCII renderer,
  session-start procedure, expert calibration reference skill, Raven-to-Sam
  artifact delegation, and greenfield-to-brownfield transition handling
- `/complete-plan` skill for closing out executed implementation plans with
  completion status, execution decisions, and retrospective
- `/revise-plan` skill for revising existing plans when re-planning triggers fire
- `/sync-tickets` skill for syncing plan tickets to GitHub issues from within
  a conversation
- Raven gains Agent dispatch and Write capabilities for wizard-mode orchestration
- Scoreboard ASCII renderer with Foundation/Core/Amplifier buckets and five
  fill states (0/25/50/75/100%)
- Skill Naming Convention decision card formalizing short `name:` fields with
  plugin auto-namespace

### Changed
- Skill names renamed to short forms (`wizard`, `plan`, `brief`, etc.) — Claude
  Code auto-prefixes as `/alexandria:<name>`
- Planning skill uses AskUserQuestion for interactive choices instead of
  inferring from context
- Eval artifacts migrated from `context-library/` to `alexandria/` paths
- Release skill moved to contributor workflows (not part of plugin surface)
- Surgery plans are now transient (not checked into the repo)

### Fixed
- Sync-issues same-batch dependency resolution for tickets created in one run
- Sync-issues cross-plan matching when multiple plans share ticket ID prefixes
- Stale revise-plan archive reference
- Skill rename eval routing after short-name migration

## [0.7.0] — 2026-04-02

### Changed
- Renamed Context Library to Alexandria across the product, docs, contributor
  workflows, plugin metadata, install surfaces, and release artifacts
- `alexandria` is now the primary runtime/install identity, including the main
  CLI wrappers, plugin paths, state directory, and hosted documentation path
- Kept compatibility aliases for legacy `context-library` command names and
  related contributor setup surfaces during the transition

### Added
- New primary `bin/alexandria-*` command entrypoints and Alexandria-named
  distribution artifacts
- `docs/alexandria/` as the canonical documentation root for plans, assessments,
  and upgrade guidance

### Notes
- Post-merge eval follow-up remains tracked in issue `#201`
- Two accepted operational follow-ups from the rename rollout remain deferred to
  deployment/release handling: legacy plugin-directory replacement during
  upgrade and legacy tarball URL handling in update-check output

## [0.6.1] — 2026-04-02

### Fixed
- Build-tarball script failed in CI when given a relative output directory
- Setup installs only production dependencies (`--production --ignore-scripts`),
  no longer pulls devDependencies or runs husky in consumer installs
- Prettier and markdownlint no longer scan gitignored runtime directories

### Added
- `/release` skill for cutting releases
- `marketplace.json` in `.claude-plugin/` — installer auto-registers the plugin
  with Claude Code so it loads without `--plugin-dir`

## [0.6.0] — 2026-04-01

### Changed
- Completed the FEAT-018 cleanup on the Bun/TypeScript toolchain
  - removed the legacy Python graph library and shell test/helper suites
  - made `src/tools/eval-harness.ts` the canonical eval runner and
    `structural-checks.ts` the only active structural-check format
  - switched CI and contributor guidance to the Bun-native `bun run check` +
    `bun test` contract
- Clarified that the `bin/alexandria-*` bash files remain as intentional
  launcher infrastructure for compiled distribution, not legacy implementation code

## [0.5.0] — 2026-03-26

### Added
- **Progressive codebase discovery** — extends the wizard to scan codebases and discover
  product entities
  - Wizard routing: two yes/no questions before Step 1 determine input path (docs-only,
    code-only, both, neither) (DISC-001)
  - Scanner skill: Tier 1 file tree investigation with framework-agnostic heuristics
    (DISC-002), Tier 2 schema + route scanning for richer evidence (DISC-005)
  - Noun proposal dialogue: grouped conversational flow (summary → domain groups →
    confirm/rename/merge/split/reject → annotate) (DISC-003)
  - Gap analysis integration: confirmed entities pre-populate wizard-config.json as
    "present" for Step 5 (DISC-004)
  - Code walk: doc-vs-code divergence validation with three classification types
    (missing-from-code, missing-from-docs, evolved-past-docs) (DISC-006)
  - Eval structure for scanner metrics: token cost, escalation rate,
    self-consistency (DISC-007)
  - 10 QA tests for routing logic (DISC-008)

## [0.4.1] — 2026-03-26

### Changed
- **Wizard Q3 replaced with observable complexity checklist** (WIZ-001)
  - 6 binary signals replace abstract "how many features does a decision affect?"
  - Count maps to Low (0-1) / Moderate (2-3) / High (4+) before engine sees it
  - Engine algorithm, tier assignments, and all 36 configurations untouched
- **Q2 disambiguation bumps** (WIZ-002) — gentle nudge toward Moderate using
  observable signals (onboarding time for Low, competitor existence for High)
- **Risk narrative shown before Q2/Q3** (WIZ-003) — mode-specific failure scenario
  primes users after Q1, before calibration questions
- **when_missing text surfaced during gap analysis** (WIZ-004) — failure symptoms
  shown alongside each area during self-assessment; "Present" renamed to "Robust"
  as user-facing label (internal value unchanged)
- **Configuration confirmation signal** (WIZ-005) — "does this ring true?" check
  after Step 4 summary with reconfigure option

### Added
- **15 QA tests for checklist mapping** (WIZ-006) — count-to-level mapping,
  boundary cases, 5 calibration profiles (blog, fitness, SaaS PM, CRM, marketplace)

## [0.4.0] — 2026-03-27

### Added
- **Implementation planning skill** (`skills/implementation-planning/SKILL.md`)
  - 9-step conversational planning: goal → context briefing → outcomes → gap analysis →
    ticket decomposition → DAG → output → library updates → summary
  - Success Outcomes as first-class objects with scope tiers (Must/Should/Could)
  - Decisions resolved inline during planning conversation
  - Roller-skate staging, end-to-end first sequencing, vertical slicing principles
  - Library updates documented (not applied directly) — Conan/Sam process via surgery
  - Ticket format options: Minimal / Standard / BDD / Custom (configurable)
- **DAG tool** (`bin/alexandria-dag`) — deterministic dependency graph computation
  - Parse, validate, cycle detection, phase computation, critical path
  - Output: text, JSON, mermaid, validate mode
  - 24 unit tests
- **LLM-as-user adaptive eval mode** — persona-based Claude instance plays user for
  testing interactive skills
- **Judge reference + categorical rubric criteria** — calibrated quality evaluation
  for implementation plans (excellent/good/adequate/weak/poor per criterion)
- **Calibration plans** — good-plan (4.8/5) and mediocre-plan (1.5/5) for judge tuning
- **11 new context library cards** — eval harness system, DAG engine system, implementation
  planning capability, implementation plan structure, success outcome component,
  3 decisions, 2 lessons, 1 anti-pattern
- **14 existing card updates** — WHEN sections and WHERE relationships reflecting
  Releases 1+2

### Changed
- Step 8 rewritten: planner documents library updates in library-updates.md for
  Conan/Sam to process (planning and library are discrete systems)
- Eval harness supports three modes: single-prompt, multi-turn, adaptive

## [0.3.0] — 2026-03-26

### Added
- **Eval infrastructure** — reusable harness for testing conversational skills
  - `tests/run-eval.sh`: runner with multi-turn support via `claude -p --resume`
  - `tests/lib/judge.sh`: LLM-as-Judge framework with per-skill criteria
  - `tests/lib/structural-checks.sh`: pluggable deterministic check framework
  - `--compare` mode for regression detection against checked-in baselines
  - Auto-detects single-prompt vs multi-turn from `## Turn N` headers in inputs.md
  - Version hashing in run-metadata.json (git SHA, skill hash, eval case hash)
  - Historical run storage (`.gitignored`, baselines checked in)
- **Wizard eval cases** — three configurations with full multi-turn transcripts
  - Factory × High × High (22-area pool, mixed declarations)
  - No/Low AI × Low × Low (10-area pool, all absent)
  - Pair Programmer × High × Moderate (18-area pool, free-text notes)
  - All cases: 13/13 structural checks, 10-12/12 judge criteria
- **Test fixtures for Release 2** — seeded context libraries
  - TaskFlow: 5 sample cards (vision, entities, systems, decision)
  - Blank Slate: wizard config only (tests graceful degradation)
  - MediConnect: 5 sample cards (vision, persona, entities, anti-pattern, decision)
- **Implementation planning design** — complete plan for Release 2
  - Success Outcomes as first-class objects with scope tiers (Must/Should/Could)
  - DAG tool design (deterministic phase computation, mermaid output)
  - Research recommendations from 26 Fowler articles (24 recommendations triaged)
  - 15 implementation tickets
  - Companion skill designs: `/reassess-plan`, `/complete-plan`

### Changed
- Eval runner unit tests added to CI (15 tests)
- CLAUDE.md updated with merge policy (wait for all CI + Devin Review)

## [0.2.0] — 2026-03-23

### Added
- **Version tracking + upgrade path**
  - `VERSION` file (semver, synced with plugin.json)
  - `bin/alexandria-update-check`: checks GitHub for newer versions with smart
    caching (60min/12h TTLs), graceful network failure, semver comparison
  - `bin/alexandria-version`: prints current version
  - `skills/alexandria-upgrade/SKILL.md`: upgrade skill (git + vendored installs)
  - 18 unit tests for update check
- **Setup script** (`./setup`)
  - One-command install for Claude Code (plugin symlink + skill symlinks)
  - `--host` flag (claude default, codex/cursor stubbed for future)
  - `--uninstall` to clean up
  - Idempotent (safe to re-run), detects clone-into-plugins-dir path
  - 22 unit tests
- **ADR 001: dual-mode distribution** — plugin.json for Claude, symlinks for others
- **Wizard gap analysis engine** (issue #5)
  - Step 5: knowledge declaration, gap scoring, sequencing
  - Scoring: `tier_weight × gap_severity` / `tier_weight × freshness_penalty`
  - Edge cases: empty declaration, all-present, Foundation gaps with present Core
  - 18 unit tests (qa-gap-analysis.sh)
- **Wizard solicitation & output layer** (issue #7)
  - Step 6: impact statements, solicitation prompt selection with mode variants
  - Assessment document output following intake-output-template.md
  - 4 test suites in qa-solicitation.sh

### Changed
- Plugin version bumped from 0.1.0 to 0.2.0
- README updated with real install one-liner and Updating section
- CLAUDE.md expanded with structure map, dev workflow, testing section
- CI: fast tests (update-check, setup) run on every PR alongside plugin validation

## [0.1.0] — 2026-03-19

### Added
- **Initial plugin structure**
  - `.claude-plugin/plugin.json` manifest
  - Agents: Conan (librarian), Sam (scribe)
  - Skills: wizard (Steps 1-4), context-briefing, conan skills, sam skills
  - Templates: reference.md, library-readme.md
- **Wizard configuration engine** (issue #3)
  - 3-question configuration (AI mode, domain novelty, product complexity)
  - 22-category knowledge catalog with sensitivity profiles
  - Tier assignment engine (Foundation/Core/Amplifier/Deprioritized)
  - 36 configuration verification targets
- **Wizard engine data** — wizard-engine.yaml with pools, profiles, overrides
- **CI: plugin validation** — `claude plugin validate .` on every PR
