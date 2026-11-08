# Lodi 2025–26 | Analysis handoff

The 31-school kindergarten meal extract and CDE attendance estimates have been matched and checked. The school-level table, district totals, coverage audit, source extracts, and R code are here for the Lodi report and figures.

## Analysis files

| File | Contents |
| --- | --- |
| [School-level analysis](outputs/lodi_31_school_k_meal_attendance_review.csv) | One row per matched school; kindergarten breakfast and lunch counts, Census enrollment, modeled attendance, and meal-to-day ratios |
| [District summary](outputs/lodi_k_summary_2025_26.csv) | Pooled counts and ratios across the 31 schools |
| [Coverage audit](outputs/lodi_coverage_audit.csv) | All 35 CDE school records, including the four outside the meal workbook |
| [Source snapshots](inputs/) | District meal extract, independent kindergarten eligibility list, and corrected CDE school proxy extract |
| [R analysis](code/reproduce_lodi_2025_26.R) and [checks](code/test_lodi_reproduction.R) | Reproducible calculations and validation tests |
| [QA notes](internal/QA_AND_OPEN_QUESTIONS.md) | Source details and outstanding measurement questions |

## Reconciled totals

| Measure | 31-school total |
| --- | ---: |
| Kindergarten breakfasts | 70,667 |
| Kindergarten lunches | 203,639 |
| Kindergarten Census enrollment | 1,763 |
| Modeled kindergarten average daily attendance | 1,595.413 |
| Modeled kindergarten attended student-days | 287,174.337 |
| Breakfasts per 100 modeled kindergarten attendance days | 24.608 |
| Lunches per 100 modeled kindergarten attendance days | 70.911 |

The district-wide ratios are calculated using **total meals / total modeled attendance days**, rather than averaging school-level ratios.

## Source and matching checks

The original workbook has 31 school rows in each of its Breakfast and Lunch sheets. Every school's kindergarten meal count matches the preserved extract; each school's grade counts add to its reported meal total, and the kindergarten totals reconcile to the workbook's grand totals. The two meal sheets and the independent eligibility file contain the same 31 school names.

Those names match uniquely to the corrected 35-school CDE extract after standardizing punctuation and the `Elementary School` suffix. All 35 state-school names and CDS codes also agree with the CDE public-school directory export dated November 4, 2026. The **meal workbook itself has no CDS codes**, so its links to CDE schools are name-based. Four schools in the CDE extract have no meal-workbook row and are excluded from both sides of the comparison.

The workbook's kindergarten meal average daily participation (ADP) totals, 393 for breakfast and 1,131 for lunch, are consistent with dividing annual meal totals by **180** and rounding. The workbook has **no explicit service-date range**, so this is not independent confirmation of the meal dates or the calendars at every school. Lodi's [2025–26 modified traditional calendar](https://resources.finalsite.net/images/v1736443433/lodiusdnet/fsjjkrvfjsh0bwpqtvlh/LodiUSD_InstructionalCalendar_2025-26.pdf) runs July 29, 2025–May 29, 2026; individual school calendars may differ.

## Attendance construction and limits

The kindergarten attendance denominator is **modeled attended student-days**, not observed kindergarten attendance. CDE reports TK/K absences together; the estimate allocates those days to kindergarten according to kindergarten's share of school TK/K Census enrollment, using 180 days:

```text
Modeled K ADA = K Census − (TK/K absent days / 180) × K Census / (K Census + TK Census)
```

The [CDE absenteeism file definitions](https://www.cde.ca.gov/ds/ad/fsabr.asp) describe an *eligible cumulative enrollment* reporting population, with exclusions for some short-duration and exempt enrollments. Census enrollment is a different population measure. The model does not recover actual kindergarten attendance days or each student's enrollment duration.

The workbook records **meals**, not distinct children. Its `Preschool` field remains separate because that grade label has not been established as TK. The eligibility report's `Highest Eligible` and `Last Day` fields are used for school-list checks, not attendance denominators. The resulting meal-to-day ratios are descriptive and are not verified percentages of children eating breakfast or lunch.

## Reproduction

From `studies/lodi_2025_26/`:

```sh
Rscript code/reproduce_lodi_2025_26.R
Rscript code/test_lodi_reproduction.R
```

The base-R snapshot workflow passed its recorded checks, and the figures above were recomputed independently on November 8, 2026. Direct `readxl` import of the original workbook has not been tested in R; the original Excel rows were checked separately against the snapshot. The [study README](README.md) lists the source versions.
