# California School Lunch Attendance Denominator

Reproducible R workflow for constructing and evaluating school-level TK/K attendance denominators for a California school-meal participation project.

## Current question

How closely can public California education data approximate school-level TK/K student-days attended, and how sensitive are the resulting denominators to alternative representations of annual enrollment exposure?

The 2024–25 public CDE Absenteeism by Reason release combines TK and K and reports eligible cumulative enrollment and total absence days, but not school-by-grade Expected Attendance Days. The workflow therefore keeps TK and K combined and treats the annual attendance denominator as partially unidentified from the public aggregate data.

The primary focus districts are Irvine Unified and Lodi Unified. A 2025–26 Irvine validation module compares same-year Census enrollment with observed district TK/K attendance for November 3–7, 2025. A separate Lodi source-triangulation module audits Kindergarten `Highest Eligible` and `Last Day` measures from the district meal-program eligibility report against same-year CDE Kindergarten Census enrollment.

## Data

Raw CDE and district source files are **not committed**. Place these files in `data/raw/` before running the full pipeline:

- `cdenroll2425.txt` — 2024–25 Census Day enrollment
- `absenteeismreason25-v2.txt` — 2024–25 Student Absenteeism by Reason
- `cbedsora24b.txt` — 2024–25 CBEDS school/program data
- `cdenroll2526.txt` — 2025–26 Census Day enrollment used for the Irvine validation
- `irvine_k_pk_attendance_2025_11_03_07.csv` — transcribed Irvine K and PK/TK attendance for November 3–7, 2025
- `lodi_kindergarten_enrollment_measures_2025_26.csv` — extracted Lodi Kindergarten `Highest Eligible` and `Last Day` measures from the 2025–26 eligibility report

See `data/README.md` and `docs/sources.md` for provenance, definitions, and interpretation.

## Reproduce

The pipeline uses base R only.

From the repository root:

```r
source("RUN_ALL.R")
```

or from a shell:

```sh
Rscript RUN_ALL.R
```

The runner executes:

1. `R/00_config.R`
2. `R/01_clean_enrollment.R`
3. `R/02_clean_absenteeism.R`
4. `R/03_clean_cbeds.R`
5. `R/04_build_school_panel.R`
6. `R/05_validate_links.R`
7. `R/06_build_denominators.R`
8. `R/07_irvine_lodi_analysis.R`
9. `R/08_district_validation.R`
10. `R/09_lodi_enrollment_triangulation.R`

Generated derived data, diagnostics, and tables are ignored by Git and can be rebuilt from the raw inputs.

## Tests

After placing all required raw inputs in `data/raw/`, run:

```sh
Rscript tests/test_pipeline.R
```

The test suite reruns the full pipeline and checks the frozen 2024–25 Irvine/Lodi denominator benchmarks, school-panel integrity, non-charter sensitivity results, the school-level handoff, the Irvine attendance transcription, the 2025–26 Irvine Census extract, deterministic district-to-Census matching, the two zero-TK reconciliations, the five-day Irvine attendance benchmark, and the 31-school Lodi Kindergarten source-triangulation results.

The complete pipeline through `R/09_lodi_enrollment_triangulation.R` has been run locally in R, and all regression and integrity tests passed.

## Measurement status

The target quantity is:

`student-days attended = expected student-days − absent student-days`.

Observed quantities are kept separate from assumption-dependent reconstructions. Neither `Census enrollment × 180` nor `eligible cumulative enrollment × 180` is treated as observed expected student-days.

Using a 180-day full-year benchmark:

- Irvine's cumulative-enrollment construction is 8.20% above its Census construction.
- Lodi's cumulative-enrollment construction is 7.99% above its Census construction.

This is a sensitivity result, not evidence that either proxy is the true denominator.

## District-data validation

For the 30 Irvine schools represented in the November 3–7, 2025 district attendance reports:

- same-year CDE Census TK/K enrollment = 3,043;
- observed TK/K student-days over five days = 14,104;
- mean daily TK/K attendance = 2,820.8; and
- mean daily attendance / Census enrollment = 92.70%.

This is a short-window descriptive check on Census enrollment relative to observed attendance. It does **not** validate either annual 180-day denominator construction.

The Lodi files do not provide grade-specific attendance comparable to Irvine's daily attendance reports. School-wide ADA and grade-level meal ADP therefore are not treated as TK/K attendance ground truth. The Lodi meal-data `Preschool` category is also not assumed to represent TK without documentation.

A separate audit of the Lodi Kindergarten eligibility report identified `Highest Eligible` and `Last Day` measures for 31 schools over the July 29, 2025–May 29, 2026 eligibility period. The report defines `Last Day` as the number of enrolled students on the last day of the selected date range. `Highest Eligible` and `Last Day` are identical at all 31 schools and total 3,481, compared with 1,763 Kindergarten students in the same-year CDE Census for the matched schools. These measures provide useful source-triangulation evidence but do not identify student-specific expected attendance days or adjudicate between the annual Census and cumulative-enrollment proxy constructions.

## Documentation

- `docs/denominator_method_note.md` — estimand, assumptions, and identification limits
- `docs/validation_report.md` — regression benchmarks and district-validation results
- `docs/decisions.md` — research decision log
- `docs/sources.md` — source provenance and interpretation
- `docs/penner_memo_2026-09-24.md` — current collaborator memo
- `docs/presentation_outline_2026-10-15.md` — meeting walkthrough

## Next analysis

The annual public-data denominator work has reached the limit supported by the currently available attendance and exposure data. Penner's suggestion to examine the Lodi Kindergarten `Highest Eligible` and `Last Day` fields was followed through as new evidence; the audit added a useful enrollment/eligibility comparison but did not identify duration-weighted expected attendance exposure. Further changes to the annual denominator specification should therefore be driven by genuinely new exposure data rather than by choosing among unsupported assumptions.

The next planned substantive analysis is an Irvine short-window meal-participation check for November 3–7, 2025. The district files provide observed K and PK/TK attendance and daily grade-specific meal counts for the same week. Before calculating rates, the workflow will verify school, date, grade, and meal-type alignment and will preserve breakfast and lunch separately.

This short-window Irvine analysis is conceptually separate from the 2024–25 annual denominator sensitivity analysis and will not be presented as an annual take-up estimate.

Lodi remains unresolved for a population-aligned TK/K take-up calculation because the available files do not provide grade-specific attendance and do not establish that the meal-data `Preschool` category represents TK.

## Status

Active research repository. The denominator workflow is complete under the currently available data; the next planned work is the Irvine five-day meal/attendance analysis. Private while the project is in development.
