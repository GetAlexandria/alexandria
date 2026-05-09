---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Intake Traversal

How to read the knowledge graph as a signal triage analyst. Two parts:
1. **Signal doors** — six entry-point-specific intake sequences (primary strategy)
2. **Intake graph reading toolkit** — techniques for comparing claims against the graph

---

## Part 1: Signal Doors

Six ways signal arrives at the library. Each door is a focused recipe: what to ask, what
to search, how to extract claims, what the human probably forgot. Pick the door that
matches the signal type, run its sequence.

### How to Use

1. Read the human's opening message
2. Match it to a door (see signal phrases)
3. Run that door's intake sequence — it replaces generic "read the library"
4. After the door sequence, proceed to claim extraction (claim-extraction.md)
5. Then run tension detection (tension-detection.md) on each extracted claim

If the signal doesn't fit a door, skip to Part 2 and use the general toolkit.

---

### Door 1: Meeting Notes

**Signal phrases:** "Here are the notes from...", "We had a meeting about...", "Notes from
the strategy review...", "Team sync notes..."

**What the human has:** A mix of decisions, discussions, and action items. Some important,
some noise. All jumbled together.

**What they're probably missing:** Which statements are actually decisions vs. discussions.
Whether the "decisions" contradict anything in the library. Whether attendee authority
covers the decision scope.

**Ask first:** "Was this a decision-making meeting or a discussion meeting?" This
calibrates your extraction aggressiveness. Decision meetings produce more settled claims.

**Search 1 — Topic scan.** Identify the meeting's domain(s) and check library coverage.
```
Grep: "<meeting topic>" path="docs/alexandria/"
```
Map the meeting to library areas. **Do we have existing positions on these topics?** This
determines whether claims will be net-new or potentially contradictory.

**Search 2 — Decision layer check.** Look for existing decisions in this domain.
```
Grep: "<meeting topic>" path="docs/alexandria/temporal/"
```
Existing Decision and Initiative cards in this area = claims that could fire T1. Read them
before extracting claims so you can spot contradictions during extraction, not after.

**Search 3 — Signal queue echo.** Check for parked claims on the same topics.
```
Grep: "<meeting topic>" path="docs/alexandria/signal-queue.jsonl"
```
A meeting about a topic that already has contested claims in the queue → likely producing
resolving or compounding signal. Flag the connection.

**Search 4 — Authority baseline.** Check who has authority in this domain.
```
Grep: "<role or name>" path="docs/alexandria/sources/"
```
If existing library positions cite specific authority (founder decision, board directive),
you need comparable authority to override. Note the bar.

**Surface:** Library coverage map for meeting topics, existing decisions that could
conflict, active signal queue items on these topics, authority bar for this domain.

**Then:** Extract claims using Recipe 1 from claim-extraction.md.

---

### Door 2: Executive Directive

**Signal phrases:** "CEO said...", "Founder decided...", "Leadership announced...",
"[Senior person] told us...", "Board decision:..."

**What the human has:** Clear authority. A directive with weight behind it.

**What they're probably missing:** Whether this contradicts settled library positions. The
blast radius — what changes downstream. Whether the reasoning behind the directive is as
strong as the authority.

**Ask first:** "Is this a final decision or a direction being explored?" Even executives
float ideas. Calibrate accordingly.

**Search 1 — Contradiction scan.** Check what the library currently says about this topic.
```
Grep: "<directive topic>" path="docs/alexandria/product/"
Grep: "<directive topic>" path="docs/alexandria/rationale/"
```
Read WHAT and WHY sections. **Does this directive reverse an existing position?**

**Search 2 — Blast radius.** If the directive contradicts the library, how much changes?
```
Grep: "[[Card - Name]]" path="docs/alexandria/"
```
For each card that would change, check how many other cards reference it. High-gravity
cards = high blast radius. Count affected cards by type.

**Search 3 — Thesis alignment.** Check whether the directive aligns with Product Theses.
```
Read: docs/alexandria/rationale/product-theses/
```
**Does this directive reinforce or undermine foundational beliefs?** A directive that
conflicts with a Product Thesis is T2 even if authority is clear.

**Search 4 — Signal queue check.** Is this directive resolving something already parked?
```
Grep: "<directive topic>" path="docs/alexandria/signal-queue.jsonl"
```
Executive directives often resolve long-parked contested claims. If so, this triage
session may also resolve queue items.

**Surface:** Contradictions with library positions, blast radius count, thesis tensions,
queue items that might resolve.

**Then:** Extract claims using Recipe 2 from claim-extraction.md.

---

### Door 3: Slack Thread

**Signal phrases:** "This Slack thread has implications...", "There's a debate in Slack
about...", "Check this conversation...", "The team is arguing about..."

**What the human has:** Multiple voices, multiple perspectives, probably no resolution.

**What they're probably missing:** Whether a resolution was actually reached. Which voices
carry authority. Whether the positions are new or re-litigating something already decided.

**Ask first:** "Did this thread reach a conclusion, or did it trail off?" This determines
whether you're looking for a settled claim or mapping a contested landscape.

