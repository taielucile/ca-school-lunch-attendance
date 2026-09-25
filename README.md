# California School Lunch Attendance Denominator

Reproducible R workflow for constructing and evaluating school-level TK/K attendance denominators for a California school-meal participation project.

## Current question

How closely can public California education data approximate school-level TK/K student-days attended, and how sensitive are the resulting denominators to alternative representations of annual enrollment exposure?

The 2024–25 public CDE Absenteeism by Reason release combines TK and K and reports eligible cumulative enrollment and total absence days, but not school-by-grade Expected Attendance Days. The workflow therefore keeps TK and K combined and treats the annual attendance denominator as partially unidentified from the public aggregate data.

The primary focus districts are Irvine Unified and Lodi Unified. A separate 2025–26 Irvine validation module compares same-year Census enrollment with observed district TK/K attendance for November 3–7, 2025.

## Data

Raw CDE and district source files are **not committed**. Place these files in `data/raw/` before running the full pipeline:

- `cdenroll2425.txt` — 2024–25 Census Day enrollment
- `absenteeismreason25-v2.txt` — 2024–25 Student Absenteeism by Reason
- `cbedsora24b.txt` — 2024–25 CBEDS school/program data
- `cdenroll2526.txt` — 2025–26 Census Day enrollment used for the Irvine validation
- `irvine_k_pk_attendance_2025_11_03_07.csv` — transcribed Irvine K and PK/TK attendance for November 3–7, 2025

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

Generated derived data, diagnostics, and tables are ignored by Git and can be rebuilt from the raw inputs.

## Tests

After placing all five raw inputs in `data/raw/`, run:

```sh
Rscript tests/test_pipeline.R
```

The test suite reruns the full pipeline and checks the frozen 2024–25 Irvine/Lodi denominator benchmarks, school-panel integrity, non-charter sensitivity results, the school-level handoff, the Irvine attendance transcription, the 2025–26 Irvine Census extract, deterministic district-to-Census matching, the two zero-TK reconciliations, and the five-day Irvine attendance benchmark.

The complete pipeline and test suite have been run locally in R, and all regression and integrity tests passed after the district-validation module was added.

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

The available Lodi files cover the full reporting period but do not provide grade-specific attendance. School-wide ADA and grade-level meal ADP therefore are not treated as TK/K attendance ground truth. The Lodi meal-data `Preschool` category is also not assumed to represent TK without documentation.

## Documentation

- `docs/denominator_method_note.md` — estimand, assumptions, and identification limits
- `docs/validation_report.md` — regression benchmarks and district-validation results
- `docs/decisions.md` — research decision log
- `docs/sources.md` — source provenance and interpretation
- `docs/penner_memo_2026-09-24.md` — current collaborator memo
- `docs/presentation_outline_2026-10-15.md` — meeting walkthrough

## Status

Active research repository. Private while the project is in development.
