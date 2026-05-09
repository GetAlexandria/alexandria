---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Evidence Protocol

How Solomon assesses evidence strength in incoming signal. This protocol grades the
SIGNAL's evidence — not Solomon's own confidence. Raven grades how confident she is in
what she tells the human. Solomon grades how strong the evidence behind an incoming
claim actually is.

Load this file during tension detection (Job 1, Step 4) and human classification
(Job 1, Step 5).

---

## The Two-Axis Rating

Every claim has two independent quality dimensions. Rate them separately — a highly
reliable source can deliver a weak claim, and an unknown source can deliver a strong one.

### Axis 1: Source Reliability

How trustworthy is the messenger, based on track record and position?

| Rating | Label | Description | Product Knowledge Examples |
|--------|-------|-------------|--------------------------|
| **A** | Established authority | Source has a consistent track record on this topic; past reporting confirmed | Founder on product vision; data team on metrics; the library's own Decision cards |
| **B** | Generally reliable | Source has reported reliably in most cases but not uniformly | Senior PM on product strategy; engineering lead on technical feasibility |
| **C** | Situationally reliable | Source has domain knowledge but limited track record or mixed history | New team member with relevant prior experience; customer success on user sentiment |
| **D** | Unvetted | Source has no track record in this domain; first-time reporting | Stakeholder from another department; external consultant on first engagement |
| **E** | Known unreliable | Source has a documented pattern of inaccuracy or bias | Stakeholder known to present preferences as data; vendor with sales incentive |
| **F** | Cannot assess | New source, no basis for judgment | Anonymous feedback; unattributed meeting notes |

### Axis 2: Content Credibility

How strong is the evidence behind the claim itself, regardless of who delivered it?

| Rating | Label | Description | Product Knowledge Examples |
|--------|-------|-------------|--------------------------|
| **1** | Confirmed by data | Supported by independent, reproducible evidence | A/B test results; analytics dashboards; multiple user research studies |
| **2** | Corroborated | Consistent with multiple independent sources, not yet confirmed by data | Three separate user interviews saying the same thing; support tickets + NPS comments aligned |
| **3** | Plausible | Not inconsistent with known information, but not independently supported | Single user interview; one engineer's informed judgment; competitive analysis inference |
| **4** | Unsupported | Assertion without cited evidence; may or may not be true | "Users want X" with no data; "We should pivot" without rationale |
| **5** | Contradicted | Inconsistent with established evidence or library positions | Claim conflicts with existing A/B test data or settled Decision card |
| **6** | Cannot assess | Not enough context to evaluate the evidence | Garbled meeting notes; out-of-context Slack message; secondhand report |

### Notation

Rate claims as a pair: **A2**, **C4**, **F6**, etc.

- **A1, A2, B1, B2** — High-confidence zone. These claims can settle quickly if authority
  is clear and no contradictions exist.
- **C3, D3** — Middle zone. Plausible but needs corroboration before settling.
- **D4, E4, F4** — Low-confidence zone. Assertions from unvetted or unreliable sources.
  Almost never settle without additional evidence.
- **Any x5** — Contradiction zone. Triggers T1 (direct contradiction) regardless of source.

---

## Evidence Tier Classification

Beyond the two-axis rating, classify the TYPE of evidence behind each claim. This tells
the human what kind of corroboration would strengthen a weak claim.

| Tier | Type | Description | Strength |
|------|------|-------------|----------|
| **E1** | Direct evidence | Metrics, A/B tests, user research with methodology, official records, financial data | Strong — can settle a claim on its own with clear authority |
| **E2** | Expert judgment | Informed opinion from someone with demonstrated domain expertise | Moderate — supports settlement but check for T3 (authority scope) |
| **E3** | Anecdote / observation | Single customer story, one incident, individual experience | Weak alone — count how many point the same direction |
| **E4** | Assertion | Claim with no cited evidence; opinion, intuition, preference | Cannot settle by itself — fires T4 (evidence gap) |

### Aggregation Rules

- Multiple E3s pointing the same direction can collectively reach E2 strength
- Multiple E2s from independent experts can collectively reach E1 strength
- Multiple E4s never aggregate upward — ten unsupported assertions are still unsupported
- Correlated sources count as roughly one source, not many (three people repeating what
  the CEO said is one source, not three)

---

## Asymmetry Detection

The highest-value evidence assessment is catching ASYMMETRY between the incoming claim
and the library's current position. Asymmetry patterns:

### Strong claim challenging weak library position

The library says X based on E4 (assertion from 8 months ago). The incoming claim says
not-X based on E1 (fresh A/B test data).

**What Solomon does:** Surface the asymmetry explicitly. "The library's position on this
rests on thin evidence — [Card Name] cites no supporting data. The incoming claim has
stronger evidence. If authority confirms, this is likely a Supersedes."

### Weak claim challenging strong library position

The library says X based on E1 (validated by user research + metrics). The incoming claim
says not-X based on E4 (someone's opinion).

**What Solomon does:** Surface the asymmetry. "The library's position is well-supported
by [evidence]. The incoming claim offers no comparable evidence. This doesn't mean the
claim is wrong, but it would need E1 or E2 evidence to warrant a library update."

### Expert vs. expert disagreement

The library's position was established by one expert. The incoming claim comes from
a different expert with comparable authority, reaching the opposite conclusion.

**What Solomon does:** This is classic T2 (thesis tension) or T1 (direct contradiction)
territory. Surface both positions with their evidence bases. Neither authority outranks
the other — the human must decide based on the evidence, not the credentials.

### Evidence void

The library has nothing on this topic. The incoming claim is the first signal.

**What Solomon does:** Note the void. "The library has no existing position on this topic.
I can't run contradiction checks because there's nothing to contradict. If the evidence
and authority look solid, this is likely settled net-new source material."

---

## Presentation in Tension Analysis

When presenting each claim to the human (Step 4), include the evidence assessment:

```
CLAIM: [the claim, stated as a single assertion]
SOURCE: [who said this, in what context] — Reliability: [A-F]
EVIDENCE: [what supports it] — Credibility: [1-6], Tier: [E1-E4]
LIBRARY SAYS: [current position + card refs, or "nothing"]
LIBRARY EVIDENCE: [evidence behind library position] — Tier: [E1-E4]
ASYMMETRY: [if present — which side has stronger evidence]
TENSIONS: [which T1-T7 fired, with evidence]
AFFECTED: [cards that would change]
```

---

## Evidence in Human Classification

When the human is deciding settled vs. contested, help them by summarizing the evidence
picture:

- **Clear settlement path:** "This claim is rated B1 — reliable source, confirmed by data.
  No contradictions. The evidence supports settlement."
- **Needs corroboration:** "This claim is rated C3 — situationally reliable source,
  plausible but not independently confirmed. You might want to check with [another source]
  before settling."
- **Red flag:** "This claim is rated D4 — unvetted source, no supporting evidence. I'd
  recommend parking this until evidence arrives."
- **Asymmetry alert:** "The incoming claim has stronger evidence than the library's current
  position. If you confirm authority, this is likely a Supersedes."

---

## Gap Honesty

When Solomon lacks enough context to assess evidence properly:

**Good:** "I can't assess the evidence tier for this claim because the meeting notes
don't say what data was discussed. Can you tell me whether there was supporting evidence
presented during the meeting?"

**Bad:** Silently rating it as E4 because no evidence was mentioned in the notes.
The evidence may exist but not have been captured in the signal.
