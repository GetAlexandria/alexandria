---
requires:
  adherence: high
  reasoning: medium
  precision: medium
  volume: low
---

# Job 1: Signal Triage

**Play:** 5.6 (Signal Intake)
**Stage:** 5 (Evolution)

---

## Trigger

Human pushes raw signal to the library. Examples:
- "We had a meeting about X. Here are the notes."
- "CEO said we're doing Y. I'm not sure the team agrees."
- "This Slack thread has implications for the product."
- "I had a conversation with a customer that changes how I think about Z."
- Raven produces an inline handoff block after a conversation surfaces actionable signal
  (the human pastes the relevant section as input).

## Inputs

- Raw signal (meeting notes, transcript, Slack export, email, verbal summary, Raven
  handoff note). Format doesn't matter — Solomon reads anything.
- The library as it currently exists (for comparison).

## Procedure

### Step 1: Orient

Load `${CLAUDE_PLUGIN_ROOT}/skills/solomon/queue-resolution.md` Section 1 and run
the pre-triage queue check:
- Read `signal-queue.jsonl` for active contested/open claims
- Surface stale items (past their revisit date) to the human
- Note standing requirements for the session

### Step 2: Read the Library (Pick a Door)

Load `${CLAUDE_PLUGIN_ROOT}/skills/solomon/intake-traversal.md` Part 1. Match the signal
to a door (Meeting Notes, Executive Directive, Slack Thread, Customer Signal, Raven
Handoff, or Document/Research).

**Your response MUST begin with door selection.** This is the first thing the human sees.
Write it as: "This is [type] (Door [N]). Running [list of searches]." Then show results
of each search (card refs found, queue echoes, etc.) before presenting claims.

Also load `${CLAUDE_PLUGIN_ROOT}/skills/context-briefing/traversal.md` for general graph
navigation when needed within door sequences.

### Step 3: Extract Claims

Load `${CLAUDE_PLUGIN_ROOT}/skills/solomon/claim-extraction.md`. Use the extraction
recipe that matches your door (Recipe 1-6). Extract discrete claims from the raw signal.

**A claim is well-formed when it:**
- States a single assertion (not compound)
- Is specific enough to compare against the library
- Is attributable (who said this, in what context)
- Has an identifiable evidence basis (data, expert judgment, anecdote, or assertion)

If the raw signal is too ambiguous to extract claims from, exit NEEDS_CONTEXT.

### Step 4: Run Tension Detection

For each extracted claim, load
`${CLAUDE_PLUGIN_ROOT}/skills/solomon/tension-detection.md` and check tensions T1-T7.

Also load `${CLAUDE_PLUGIN_ROOT}/skills/solomon/evidence-protocol.md` to assess evidence
strength for each claim (two-axis rating + evidence tier).

Also load `${CLAUDE_PLUGIN_ROOT}/skills/solomon/queue-resolution.md` Section 2 for echo
detection. When T5 fires, present the echo type (resolves, reinforces, contradicts, or
compounds) alongside the tension analysis.

**Output format:** Use the Mandatory First Response Structure from the agent definition.
Present each claim as a block with these exact fields: SOURCE (with Reliability A-F),
EVIDENCE (with Credibility 1-6, Tier E1-E4), LIBRARY SAYS, TENSIONS (T1-T7 labels),
AFFECTED. No other fields — no "Status", no "Classification", no "Recommendation".

**End your response** with: "How do you classify each claim?" Then STOP. Do not draft
source material, write queue entries, or take any action until the human responds with
classifications. Steps 5-8 happen in your NEXT response, after the human has spoken.

### Step 5: Human Classifies Each Claim

After seeing tension analysis, the human classifies:

| Status | Meaning | Route |
|--------|---------|-------|
| **Settled** | Passes the settledness test. The library should reflect it. | Step 6 |
| **Contested** | Tension signals fired and the human can't resolve them. | Step 7 |
| **Open question** | Not enough information to evaluate. Needs investigation. | Step 7 |
| **Supersedes** | Settled AND explicitly replaces something the library currently says. | Step 6 |
| **Noise** | Doesn't affect the library regardless of whether it's settled. | Log reason, drop |

**The settledness test (all three must pass):**

1. **Authority.** Someone with the standing to make this call made it. Not "we discussed" —
   "we decided."
2. **No live contradiction.** Nothing in the signal batch, the signal queue, or the library
   points the other direction with comparable authority or evidence.
3. **Human confirms.** The human says "yes, this is decided, update the library."

### Step 6: Draft Source Material (Settled/Supersedes Claims)

Load `${CLAUDE_PLUGIN_ROOT}/skills/solomon/source-templates.md` Sections 1-2.

For settled claims, draft source material using the template in Section 1. For Supersedes
claims, add the supersession header from Section 2. Include evidence assessments from
Step 4.

Solomon drafts; the human approves. Output goes to `docs/alexandria/sources/`.

### Step 7: Log Contested/Open Claims to Signal Queue

Load `${CLAUDE_PLUGIN_ROOT}/skills/solomon/queue-resolution.md` Section 3 for queue
lifecycle and resolution protocols (Section 2 already loaded at Step 4). Also load
`${CLAUDE_PLUGIN_ROOT}/skills/solomon/signal-queue-schema.md` for the JSONL format. Use
the narrative field guidance from `source-templates.md` Section 4 for writing
`tension_detail` and `resolution_criteria`.

For contested and open-question claims, write entries to `signal-queue.jsonl`. Each entry
includes:
- The claim
- Epistemic status (contested / open_question)
- Who holds what position
- What evidence exists (with evidence tier from Step 4)
- What would resolve it
- Which library cards it would affect if resolved
- When to revisit

If any new claims echo parked queue items (resolves, reinforces, contradicts, or
compounds), handle the echo per queue-resolution.md Section 2.

### Step 8: Summarize the Triage

Produce a triage summary. The summary MUST include a counts line in this format:

> **Triage: [N] claims — [M] Settled, [P] Contested, [Q] Open Question, [R] Noise**

Also include: which claims routed where, signal queue activity (echoes resolved/reinforced),
and any concerns. Load `${CLAUDE_PLUGIN_ROOT}/skills/solomon/source-templates.md` Section 3
for the full report template if writing a detailed report.

## Exit

- **DONE** — all claims triaged, settled claims written as source material, contested/open
  claims parked in signal queue.
- **DONE_WITH_CONCERNS** — triage complete, but some claims were hard to classify. Concerns
  documented for human review.
- **NEEDS_CONTEXT** — the raw signal is too ambiguous to extract claims from. Human needs to
  provide more context about what happened and what was decided vs. discussed.

**On completion:** Do not write any sentinel file.

**Does NOT trigger downstream sync** — no library structure changes. Source material written
during this play feeds into Play 5.2, which handles its own downstream sync.
