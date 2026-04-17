---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Context Briefing Protocol

Contract for context delivery between the library system and consuming agents.

**Roles:**

- **Bridget** (assembler) — assembles context briefings from the library
- **Builder agents** (code writers) — consume briefings during software implementation
- **Sam** (scribe) — writes and fixes library cards, NOT code
- **Conan** (quality guardian) — grades library cards, consumes feedback from assembly

The current architecture has four agents. Bridget assembles and delivers briefings, builder agents consume briefings and write code, Sam writes library cards, Conan grades and maintains the library. Where this document says "the consumer," it means whichever agent is using the briefing — typically a builder agent writing code, but also Sam when writing cards that depend on product context.

---

## Context Briefing: CONTEXT_BRIEFING.md

**Output filename:** The file MUST be named exactly `CONTEXT_BRIEFING.md` — never use custom or task-specific names.

Bridget writes this file before the consuming agent begins work. The consumer reads it as primary context.

### Structure

```markdown
# Context Briefing

## Task Frame

**Task:** [what needs to be built/modified]
**Target type:** [System | Component | Section | Domain | Template | Capability | Artifact | Governance | Agent | Prompt | Primitive | Loop | Journey | Experience Goal | Force]
**Task type:** [feature | bug | refactor | new | architecture]
**Constraints:** [non-negotiable boundaries]
**Acceptance criteria:** [how to know it's done]

## Primary Cards (full content)

### [Card Name]

**Type:** [card type]
**Relevance:** [why this card matters for this task]

[Full card content — all 5 dimensions]

### [Card Name]

...

## Supporting Cards (summaries)

| Card          | Type     | Key Insight                         |
| ------------- | -------- | ----------------------------------- |
| [[Card Name]] | System   | [one-line summary relevant to task] |
| [[Card Name]] | Standard | [one-line summary relevant to task] |

...

## Relationship Map

- Card_A depends-on Card_B (Card_A needs Card_B's state data)
- Card_B implements Standard_X (Card_B must conform to Standard_X's rules)
- Card_A invokes Capability_Y (Card_A triggers Capability_Y's workflow)
  ...

## Gap Manifest

| Dimension | Topic               | Searched | Found | Recommendation |
| --------- | ------------------- | -------- | ----- | -------------- |
| WHY       | [missing rationale] | yes      | no    | [what to do]   |

...

## Completion Status

**Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
```

### Retrieval default

Bridget should not manually recreate traversal, budgeting, and ordering once seed cards and
the retrieval profile are known.

Default assembly path:

1. Find 1-4 seed cards with `Glob`/`Grep`.
2. Call the retrieve CLI:

```bash
ax retrieve --seeds "System - Foo,Component - Bar" --profile <type> --complexity <tier> --library docs/alexandria/library --format json
```

3. Use the CLI output as the candidate set and ordering scaffold for the briefing. Do not
   re-rank the returned cards by hand; use the CLI's `beginning`, `middle`, and `end`
   positions directly for the U-shaped attention order.
4. Read the returned cards, verify mandatory categories, inspect WHEN/HOW anti-patterns,
   and do targeted manual follow-up only when seeds are missing, required categories are
   still absent, or the CLI is unavailable.
5. If the task hinges on discoverability, disclosure, governance, or other UX exposure
   tradeoffs, follow WHY links from the returned cards so governing principle cards stay in
   the final selection.
6. If a mandatory category is still missing after the CLI result, Bridget may use targeted
   fallback search, but must log the missing category, the fallback action taken, and the
   reason in `provenance-log.md`.
7. When the provenance log records the retrieval command, name the routed surface exactly
   as `ax retrieve`. If the library path differs from the default, only substitute
   the `--library` value; do not switch back to the legacy `bin/alexandria-retrieve`
   wrapper name in new output.

The CLI is the deterministic selector. Bridget still owns judgment-heavy work: task
classification, relevance framing, gap honesty, and narrative assembly.

When filling the primary-card budget, prioritize:

1. the direct target card or surface
2. hard dependency systems or standards that can block correct implementation
3. governing WHY / experience / disclosure cards that materially constrain the task

Prefer supporting summaries for precedent capabilities, sibling components, or data cards
unless they add a unique constraint the builder cannot safely infer from the primary set.

### Card budget by task complexity

| Complexity             | Primary Cards | Supporting Cards | Total |
| ---------------------- | ------------- | ---------------- | ----- |
| Simple (single file)   | 2-3           | 3-5              | 5-8   |
| Medium (single module) | 3-5           | 5-8              | 8-13  |
| Complex (cross-system) | 4-6           | 6-10             | 10-16 |
| Architecture change    | 5-8           | 8-12             | 13-20 |

---

## Ordering for Attention

LLMs exhibit U-shaped attention (beginning and end strongest). Order context accordingly:

1. **Beginning (highest attention):** Task frame + primary cards
2. **Middle (lowest attention):** Relationship map + supporting card summaries
3. **End (second-highest attention):** WHY/architectural cards + constraints + anti-patterns from HOW sections

When a card serves both primary and WHY-chain purposes, include it as a primary card at the beginning AND extract its anti-patterns to the end section.

---

## Inquiry Protocol (5-Signal Decision Matrix)

