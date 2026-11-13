# Validation report

## Statewide backbone checks

The 2024–25 Census Day school-total file defines the left-join universe.

- 10,591 unique school-level Census TA rows.
- Census grade columns sum to total enrollment for every school row.
- 6,295 Census schools have positive combined TK+K enrollment before pseudo-entity exclusions.
- 6,234 of the 10,591 Census schools have a school-level GRTKKN absenteeism row.
- 6,204 of the 6,295 positive-TK/K Census schools have a GRTKKN absenteeism row.
- 291 positive-TK/K schools have a matched GRTKKN row with at least one core metric suppressed.
- Suppression is retained as unknown, not recoded to zero.

These counts differ from earlier kindergarten-only diagnostics because the primary unit is now combined TK+K following the PI decision.

## Focus districts

After excluding CDS school codes 0000000 and 0000001 and requiring positive Census TK+K enrollment:

### Irvine Unified

- 30 schools in the 2024–25 focus universe.
- All 30 have usable unsuppressed TK/K denominator inputs.
- Census TK+K enrollment across usable schools: 3,172.
- Eligible cumulative TK+K enrollment: 3,417.
- Observed TK+K absence days: 33,152.

### Lodi Unified

- 34 schools in the 2024–25 focus universe.
- 33 have usable unsuppressed TK/K denominator inputs.
- Valley Robotics Academy has a suppressed TK/K absenteeism cell; its Census TK+K enrollment is 9, so its denominator estimates remain missing rather than being treated as zero.
- Census TK+K enrollment across the 33 usable schools: 2,632.
- Eligible cumulative TK+K enrollment: 2,823.
- Observed TK+K absence days: 43,256.

## 2024–25 denominator regression benchmark

Using a 180-day full-year benchmark:

- Irvine: Census proxy = 537,808; cumulative proxy = 581,908; cumulative is 8.19995% larger.
- Lodi: Census proxy = 430,504; cumulative proxy = 464,884; cumulative is 7.98599% larger.

For non-charter schools only:

- Irvine: 29 usable schools; cumulative proxy is 8.75742% larger.
- Lodi: 29 usable schools; cumulative proxy is 8.52118% larger.

Thus the roughly eight-percent aggregate difference is not being driven solely by charter schools.

The two constructions represent different assumptions rather than alternative measurements of an observed quantity. The Census construction treats Census Day TK+K enrollment as the full-year enrollment stock. The cumulative construction includes eligible students observed across the year but assigns each the equivalent of a full 180 days of exposure. Neither construction identifies student-specific expected attendance days from the public aggregate data.

## Irvine district-data validation

The Irvine district files provide daily Kindergarten and Pre-Kindergarten attendance for November 3–7, 2025. Irvine Unified identifies Pre-Kindergarten as the program formerly called Transitional Kindergarten, allowing PK and K attendance to be combined for comparison with the CDE TK+K population.

The district attendance reports contain:

- 30 Kindergarten school rows.
- 28 PK/TK school rows.
- 8,703 observed Kindergarten student-days across the five days.
- 5,401 observed PK/TK student-days across the five days.
- 14,104 combined TK+K observed student-days.

Vista Verde K-8 and IUSD Virtual Academy Elementary do not have PK/TK rows in the district attendance report. The same-year 2025–26 CDE Census reports zero TK enrollment at both schools, so their absent PK/TK report rows are reconciled to zero TK attendance rather than treated as unresolved missing observations.

The 30 schools represented in the district attendance reports contain, in the 2025–26 CDE Census:

- TK enrollment: 1,170.
- K enrollment: 1,873.
- Combined TK+K enrollment: 3,043.

Observed combined TK+K attendance averaged 2,820.8 students per day during the five-day period. The aggregate observed-attendance-to-Census-enrollment ratio is 0.926980. The median school-level ratio is 0.927264.

These figures are descriptive validation checks, not an annual denominator estimate. The district attendance observations cover only November 3–7, 2025. The difference between Census enrollment and observed daily attendance can reflect ordinary student absences as well as enrollment changes. The comparison therefore does not establish whether the Census-based or cumulative-enrollment-based 180-day construction is closer to true annual TK+K attended student-days.

The full 2025–26 Irvine CDE school-level Census extract contains 47 school rows and 3,318 TK+K students (1,296 TK and 2,022 K). The 3,043 figure above refers only to the 30 schools represented in the district attendance reports and should not be interpreted as the district-wide Census total.

## Lodi district-data assessment

The Lodi district files cover the full 2025–26 reporting period but do not provide a grade-specific attendance benchmark analogous to Irvine's daily attendance reports.

