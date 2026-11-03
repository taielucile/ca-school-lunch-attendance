# Research overview

This work examines attendance denominators for transitional kindergarten (TK) and kindergarten (K) within [Feed California Kinders](https://github.com/whippedfruit/Feed-California-Kinders), with attention to the comparability of school attendance and meal records.

## Research question

What do California's enrollment and absenteeism records establish about school-level TK/K attendance, and how closely do public-data estimates correspond to district-reported attendance?

The distinction matters because meal analyses require numerators and denominators aligned by school, grade, and reporting period. Public statewide records do not provide school-by-grade annual attended student-days directly.

## Analytical approach

1. Extract school-level Census enrollment and grouped absence measures from CDE records.
2. Construct combined TK/K attendance estimates under explicit calendar and enrollment assumptions.
3. Assess record coverage, suppression, and source consistency; examine alternative denominator specifications.
4. Compare estimates with district attendance where available and separately audit the scope and linkability of meal records.

The [calculation map](repository_workflow.md) identifies the scripts and outputs, and the [denominator method note](denominator_method_note.md) discusses the measurement assumptions.

## Ventura comparison

The October 31, 2026 source check includes 17 matched Ventura schools:

| Measure | Sum of average daily students |
| --- | ---: |
| District-reported TK/K ADA | 1,179.14 |
| Census-based estimate | 1,186.06 |
| Cumulative-enrollment estimate | 1,236.06 |

In this matched set, the Census-based estimate is closer to district-reported attendance. The comparison is district-specific and does not establish statewide performance. See the [comparison file](../results/2025_26/ventura_17_school_ada_validation.csv) and [validation note](ventura_tkk_ada_validation_2026-10.md).

## Measurement boundaries

The principal 2025–26 measure is `TK/K Census enrollment − combined TK/K absence days / 180`. The 180-day benchmark is assumed; Census enrollment and cumulative enrollment capture different populations and neither records individual enrollment duration. Separately reported TK, K, or grade 1 estimates allocate absences from broader grade groups rather than observing grade-specific attendance directly.

The FNS10 meal claims are service-site meal totals, not kindergarten-specific student counts. Proposed name-based site matches remain unverified. The 2024–25 meal claims and 2025–26 attendance estimates also cover different school years, so these files do not establish a statewide kindergarten meal-participation rate.

## Research materials

| Resource | Contents |
| --- | --- |
| [Current status](current_status.md) | Verified results, revisions, and open measurement questions |
| [Results index](../results/README.md) | Statewide and district tables, validation, and source-review outputs |
| [2025–26 variable guide](reading_2025_26_files.md) | File structure and field definitions |
| [Denominator method note](denominator_method_note.md) | Estimands, proxy specifications, and sensitivity analysis |
| [Calculation map](repository_workflow.md) | Source-to-output relationships |
| [Original sources and commands](../data/README.md) | Inputs and reproduction instructions |
| [October 31 audit](independent_research_integrity_audit_2026_10_31.md) | Source checks and corrected claims |
| [Documentation index](README.md) | District studies and historical notes |

*Analytical status based on the October 31, 2026 source review.*
