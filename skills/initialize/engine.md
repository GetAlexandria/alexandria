---
requires:
  adherence: low
  reasoning: low
  precision: low
  volume: low
---

# Initialize Engine — Algorithm

This file contains the complete algorithm for computing tier assignments from initialize inputs.
All data tables are in `${CLAUDE_PLUGIN_ROOT}/docs/initialize/initialize-engine.yaml`.

## Inputs

```
mode:       "no_low_ai" | "short_order_cook" | "pair_programmer" | "factory"
novelty:    "high" | "moderate" | "low"
complexity: "high" | "moderate" | "low"
```

## Tier Ordering (for max() comparisons)

```
foundation > core > amplifier > deprioritized
```

When the algorithm says `max(tier_a, tier_b)`, it means the HIGHER priority tier wins.

## Algorithm

For each of the 22 areas in the catalog:

### 1. Pool Check

```
if area.id NOT IN pools[mode].areas:
    → skip (area is not relevant at this mode)
```

### 2. Foundation Check

```
if area.id IN foundation[mode]:
    → tier = "foundation"
    → done (skip remaining steps)
```

### 3. Sensitivity Profiles

Look up the area's novelty and complexity profiles from `area_profiles[area.id]`:

```
novelty_tier = null
if area has a novelty profile:
    profile_name = area_profiles[area.id].novelty
    novelty_tier = novelty_profiles[profile_name][novelty]

complexity_tier = null
if area has a complexity profile:
    profile_name = area_profiles[area.id].complexity
    complexity_tier = complexity_profiles[profile_name][complexity]
```

Combine using max():

```
if both are null:
    implied_tier = "deprioritized"
else if one is null:
    implied_tier = the non-null one
else:
    implied_tier = max(novelty_tier, complexity_tier)
```

### 4. Mode Floor

Look up the area's floor at this mode:

```
floor = area_profiles[area.id].floors[mode] or "deprioritized"
tier = max(implied_tier, floor)
```

### 5. Override Rules

Apply in order. Each override can replace the tier computed above.

**Override 1: Progression / Mastery (area 3.4)**

Progression has an interaction effect between novelty and complexity. Replace the
tier from steps 3-4 with a direct lookup:

```
if area.id == "3.4":
    key = novelty + "_" + complexity   # e.g., "high_moderate"
    tier = progression_lookup[key]
```

The lookup table:

| Novelty \ Complexity | High | Moderate | Low |
|---------------------|------|----------|-----|
| **High**            | Core | Core     | Core |
| **Moderate**        | Amplifier | Amplifier | Deprioritized |
| **Low**             | Amplifier | Deprioritized | Deprioritized |

**Override 2: Journey Maps (area 3.1) at Pair Programmer**

At Pair Programmer mode, Journey Maps has a novelty-gated floor:

```
if area.id == "3.1" AND mode == "pair_programmer":
    if novelty == "low":
        floor = "deprioritized"   # no special floor
    else:
        floor = "amplifier"       # prevent drop below Amplifier
    tier = max(tier_from_step_3, floor)
```

**Override 3: Design System (area 4.1) at No/Low AI**

At No/Low AI mode, Design System has complexity-sensitive behavior:

```
if area.id == "4.1" AND mode == "no_low_ai":
    if complexity == "high":
        tier = "core"
    else:
        tier = "amplifier"
```

### 6. Collect and Sort

After processing all areas, group by tier:

```
foundation_areas    = [areas where tier == "foundation"]
core_areas          = [areas where tier == "core"]
amplifier_areas     = [areas where tier == "amplifier"]
deprioritized_areas = [areas where tier == "deprioritized"]
not_in_pool         = [areas NOT in pools[mode].areas]
```

Sort within each tier by area ID (numeric order).

## Verification

The engine must reproduce all 36 configuration tables in
`${CLAUDE_PLUGIN_ROOT}/docs/initialize/phase-3-configurations.md`.

Quick verification targets:

| Config | Mode | F | C | A | D |
|--------|------|---|---|---|---|
| H/H | No/Low AI | 3 | 7 | 0 | 0 |
| L/L | No/Low AI | 3 | 0 | 3 | 4 |
| H/H | Short-Order Cook | 3 | 9 | 1 | 0 |
| L/L | Short-Order Cook | 3 | 1 | 5 | 4 |
| H/H | Pair Programmer | 4 | 13 | 1 | 0 |
| L/L | Pair Programmer | 4 | 3 | 7 | 4 |
| H/H | Factory | 5 | 15 | 2 | 0 |
| L/L | Factory | 5 | 4 | 9 | 4 |

