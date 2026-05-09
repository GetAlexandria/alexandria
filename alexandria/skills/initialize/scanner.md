---
name: scanner
description: >
  Scan a codebase to discover product-level entities and domain structure.
  Tier 1: uses only directory and file names (no file content reading).
  Tier 2: reads file contents for Tier 1 candidates to extract fields, routes, and relationships.
  Called by the initialize when the user has code to scan.
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Codebase Scanner

Discover product-level entities and domain structure by analyzing a codebase. Tier 1 uses
only the file tree (directory and file names). Tier 2 optionally reads file contents for
Tier 1 candidates to extract fields, routes, relationships, and dead code signals.

## When to Use

- When setting up an Alexandria and the product already has code
- When the initialize needs candidate nouns to seed the knowledge graph
- When you want a quick structural overview of a codebase's domain model

## Tier 1: File Tree Investigation

Tier 1 uses ONLY the file tree — it never reads file contents.

### Step 1: Run the Deterministic Scanner

Do not re-implement Tier 1 with manual Glob/Grep work when the CLI is available. Run:

```bash
ax scan <path>
```

This command performs the mechanical Tier 1 work in software:

- scans framework-agnostic pattern directories such as `models/`, `schemas/`,
  `entities/`, `routes/`, `api/`, `controllers/`, `components/`, `pages/`,
  `views/`, `templates/`, `features/`, `modules/`, `domains/`, `apps/`, and
  `services/`
- extracts candidate nouns from file names
- strips common suffixes and normalizes casing
- filters known infrastructure, test, and build noise
- groups candidates by domain structure or safe structural heuristics
- assigns confidence from cross-layer evidence

The CLI emits JSON with:

- summary counts
- grouped candidates
- per-candidate `name`, `group`, `confidence`, `type_hint`, `layers`, and evidence paths

### Step 2: Interpret the Tier 1 Output

Treat the CLI output as proposal data, not confirmed knowledge.

- Use the grouped summary to orient the user: how many candidates, how many groups,
  where the strongest evidence sits
- Use each candidate's evidence paths to explain why it was proposed
- Preserve uncertainty honestly: low-confidence or speculative grouping stays
  speculative until the human confirms it
- Do NOT infer product rationale, priority, or card content from the scan alone

### Step 5: Assign Confidence Levels

The CLI assigns confidence based on the breadth of evidence:

| Confidence | Criteria |
|-----------|---------|
| **high** | Entity appears in 3+ layers: model/schema + routes/API + UI (components/pages). This is almost certainly a core product entity. |
| **medium** | Entity appears in 2 layers: model + routes, OR model + UI, OR routes + UI. Likely a real entity but may be secondary. |
| **low** | Entity appears in only 1 layer: model only, route only, UI only, or directory name only. Could be real but needs validation. |

**Counting layers:**
- Model layer: `models/`, `schemas/`, `entities/`
- API layer: `routes/`, `api/`, `controllers/`, `services/`
- UI layer: `components/`, `pages/`, `views/`, `templates/`
- Domain layer: `features/`, `modules/`, `domains/`, `apps/`

A candidate that appears in `models/user.py` AND `routes/users.py` AND `components/UserProfile.tsx`
has evidence in 3 layers = high confidence.

A candidate that only appears in `models/audit_log.py` has evidence in 1 layer = low confidence.

### Step 6: Classify Type Hints

The CLI assigns a type hint based on where the entity was found:

| Type Hint | When to Assign |
|-----------|---------------|
| `entity` | Found in models/, schemas/, or entities/ — this is a data entity |
| `feature` | Found in features/, modules/, routes/, controllers/, or api/ without a model — this is a feature/capability |
| `page` | Found only in pages/ or views/ — this is a UI surface |
| `domain` | A domain-level grouping directory (features/billing/, modules/auth/) — represents a bounded context |
| `service` | Found only in services/ — this is a backend capability |

