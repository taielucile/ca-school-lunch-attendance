# Reproduce the October 2026 TK/K stability analysis

Maintainer/contributor: Taiel Lucile. Analysis is part of the Feed California Kinders TK/K denominator work.

## Inputs and provenance

The original 2024–25 attendance comparison is produced by this repository's `RUN_ALL.R`, using `cdenroll2425.txt`, `absenteeismreason25-v2.txt`, and `cbedsora24b.txt` (and three additional inputs for the later Irvine and Lodi modules; see root README). Generated outputs and raw files are intentionally ignored by Git.

Additional CDE input: `sr2425-v3.txt`, 2024–25 Stability Rate download. The audit selects **school** aggregate level (`S`), combined TK/K (`GRTKKN`), Irvine Unified and Lodi Unified, excluding pseudo school codes `0000000` and `0000001`. It requires an exact 64-school CDS identifier match with the existing attendance comparison.

## Commands (from repository root)

1. Obtain original inputs listed in the root README and put them in `data/raw/`. Do not commit raw district files without permission.
2. `Rscript RUN_ALL.R` and `Rscript tests/test_pipeline.R` to rebuild and test the upstream attendance work.
3. Put the original CDE Stability Rate TSV at `data/raw/sr2425-v3.txt`.
4. `Rscript R/10_stability_audit.R` to extract, join, validate, and write:
   - `output/tables/october_2026_stability_summary.csv`
   - `output/tables/october_2026_stability_school_audit.csv`

If the six upstream raw files are unavailable, an RA can instead obtain the **generated** `output/tables/irvine_lodi_denominator_comparison_2024_25.csv` from the analyst and place it at that path, then run step 4. This independently verifies the October join/correlations **but does not reproduce the upstream attendance pipeline**.

The stability TSV is read with `encoding="latin1"` rather than `fileEncoding="latin1"`; the latter stopped prematurely on the original 354,000-row file in the tested environment.

## Analysis and interpretation

64 schools are matched: 30 Irvine, 34 Lodi. The correlation sample excludes one Lodi school with suppressed TK/K absenteeism, leaving 30 Irvine and 33 Lodi.

The correlated denominator measure is **`B_vs_A_pct`**, the percentage difference between the cumulative-enrollment and Census-enrollment 180-day *constructed* attended-day denominators. It is **not** the raw enrollment count difference. Pearson and Spearman correlations compare this percentage with the CDE's school-level stability rate.

Expected rounded correlations: Irvine Pearson −0.798 and Spearman −0.735; Lodi Pearson −0.647 and Spearman −0.664. District weighted stability uses **sum(stable enrollment) / sum(adjusted cumulative enrollment)** across all 64 schools (30 Irvine, 34 Lodi), not an average of school percentages: Irvine 3012/3519 = 85.5925%; Lodi 2450/2957 = 82.8542%. The October 15 memo gives Lodi 82.8%; conventional rounding of these source totals gives **82.9%**. This discrepancy is documented, not silently changed.

The stability release's 245-calendar-day window is **not** 245 instructional days. Neither the stability rate nor the 180-day proxy identifies student-specific expected attendance exposure. Correlations are descriptive, not causal; they cannot establish which denominator is closer to actual annual TK/K student-days attended.

## Calendar review

180 instructional days is a district-level benchmark, not a verified per-school/per-student exposure count. School-specific exceptions, including Vista Verde, Irvine Chinese Immersion Academy, Lodi charters, and independent-study programs, require school-calendar checks. Calendar verification is separate from reproducing the correlations. Do not infer instructional-day totals from a 245-calendar-day stability window.

## Verification history and limits

The 2024–25 stability TSV (354,000 rows) was independently read in R 4.5.0, and its 64 extracted records were cross-checked with a separate Python extraction. The 64-school join and four correlations were independently reproduced in R and Python using the saved attendance comparison CSV. The entire `RUN_ALL.R` pipeline was **not rerun in the verification workspace** because its six original raw inputs were not accessible there; the repository documents an earlier local successful run. Do not claim a new end-to-end run until those inputs are supplied and tests pass.