Edge cases:
- Progression at M/L → Deprioritized (interaction effect)
- Competitive Analysis at H/H → Amplifier (inverse novelty sensitivity)
- Design System at Short-Order Cook → always Foundation
- Design System at Pair Programmer → always Core
- Nothing Deprioritized at any H/x Factory config

---

# Gap Analysis Engine

This section contains the algorithm for scoring knowledge gaps and producing a seeding sequence.
It runs after the tier assignment algorithm above, taking the initialize output plus a knowledge
declaration as inputs.

## Inputs

```
initialize_output:  The tier assignments from the algorithm above (mode, areas with tiers)
declaration:    Array of { area_id, status, freshness, notes } from the user
```

## Constants

```
tier_weight:
  foundation    = 1.0
  core          = 0.75
  amplifier     = 0.5
  deprioritized = 0.25

gap_severity:
  absent  = 1.0
  partial = 0.6
  present = 0.0

freshness_penalty:    (only applied when status = present)
  stale   = 0.4
  unknown = 0.2
  fresh   = 0.0
```

## Algorithm

### 1. Score Each Area

For each area in the initialize output's recommendations:

```
declaration = user_declarations.find(area.id) or { status: "absent", freshness: "unknown" }

weight = tier_weight[area.tier]

if declaration.status == "present":
    severity = 0.0
    penalty = freshness_penalty[declaration.freshness]
    score = weight × penalty
    action = penalty > 0 ? "refresh" : "none"

else:
    # Absent or Partial — freshness is irrelevant
    severity = gap_severity[declaration.status]
    score = weight × severity
    action = declaration.status == "absent" ? "create" : "update"

area.priority_score = score
area.action = action
area.current_status = declaration.status
area.current_freshness = declaration.freshness or "unknown"
```

### 2. Sort

```
sort areas by:
  1. priority_score DESCENDING
  2. tier rank ASCENDING (foundation=0, core=1, amplifier=2, deprioritized=3)
  3. catalog order ASCENDING (1.1 before 1.2, etc.)
```

**Note:** The `sequence` array reflects **urgency** (highest-scoring gaps first), not structural
dependency. A Core+Absent area (score 0.75) will appear before a Foundation+Present+Stale
area (score 0.4) in the sequence because it's a bigger gap. The **phase grouping** (step 3)
reflects structural dependency — Foundation phases always come first regardless of score.
Consumers should use phases for seeding order and sequence for prioritization within a phase.

### 3. Group into Phases

```
phase_1  = areas where tier == "foundation"    AND action != "none"
phase_2  = areas where tier == "core"          AND action != "none"
phase_3  = areas where tier == "amplifier"     AND action != "none"
phase_3b = areas where tier == "deprioritized" AND action != "none"
phase_4  = areas where action == "none"
```

### 4. Compute Summary

```
total_areas     = count of all areas in pool
gaps_to_fill    = count where action == "create" or action == "update"
areas_to_refresh = count where action == "refresh"
areas_complete  = count where action == "none"
```

### 5. Build Sequence

The `sequence` array is the ordered list of area IDs from the sort in step 2,
excluding areas where action == "none".

## Edge Cases

### Empty declaration
All areas default to Absent / Unknown. The output is the initialize recommendation
re-presented as a seeding sequence with every area needing creation.

### Everything present and fresh
Every area scores 0.0. Output is a clean bill of health:
"Your library covers all [N] recommended areas. No gaps detected."
Suggest a refresh schedule.

### Foundation gaps with present Core areas
Flag explicitly: "You have Core knowledge but missing Foundation prerequisites.
The Core knowledge may be internally inconsistent without [Foundation area names].
Prioritize Foundation gaps before building on Core."

### Declarations outside pool
Ignore gracefully. Only score areas within the initialize-selected pool.

### Partial + Stale
Treat as Partial (gap_severity = 0.6). The freshness penalty only applies to
Present items. Partial items need updating regardless of freshness.

## Verification

Quick scoring targets:

| Status | Freshness | Tier | Score | Action |
|--------|-----------|------|-------|--------|
| Absent | — | Foundation | 1.0 × 1.0 = **1.00** | create |
| Absent | — | Core | 0.75 × 1.0 = **0.75** | create |
| Partial | — | Core | 0.75 × 0.6 = **0.45** | update |
| Present | Stale | Amplifier | 0.5 × 0.4 = **0.20** | refresh |
| Present | Unknown | Core | 0.75 × 0.2 = **0.15** | refresh |
| Absent | — | Deprioritized | 0.25 × 1.0 = **0.25** | create |
| Present | Fresh | any | any × 0.0 = **0.00** | none |

Sequencing: an Absent Foundation area (1.00) always sorts before an Absent Core area (0.75).
A Partial Core area (0.45) sorts before an Absent Deprioritized area (0.25).
