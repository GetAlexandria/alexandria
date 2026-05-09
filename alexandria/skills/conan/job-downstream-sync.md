---
requires:
  adherence: medium
  reasoning: low
  precision: high
  volume: medium
---

# Job: Downstream Sync

After any structural library change, verify and fix all meta-files that reference library structure. These files drift silently whenever types are added, terminology is renamed, folder structure changes, or cards are created/deleted in bulk.

## When to Run

**Auto-trigger** after completing any maintenance job that:

- Adds, removes, or renames types in the taxonomy
- Creates or reorganizes folder structure
- Renames terminology across the library (e.g., Strategy → Product Thesis)
- Adds or removes significant numbers of cards
- Changes templates or section naming conventions

Also run on explicit request: "sync downstream" or "check the meta-files."

## The Manifest

Files that mirror library structure and must stay in sync with `docs/alexandria/reference.md` (the canonical source of truth).

### Agent Definitions

| File                       | Sync Points                                                                                                                      |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `${CLAUDE_PLUGIN_ROOT}/agents/conan.md`  | Target type list (Step 2), decision tree steps, containment relationships table, library structure description ("What You Know") |
| `${CLAUDE_PLUGIN_ROOT}/agents/sam.md`    | Library Organization table                                                                                                       |
### Skill Files — Sam

| File                                  | Sync Points                                                     |
| ------------------------------------- | --------------------------------------------------------------- |
| `${CLAUDE_PLUGIN_ROOT}/skills/sam/card-creation.md`  | Type list, WHERE templates per type, folder paths, build order  |
| `${CLAUDE_PLUGIN_ROOT}/skills/sam/decomposition.md`  | Decision tree steps, common confusions table, SOT pattern table |
| `${CLAUDE_PLUGIN_ROOT}/skills/sam/link-patterns.md`  | Example card names, terminology                                 |
| `${CLAUDE_PLUGIN_ROOT}/skills/sam/self-check.md`     | Example card names, terminology                                 |

### Skill Files — Context Briefing

| File                                                    | Sync Points                                                                                            |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `${CLAUDE_PLUGIN_ROOT}/skills/ax-brief/retrieval-profiles.md` | One profile per type, example card names (must match actual cards), mandatory categories summary table |
| `${CLAUDE_PLUGIN_ROOT}/skills/ax-brief/traversal.md`          | Folder path examples in "Finding Cards" section                                                        |
| `${CLAUDE_PLUGIN_ROOT}/skills/ax-brief/protocol.md`           | Relationship types, target type mentions                                                               |

### Skill Files — Conan

| File                                | Sync Points                          |
| ----------------------------------- | ------------------------------------ |
| `${CLAUDE_PLUGIN_ROOT}/skills/conan/rubrics.md`            | Type signal table, terminology                           |
| `${CLAUDE_PLUGIN_ROOT}/skills/conan/job-audit.md`          | Decision tree reference, terminology                     |
| `${CLAUDE_PLUGIN_ROOT}/skills/conan/job-inventory.md`      | Type list in output template, build order phases         |
| `${CLAUDE_PLUGIN_ROOT}/skills/conan/job-spot-check.md`     | Type references, grading criteria                        |
| `${CLAUDE_PLUGIN_ROOT}/skills/conan/job-diagnose.md`       | Terminology (Product Thesis/Principle references)        |
| `${CLAUDE_PLUGIN_ROOT}/skills/conan/grade-computation.md`  | Experience layer type list, folder paths                 |
| `${CLAUDE_PLUGIN_ROOT}/skills/conan/job-health-check.md`   | Type references, health check criteria                   |

### Library Documentation

| File                                   | Sync Points                                                                                                   |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `docs/alexandria/reference.md`    | Canonical type taxonomy, templates, folder structure, naming conventions — this is the SOURCE, not the target |
| `docs/alexandria/README.md`       | Card counts per type, type descriptions, library structure summary                                            |

## Procedure

### Step 1: Establish current library state

Read `docs/alexandria/reference.md` to get the canonical:

- Type list (all types with their folder paths)
- Template section headers per type
- Naming conventions and terminology
- Folder structure

Then Glob actual card files to get:

- Real card names per type folder (for example validation)
- Actual folder structure

### Step 2: Audit each manifest file

For each file in the manifest, read it and check each sync point against current library state. Flag any:

| Deviation                     | Example                                                               |
| ----------------------------- | --------------------------------------------------------------------- |
| **Missing type**              | New type in reference.md but absent from a type list or decision tree |
| **Stale type**                | Type listed in meta-file but removed from reference.md                |
| **Wrong examples**            | Example card names that don't match actual cards                      |
| **Stale terminology**         | Old naming that was renamed (check watch list below)                  |
| **Missing folder paths**      | New folders not reflected in path examples                            |
| **Missing retrieval profile** | Type exists but has no profile in retrieval-profiles.md               |
| **Stale section headers**     | Template section names changed but not reflected in meta-files        |

### Step 3: Fix deviations

For each deviation found, make the edit directly. These are meta-files (agent definitions, skill procedures), not library cards — editing them is within Conan's scope for this job.

Priority order:

1. **Type lists and decision trees** — these gate classification decisions
2. **Retrieval profiles** — these gate context assembly quality
3. **Folder paths and examples** — these affect navigation
4. **Terminology** — consistency, but least likely to cause functional errors

### Step 4: Report

Output a summary:

```
DOWNSTREAM SYNC COMPLETE
Files checked: N
Files updated: N (list)
Files clean: N
Changes made:
- [file]: [what changed]
- [file]: [what changed]
Remaining issues: [any that need human judgment]
```

## Terminology Watch List

Known renames to check for (add to this list as renames happen):

| Old                      | New                       | When    |
| ------------------------ | ------------------------- | ------- |
| Strategy                 | Product Thesis            | 2026-03 |
| Constellation Protocol   | Context Briefing Protocol | 2026-03 |
| Zone                     | Domain                    | 2026-03 |
| Room                     | Section                   | 2026-03 |
| Structure                | Template                  | 2026-03 |
| Overlay                  | Governance                | 2026-03 |
| Dynamic                  | Force                     | 2026-03 |
| Aesthetic                | Experience Goal           | 2026-03 |