If an entity appears in multiple locations, prefer `entity` > `feature` > `service` > `page`.
The `domain` type is only for the group itself, not for entities within it.

### Step 7: Present Results

Use the JSON output to drive a grouped conversational summary.

**If only Tier 1 was run:**

```
## Codebase Discovery — Tier 1 (File Tree)

Scanned [N] directories, [M] files.
Found [X] candidate product entities in [Y] domain groups.

### [Domain Group 1]
| Entity | Type | Confidence | Evidence |
|--------|------|-----------|----------|
| [name] | [entity/feature/page/domain/service] | [high/medium/low] | [comma-separated file paths] |

### [Domain Group 2]
| Entity | Type | Confidence | Evidence |
|--------|------|-----------|----------|
| [name] | [entity/feature/page/domain/service] | [high/medium/low] | [comma-separated file paths] |

### Ungrouped (if any)
| Entity | Type | Confidence | Evidence |
|--------|------|-----------|----------|
| [name] | [entity/feature/page/domain/service] | [high/medium/low] | [comma-separated file paths] |

---

**Summary:**
- High confidence: [N] entities (appear across 3+ layers)
- Medium confidence: [N] entities (appear across 2 layers)
- Low confidence: [N] entities (appear in 1 layer only)

**Filtered out:** [N] infrastructure/utility names excluded (e.g., [list a few examples])

**Note:** This is Tier 1 (file tree only). Confidence levels are based on directory
structure alone. A future Tier 2 scan (file contents) would refine these proposals by
examining actual class definitions, schema fields, and route handlers.
```

**If Tier 2 was also run, enrich the output:**

```
## Codebase Discovery — Tier 1 + Tier 2

Scanned [N] directories, [M] files. Read [K] files for Tier 2 evidence.
Found [X] candidate product entities in [Y] domain groups.

### [Domain Group]
| Entity | Type | Confidence | Fields | Routes | UI | Dead Code? |
|--------|------|-----------|--------|--------|----|------------|
| [name] | [type] | [high/medium/low] | [N fields] | [CRUD coverage] | [N components] | [yes/no] |

#### [Entity Name] — Detail
- **Fields:** id, name, email, status (active/archived), created_at
- **Routes:** GET /users, POST /users, GET /users/:id, PUT /users/:id (CRUD)
- **UI components:** UserProfile, UserList, UserSettings
- **Relationships:** has_many Orders, belongs_to Organization
- **Dead code signals:** none

#### [Entity Name] — Detail (dead code flagged)
- **Fields:** id, code, amount, expires_at
- **Routes:** none found
- **UI components:** none found
- **Relationships:** belongs_to User
- **Dead code signals:** Model exists but no routes or UI reference it — possibly abandoned

---

**Summary:**
- High confidence: [N] entities (3+ evidence layers)
- Medium confidence: [N] entities (2 evidence layers)
- Low confidence: [N] entities (1 evidence layer)
- Dead code signals: [N] entities flagged for review

**Filtered out:** [N] infrastructure/utility names excluded
**Tier 2 files read:** [K] files ([token estimate] tokens)
```

Only show the detail blocks for entities where Tier 2 found meaningful enrichment (fields,
routes, or dead code signals). Low-confidence entities with no Tier 2 enrichment can stay
in the summary table without a detail block.

**Presentation guidelines:**

- Sort domain groups alphabetically
- Within each group, sort by confidence (high first), then alphabetically
- Show at most 5 evidence paths per entity; if more exist, show 5 and append "(+N more)"
- Use relative paths from the project root
- If the project is very large (500+ candidate files), summarize by domain group counts
  and only show high/medium confidence entities in the table. List low-confidence entities
  as a bullet list below.

## Tier 2: Schema + Route Scanning

Tier 2 deepens Tier 1 proposals by reading actual file contents. It ONLY reads files
associated with Tier 1 candidates — it does not scan the entire codebase.

### When to run Tier 2