**Search 1 — Topic scan.** What library areas does this thread touch?
```
Grep: "<thread topic>" path="docs/alexandria/"
```
Map to library areas. **Is this thread about something the library has strong positions
on, or unexplored territory?**

**Search 2 — Prior decisions.** Has this been decided before?
```
Grep: "<thread topic>" path="docs/alexandria/temporal/"
```
**Are they re-litigating a settled decision?** If so, the thread is either evidence that
the decision should be revisited (new information) or noise (disagreement without new
grounds). Check what's changed since the original decision.

**Search 3 — Signal queue echo.** Is this thread an extension of a known debate?
```
Grep: "<thread topic>" path="docs/alexandria/signal-queue.jsonl"
```
Slack threads often echo parked contested claims. If so, the thread adds new voices or
evidence to an existing item.

**Search 4 — Authority mapping.** Identify who's in the thread.
For each distinct position in the thread, note the holder's role and authority scope.
**Does anyone in the thread have the authority to settle this?**

**Surface:** Library positions on the topic, prior decisions, signal queue echoes,
authority map of participants.

**Then:** Extract claims using Recipe 3 from claim-extraction.md.

---

### Door 4: Customer Signal

**Signal phrases:** "Customer told us...", "Support tickets show...", "Usage data says...",
"User research found...", "NPS comments mention..."

**What the human has:** External data. Signal from outside the team.

**What they're probably missing:** Whether this is one voice or a pattern. How it maps to
library concepts. Whether the library has a theory about why this is happening.

**Ask first:** "Is this one customer or a pattern across multiple customers?" The answer
determines evidence tier (E3 anecdote vs. E1/E2 data).

**Search 1 — Topic mapping.** What part of the product does this signal concern?
```
Grep: "<customer topic>" path="docs/alexandria/product/"
```
Map the customer signal to specific product areas, capabilities, or systems.

**Search 2 — Experience layer.** Does the library have a designed experience for this?
```
Grep: "<customer topic>" path="docs/alexandria/experience/"
```
Look for Journeys, Loops, Experience Goals. **Did we articulate how this should feel? Is the
customer signal about a gap between designed intent and actual experience?**

**Search 3 — Feedback queue.** Has this shown up before?
```
Grep: "<customer topic>" path="docs/alexandria/feedback-queue.jsonl"
```
If the feedback queue already has entries about this area, the customer signal is
corroborating evidence. Multiple independent sources pointing the same way is significant.

**Search 4 — Thesis grounding.** Do we have a theory about this area?
```
Grep: "<customer topic>" path="docs/alexandria/rationale/"
```
**Are our product beliefs consistent with what customers are telling us?** Customer signal
that conflicts with a Product Thesis is high-value — either our thesis is wrong or the
customer is encountering a specific edge case.

**Surface:** Product area mapping, experience-layer coverage (or gap), prior feedback
signals, thesis alignment/tension.

**Then:** Extract claims using Recipe 4 from claim-extraction.md.

---

### Door 5: Raven Handoff

**Signal phrases:** Raven handoff block pasted as input (inline from conversation transcript).

**What the human has:** Pre-extracted claims with library context already identified.
This is the cleanest input — Raven has done the hard work.

**What they're probably missing:** Nothing significant — Raven handoffs are pre-filtered.
Solomon's job is tension detection, not discovery.

**No initial questions needed.** Read the handoff note and proceed.

**Search 1 — Read the handoff.** Load the handoff note. Read Key Claims, Library Context,
and Suggested Action.

**Search 2 — Signal queue echo.** Quick check for connections to parked items.
```
Grep: "<handoff topic>" path="docs/alexandria/signal-queue.jsonl"
```

**Search 3 — Verify library context.** Spot-check the cards Raven referenced. Raven
reads the library during conversation but may have worked with stale context.
```
Read: <card paths from handoff note>
```
**Do the cards still say what Raven thought they said?**

**Surface:** Validated claims from handoff, signal queue connections, any stale context.

**Then:** Extract claims using Recipe 5 from claim-extraction.md (mostly validation).

---

### Door 6: Document / Research

**Signal phrases:** "Read this document...", "Here's a whitepaper about...", "Competitor
published...", "I wrote a design doc for..."

**What the human has:** Structured external knowledge. Often long. Often contains far more
than what's relevant to the library.

**What they're probably missing:** Which parts of the document actually affect the library.
How the document's claims map to existing library positions.

**Ask first:** "What should the library take away from this? Are there specific sections
or conclusions you want triaged?"

Scoping is critical. A 20-page document should not produce 20 claims. The human knows
which parts matter.

**Search 1 — Scope to library.** Identify document topics, map to library areas.
```
Grep: "<document topics>" path="docs/alexandria/"
```
Focus extraction on topics where the library HAS existing positions (contradiction
potential) or SHOULD have positions (gap-filling potential).

**Search 2 — Existing positions.** For each relevant library area, read the current cards.
```
Read: <relevant card paths>
```
**What does the library currently believe about the topics this document covers?**

