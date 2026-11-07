# Lodi 2025–26 | Analysis handoff

The Lodi files are matched and the kindergarten meal counts have been reconciled. The school-level table, district summary, coverage audit, and R code are available here for Angela's report and visualizations.

## Files

| File | Contents |
| --- | --- |
| [School-level analysis](outputs/lodi_31_school_k_meal_attendance_review.csv) | 31 matched schools, CDS codes, kindergarten breakfast and lunch counts, modeled kindergarten attendance days, and meal-to-day ratios |
| [District summary](outputs/lodi_k_summary_2025_26.csv) | Combined meal counts, modeled attendance days, and pooled ratios across the 31 schools |
| [Coverage audit](outputs/lodi_coverage_audit.csv) | School matches and the four CDE records excluded because they have no corresponding meal-workbook record |
| [Source snapshots](inputs/) | District meal extract, kindergarten eligibility school list, and corrected 2025–26 CDE attendance proxy file |
| [R analysis](code/reproduce_lodi_2025_26.R) and [checks](code/test_lodi_reproduction.R) | Reproduction and verification of the analysis tables |
| [QA notes](internal/QA_AND_OPEN_QUESTIONS.md) | Source questions and outstanding measurement issues |

## Reconciled results

| Measure | Total across matched schools |
| --- | ---: |
| Schools | 31 |
| Kindergarten breakfasts | 70,667 |
| Kindergarten lunches | 203,639 |
| Kindergarten Census enrollment | 1,763 |
| Modeled kindergarten average daily attendance | 1,595.413 |
| Modeled kindergarten attended student-days | 287,174.337 |
| Breakfasts per 100 modeled kindergarten attendance days | 24.608 |
| Lunches per 100 modeled kindergarten attendance days | 70.911 |

The 31 schools appear in both meal sheets and the independent kindergarten eligibility list, and all match the corrected CDE extract. Breakfast and lunch totals agree with the workbook's printed totals. The district-wide ratios divide total meals by total modeled attendance days rather than averaging school ratios.

## Measurement notes

The meal numerators are recorded kindergarten meals, not counts of individual students. The denominator is **modeled kindergarten attended student-days**, not observed kindergarten attendance or Census enrollment.

The CDE file reports absences for transitional kindergarten and kindergarten together. The calculation assigns kindergarten a share of those absences based on its share of TK/K Census enrollment at each school and uses a 180-day benchmark. Enrollment duration and actual kindergarten attended days are unavailable in these inputs.

The meal workbook's exact service period and the definitions of its grade fields remain to be confirmed. Its `Preschool` field has been kept separate from kindergarten and is not assumed to mean TK. The eligibility report's `Highest Eligible` and `Last Day` figures were used only to check the school list.

The ratios describe meals recorded relative to **estimated attendance days**. They are not verified percentages of kindergarten students eating school meals. The available data also do not establish why ratios differ across schools.

## Reproduction

From `studies/lodi_2025_26/`:

```sh
Rscript code/reproduce_lodi_2025_26.R
Rscript code/test_lodi_reproduction.R
```

Both ran successfully on Debian 13 with R 4.5.0 using the preserved CSV snapshots. Direct R import of the original Excel workbook remains untested; its kindergarten rows and totals were checked separately. Source locations and version identifiers are listed in the [study README](README.md).
