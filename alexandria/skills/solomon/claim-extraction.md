---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Claim Extraction

How Solomon decomposes raw signal into discrete, well-formed claims. This is the bridge
between "someone said a bunch of stuff" and "here are the specific assertions that may
affect the library."

Load this file during Step 3 of job-signal-triage.md.

---

## What Makes a Well-Formed Claim

A claim is a single assertion that either does or doesn't affect the library's current state.

**Well-formed claim checklist:**

1. **Single assertion.** One fact, one decision, one direction. Not compound.
2. **Specific enough to check.** You can search the library and determine whether the
   claim agrees, disagrees, or is net-new.
3. **Attributable.** You know who said it and in what context.
4. **Evidence-linked.** You can identify what (if anything) supports it — data, authority,
   anecdote, or nothing.

**Example — decomposing a compound statement:**

Raw: "We decided to drop Feature X and focus on Platform Y because the TAM
for other platforms is too small and our engineering team is already stretched."

Well-formed claims:
- CLAIM 1: We decided to drop Feature X. [decision — check authority]
- CLAIM 2: We will focus exclusively on Platform Y. [direction — implied by claim 1]
- CLAIM 3: The TAM for non-Platform-Y alternatives is too small to justify. [assertion — check evidence]
- CLAIM 4: Engineering capacity is a constraint on platform support. [assertion — check evidence]

Claims 1-2 are the decisions. Claims 3-4 are the reasoning. All four need separate
tension analysis because the reasoning could be wrong even if the decision is settled.

---

## Six Extraction Recipes

Each recipe matches a signal door from intake-traversal.md. The door tells you how to
INTAKE the signal. The recipe tells you how to EXTRACT claims from it.

### Recipe 1: Meeting Notes

**Signal shape:** Minutes, transcripts, or summaries. Mix of decisions, discussion, and
action items.

**The key distinction: decided vs. discussed.**

Meetings produce three types of content:
1. **Decisions** — "We agreed to X." "The team decided Y." Authority is clear.
2. **Discussions** — "We talked about X." "Several views were shared." No resolution.
3. **Action items** — "Alice will investigate X by Friday." Task assignment, not knowledge.

**Extraction steps:**

1. **Scan for decision language.** Look for: "decided," "agreed," "going forward we will,"
   "the conclusion was," "approved," "signed off on." Each of these is a claim candidate.
2. **Scan for discussion language.** Look for: "discussed," "explored," "considered,"
   "debated," "raised the question of." These signal CONTESTED territory — multiple views
   exist.
