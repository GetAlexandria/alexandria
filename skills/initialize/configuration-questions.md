# Configuration Questions

Reference material for the three configuration questions. Loaded on demand during
the standard (non-greenfield) configuration path.

---

## Inference-Before-Asking Principle

For every question, check what the user's product description, shared documentation,
and scanner output already suggest. Where evidence supports an inference, surface it
as a hypothesis for confirmation rather than asking cold. Where evidence is absent or
ambiguous, ask directly.

**Confidence-hedge posture:** When you infer, sound like a sharp colleague making a
read, not a form scoring engine. Preferred phrasings:

> "My first read is [X], based on [evidence]. Does that match how you see it?"
>
> "From what you've described, I'd guess [X] — but I could be misreading it."
>
> "The code points one way, but it may not be telling the full story."

Do not present an inference as settled fact until the human confirms it.

**Mismatch detection:** If the user corrects an inference or gives an answer that
doesn't match the evidence you've seen, surface the tension as a question — not a
correction:

> "You said [X], but from what you've described I'd have guessed [Y] because
> [specific evidence]. I could be misreading it — what am I missing?"

Accept the user's answer after surfacing the tension. If they explain why their
read is different, use their answer. If the tension reveals they misunderstood the
question, clarify and let them re-answer. Never silently override.

**Canonical label rule:** Use only these current Alexandria mode labels in
conversation and written output: `No/Low AI`, `Short-Order Cook`, `Pair Programmer`,
`Factory`. Do not invent aliases or carry forward retired shorthand.

---

## Question 1: AI Mode (Guidance posture: Prescriptive)

This question has the largest downstream impact. Explain what each option means in
practice before the user answers — the implications are large enough that picking
without understanding creates configuration debt.

**Inference-before-asking:** Check the user's product description and any shared
material for AI mode signals:
- Explicit mentions of how AI is used ("our AI generates...", "builders follow specs")
- Job-to-be-done framing that implies autonomy level
- Team structure descriptions (dedicated PM per feature vs. AI-first workflows)

If signals are clear, present an inference:

> My first read, from what you've described — [specific evidence] — is [mode].
> [One sentence explaining why.] Does that match how your team actually works, or
> am I flattening something important?

**Do not collapse "human-led specs" into Factory mode.** A team can have tight specs and
still be `no_low_ai` or `short_order_cook` if a human makes the product decisions and AI
does not choose what to build. Factory mode requires autonomous product micro-decisions,
not just AI-assisted implementation.

**When the evidence sounds human-led, force the autonomy check.** If the user says things
like "a product person decides," "builders follow specs," "AI helps but doesn't decide,"
or equivalent, ask the direct disambiguator before settling on the mode:

> To be precise: when the work gets ambiguous, does the AI decide the product behavior on
> its own, or does a product person still make that call?

If the product person still makes the call, the answer is not Factory mode.

If signals are absent or ambiguous, present Q1 with its WHY:

> Now I need to understand how your team works with AI. This is the single biggest
> factor in what your library needs.
>
> AI mode determines how much the library has to do on its own vs. with a human
> checking its work. At Factory mode, every micro-decision the AI makes runs without
> review — the library is the briefing before a long unsupervised shift. At Pair
> Programmer, a human is reviewing everything — the library needs to orient, not
> operate. The choice changes how much the library needs to do and how precisely it
> needs to do it.
>
> How much product decision authority do your AI builders have?

| Mode | Description |
|------|-------------|
| **No/Low AI** | A product person makes every product decision. AI assists but doesn't decide. |
| **Short-Order Cook** | A product person scopes each task. AI executes bounded work but doesn't decide what to build. |
| **Pair Programmer** | AI participates in design. It proposes and evaluates, but a product person approves. |
| **Factory** | AI is the primary implementer. It makes hundreds of product micro-decisions autonomously. |

If the user is unsure, use the disambiguation prompt: "Think about the last 10 product
decisions. How many did a product person explicitly make vs. how many did the builder
decide on their own?"

**Decision boundary to keep straight:**
- If a product person makes every product decision and AI assists or drafts, choose
  **No/Low AI**.
- If a product person writes detailed specs and AI implements inside those specs
  without deciding product behavior, that is still **No/Low AI**.
- If a product person scopes the task and AI executes bounded work, choose
  **Short-Order Cook**.
- If AI proposes and evaluates options but a product person approves, choose
  **Pair Programmer**.
- Only choose **Factory** when the AI makes consequential product micro-decisions without
  human review.

**After Q1: Show Risk Narrative**

Once the user answers Q1, immediately present the mode's risk narrative from the
`mode_narratives` section of `${CLAUDE_PLUGIN_ROOT}/docs/initialize/initialize-engine.yaml`.
Use the key that matches their answer (no_low_ai, short_order_cook, pair_programmer,
or factory).

