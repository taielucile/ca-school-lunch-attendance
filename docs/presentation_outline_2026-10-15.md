# October 15 research meeting: quick walkthrough

## 1. What I was trying to build

The denominator for school-level TK/K meal take-up is student-days attended, not enrollment alone.

At school × TK/K:

`attended student-days = expected attendance days − absence days`.

## 2. What the public CDE data give us

- Absenteeism by Reason: combined TK/K eligible cumulative enrollment and total absence days.
- Census Day enrollment: separate TK and K enrollment counts.
- CBEDS: full-day/part-day TK/K program classifications.

Keeping TK and K combined avoids trying to allocate a combined public absenteeism measure back to individual grades.

## 3. What is missing

The public aggregate data do not report total Expected Attendance Days at school × TK/K.

CALPADS STAS contains student-school Expected Attendance Days, which is the duration-weighted exposure concept needed for the denominator, but that quantity is not released in the public school-by-grade absenteeism file.

## 4. Two main public-data constructions

**Census proxy**  
`180 × Census TK/K enrollment − TK/K absence days`

**Cumulative proxy**  
`180 × eligible cumulative TK/K enrollment − TK/K absence days`

The Census approach uses a one-day enrollment stock. The cumulative approach captures eligible students appearing during the year but assigns each a full 180-day exposure.

A midpoint construction is retained only as a descriptive sensitivity check; it has no independent identification argument.

## 5. 2024–25 sensitivity

| District | Census proxy | Cumulative proxy | Difference |
|---|---:|---:|---:|
| Irvine | 537,808 | 581,908 | +8.20% |
| Lodi | 430,504 | 464,884 | +7.99% |

School-level differences exceed 20% in several cases. Restricting to non-charter schools leaves the district-level difference around 8–9%.

Because the same observed absence-days value is subtracted from both constructions:

`D_cumulative − D_census = 180 × (cumulative enrollment − Census enrollment)`.

The sensitivity is therefore about how annual enrollment exposure is represented, not about different absence measures.

## 6. What the Irvine district data tell us

Irvine provides actual daily K and PK/TK attendance for November 3–7, 2025.

For the 30 schools represented in the reports:

- same-year CDE Census TK/K enrollment = 3,043;
- observed TK/K student-days over five days = 14,104;
- mean daily observed TK/K attendance = 2,820.8;
- mean daily attendance / Census enrollment = 92.70%;
- median school-level attendance / Census ratio = 92.73%.

This is useful as a same-year check on the scale and school-level behavior of Census enrollment relative to actual attendance.

It does **not** validate an annual 180-day denominator. The reports cover only five days, and the gap between Census enrollment and attendance includes ordinary absences as well as any enrollment differences.

## 7. What the additional Lodi fields tell us

Lodi covers the full 2025–26 reporting period, but its school-wide ADA and grade-level meal ADP still do not provide grade-specific TK/K attendance.

The original eligibility report does contain Kindergarten-filtered `Highest Eligible` and `Last Day` fields for July 29, 2025–May 29, 2026. The report defines `Last Day` as enrolled students on the last day of the selected date range.

Across 31 schools:

- Highest Eligible = 3,481;
- Last Day = 3,481;
- the two measures are identical at every school;
- same-year CDE K Census enrollment = 1,763; and
- the report-side quantity is higher than Census at all 31 schools.

This gives us another grade-specific enrollment/eligibility comparison, but not the missing duration-weighted exposure. It therefore does not select between the Census and cumulative annual denominator constructions.

The meal file also has separate `Preschool` and `Kindergarten` categories. The available documentation does not establish that `Preschool` means TK, and Lodi program documentation treats preschool and TK as distinct programs. I therefore do not combine those fields and label them TK/K.

## 8. What remains unidentified

Neither the public CDE files nor the available Irvine/Lodi district files identify annual school × TK/K expected attendance days.

The current evidence therefore does not establish that the Census or cumulative construction is uniformly closer to the true annual denominator.

For analyses where the numerator can be aligned to the same TK/K population, I would carry both constructions as explicit sensitivity specifications rather than present either as observed attendance.

If a single annual denominator is required, student-specific or otherwise duration-weighted Expected Attendance Days would be the cleaner target.

## 9. Questions for the team

The remaining questions are data questions rather than reasons to choose an unsupported estimator:

- Is there student-specific or otherwise duration-weighted Lodi expected-attendance data beyond the eligibility-report fields?
- What exactly does the Lodi meal-data `Preschool` category represent?
- For meal-access analyses, should Rio Valley's homeschool/independent-study model be handled separately?
- If the substantive results are sensitive to the denominator, is obtaining duration-weighted expected-attendance data worth pursuing?

## Reproducibility

The full R pipeline now runs through `R/09_lodi_enrollment_triangulation.R`. The regression and integrity test suite passes, including the 2024–25 Irvine/Lodi benchmarks, the 2025–26 Irvine district-attendance validation, and the 31-school Lodi Kindergarten source-triangulation checks.
