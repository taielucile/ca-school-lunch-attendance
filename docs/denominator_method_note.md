# TK/K attendance denominator: identification note

## Estimand

The downstream meal take-up calculation requires school-level TK/K student-days actually attended:

`student-days attended = expected student-days - absent student-days`.

The key missing quantity is the duration-weighted sum of Expected Attendance Days for the relevant students at each school.

## Public-data limitation

The 2024–25 public CDE Absenteeism by Reason release reports TK and K jointly and includes eligible cumulative enrollment and total absence days. It does not expose school-by-grade Expected Attendance Days.

Because cumulative enrollment is a count of distinct eligible students rather than a duration-weighted exposure measure, multiplying cumulative enrollment by a full-year day count is not an exact reconstruction of expected student-days.

Census Day enrollment has a different problem: it is a point-in-time snapshot and does not represent all enrollment entry and exit during the year.

The underlying CALPADS STAS Expected Attendance Days field is conceptually closer to the target because expected days can vary with student-school exposure duration.

## Why 180 days appears in the comparison

Irvine Unified's audited 2024–25 instructional-time schedule reports 180 actual kindergarten days for its traditional calendar. Lodi Unified's school-calendar policy calls for 180 days of instruction. Thus 180 is a defensible **full-year calendar benchmark** for the focus-district comparison.

It is not a claim that every student represented in Census or cumulative enrollment had 180 expected attendance days.

## Main public-data constructions

### A. Census snapshot proxy

`180 × TK/K Census enrollment - observed TK/K absence days`

This treats Census Day TK/K enrollment as the full-year enrollment stock.

### B. Eligible cumulative proxy

`180 × TK/K eligible cumulative enrollment - observed TK/K absence days`

This captures eligible students who appear during the year but assigns every included student a full 180-day exposure.

### C. Midpoint sensitivity proxy

`180 × mean(Census enrollment, eligible cumulative enrollment) - observed TK/K absence days`

This is a descriptive sensitivity construction only. There is no identification argument that the arithmetic midpoint is closer to true annual exposure.

A 175-day alternative remains an internal sensitivity benchmark; it is not the primary focus-district calendar specification.

## 2024–25 Irvine/Lodi sensitivity

Under the 180-day benchmark:

- Irvine: Census proxy = 537,808; cumulative proxy = 581,908; cumulative is 8.20% larger.
- Lodi: Census proxy = 430,504; cumulative proxy = 464,884; cumulative is 7.99% larger.

The difference is mechanical because the same observed absence-days quantity is subtracted in both constructions:

`B - A = 180 × (eligible cumulative enrollment - Census enrollment)`.

The comparison therefore measures sensitivity to alternative representations of annual enrollment exposure.

## Irvine district-data check

The Irvine district files provide daily Kindergarten and PK/TK attendance for November 3–7, 2025. Irvine Unified identifies Pre-Kindergarten as the program formerly known as Transitional Kindergarten, allowing the district PK and K attendance reports to be combined for this check.

Across the 30 schools represented in the reports:

- same-year 2025–26 Census TK/K enrollment = 3,043;
- observed TK/K student-days over five days = 14,104;
- mean daily observed TK/K attendance = 2,820.8;
- aggregate mean-daily-attendance-to-Census ratio = 92.70%.

This comparison is useful for checking the scale and school-level behavior of Census enrollment relative to observed attendance. It does not validate an annual 180-day denominator. The observed period is only five days, and the difference between enrollment and attendance includes ordinary absences as well as any enrollment differences.

## Lodi district-data check

The available Lodi files cover the full 2025–26 reporting period but do not contain grade-specific attendance or attended student-days. Their Average Daily Attendance measure is school-wide, while grade-level ADP refers to meal participation.

Those quantities cannot be used as TK/K attendance ground truth.

The meal files also contain separate `Preschool` and `Kindergarten` fields. The available documentation does not establish that `Preschool` represents TK, and Lodi program materials distinguish preschool from Transitional Kindergarten. The workflow therefore does not combine those fields and relabel them as TK/K.

## Interpretation

Neither the public CDE files nor the available district files identify annual school × TK/K Expected Attendance Days. The current evidence therefore does not provide a defensible empirical basis for declaring either the Census or cumulative construction the true or uniformly closer annual denominator.

For analyses with a population-aligned meal numerator, the two constructions should be retained as explicit sensitivity specifications. The midpoint should remain secondary and descriptive.

If a single annual denominator is required, student-specific or otherwise duration-weighted Expected Attendance Days would be the cleaner target.
