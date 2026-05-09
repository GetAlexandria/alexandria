---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Handoff Templates

Raven's boundary outputs. The handoff block goes **inline in the transcript** as a rolling
summary. When items are clear and actionable, Raven dispatches the relevant agent directly
using the Agent tool rather than waiting for the human to relay the work.

Produce the handoff block from Turn 4 onward (Job 1, Step 7). This is mandatory. The
handoff block is the last thing in the response; do not add a sentence after it.

---

## Handoff Block Format

Output this fenced block in every response from Turn 4 onward:

~~~markdown
## Raven Handoff

### Solomon
<!-- New insight, contested claims, strategic thinking to formalize -->
- **[topic]** (triage: new-source | contested-claim | signal-queue-entry): [what Solomon
  should receive and why]

### Feedback Queue
<!-- Library gaps — what's missing, severity, card types to fill it -->
- **[gap]** (severity: high | medium | low): [what's missing, what card types would fix it]

### Conan Flags
<!-- Stale or weak cards revealed by conversation -->
- **[Card Name]** (flag: stale | weak | contradicted): [what's wrong]

### Bridget
<!-- Build decisions reached — context for a builder briefing -->
- **[decision]**: [what to build and why]
~~~

Omit sections with no findings. Every conversation produces at least one Feedback Queue
entry (if nothing else, gaps you traversed).

---

## Severity Guide

| Severity | When |
|----------|------|
| **high** | Human's question unanswerable from library. Conversation mostly Tier 3. |
| **medium** | Partial coverage, heavy inference required. |
| **low** | Topic covered but adjacent area thin. Found during traversal, not blocking. |

---

## Routing Decision

| Conversation Outcome | Section |
|---------------------|---------|
| New strategic thinking not in library | Solomon |
| New connection discovered between cards | Solomon |
| Contested claim emerges | Solomon (triage: contested-claim) |
| Cards don't exist for the topic | Feedback Queue (type: gap) |
| Dimension too thin | Feedback Queue (type: weak_card) |
| Missing wikilink discovered | Feedback Queue (type: relationship_discovery) |
| Card content contradicts known truth | Conan Flags (flag: stale/contradicted) |
| Human says "we should build this" | Bridget |
| Purely exploratory, no findings | Still produce Feedback Queue for traversed gaps |

---

## Multiple Outputs

One conversation can produce entries in all four sections.
