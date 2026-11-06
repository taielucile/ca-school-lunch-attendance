# R execution and validation — 2026-11-06

Environment: Debian 13 amd64; `Rscript` version 4.5.0.

Executed successfully with the reorganized study layout:

```sh
Rscript code/reproduce_lodi_2025_26.R
Rscript code/test_lodi_reproduction.R
```

Run output:

```text
OK: 31 matched schools; K breakfasts=70667, lunches=203639; K attended-days=287174
PASS: 31 school joins, 35 source schools, meals, K denominator and ratios verified.
```

The pipeline reads three preserved source CSV snapshots, reconciles the school lists and attendance allocation, checks fixed source totals, and writes school-level, coverage, and aggregate CSV tables. On November 6, 2026, the analysis-only R script and independent test were rerun after removing figure generation; both passed. Final figure creation and reporting belong to Angela. The output was checked against the earlier independently calculated Python results; numerical school measures agreed (minor text-formatting differences in integer-like decimal cells only).

**Not tested:** `--meal-xlsx` direct import of the original district workbook using `readxl`. The original workbook was inspected separately and its 31 rows and printed K grand totals were reconciled; the tested R workflow reads the preserved audited meal CSV snapshot.

The arithmetic test does **not** validate the model's 180-day, Census-stock, or proportional TK/K absence-allocation assumptions against observed kindergarten attendance.