3. **Separate the decisions from the reasoning.** A meeting note might say "We decided to
   use Postgres because MySQL doesn't support JSONB well enough." That's two claims: the
   decision (Postgres) and the reasoning (MySQL's JSONB limitation). The reasoning might
   be wrong.
4. **Flag action items but don't extract them.** "Alice will look into X" is a task, not a
   knowledge claim. Skip it unless the action item implies a decision ("Alice will migrate
   us to Postgres" implies the Postgres decision was made).
5. **Note who was in the room.** Authority depends on attendees. A meeting of the founding
   team carries different authority than an engineering standup.

**Common trap:** Meeting notes say "we" without specifying who. "We decided" could mean the
whole company or two people in a breakout. Ask the human: "Who was in this meeting?"

### Recipe 2: Executive Directive

**Signal shape:** Clear authority statement from a founder, CEO, or domain leader.

**Extraction steps:**

1. **Extract the directive itself.** Usually one or two claims. "We're pivoting to
   enterprise" or "Stop all work on feature X."
2. **Separate the directive from the reasoning.** The exec may say why. The "why" is a
   separate claim with potentially weaker evidence.
3. **Check for implicit claims.** "We're pivoting to enterprise" implicitly claims:
   consumer isn't working, enterprise is viable, the team can execute an enterprise
   strategy. Surface these — they may be contested even if the directive itself has
   authority.
4. **Note the authority scope.** A CEO directive on product strategy carries full authority.
   A VP of Engineering directive on pricing strategy may not.

**Common trap:** Treating the directive as automatically settled. Authority is clear, but
contradiction (leg 2 of the settledness test) still needs checking. A CEO directive that
contradicts a recent board decision is T1 + T3 territory.

### Recipe 3: Slack Thread

**Signal shape:** Multi-voice, informal, often internally contradictory. May trail off
without resolution.

**Extraction steps:**

1. **Identify the participants.** Who's in the thread? Note roles and authority levels.
2. **Map the positions.** In a multi-voice thread, different people say different things.
   Extract each distinct position as a separate claim attributed to its holder.
3. **Check for convergence.** Did the thread reach agreement? Look for: thumbs-up reactions
   on a specific message, "sounds good," "let's do that," final summary message. If yes,
   the convergent position is a stronger claim.
4. **Check for trail-off.** If the thread just stops without resolution, every position
   is automatically contested — T7 (internal signal conflict) fires.
5. **Watch for the loudest-voice trap.** The longest message or the most senior person's
   view may not be the group consensus. Count voices, not words.

**Common trap:** Treating a Slack thread as a decision forum. Unless the thread explicitly
reaches a conclusion ("OK we're going with X"), it's discussion, not decision.

### Recipe 4: Customer Signal

**Signal shape:** User feedback, support tickets, usage data, interview notes.

**Extraction steps:**

1. **Separate observation from interpretation.** "Users are churning because the onboarding
   is bad" is two claims: "Users are churning" (check data) and "Onboarding quality is the
   cause" (interpretation — check evidence).
2. **Count the signal.** One customer complaint is an anecdote (E3). Five complaints about
   the same thing is a pattern (approaching E2). Statistical data is evidence (E1).
3. **Check the customer segment.** Enterprise customer feedback and consumer customer
   feedback may point different directions. Both can be valid.
4. **Look for the underlying need, not the surface request.** "Users want a dark mode" is
   a feature request. "Users work late at night and find the bright UI uncomfortable" is a
   need. Extract the need if the raw signal provides enough context.

**Common trap:** Treating one passionate customer's feedback as representative. Ask: "Is
this one customer or a pattern?"

### Recipe 5: Raven Handoff

**Signal shape:** Structured handoff note from `sources/incoming/`. Pre-extracted claims
with library context already identified.

**Extraction steps:**

1. **Read the handoff note's Key Claims section.** Raven has already done initial
   extraction. Claims are pre-formed.
2. **Validate the claims.** Raven may have been in a conversational mode and over-extracted
   (included opinions as claims) or under-extracted (missed implicit claims).
3. **Skip to tension detection.** The point of a Raven handoff is that the signal has
   already been filtered through a product conversation. The human and Raven agreed this
   was worth triaging. Don't re-interrogate the source — go straight to T1-T7.

**Time saver:** Raven handoffs are the fastest door. Library context is already in the
note. You're validating claims and running tensions, not extracting from scratch.

### Recipe 6: Document / Research

**Signal shape:** Whitepapers, competitor analyses, industry reports, design documents.

**Extraction steps:**

1. **Identify the document type.** Internal (design doc, RFC, ADR) vs. external
   (competitor analysis, market research, academic paper). This affects source reliability.
2. **Extract claims relevant to the library.** A 20-page competitor analysis may contain
   200 assertions. Only extract claims that touch topics the library covers or should cover.
3. **Map claims to library areas.** For each extracted claim, identify which library cards
   or zones it relates to. This is scope-matching, not tension detection.
4. **Assess the evidence tier.** Documents often cite their own evidence. Note what it is:
   primary data (E1), expert analysis (E2), case study (E3), or assertion (E4).

**Common trap:** Trying to extract every claim from a long document. Focus on claims that
are RELEVANT TO THE LIBRARY. If the library has nothing on competitive pricing and the
document has 10 pages on competitive pricing, extract one or two framing claims and note
the topic as a potential library gap.

---

## Batch Management

The number of claims affects how Solomon presents them.

### Small batch (1-3 claims)

Present all claims at once with full tension analysis. The human can hold all of them in
working memory.

```
I extracted 3 claims from the strategy review notes. Here's the full picture:

CLAIM 1: [claim]
SOURCE: [who, context] — Reliability: [A-F]
EVIDENCE: [basis] — Credibility: [1-6], Tier: [E1-E4]
LIBRARY SAYS: [position + card refs, or "nothing"]
LIBRARY EVIDENCE: [evidence behind library position] — Tier: [E1-E4]
ASYMMETRY: [if present — which side has stronger evidence]
TENSIONS: [T1-T7 that fired]
AFFECTED: [cards]

CLAIM 2: ...
CLAIM 3: ...

Ready to classify? Or want to dig into any of these first?
```

### Medium batch (4-7 claims)

Present a summary first, then walk through one at a time. Group by topic if claims
cluster around 2-3 areas.

```
I extracted 6 claims from the meeting notes, touching 3 areas:
- Product strategy (2 claims — 1 has tensions, 1 is clean)
- Technical architecture (3 claims — 2 have tensions)
- Team process (1 claim — clean)

Want me to start with the ones that have tensions, or work through all of them in order?
```

### Large batch (8+ claims)

The signal is dense. Don't present everything at once. Triage the triage:

1. **Separate the clean from the tense.** Claims with zero tensions can often be batched:
   "These 4 claims are net-new, no contradictions, no authority issues. Likely all settled.
   Want to confirm them as a group?"
2. **Walk through tension claims one at a time.** These need individual attention.
3. **Flag internal conflicts (T7) early.** If claims from the same batch contradict each
   other, surface that before walking through individual claims.

```
I extracted 11 claims from the strategy review. Here's the landscape:

CLEAN (5 claims): Net-new, no tensions. I can list them for batch confirmation.
TENSIONS (4 claims): Each has at least one T-signal. Need individual attention.
INTERNAL CONFLICT (2 claims): Claims 3 and 9 contradict each other (T7).

Where would you like to start?
```

---

## Presentation Order

Within each batch, present claims in this order:

1. **Internal conflicts first (T7).** If claims within the same batch contradict each
   other, surface that first — it reframes everything else.
2. **High-tension claims.** Claims with multiple T-signals or T1 (direct contradiction).
3. **Single-tension claims.** One T-signal, manageable.
4. **Clean claims last.** Zero tensions, likely settled. These go fast.

This is the opposite of what feels natural (starting with easy wins). But tensions can
reframe clean claims — a clean claim might depend on a contested one. Seeing the hard
stuff first gives the human the full picture.

---

## What NOT to Extract

- **Action items without decisions.** "Alice will send the doc by Friday" is a task.
- **Meta-commentary about the meeting.** "It was a productive session" is not a claim.
- **Restatements of existing library positions.** If someone said "our four-agent split
  is working well" and the library already says this, it's confirmation, not new signal.
  Note it as reinforcing evidence but don't extract it as a separate claim.
- **Hypotheticals without commitment.** "What if we tried X?" is brainstorming. "We're
  going to try X" is a claim.
- **Pleasantries, hedging, and filler.** "I think maybe possibly we should consider..."
  Strip the hedging. If there's a core assertion underneath, extract it. If it's pure
  hedging with no assertion, skip it.
