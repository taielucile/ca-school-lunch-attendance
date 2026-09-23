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

See `data/README.md`.

## Workflow

`RUN_ALL.R` runs the project from raw files through cleaned school-level data, diagnostics, denominator constructions, and Irvine/Lodi outputs.

Planned modules:

1. clean Census enrollment
2. clean absenteeism data
3. clean CBEDS program data
4. build and validate the school panel
5. construct alternative TK/K attendance denominators
6. compare Irvine and Lodi
7. export memo tables and diagnostics

## Measurement status

Observed quantities are kept separate from reconstructed or assumption-dependent quantities. In particular, neither Census enrollment × 180 nor eligible cumulative enrollment × 180 is treated as observed expected student-days.

See `docs/denominator_method_note.md` and `docs/decisions.md`.

## Status

Active research repository. Private while the project is in development.