Run Tier 2 after Tier 1 completes. Tier 2 is recommended when:
- Tier 1 found candidates with low confidence (only directory-level evidence)
- The user wants richer evidence before confirming entities
- The codebase is large enough that domain grouping needs refinement

Tier 2 is optional — Tier 1 proposals are sufficient for the noun proposal dialogue.

### Step T2-1: Read model/schema files

For each Tier 1 entity candidate found in a models/, schemas/, or entities/ directory:
1. Read the file content
2. Extract field names and types
3. Identify relationships: foreign keys, references to other entities, belongs_to/has_many
4. Note any status/state fields that suggest lifecycle (e.g., status, state, active, archived)

Record: entity name → fields list, relationships list, lifecycle indicators

### Step T2-2: Read route/API files

For each Tier 1 candidate found in routes/, api/, or controllers/ directories:
1. Read the file content
2. Extract route patterns and HTTP methods (GET /users, POST /billing/subscribe, etc.)
3. Group routes by resource (all /users/* routes → User entity)
4. Note CRUD completeness: does this entity have create, read, update, delete?

Record: entity name → routes list, CRUD coverage

### Step T2-3: Read component/page files

For each Tier 1 candidate found in components/, pages/, views/, or templates/ directories:
1. Read the file (or at minimum the imports and export name)
2. Extract component names and props
3. Note which entities are referenced in the UI layer
4. Identify page-level components vs. reusable components

Record: entity name → UI components list, page presence

### Step T2-4: Detect dead code signals

Cross-reference Tier 1 + Tier 2 evidence to flag potential dead code:
- **Model without routes:** Entity has a model/schema but no API endpoints → possibly abandoned
- **Routes without UI:** API endpoints exist but no UI components reference them → possibly backend-only or abandoned
- **Model without any references:** Schema exists but nothing references it → likely dead

Flag these as `dead_code_signal: true` on the proposal. Do NOT remove them from proposals — present them to the user with the flag so they can decide.

### Step T2-5: Enrich proposals

Update each Tier 1 proposal with Tier 2 evidence:
- Add `fields` array (from model/schema reading)
- Add `routes` array (from route/API reading)
- Add `ui_components` array (from component/page reading)
- Add `relationships` array (foreign keys, references)
- Upgrade confidence: low → medium if 2+ evidence layers found, medium → high if 3+ layers
- Add `dead_code_signal` boolean
- Add `crud_coverage` summary (e.g., "CR" for create+read only, "CRUD" for full)

### Token cost control

Tier 2 reads file CONTENTS, which is more expensive than Tier 1. Control costs:
- Only read files associated with Tier 1 candidates (not all files)
- For large files (>200 lines), read only the first 50 lines (usually enough for models/schemas) and the export/class declaration
- Skip test files, migration files, and generated files
- If more than 50 files would need reading, ask the user: "Tier 2 scanning would read [N] files. Want to proceed, or focus on [top 10 by confidence]?"

## Key Constraints

1. **Tier 1: file tree only** — Tier 1 never reads file contents. Only use directory names and file names.
2. **Tier 2: candidate files only** — Tier 2 reads file contents ONLY for Tier 1 candidates. Never scan the entire codebase.
3. **Dead code signals are flags, not removals** — Tier 2 flags potential dead code but never removes candidates. The user decides.
4. **Token cost control** — Tier 2 limits file reading: skip tests/migrations/generated files, truncate large files, prompt user if >50 files.
5. **Product-level nouns** — Output should be things a product person would recognize, not implementation details like "BaseRepository" or "AbstractFactory."
6. **Framework-agnostic** — These heuristics work across Python, JavaScript/TypeScript, Ruby, Go, Rust, Java, Kotlin, C#, Elixir, and Scala projects. Do not assume any specific framework.
7. **Filter aggressively, but keep borderline cases** — It is better to include a low-confidence candidate than to miss a real product entity. The human will review.
8. **No hallucination** — Every candidate must have at least one real file path as evidence. Never invent entities that do not appear in the file tree.