**Search 3 — Decision history.** Has this topic area been decided before?
```
Grep: "<document topics>" path="docs/alexandria/temporal/"
```
A design doc proposing something that contradicts a prior ADR needs explicit supersession.

**Search 4 — Evidence assessment.** What kind of evidence does the document itself present?
Check for: primary data, cited research, expert analysis, or bare assertion. This maps
directly to the evidence protocol (E1-E4).

**Surface:** Library scope mapping, existing positions, decision history, document's own
evidence quality.

**Then:** Extract claims using Recipe 6 from claim-extraction.md.

---

### Door-to-Recipe Mapping

| Door | Recipe | Typical Batch Size | Speed |
|------|--------|-------------------|-------|
| Meeting Notes | Recipe 1 | 4-8 claims | Medium |
| Executive Directive | Recipe 2 | 1-3 claims | Fast |
| Slack Thread | Recipe 3 | 3-6 claims | Slow (multi-voice) |
| Customer Signal | Recipe 4 | 1-4 claims | Medium |
| Raven Handoff | Recipe 5 | 1-3 claims (pre-extracted) | Fastest |
| Document / Research | Recipe 6 | 2-6 claims (scoped) | Slow (long source) |

---

## Part 2: Intake Graph Reading Toolkit

Techniques for comparing incoming claims against the existing library. Used within door
sequences and during tension detection.

---

### Contradiction Scan

The core triage operation: does this claim conflict with what the library says?

1. **Find the relevant card(s).** Search by topic in `docs/alexandria/`.
2. **Read the WHAT section.** This is what the card asserts. Compare directly with the
   incoming claim.
3. **Read the WHY section.** This is the reasoning. A claim may agree with WHAT but
   undermine WHY (or vice versa).
4. **Check for partial contradiction.** The claim might agree with 80% of a card but
   contradict one specific aspect. Note the specific disagreement.

**If the library has nothing:** No contradiction is possible. Note the void. The claim
is net-new signal — likely settled if authority and evidence are clear.

---

### Echo Detection

Connecting incoming claims to parked signal queue items.

Read `signal-queue.jsonl`. For each active (unresolved) item, check four relationships:

| Relationship | What It Means | What Solomon Does |
|-------------|---------------|-------------------|
| **Resolves** | New claim provides the evidence or authority needed to settle a parked claim | Present both. "This new claim may resolve the [date] contested item about X." |
| **Reinforces** | New claim adds a voice or evidence on the same side as a parked position | Note the reinforcement. Doesn't settle alone but strengthens one side. |
| **Contradicts** | New claim takes the opposite side of a parked position | Add as a new position on the contested item. The debate deepens. |
| **Compounds** | New claim + parked claim together imply something neither says alone | Surface the combined implication. This is high-value — emergent insight. |

---

### Blast Radius Assessment

When a claim would change existing library positions, how big is the impact?

1. **Identify directly affected cards.** These are cards whose WHAT or WHY would change
   if the claim is settled.
2. **Count reverse links.** For each affected card, how many other cards reference it?
   ```
   Grep: "[[Card - Name]]" path="docs/alexandria/" output_mode="count"
   ```
3. **Weight by type.** Changes to different card types have different propagation patterns:

| Card Type | Blast Weight | Why |
|-----------|-------------|-----|
| Product Thesis | Critical | Everything traces back to theses via WHY chains |
| Standard | High | Many cards "Conforms to" standards |
| Principle | High | Referenced across all layers |
| System | Medium | Components and Capabilities depend on Systems |
| Agent | Medium | Capabilities, Plays, and coordination patterns depend on Agents |
| Decision (Artifact) | Medium | Cited as precedent by other decisions and cards |
| Capability | Low-Medium | Usually contained within one agent's scope |
| Component, Section, Domain | Low | Mostly leaf nodes with few reverse references |

4. **Report the radius.** "If this claim is settled, N cards need updating. The highest-
   impact card is [Type - Name] (referenced by M other cards)."

---

### Authority Provenance

Tracing who decided what and whether new claims meet the authority bar.

1. **Check existing card provenance.** Read the card's WHEN section and any linked Decision
   cards. Who established the current position? A founder? A team vote? An unstated
   assumption?
2. **Compare authority levels.** The incoming claim's authority must be at least
   comparable to the authority that established the current position. A team discussion
   doesn't override a board decision. An individual opinion doesn't override team consensus.
3. **Note authority gaps.** If the existing position has no clear authority provenance
   (it just appeared in the library), the bar is lower. Any clear authority can settle.

---

### Standing Requirements Check

What is the library actively trying to learn? Modeled on intelligence analysis: signal
that addresses active questions gets priority.

**Standing requirements sources:**

1. **Signal queue open questions.** Items with status `open_question` are things we're
   actively trying to learn.
2. **Feedback queue gaps.** Items with type `gap` are areas where builders need knowledge
   that doesn't exist yet.
3. **Health report weak areas.** Cards that Conan has flagged as weak are areas where
   new evidence is especially valuable.

When a claim addresses a standing requirement, flag it: "This claim speaks to an open
question from the [date] triage session." Signal that fills known gaps deserves more
careful attention than signal about well-covered topics.
