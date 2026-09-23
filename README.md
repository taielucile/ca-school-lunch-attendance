# California School Lunch Attendance Denominator

Reproducible work to construct and evaluate school-level TK/K attendance denominators for a California school-meal take-up project.

## Current question

For Irvine Unified and Lodi Unified in 2024–25, how sensitive are estimated TK/K student-days attended to alternative public-data constructions?

The public CDE absenteeism release combines TK and K. This is acceptable for the current analysis. The remaining measurement problem is annual attendance exposure: the public file reports eligible cumulative enrollment and total absence days, but not school-by-grade expected attendance days.

## Data

Raw CDE files are **not committed**. Place these files in `data/raw/`:

- `absenteeismreason25-v2.txt` — 2024–25 Student Absenteeism by Reason
- `cdenroll2425.txt` — 2024–25 Census Day enrollment
- `cbedsora24b.txt` — 2024–25 CBEDS school/program data

See `data/README.md` and `docs/sources.md`.

## Reproduce

The core pipeline uses base R only.

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

Generated data and outputs are ignored by Git and can always be rebuilt from the raw inputs.

## Tests

After placing the raw files in `data/raw/`, run:

```sh
Rscript tests/test_pipeline.R
```

The regression test checks the current Irvine/Lodi benchmark totals as well as core row-count and identification invariants.

## Measurement status

Observed quantities are kept separate from reconstructed or assumption-dependent quantities. Neither Census enrollment × 180 nor eligible cumulative enrollment × 180 is treated as observed expected student-days.

For the focus districts, 180 is supported as a full-year district calendar benchmark for district-operated schools, but calendar days offered are not the same as each student's expected attendance exposure. Charter/school-specific calendar exceptions remain under review.

See `docs/denominator_method_note.md`, `docs/decisions.md`, and `docs/memo_outline.md`.

## Current benchmark result

Under a 180-day full-year benchmark, the eligible-cumulative construction produces an aggregate attended-days proxy about 8.20% above the Census construction in Irvine and 7.99% above it in Lodi. This is a sensitivity result, not evidence that either proxy is the true denominator.

## Status

Active research repository. Private while the project is in development.
