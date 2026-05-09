# Noun Proposal Dialogue

Reference material for scanner-based entity discovery. Loaded on demand when the
user has a codebase to scan (Steps 0b, 0c, 0d of the initialize flow).

---

## Step 0b: Noun Proposal Dialogue

After the scanner completes, present the discovered entities to the user
for confirmation. The user is the product expert — the scanner proposes, the human
decides.

**1. Summary layer:**

Present a high-level overview before any details:

> "I scanned your codebase and found **[N] candidate product entities** organized
> in **[M] domain groups**. Here's the overview:"
>
> | Domain | Entities | Top Confidence |
> |--------|----------|---------------|
> | [domain] | [count] | [highest confidence entity] |
>
> "Let's go through each domain. You can confirm, rename, merge, split, or
> reject any entity."

**2. Domain-by-domain confirmation:**

For each domain group, present the entities:

> "**[Domain Name]** — I found [N] entities:"
>
> | Entity | Confidence | Evidence |
> |--------|-----------|----------|
> | [name] | [high/medium/low] | [brief evidence summary] |
>
> "Which of these are real product concepts? You can:
> - **Confirm** — yes, this is a real product entity
> - **Rename** — right concept, wrong name (e.g., 'Subscription' → 'Plan')
> - **Merge** — these are actually the same thing (e.g., 'User' + 'Account')
> - **Split** — this is actually multiple things
> - **Reject** — this is an implementation detail, not a product concept"

Wait for the user to respond before moving to the next domain.

**3. Annotation (optional):**

For each confirmed entity, optionally ask:

> "Anything I should know about **[entity]**? What role does it play in your product?"
> (Skip if you'd rather move on — you can always add context later.)

Record any annotations. These become product intent that enriches the entity beyond
what code can tell us.

**Mismatch and missing-concept check:**

Before leaving the noun beat, surface any meaningful tension between scanner shape
and product framing:

> "The code suggests [X], but from your description I'd have guessed [Y]. I could
> be misreading it — what am I missing?"

Then ask what the code still does **not** capture:

> "What's central to the product story that isn't modeled here yet?"

Use this to separate:
- confirmed current nouns
- renamed / corrected nouns
- emerging concepts that matter but are not yet on disk

**4. Confirmation summary:**

After all domains are reviewed:

> "Here's what we confirmed:"
>
> | Entity | Domain | Annotation |
> |--------|--------|-----------|
> | [name] | [domain] | [annotation or "—"] |
>
> "[N] entities confirmed, [M] rejected, [K] renamed/merged/split."
>
> "These will be pre-loaded as existing knowledge when we configure your library.
> I'll also carry forward any emerging concepts that matter but aren't modeled yet.
> Ready to proceed to configuration?"

**Anti-pattern guard:** NEVER dump all proposals at once. Always show the summary
layer first, then walk through domains one at a time. If there are more than 5
domains, ask "Want to see all [N] domains, or focus on the top ones by confidence?"

---

## Step 0c: Pre-load Discovered Entities

After the noun proposal dialogue completes, pre-load confirmed entities into the
the initialize flow's knowledge state before proceeding to configuration.

**What happens:**
1. Confirmed entities are recorded for use in gap analysis
2. Each confirmed entity maps to knowledge area 2.3 (Product Entities) and
   potentially 2.2 (Noun Vocabulary)
3. During gap analysis knowledge declaration, areas with discovered entities are
   pre-populated as "present" with freshness "fresh"
4. The user can still override: "The scanner found your User entity, but is your
   User documentation actually complete?" — user can downgrade to "partial"

**What is written to alexandria-config.json:**

Add a `discovery` section as a sibling to the existing config:

```json
{
  "discovery": {
    "scan_date": "[ISO timestamp]",
    "scan_tiers": ["tier1"] or ["tier1", "tier2"],
    "confirmed_entities": [
      {
        "name": "[entity name]",
        "domain": "[domain group]",
        "annotation": "[user annotation or null]",
        "confidence": "high|medium|low",
        "evidence": ["file paths"]
      }
    ],
    "rejected_entities": ["[names of rejected proposals]"]
  }
}
```

**Integration with gap analysis:**

When gap analysis runs (knowledge declaration), check for the `discovery` section:
- If it exists, pre-populate area 2.3 (Product Entities) as "present/fresh" if
  confirmed entities exist
- Show the user: "Based on your codebase scan, I've pre-populated these areas as
  present. Adjust if needed."
- Other areas (Vision, Strategy, etc.) are NOT affected by code discovery — they
  still require human declaration

**Key constraint:** Discovery pre-populates, it does not override. The user always
has final say on gap analysis status.

---

## Step 0d: Code Walk — Doc vs. Code Validation (Both path only)

This step only runs when the user answered "yes" to both routing questions (has docs
AND has code). It compares what documentation claims against what the scanner found.

**When to run:** After entity pre-loading and before configuration questions. Only
for the "both" routing path.

**Divergence classification:**

Compare each documented product entity/feature against scanner findings:

| Classification | Meaning | Example |
|---------------|---------|---------|
| **Missing from code** | Docs describe it, scanner found no evidence | "Your docs mention a Referral system but the codebase has no referral models, routes, or UI" |
| **Missing from docs** | Scanner found it, docs don't mention it | "The scanner found a Notification entity with models and routes, but your docs don't mention notifications" |
| **Evolved past docs** | Both exist but code has diverged | "Your docs describe Billing with 3 plan types, but the code shows 5 plan types and a trial system" |

**Flow:**

1. **Load documentation context:** Read existing library cards or user-provided docs
   that describe the product's entities and features.

2. **Cross-reference with scanner output:** For each documented entity, check if the
   scanner found matching evidence. For each scanner entity, check if docs mention it.

3. **Classify divergences:** Apply the three-type classification above.

4. **Present divergences to user:**

> "I compared your documentation against your codebase. Here's what I found:"
>
> **Missing from code** ([N] items):
> | Entity | Doc Source | Scanner Finding |
> |--------|-----------|-----------------|
> | [name] | [where in docs] | No code evidence found |
>
> **Missing from docs** ([N] items):
> | Entity | Scanner Evidence | Confidence |
> |--------|-----------------|-----------|
> | [name] | [file paths] | [high/medium/low] |
>
> **Evolved past docs** ([N] items):
> | Entity | Doc Description | Code Reality |
> |--------|----------------|-------------|
> | [name] | [what docs say] | [what code shows] |

5. **User decides:** For each divergence:
   - "Update docs" — flag for library card update
   - "Acknowledge" — known divergence, no action needed
   - "Investigate" — needs more research before deciding

**Key constraints:**
- This step is OPTIONAL — only for "both" routing path
- Scanner output from Tier 1 + Tier 2 is used for comparison
- The code walk does NOT modify any library cards — it flags divergences for the user
- "Missing from code" does NOT mean "delete from docs" — the feature might be planned
