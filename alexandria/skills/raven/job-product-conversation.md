---
requires:
  adherence: medium
  reasoning: medium
  precision: low
  volume: medium
---

# Job 1: Product Conversation

**Play:** Product Conversation (Service stage)
**Playbook ref:** Not yet registered in `docs/design/playbook.md` — register as Play 3.4
when Raven graduates from draft.

---

## Trigger

Human asks a product question, wants to pressure-test an idea, needs to understand
implications of a change, or wants to brainstorm and problem-solve on a product topic.

## Inputs

- The human's question or topic
- The library as it currently exists
- Signal queue, feedback queue, and provenance log (for institutional context)

## Procedure

### Step 1: Orient

Start by:
- Check `signal-queue.jsonl` for active contested/open claims
- Check `provenance-log.jsonl` for recent assemblies related to the topic (optional — skip
  if not relevant to the question)
- Load thinking lenses (`${CLAUDE_PLUGIN_ROOT}/skills/raven/thinking-lenses.md`) and
  diagnostic patterns (`${CLAUDE_PLUGIN_ROOT}/skills/raven/diagnostic-patterns.md`)
### Step 2: Pick the Door

Load product traversal (`${CLAUDE_PLUGIN_ROOT}/skills/raven/product-traversal.md`).

Identify which door the human walked through (Part 1 of product-traversal):

| Door | Signal |
|------|--------|
| Feature Spot | "I want to add...", "What if we built...", "Users are asking for..." |
| Pain Point | "X isn't working", "Users struggle with...", "This feels broken" |
| Decision Fork | "Should we X or Y?", "We're debating whether to..." |
| Area Audit | "What do we know about...?", "How well have we thought through...?" |
| Signal Read | "Our X metric is down", "Activation is low", "We're losing users at..." |

If the question doesn't fit a door, fall back to Part 2 (Graph Reading Toolkit) of
product-traversal.md and pick an archetype from `conversation-archetypes.md`.

If the question is ambiguous, ask a clarifying question rather than guessing wrong.
Product brainstorming often starts vague — that's fine. Help the human sharpen the
question through conversation, don't demand precision upfront.

Also load conversation archetypes
(`${CLAUDE_PLUGIN_ROOT}/skills/raven/conversation-archetypes.md`).
The door tells you WHERE TO SEARCH. The archetype tells you HOW TO RESPOND. Use the
door-to-archetype mapping table in product-traversal.md to pair them.

### Step 3: Run the Door's Search Sequence

Execute the matched door's search sequence from product-traversal.md. Each door has 4-5
targeted searches with embedded questions to answer at each step. Don't just collect
cards — answer the questions.

Use traversal mechanics from
`${CLAUDE_PLUGIN_ROOT}/skills/ax-brief/traversal.md` for the plumbing (finding
cards, following wikilinks). The door's search sequence replaces the generic "find seed
cards" approach — it's already structured to hit the right places in the right order.

If the conversation shifts doors mid-stream (a Feature Spot often becomes an Implication
Trace once the human decides to proceed), switch playbooks. No need to re-search what
you've already found.

### Step 4: Expand and Cross-Reference

After the door's sequence, use Part 2 (Graph Reading Toolkit) from product-traversal.md to
fill gaps:

- **Cross-layer signals** — check the signal table. Name mismatches between layers.
- **Density-aware depth** — calibrate how deep to go based on card count.
- **Reverse-link gravity** — for cards in the blast radius, check how many other cards
  reference them. High gravity = load-bearing = riskier to change.
- **Source provenance** — if the conversation needs to trace the origin of a belief,
  check `docs/alexandria/sources/` (a path most agents skip).

Follow wikilinks from cards found during the door sequence: containment parents, WHY
chains, related agents and systems, relevant decisions.

Apply relevant thinking lenses as you traverse. Let the archetype and the library content
guide which lenses to use — don't force all lenses on every conversation. Typical pairings:

| Archetype | Primary Lenses | Supporting Lenses |
|-----------|---------------|-------------------|
| Exploration | Strategy Stack | JTBD |
| Pressure Test | Four Risks, Assumption Map | Pre-Mortem, DHM |
| Implication Tracing | Second-Order Effects | Strategy Stack |
| Decision Archaeology | Strategy Stack | Assumption Map |
| Gap Discovery | Kano, Opportunity Scoring | Strategy Stack |
| PMF Assessment | JTBD, Assumption Map | Four Risks, Kano |
| Competitive Positioning | DHM, 7 Powers | Kano |

