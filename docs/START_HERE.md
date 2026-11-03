# Start here: reader's guide

This guide introduces the attendance-denominator work in [Feed California Kinders](https://github.com/whippedfruit/Feed-California-Kinders). You do not need R or Python to inspect the results. The code and source inventories are here if you want to trace or reproduce a calculation.

## The research question

To study school meal participation, we need to know how many students were **in school during the meal reporting period**. For transitional kindergarten (TK) and kindergarten (K), California's statewide public records do not directly provide annual school-by-grade days attended.

This repository documents what can be estimated from school enrollment and absence records, how the estimates compare with directly reported district attendance where available, and why some meal datasets cannot yet be combined with those denominators.

It does **not** claim to measure the number of children eating school meals statewide or establish a causal relationship between meals and attendance.

## A five-minute tour

| Step | Read | Learn |
| --- | --- | --- |
| 1 | [Current research status](current_status.md) | What is supported, corrected, or uncertain |
| 2 | [Results index](../results/README.md) | Which CSV answers which question |
| 3 | [Statewide 2025–26 estimates](../results/2025_26/statewide_school_denominator_proxies.csv) | School-level Census enrollment, absences, and attendance estimates |
| 4 | [Ventura 17-school comparison](../results/2025_26/ventura_17_school_ada_validation.csv) | Constructed estimates versus district-reported attendance |
| 5 | [Calculation map](repository_workflow.md) | How sources, code, checks, and results connect |

For definitions of the output fields, use the [2025–26 file guide](reading_2025_26_files.md).

## How to read an estimate

The main calculation uses **combined TK/K** enrollment and absence records:

```text
Estimated students attending per day
= TK/K Census Day enrollment − (TK/K total days absent ÷ 180)
```

**Illustration, not an actual school's result:** If 60 TK/K students were enrolled on Census Day and the combined absence record shows 540 days absent, the estimate is `60 − 540/180 = 57` students attending per day. Multiplying by 180 gives an **estimated** 10,260 attended student-days.

This is not directly measured annual attendance. Census Day enrollment is a point-in-time snapshot; some students enter or leave during the school year. The 180-day calendar is assumed. CDE's absence figures also combine TK and K, so separate grade estimates require allocation assumptions.

| Label | What it means |
| --- | --- |
| **Observed** | A number recorded in an original source, such as district-reported average daily attendance (ADA) |
| **Estimated / proxy** | A constructed attendance measure relying on enrollment and a day-count assumption |
| **Grade-allocated estimate** | A modeled TK, K, or grade 1 number made by allocating grouped absence totals according to enrollment shares |
| **Candidate school match** | A name-based possible link that has not been verified with a stable identifier |
| **Missing / suppressed** | Unavailable data, **not zero** |

The [method note](denominator_method_note.md) explains the difference between Census and cumulative-enrollment estimates.

## One concrete comparison: Ventura

The October 31 source check covers **17 matched schools**:

| Measure | Sum of average daily students |
| --- | ---: |
| District-reported combined TK/K ADA | **1,179.14** |
| Census-based estimate | 1,186.06 |
| Cumulative-enrollment estimate | 1,236.06 |

The Census-based estimate is closer in this set of schools, **not necessarily across California**. These are average daily students, **not meals, unique meal recipients, or annual attended student-days**. See the [CSV](../results/2025_26/ventura_17_school_ada_validation.csv) and [Ventura notes](ventura_tkk_ada_validation_2026-10.md).

## What you should not conclude

- A statewide kindergarten meal-participation rate has **not** been established.
- The statewide CDE-derived figures are **not** actual annual TK/K ADA or grade-specific attended days.
- The 180-day assumption is **not** verified for every school or student.
- FNS10 service-site name matches are **not** confirmed school identities.
- 2024–25 meal-claim totals cannot be divided by 2025–26 attendance estimates to produce a meaningful participation rate.

## Where to read next

| Question | Best starting point |
| --- | --- |
| I want a district's CSV | [District file index](../results/README.md#district-files) |
| What do the columns mean? | [2025–26 guide](reading_2025_26_files.md) |
| Why was this denominator chosen? | [Denominator methods](denominator_method_note.md) |
| What code generated the outputs? | [Calculation map](repository_workflow.md) |
| Which original files are needed? | [Source and run instructions](../data/README.md) |
| Were earlier numbers corrected? | [Current status](current_status.md), [October 31 audit](independent_research_integrity_audit_2026_10_31.md) |
| What do the other documents cover? | [Documentation index](README.md) |

**Common abbreviations:** CDE = California Department of Education; TK = transitional kindergarten; K = kindergarten; CDS = county-district-school identifier (keep as text); ADA = student average daily attendance; ADP = meal average daily participation; FNS10 = school meal claim records.

**Access:** The repository is currently private. The original district workbooks and project source files may require separate access. This documentation is intended to be browsed as a research record, not to assign tasks to other contributors.

*Source findings last reviewed October 31, 2026; reader navigation revised November 3, 2026.*
