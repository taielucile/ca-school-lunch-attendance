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

`RUN_ALL.R` uses base R through `R/08_district_validation.R`; `R/09_lodi_enrollment_triangulation.R` requires `dplyr`, `readr`, and `stringr`. `R/10_stability_audit.R` is a separate base-R analysis.

Install the `R/09` dependencies once with `install.packages(c("dplyr", "readr", "stringr"))`.

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

A syntax-only check under R 4.3.3 parsed all 11 R modules, RUN_ALL.R, and tests/test_pipeline.R at commit 66572de. The end-to-end test did not run because data/raw/ is empty and the runner stops with missing enrollment, absenteeism, and CBEDS inputs. Earlier documentation linked an October 25 execution record at analysis/2026-10-25 in the companion repository, but that path is absent from the cited commit's tree; treat the historical pass as unverified until its log or artifact is restored. GitHub Actions checks repository integrity and raw-data exclusions only; it does not run R. R/10_stability_audit.R is separate from tests/test_pipeline.R and needs its own run with sr2425-v3.txt.

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

## October 2026 stability audit

The repository includes a standalone **2024–25 school-level stability check** added in [PR #5](https://github.com/taielucile/ca-school-lunch-attendance/pull/5). It links CDE TK/K Stability Rate records to the 64-school Irvine/Lodi denominator panel (30 Irvine, 34 Lodi) and tests whether enrollment stability covaries with the percentage gap between two constructed attendance denominators. It does not estimate true annual attendance exposure.

Run the existing pipeline first, then place the CDE Stability Rate file at `data/raw/sr2425-v3.txt` and run:

```sh
Rscript R/10_stability_audit.R
```

The module requires either the generated comparison CSV or the upstream inputs needed to create it. The reported correlations are Irvine Pearson `r = -0.798`, Spearman `rho = -0.735`; Lodi `r = -0.647`, `rho = -0.664`. One Lodi school with suppressed TK/K absenteeism is excluded from the correlations. The rate describes enrollment stability, not instructional days or student-specific expected attendance. The October reproduction did not rerun the entire upstream pipeline because its raw inputs were not available in that verification workspace. This module remains separate from `RUN_ALL.R`, and Actions does not execute it.

## October 2026 statewide and Ventura evidence

The October research handoff records two **reported, not independently rerun in this repository** analyses:

- **Statewide 2024–25 district ADA alignment:** 930 of 937 district records retained after excluding seven all-charter districts without the benchmark B-1 ADA line. The TK/K–3 aggregate Census-minus-absence proxy gap was reported as +0.26%; 56%, 75%, and 90% of districts were within 1%, 2%, and 5%, respectively. This is district-level alignment, **not** school-level TK/K validation. See [statewide methods and exclusions](docs/statewide_ada_comparison_2026-10.md).
- **Ventura 2025–26 combined TK/K ADA validation:** 17 matched schools; observed TK/K ADA 1,179.14 versus absence-adjusted Census proxy 1,186.06 (+0.59%), cumulative proxy 1,236.06 (+4.83%), and unadjusted Census 1,263.00 (+7.11%). This is one district/year and does not establish a statewide preferred estimator. See [Ventura methods and caveats](docs/ventura_tkk_ada_validation_2026-10.md).

See the [October handoff and reproduction checklist](docs/october_2026_handoff.md). Original statewide/Ventura source files and scripts are not in this repository, so these results remain reported pending independent reproduction. The separate stability audit is included in merged [PR #5](https://github.com/taielucile/ca-school-lunch-attendance/pull/5); its standalone module still needs a run in an R-enabled environment.

## Next analysis

The annual public-data denominator work has reached the limit supported by available exposure measures. The Irvine November 3–7, 2025 meal-service PDFs and attendance reports have been manually transcribed and aligned for a provisional short-window audit; the extraction is not yet rebuildable from this repository. The five meal reports reconcile to their printed all-grade quantity totals. After excluding the virtual school, the matched campus sample contains 29 Kindergarten schools and 28 PK/TK schools, representing 14,099 student-days.

If absent school-grade-meal rows are treated as zero, the preliminary extract contains 2,678 breakfasts and 4,023 lunches: 18.99 and 28.53 meals per 100 matched student-days, respectively. These are not final participation estimates. Seventy of 570 possible school-grade-day-meal records have no row in the export, and the report semantics must confirm whether those omissions mean zero meals and whether `Total Quantity` represents meals served. See `docs/meal_numerator_audit.md`.

Lodi remains unresolved for a population-aligned TK/K meal calculation. Its files do not provide grade-specific attendance, and the `Preschool` meal category is not established as TK. Rio Valley's independent-study model will be kept separate from the primary campus-based meal sample unless its meal-serving arrangements and target population can be aligned.

## Status

Active research repository. The denominator workflow is complete under the currently available data; the Irvine five-day meal/attendance analysis is under source-semantic review. Private while the project is in development.


## 2025–26 district denominator extracts (working branch, October 29)

This branch contains public CDE-derived school proxies for **Lodi, Ventura, Irvine, Elk Grove, Ontario-Montclair, and Ojai** in `results/2025_26/`. Each has a wide school-level file (`_school_denominator_proxies.csv`) and a long TK/K/first-grade **model-based** file (`_school_grade_proxies.csv`). See `results/2025_26/district_extract_quality_summary.csv` (corrected **35-school Lodi**; six districts **161 schools/156 calculable TK/K proxies**) and `results/2025_26/all_district_quality_summary.csv` (full statewide source-backed output; actual-school analytical coverage requires excluding pseudo-entities).

**Reproduced public side of Ventura 2025–26 check:** 17 schools; 1,263.00 Census TK/K, 1,186.06 Census-minus-absences/180, 1,236.06 cumulative-minus-absences/180. The 17-school comparison is reproduced against the team's independently checked archived Ventura benchmark (observed 1,179.14): **13 Census-adjusted closer, two cumulative-adjusted closer (Lincoln and Montalvo), two ties**. This remains an archived-reference replication, not a new extraction of the original district workbook. The 180-day assumption follows Ventura's verified calendar; days can vary elsewhere.

**Rebuild all districts** with the official 2025–26 files present locally:
```sh
python scripts/build_denominators_2526.py \
  data/raw/cdenroll2526.txt data/raw/absenteeismreason26.txt \
  output/district_denominators
python -m unittest discover -s tests -p 'test_denominators_2526.py' -v
```

**FNS10 linkage** is separately re-audited directly from the team's complete original **2024–25** claims workbook and CBEDS source using `scripts/run_fns10_source_audit.py`. The full output and unresolved candidate queue are under `results/2024_25/`. Conservative normalization produced 6,282 exact candidates among 9,985 pairs, with 3,703 unmatched; this differs from the earlier 6,515/9,988 matching rules and is not an authoritative site-to-CDS crosswalk.

Read `docs/district_denominators_2025_26.md` and `docs/fns10_cde_linkage_review_2026_10.md` before using these outputs. TK/K is a combined published absence group; TK and kindergarten separate grade estimates and first-grade estimates in the long files allocate group-level absences by Census enrollment share. These are **assumption-dependent proxies**, not observed grade-specific ADA or participation rates. No meal numerator is merged here; statewide FNS10 2024–25 and district 2025–26 meal records must not be conflated.


The active branch includes a [full-source GitHub Actions workflow](.github/workflows/fck-2025-26-repro.yml) that downloads and hashes the official CDE inputs and runs the 2025–26 generator, original FNS10 audit, unit tests, original Ventura R integration harness, and the legacy 2024–25 R suite. Only checked, complete runs should be called passing; historical claims of success are not substitutes for corresponding job logs.