Any agent working with library content — builder agents during code implementation, Sam during card creation — uses this protocol when encountering uncertainty about product concepts.

### 5-Signal Decision Matrix

| Signal                 | Proceed Autonomously                           | Search the Library                                       |
| ---------------------- | ---------------------------------------------- | -------------------------------------------------------- |
| **Reversibility**      | Easily undone (formatting, tests, comments)    | Hard to reverse (schema, API contracts, data migrations) |
| **Context coverage**   | All relevant dimensions present in briefing    | Missing cards in any dimension for affected area         |
| **Precedent**          | Similar pattern exists in briefing or codebase | Novel pattern with no precedent                          |
| **Blast radius**       | Change affects single file/card                | Change propagates across multiple systems                |
| **Domain specificity** | General patterns                               | Product-specific knowledge                               |

**Rule: 2+ "Search" signals → MUST search the library before proceeding**

**Note on Sam:** Sam the Scribe also uses this matrix, but during _card creation_, not code implementation. When Sam encounters uncertainty about product concepts while writing a card (e.g., "is this a System or a Capability?"), the same protocol applies. The signals map slightly differently: "reversibility" means how hard it is to fix a card classification error, "blast radius" means how many downstream cards would inherit a mistake.

### Query Format

When the consuming agent needs more context, log this before searching:

```
UNCERTAINTY: [dimension — WHAT/WHY/WHERE/HOW/WHEN]
TOPIC: [specific subject]
DEFAULT ASSUMPTION: [what I'll do if no answer]
IMPACT IF WRONG: [what changes]
SEARCH: Grep for "[terms]" in docs/alexandria/
```

### Search Techniques

| Need                             | Technique                                                         |
| -------------------------------- | ----------------------------------------------------------------- |
| Find a card by name              | `Glob` for `**/[Type] - [Name].md`                                |
| Find cards about a topic         | `Grep` for topic terms across `docs/alexandria/`             |
| Find cards in a dimension        | `Grep` for content under `## WHY:` or `## HOW:` headers           |
| Find cards that reference a card | `Grep` for `[[Card Name]]` across the library                     |
| Follow a WHY chain upstream      | Read card → follow `[[Principle -` and `[[Product Thesis -` links |

### Loop Prevention

- **Max rounds:** 3 follow-up searches per uncertainty
- **Novel query requirement:** Each search must use different terms than previous
- **Confidence check:** If confidence doesn't improve after a round, proceed with default assumption and document it
- **Escalation:** After max rounds, document uncertainty in provenance log and proceed with default OR flag for human input

---

## Handoff Flow

```
1. Task arrives (user request or issue)
       │
       ▼
2. Bridget receives task description
       │
       ▼
3. Bridget identifies target type + task type
       │
       ▼
4. Bridget loads retrieval profile for that type
       │
       ▼
5. Bridget finds seed cards (Grep/Glob/Read)
       │
       ├── 1-4 seeds selected
       └── Retrieval profile confirmed
       │
       ▼
6. Bridget calls `ax retrieve`
       │
       ├── Traversal expanded deterministically
       ├── Budget + ordering scaffold returned (`beginning` / `middle` / `end`)
       └── Missing seeds surfaced as warnings
       │
       ▼
7. Bridget verifies mandatory categories / gaps
       │
       ├── Read returned cards
       ├── Targeted follow-up search only if needed
       ├── Log missing-category fallback decisions to provenance-log.md
       └── Gaps identified honestly
       │
       ▼
8. Bridget writes `CONTEXT_BRIEFING.md`
       │
       ▼
9. Bridget logs assembly to provenance-log.md
       │
       ▼
10. Bridget triages assembly insights → actionable items
     to feedback-queue.md (gaps, weak cards,
     retrieval misses, relationship discoveries)
       │
       ▼
11. Builder agent reads `CONTEXT_BRIEFING.md`
       │
       ▼
12. Builder agent implements code, querying library
   when uncertain (5-signal matrix)
       │
       ▼
13. Builder agent logs decisions to provenance-log.md
       │
       ▼
14. Builder agent updates decision outcomes after task
       │
       ▼
15. If implementation changed product concepts:
    Sam updates affected library cards
```

**Note:** Sam the Scribe also consumes briefings in a parallel workflow — when writing _library cards_ (not code) that depend on product context. Sam's handoff flow is: Bridget assembles briefing → Sam reads briefing → Sam writes cards → Conan grades cards. This is distinct from the builder agent flow above.

---

## Relationship Types

When mapping relationships in the briefing, use these edge types:

| Relationship       | Meaning                     | Example                           |
| ------------------ | --------------------------- | --------------------------------- |
| `depends-on`       | Requires this to function   | System depends-on Primitive       |
| `implements`       | Realizes this specification | Section implements Standard       |
| `constrained-by`   | Must conform to this        | Component constrained-by Standard |
| `contains`         | Parent-child spatial        | Domain contains Section           |
| `invokes`          | Triggers this workflow      | Section invokes Capability        |
| `extends`          | Builds on this              | Principle extends Product Thesis  |
| `coordinates-with` | Peer relationship           | Agent coordinates-with Agent      |
| `operates-on`      | Acts on this data           | Capability operates-on Primitive  |
| `manages`          | Oversees lifecycle of       | Agent manages Artifact            |