Present it conversationally:

> Here's what that means for your risk profile:
>
> [risk text from mode_narratives]
>
> [story text from mode_narratives]
>
> Keep that in mind — it shapes everything that follows.

**Noun Vocabulary warning (Factory mode, Medium/High complexity only):**

If the user selected Factory mode, flag vocabulary consistency before moving to Q2:

> One thing that matters specifically at Factory mode: vocabulary consistency is
> load-bearing when AI operates autonomously. At this scale, inconsistent nouns
> compound — "tabs" meaning three different things in different files, in different
> contexts, creates real grind. We'll come back to this when we talk about library
> areas, but I want to flag it now so it's on your radar.

This warning only fires for Factory mode. It plants a seed that pays off in gap
analysis when Noun Vocabulary appears as a knowledge area.

Then continue with Q2.

---

## Question 2: Domain Novelty (Guidance posture: Advisory)

The user knows their product and competitive landscape better than Raven does.
Surface your inference and ask for confirmation. If the user's read differs, engage
rather than override.

**Inference-before-asking:** Check the user's product description, documentation,
and the Frankenstein diagnostic output (if available) for novelty signals:
- Product description's use of analogies ("it's like X but Y")
- Presence or absence of known category language
- Competitive landscape mentions
- Whether the user described close analogues or struggled to find them

If evidence supports an inference, present it:

> From your product description and docs, it sounds like you're building
> [description]. That reads like [novelty level] novelty to me — [reason]. Does
> that sound right, or am I misreading the category shape?

If no inference is possible, present Q2 with its WHY:

> Next — how weird is your product? This isn't a judgment call, it's about how much
> your AI builders can lean on convention vs. how much the library needs to teach them.
>
> Novelty determines how much orientation work the library needs to do. A product in
> a well-understood category can lean on the agent's priors — it already knows how
> things like that work. A product that breaks established conventions needs heavier
> documentation because the agent's priors are unreliable guides.
>
> If you described your product in one sentence, would someone from your industry
> correctly guess what using it feels like?

| Level | Description |
|-------|-------------|
| **Low** | Established category. "It's a CRM" and people picture something close. |
| **Moderate** | Familiar space, novel approach. People get the purpose but picture something different. |
| **High** | Pioneering. No established category. People look confused or compare to the wrong thing. |

**After the user answers Q2, apply a disambiguation bump:**

> **If the user said Low:**
> "Quick check — when you onboard a new team member, how long before they stop saying
> 'oh, I assumed it would work like [familiar product]'? If that's more than a week,
> you might be Moderate."
>
> **If the user said High:**
> "Quick check — do you have any direct competitors, even bad ones? If yes, your
> domain has a category forming — you might be Moderate."
>
> **If the user said Moderate:** No bump needed.

Accept whatever the user decides after the bump — these are gentle nudges, not corrections.

---

## Question 3: Product Complexity (Guidance posture: Advisory)

**Inference-before-asking:** Check multiple sources for complexity signals:
- Codebase scanner output (if scanner ran): multiple state machines, permission
  systems, integration count, number of user-facing features
- PRD/spec scope from shared documentation
- What the user described in their product question

If evidence supports an inference, present it:

> Based on what I can see — [specific evidence: e.g., "you mentioned a permission
> system, cross-feature workflows, and a recommendation engine"] — I'm reading this
> as [complexity level] complexity. Does that sound right, or is the code not telling
> the full story of how coupled the product really is?

If no inference is possible, present Q3 with its WHY:

> Last one — how interconnected is your product? Complexity determines the surface
> area the library needs to cover. Low complexity means the library can be focused
> and thin. High complexity means there are more interaction patterns, edge cases,
> and knowledge areas to address.
>
> Which of these are true about your product? (Check all that apply)

| Signal | What it indicates |
|--------|------------------|
| Features share data or state (e.g., a user's action in one area shows up in another) | Cross-feature coupling |
| The product has invisible mechanisms: scoring, recommendations, matching, progression | Hidden interconnection |
| Permissions or roles change what people see or can do | Access-layer complexity |
| There are workflows that span multiple screens or features | Cross-boundary flows |
| Changing one feature's rules has broken or surprised another feature before | Observed ripple effects |
| The product has an internal economy, points, or resource system | Shared resource coupling |

**Mapping:** Count the checked items:
- **0-1 checked -> Low** complexity
- **2-3 checked -> Moderate** complexity
- **4+ checked -> High** complexity

Each signal is binary and observable — the checklist does the systems thinking so the
user doesn't have to. Use the mapped Low/Moderate/High value as the complexity input
to the engine.

**Important:** These signals are about your PRODUCT's behavior, not your tech stack.
"Permissions or roles" means user-facing permission systems, not your deployment IAM.
"Workflows spanning multiple screens" means user journeys, not microservice calls.
