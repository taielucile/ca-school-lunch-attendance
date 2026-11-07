# Lodi Unified: 2025–26 kindergarten analysis handoff

Verified source extracts, matched school-level meal counts, modeled kindergarten attendance estimates, and R checks for the Lodi analysis. Angela is preparing the district report and visualizations.

## Start here

| File | Use |
| --- | --- |
| [Handoff for Angela](HANDOFF_FOR_ANGELA.md) | Analysis files, reconciled results, and measurement notes |
| [31-school analysis table](outputs/lodi_31_school_k_meal_attendance_review.csv) | One row per matched school with meal totals, denominator components and meal-to-day ratios |
| [District summary](outputs/lodi_k_summary_2025_26.csv) | Totals and ratios calculated as pooled totals, not unweighted school averages |
| [Coverage audit](outputs/lodi_coverage_audit.csv) | 31 included and 4 excluded CDE records |
| [Source snapshots](inputs/) | Original-workbook meal extract, independent eligibility school list and corrected 35-school CDE proxy extract |
| [R reproduction](code/reproduce_lodi_2025_26.R) | Recompute and export the tables |
| [R checks](code/test_lodi_reproduction.R) | Independently verify source counts, joins, totals and ratios |
| [QA and open questions](internal/QA_AND_OPEN_QUESTIONS.md) | Research-team caveats and unresolved source definitions; not an external attachment |
| [R verification record](internal/R_VERIFICATION.md) | Exactly what was run and what was not tested |

## Run the analysis

From this study folder:

```sh
Rscript code/reproduce_lodi_2025_26.R
Rscript code/test_lodi_reproduction.R
```

Both scripts use base R. The reproduction script reads the preserved CSV snapshots and writes three tables to `outputs/`. The optional `--meal-xlsx='/path/to/Lodi Data_copy.xlsx'` branch requires `readxl` and **has not been execution-tested**. The upstream Excel workbook was independently examined and its kindergarten meal totals reconciled.

## What the estimates mean

Kindergarten meal **counts** are from the district workbook. Kindergarten attendance **days** are estimated, not observed. The public CDE absence count combines transitional kindergarten (TK) and kindergarten (K), so the model allocates those absences to K in proportion to each school's Census Day enrollment and assumes 180 attendance days:

```text
Modeled K ADA = K Census enrollment − (combined TK/K absence days / 180)
                                      × K Census / (TK Census + K Census)
Modeled K attended days = modeled K ADA × 180
Breakfasts per 100 modeled K days = 100 × K breakfast meals / modeled K days
Lunches per 100 modeled K days = 100 × K lunch meals / modeled K days
```

Across the matched 31 schools, the source workbook records **70,667 breakfasts** and **203,639 lunches**. The model gives **287,174.337 estimated K attended student-days** (K Census enrollment: 1,763). Pooled breakfast and lunch ratios are **24.6077** and **70.9113 per 100 modeled K days**, respectively. These are **not** percentages of students, participation probabilities, unique meal recipients, or observed K attendance.

All 31 meal schools match the independent eligibility school list and the corrected CDE extract. Four other CDE schools are excluded from **both** numerator and denominator because they are not in the district meal workbook. `Preschool` meal totals remain separate and are not relabeled TK.

## Source versions

- Team meal workbook: `whippedfruit/Feed-California-Kinders/Lodi/cleaned data/Lodi Data_copy.xlsx`, Git blob `f71fc0f26933011f14a05586f67a475aedccc643`.
- Independent 31-school eligibility list: `whippedfruit/Feed-California-Kinders/Lodi/extracted data/lodi_kindergarten_enrollment_measures_2025_26.csv`, blob `82c99c9129324458ab9ba60a8af51469ee0985e3`.
- Corrected 35-school CDE extract: `results/2025_26/lodi_unified_school_denominator_proxies.csv`, blob `9ac3987a113280f88447ac3b81b8a81426966d66`.

All source versions were inspected November 6, 2026. Earlier Lodi CDE extracts missing schools should not be substituted. The original 2025–26 sources and matched-school boundaries are unchanged. This study does not address the separate 2024–25 FNS10 Nutrition Services work or CDE attendance-records correspondence.
