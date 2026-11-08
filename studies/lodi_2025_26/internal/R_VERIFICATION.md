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

## November 8, 2026 handoff audit

- Recomputed all 31 published school rows from the preserved meal and CDE snapshots independently of the R output. School-level breakfasts, lunches, modeled attendance days, and ratios agreed within published rounding.
- Executed an equivalent local copy of the updated base-R snapshot pipeline using R 4.5.0, followed by expanded tests of the 31 school rows and the clarified Independence exclusion. Both passed:

  ```text
  OK: 31 matched schools; K breakfasts=70667, lunches=203639; K attended-days=287174
  PASS: 31 school joins, 35 source schools, meals, K denominator and ratios verified.
  ```
- GitHub Actions shows **no workflow runs for this review branch**. The repository-integrity workflow runs on pull requests or manual dispatch. This local run is not a GitHub CI result.
- The original Excel workbook's kindergarten counts and grand totals were independently reconciled. Direct XLSX import through R's optional `readxl` route remains untested; it is not required for the snapshot workflow.
