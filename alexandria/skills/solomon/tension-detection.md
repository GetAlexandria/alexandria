---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Tension Detection

Seven tension signals Solomon checks for each extracted claim. Tension signals are mechanical
observations, not judgments — Solomon surfaces them, the human interprets them.

---

## T1: Direct Contradiction

**What Solomon does:** Claim X asserts the opposite of what Card Y says in WHAT or WHY.
Solomon quotes both.

**How to check:** Search the library for cards related to the claim's topic. Read their WHAT
and WHY sections. Compare assertions. If the claim and the card make incompatible statements,
T1 fires.

**Example:** "The notes say 'we're dropping Feature X.' The library says
[[Artifact - Decision: Feature X Rollout]] with a planned implementation path."

**Note:** T1 fires on routine updates too. A clean update is T1 + clear authority + human
confirms = Supersedes. T1 alone does not mean contested — it means "the library and the
signal disagree. Which is right?"

---

## T2: Thesis/Principle Tension

**What Solomon does:** Claim X is compatible with one Product Thesis but in tension with
another. Solomon names both.

**How to check:** Read all Product Thesis and Principle cards. Check whether the claim
aligns with some and conflicts with others. This is especially important for claims that
implicitly prioritize one product value over another.

**Example:** "This aligns with Thesis A (speed) but undermines Thesis B (quality). Both are
Foundation-tier."

---

## T3: Authority Ambiguity

**What Solomon does:** The signal doesn't make clear who decided this, or the decision-maker's
scope doesn't obviously cover this area. Solomon flags the gap.

**How to check:** Read the raw signal for attribution. Who said this? Was it a group
discussion or an individual directive? Does the signal distinguish between "we discussed"
and "we decided"? Check the existing card for its own authority provenance — if the existing
position cites a founder decision and the new claim cites a team discussion, that's T3.

**Example:** "The notes attribute this to a team discussion. No individual decision-maker
named. The existing card cites a founder decision."

---

## T4: Evidence Gap

**What Solomon does:** The claim is asserted without supporting evidence, and the existing
library position has evidence (or vice versa). Solomon notes the asymmetry.

**How to check:** Does the claim cite data, user research, experiments, customer feedback,
or other evidence? Does the existing library position? An evidence-backed position being
challenged by an unsupported assertion is T4. An unsupported library position being
challenged by an evidence-backed claim is also T4 (in the other direction — the library
may be the weak one).

**Example:** "The library's current position cites 3 customer interviews. The new claim
cites no evidence."

---

## T5: Signal Queue Echo

**What Solomon does:** This claim connects to or contradicts a previously parked contested
or open claim. Solomon surfaces the connection.

**How to check:** Read `signal-queue.jsonl`. Look for entries with overlapping
`affected_cards`, related claims, or the same topic area. A new claim may:
- Resolve a parked claim (new evidence arrives)
- Reinforce a parked claim (additional voice on the same side)
- Contradict a parked claim (new voice on the opposite side)
- Compound with a parked claim (together they imply something neither says alone)

**Example:** "This touches the same area as a contested claim from the March 12 triage —
that one is still unresolved."

---

## T6: Blast Radius

**What Solomon does:** If this claim is true, Solomon traces which cards are affected.
High blast radius doesn't mean contested — it means "get this right."

**How to check:** If the claim were settled and became a source update, which cards would
need to change? Search for the topic across the library. Follow wikilinks from affected
cards to their dependents. Count by type (Standards and Product Theses being affected is
more significant than a single Component card).

**Example:** "If this is settled, 8 cards need updating including 2 Standards and 1 Product
Thesis."

---

## T7: Internal Signal Conflict

**What Solomon does:** Two claims from the same signal batch (same meeting, same thread)
point in different directions.

**How to check:** After extracting all claims from a single raw signal source, compare them
pairwise. Do any pair make incompatible assertions? This is common in meeting notes where
different participants expressed different views that both got captured.

**Example:** "Claim 3 says 'we're going enterprise.' Claim 7 says 'keep the solo-builder
focus.' Both came from the same meeting notes."

---

## Presentation Format

For each claim, present:

```
CLAIM: [the claim, stated as a single assertion]
SOURCE: [who said this, in what context] — Reliability: [A-F]
EVIDENCE: [what supports it] — Credibility: [1-6], Tier: [E1-E4]
LIBRARY SAYS: [what the library currently says, with card references — or "nothing"]
LIBRARY EVIDENCE: [evidence behind library position] — Tier: [E1-E4]
ASYMMETRY: [if present — which side has stronger evidence]
TENSIONS: [which tension signals fired, with evidence]
AFFECTED: [cards that would change if this claim becomes settled]
```

**Zero tensions:** Flag as likely settled. Human still confirms.

**One or more tensions:** Do NOT classify. Present tensions and ask: **"Is this settled?"**
