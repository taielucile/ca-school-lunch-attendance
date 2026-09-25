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

The Lodi files therefore cannot currently adjudicate which public TK+K attendance-denominator construction is closer to true annual TK+K attended student-days. They may support separate downstream meal-participation sensitivity analyses where numerator and denominator populations can be aligned, but they are not treated as denominator ground truth.

## Reproducibility status

The R pipeline contains cleaning, joining, validation, denominator-construction, focus-district, and Irvine district-validation modules through `R/08_district_validation.R`.

The complete pipeline has been executed locally in R against the raw source files. `Rscript tests/test_pipeline.R` reruns the full pipeline and checks the frozen 2024–25 Irvine/Lodi denominator benchmarks, statewide school-panel integrity, non-charter sensitivity results, the 64-school Irvine/Lodi handoff file, the 58-row Irvine attendance transcription, the 47-school 2025–26 Irvine Census extract, deterministic matching of the 30 Irvine district-report schools, the two zero-TK reconciliations, and the 14,104 observed five-day TK+K student-days and associated Census comparison.

The full regression and integrity test suite passed after the addition of the Irvine district-validation module.