The workbook contains grade-specific meal counts, including separate Preschool and Kindergarten fields, while the reported Average Daily Attendance measure is school-wide. The workbook's grade-level ADP fields describe meal participation rather than student attendance and therefore cannot serve as grade-specific attendance denominators.

Repository searches found no documentation establishing that the Lodi meal-data Preschool category represents Transitional Kindergarten. Lodi's program documentation treats preschool and Transitional Kindergarten as distinct programs. Accordingly, Preschool meal counts are not relabeled as TK, and Preschool plus Kindergarten meals are not combined and presented as a TK+K numerator without additional documentation.

The original Lodi eligibility report also contains Kindergarten-filtered `Highest Eligible` and `Last Day` fields for the July 29, 2025–May 29, 2026 eligibility period. The report defines `Last Day` as the number of enrolled students on the last day of the selected date range.

A dedicated source audit matched 31 reported Kindergarten schools to the 2025–26 CDE Census. The original PDF was inspected directly after the workbook extraction because the exported workbook separates the school-name and numeric portions of the wide report. The PDF confirms that these are horizontally paginated portions of the same Kindergarten-filtered report and preserve the same 31-school row order; the school-by-school pairing used in `R/09_lodi_enrollment_triangulation.R` is therefore retained as source-supported rather than inferred from row counts alone. `Highest Eligible` and `Last Day` are identical at every school and both total 3,481. Same-year CDE Kindergarten Census enrollment across those 31 matched schools totals 1,763. The report-side quantity is therefore 1.9745 times the Census total, a difference of 1,718 students, and exceeds Census enrollment at all 31 schools.

This is useful triangulation evidence, but it does not identify annual attended student-days. Because `Highest Eligible` and `Last Day` are identical throughout this extract, they do not supply two independent enrollment observations. More importantly, neither field provides student-specific expected attendance duration. The comparison therefore does not establish whether the Census-based or cumulative-enrollment-based 180-day construction is closer to true annual TK/K attended student-days.

The Lodi files may support separate downstream meal-participation sensitivity analyses where numerator and denominator populations can be aligned, but the report-side eligibility/enrollment quantities are not treated as denominator ground truth.

## Reproducibility status

The R pipeline contains cleaning, joining, validation, denominator-construction, focus-district, Irvine district-validation, and Lodi source-triangulation modules through `R/09_lodi_enrollment_triangulation.R`.

The regression script is designed to rerun the pipeline and check:

- the frozen 2024–25 Irvine/Lodi denominator benchmarks;
- statewide school-panel integrity;
- non-charter sensitivity results;
- the 64-school Irvine/Lodi handoff file;
- the 58-row Irvine district-attendance transcription;
- the 47-school 2025–26 Irvine Census extract;
- deterministic matching of the 30 Irvine district-report schools;
- the two zero-TK reconciliations; and
- the 14,104 observed five-day TK+K student-days and associated Census comparison;
- the 31-school Lodi Kindergarten eligibility-report extract;
- the identical 3,481 `Highest Eligible` and `Last Day` totals; and
- the 1,763 same-year CDE Kindergarten Census total for those matched Lodi schools.

A verifiable full-pipeline run is not available in this workspace. The separate `R/10_stability_audit.R` module is not covered by `tests/test_pipeline.R`.


## Current verification status (2026-10-29)

All 11 R modules, `RUN_ALL.R`, and `tests/test_pipeline.R` parsed successfully under R 4.3.3 at project commit `66572de`. This confirms syntax only. Running `Rscript tests/test_pipeline.R` stopped in `R/00_config.R` because the four CDE/CBEDS raw inputs are absent from `data/raw/`; the two district extracts are also absent. The raw-data directory is intentionally excluded from version control.

Earlier documentation cited a successful October 25 pipeline run and linked `analysis/2026-10-25` in the Feed California Kinders repository at commit [7d6c3824b4beb3fcc89f9d4ff2eb6908da38a443](https://github.com/whippedfruit/Feed-California-Kinders/tree/7d6c3824b4beb3fcc89f9d4ff2eb6908da38a443). That path is absent from the cited commit tree, so the log and its claimed output checks could not be verified from that source. Treat the prior pass claim as unverified until the execution record is restored or the suite is rerun with the exact inputs.

The separate `R/10_stability_audit.R` module remains outside the runner and the test suite. It requires both `sr2425-v3.txt` and the generated school comparison CSV; neither is available in this workspace.


The [November 12 source-backed rerun](october_2026_stability_reproduction.md#november-12-source-backed-r-rerun) passed the full R pipeline, frozen regression suite, and separate stability audit. It also identifies the later team commit that contains the October 25 logs.