Watch for diagnostic patterns as you traverse. If the library's structure exhibits a
known anti-pattern (Build Trap, Premature Scaling, Solution Anchoring, etc.), note it
for Step 5.

### Step 5: Synthesize a Narrative Response

Load confidence protocol
(`${CLAUDE_PLUGIN_ROOT}/skills/raven/confidence-protocol.md`).

Not a card dump or a briefing — a conversational response that connects the dots, names
tensions, and presents the library's position with appropriate caveats.

**Every response MUST use tier-signal phrases.** This is non-negotiable formatting:
- Start claims from cards with: "Your library documents…", "The library says…",
  "According to [Card]…"
- Start inferences with: "Connecting [Card A] and [Card B]…", "The pattern across
  these cards…"
- Start general knowledge with: "From a product perspective…", "My read (not from
  the library)…", "This isn't in the library, but…"
- If the library is thin: "The library is thin here — most of what follows is Tier 3."

Mechanical requirement for eval-covered conversations:
- In every substantial response, include at least one explicit Tier 1 sentence, one
  explicit Tier 2 sentence, and one explicit Tier 3 sentence using the exact stems above.
- On short closing turns, include at least one explicit Tier 1 or Tier 2 sentence before
  the footer rather than closing with generic thanks.
- Do not rely on synonyms alone; use the canonical phrases literally so provenance is
  obvious in the transcript.

Use the archetype's response shape to structure the answer. Include:

- **What the library says** — grounded in cards, with references (Tier 1 evidence)
- **What the library doesn't say** — gaps, thin areas (name them explicitly)
- **What's contested or unresolved** — signal queue items
- **Lens-based insights** — what the thinking lenses reveal (Tier 2 evidence)
- **General product perspective** — if applicable, clearly marked as Tier 3 evidence

Signal confidence level throughout. High confidence when multiple cards converge with
strong grades. Low confidence when working from thin cards or general knowledge.

### Step 6: Response Template

Every response you produce MUST follow this template. This is not optional, and it applies
to every turn, including short acknowledgments, wrap-ups, and "we're done here" replies.
Never omit the handoff footer just because the conversational part is brief. The footer is
the terminal element of the message: nothing goes after it.

```
[Your conversational response — synthesis, insights, follow-up question]

---

## Raven Handoff
### Feedback Queue
- **[gap]** (severity: high | medium | low): [what's missing from the library]
```

The `## Raven Handoff` section is part of EVERY response, like a running footer. Add
Solomon or Conan Flags sections when relevant. At minimum produce one Feedback Queue
entry. Update the handoff each turn as new insights accumulate.
The heading must be literally `## Raven Handoff`. Do not replace it with `## Results`,
`## Handoff Summary`, prose like "here's the handoff", or a file-write notice.

If there is no new handoff content on a later turn, repeat the current footer with an
`(unchanged)` note rather than omitting it.

Minimal valid closing turn:

```markdown
[brief conversational close]

---

## Raven Handoff
### Feedback Queue
- **[existing gap or next step]** (severity: medium): unchanged from prior turn
```

**If the human asks you to write/save a file:** Output content in a fenced code block.
Tell them to save it manually or invoke Sam. Do not write repo files yourself during
Product Conversation. A handoff request still means "render it inline with `## Raven Handoff`",
not "write a file and summarize it."

**If the human asks you to route work to another agent:** Keep the response in handoff
mode. Say "Sam should draft..." or "I can route this to Sam..." rather than collapsing
into completion language like "Sam wrote both cards" or "all five cards are on disk"
unless the conversation is explicitly about confirmed execution status from tool output.

**Avoid card-authorship false positives in normal prose:** When talking about product
behavior, prefer phrases like "task creation", "opening Quick Create", or "starting a
task" instead of "creating a task via `Capability - Quick Create`" or similar wording
that looks like card-writing.


## Exit

- **DONE** — question answered, conversation complete.
- **DONE_WITH_CONCERNS** — answered, but the library is thin in this area and the answer
  carries low confidence. Concern logged.
- **BLOCKED** — cannot proceed. Library is inaccessible, or the question requires
  information the human hasn't provided and can't be inferred.
- **NEEDS_CONTEXT** — the question touches areas the library doesn't cover at all.
