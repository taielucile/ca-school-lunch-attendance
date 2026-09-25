# Memo: Public-data approaches to TK/K attendance denominators in Irvine and Lodi

**To:** Andrew Penner  
**From:** Taiel Lucile  
**Date:** September 24, 2026  
**Re:** 2024–25 TK/K attendance denominator

## Bottom line

I compared alternative ways of approximating school-level TK/K student-days attended from the public 2024–25 CDE data and then used the Irvine and Lodi district files to see how much they could help adjudicate the assumptions.

The public files provide TK/K absence days, but not the corresponding expected attendance days needed to calculate student-days attended directly. The two main public-data constructions differ by about 8% at the district level: using eligible cumulative enrollment produces a denominator 8.20% larger than using Census Day enrollment in Irvine and 7.99% larger in Lodi. The school-level differences are more variable and exceed 20% at several schools.

The district files help, but they do not fully resolve which annual construction is closer to the true denominator. Irvine provides actual daily TK and K attendance for one week in 2025–26. Across the 30 schools in those reports, observed TK/K attendance averaged 2,820.8 students per day compared with 3,043 TK/K students in the same-year CDE Census, or 92.70% of Census enrollment. This is useful as a same-year check on the scale of the Census enrollment measure, but it does not validate either annual 180-day construction because it covers only five days and the difference between enrollment and attendance includes ordinary absences.

The Lodi files cover the full year but do not contain grade-specific attendance or student-days attended. They include school-wide ADA and grade-specific meal participation, so they cannot provide a TK/K attendance benchmark comparable to Irvine. I also followed up on the Kindergarten `Highest Eligible` and `Last Day` fields in the original Lodi report. Both equal 3,481 in aggregate and are identical at all 31 reported schools, compared with 1,763 Kindergarten students in the same-year CDE Census for those matched schools. That gives us another grade-specific enrollment/eligibility comparison, but it still does not provide the student-specific expected attendance days needed to adjudicate the annual denominator.

Given those limitations, I do not think the available data establish that either public construction is uniformly closer to the true annual denominator. I would keep the Census and cumulative constructions explicitly labeled as alternative proxies and use the difference between them to show denominator sensitivity rather than label either one as observed student-days attended.

## Target quantity

The quantity we ultimately want at each school is:

`TK/K student-days attended = TK/K expected attendance days − TK/K absence days`.

The public Absenteeism by Reason file provides the TK/K absence component. It does not publish the corresponding total expected attendance days.

The underlying CALPADS Student Absence Summary (STAS) records contain Expected Attendance Days and Days Attended. Expected attendance days are student-specific, so they account for how long a student was actually expected to attend a particular school. That is the exposure concept needed for the denominator, but it is not released in the public school-by-grade absenteeism file.

## Public data and sample

I linked three 2024–25 CDE sources by 14-digit CDS code:

1. Census Day enrollment, which reports TK and K separately;
2. Absenteeism by Reason, which reports eligible cumulative enrollment and total absence days for TK/K combined; and
3. CBEDS, which provides TK/K program information, including full-day and part-day classifications.

I kept TK and K combined based on our September 23 exchange rather than trying to allocate the combined absenteeism measures back to K.

The focus sample has 30 Irvine schools with positive TK/K Census enrollment and 34 Lodi schools. All 30 Irvine schools have usable TK/K absenteeism values. Thirty-three of the 34 Lodi schools do. Valley Robotics Academy has a suppressed TK/K absenteeism cell, so I leave its denominator estimates missing rather than treating the suppressed value as zero.

## Approach 1: Census Day enrollment

`D_census = 180 × Census TK/K enrollment − observed TK/K absence days`

This uses the number of TK/K students enrolled on Census Day as the enrollment base for a full-year exposure calculation.

The advantage is that it does not assign 180 days to every student who appears at the school at any point during the year. The limitation is that Census Day is only a snapshot. It can miss exposure from students who enter later and overstate exposure for students present on Census Day who leave before the end of the year.

## Approach 2: eligible cumulative enrollment

`D_cumulative = 180 × eligible cumulative TK/K enrollment − observed TK/K absence days`

This uses annual eligible cumulative enrollment rather than a single-day snapshot.

The advantage is that its population frame is closer to the annual absenteeism file because it captures eligible students who appear during the year. The limitation is that cumulative enrollment is a headcount rather than a duration-weighted exposure measure. Multiplying it by 180 gives every included student a full school year even if that student was expected to attend for only part of the year.

CDE excludes students expected to attend fewer than 31 instructional days from eligible cumulative enrollment. That removes some very short enrollments, but students expected to attend between 31 and 179 days can still be included.

## Approach 3: midpoint sensitivity

`D_midpoint = 180 × mean(Census enrollment, eligible cumulative enrollment) − observed TK/K absence days`

This produces a value between the first two approaches. I included it as a descriptive sensitivity check, but there is no substantive reason to assume the arithmetic midpoint is closer to the true denominator.

## 2024–25 Irvine and Lodi results

| District | Usable schools | Census TK/K | Eligible cumulative TK/K | TK/K absence days | Census proxy | Cumulative proxy | Cumulative vs. Census |
|---|---:|---:|---:|---:|---:|---:|---:|
| Irvine Unified | 30 | 3,172 | 3,417 | 33,152 | 537,808 | 581,908 | +8.20% |
| Lodi Unified | 33 | 2,632 | 2,823 | 43,256 | 430,504 | 464,884 | +7.99% |

The district-level sensitivity is very similar across Irvine and Lodi, but that aggregate result hides larger school-level differences. Several schools have cumulative-based denominators more than 20% above their Census-based denominators.

The difference between the two main constructions is mechanical:

`D_cumulative − D_census = 180 × (eligible cumulative enrollment − Census enrollment)`.

The same observed absence-days total is subtracted in both constructions, so it cancels when the two are compared. The sensitivity is therefore coming from how annual enrollment exposure is represented, not from different absence measures.

Holding meals served fixed, the larger cumulative denominator will mechanically produce a lower estimated meal take-up rate. The denominator choice can therefore matter for both estimated take-up levels and school-level comparisons.

## Irvine district-data check

The Irvine files provide school-level daily Kindergarten and Pre-Kindergarten attendance for November 3–7, 2025. Irvine identifies Pre-Kindergarten as the program formerly called Transitional Kindergarten, so the two district reports can be combined to construct observed TK/K attendance for that week.

The reports contain 30 K school rows and 28 PK/TK rows. The two K schools without PK/TK rows, Vista Verde K-8 and IUSD Virtual Academy Elementary, both have zero TK enrollment in the same-year CDE Census.

Across the 30 schools:

| Measure | Value |
|---|---:|
| 2025–26 Census TK enrollment | 1,170 |
| 2025–26 Census K enrollment | 1,873 |
| 2025–26 Census TK/K enrollment | 3,043 |
| Observed K student-days, Nov. 3–7 | 8,703 |
| Observed TK student-days, Nov. 3–7 | 5,401 |
| Observed TK/K student-days, Nov. 3–7 | 14,104 |
| Mean daily TK/K attendance | 2,820.8 |
| Mean daily attendance / Census TK/K | 92.70% |

The median school-level attendance-to-Census ratio is also 92.73%, so the aggregate relationship is not being generated by a single unusually large school.

I interpret this as a limited validation check rather than a way to choose between the two annual proxies. Census enrollment is an enrollment stock, while the district values measure students actually attending on five particular days. Ordinary absences therefore contribute to the gap even if Census enrollment accurately represents the enrolled population. The comparison also comes from 2025–26, while the public annual denominator analysis is currently based on 2024–25 absenteeism data.

The Irvine files therefore help establish the scale and school-level behavior of Census enrollment relative to observed daily attendance, but they do not identify annual expected student-days and do not tell us whether the Census or cumulative 180-day construction is closer to the annual truth.

## Lodi district-data check

The Lodi files cover the full 2025–26 reporting period, but they do not contain a grade-specific attendance measure comparable to Irvine's daily attendance reports.

The workbook includes grade-specific meal counts and school-wide Average Daily Attendance. Its grade-level ADP measures refer to meal participation rather than attendance. Comparing a TK/K public denominator directly with whole-school ADA would therefore mix different populations and would not provide a valid denominator benchmark.

The meal files also separate `Preschool` and `Kindergarten`. I did not find documentation in the repository establishing that the `Preschool` category represents Transitional Kindergarten, and Lodi treats preschool and TK as distinct programs in its program materials. I therefore do not combine Preschool and Kindergarten meals and relabel them as a TK/K numerator without additional documentation.

The original report does contain another potentially useful Kindergarten-specific check. For the July 29, 2025–May 29, 2026 eligibility period, it reports `Highest Eligible` and `Last Day`; the report defines `Last Day` as the number of enrolled students on the last day of the selected date range. Across the 31 reported schools, both fields total 3,481 and are identical school-by-school.

I matched those 31 schools to the same-year 2025–26 CDE Census. Their CDE Kindergarten Census enrollment totals 1,763, so the Lodi report-side quantity is 1.9745 times the Census total and is higher at every matched school.

I would not interpret that difference as evidence that the Census denominator is wrong by 97%. The Lodi report is an eligibility-report quantity covering the full reporting period, whereas CDE Census enrollment is a point-in-time snapshot. More importantly for the denominator problem, neither quantity tells us how many instructional days each student was expected to attend. Because `Highest Eligible` and `Last Day` are also identical throughout this extract, they do not give us two independent observations with which to recover that missing exposure.

The Lodi fields are therefore useful triangulation evidence, but they still do not adjudicate between the Census and cumulative 180-day annual constructions. The files also do not provide a clearly aligned TK/K meal numerator because `Preschool` cannot be assumed to mean TK.

## Calendar and sample checks

I used 180 days as the full-year benchmark. Irvine's audited 2024–25 Schedule of Instructional Time reports 180 actual kindergarten days, and Lodi district policy specifies a 180-day instructional year. This supports 180 as a school-year benchmark, but it does not imply that every student was expected to attend all 180 days.

I also checked whether charters were driving the difference between the two constructions. They are not. Restricting the comparison to non-charter schools leaves the cumulative denominator 8.76% above the Census denominator in Irvine and 8.52% above it in Lodi.

One Lodi charter, Rio Valley, operates as a homeschool/independent-study program. I would treat that school separately when interpreting campus meal access because the relationship between enrollment, attendance, and access to an on-campus meal may differ from a conventional school setting.

## Interpretation and next step

The public data let us quantify how sensitive the denominator is to alternative representations of enrollment exposure, but neither the public files nor the available Irvine/Lodi district files identify the true annual TK/K expected attendance days.

The Census construction uses a point-in-time enrollment stock and therefore does not represent annual enrollment turnover. The cumulative construction captures students who appear during the year but assigns every eligible student a full 180-day exposure. The available evidence does not provide a defensible empirical basis for selecting one of those assumptions as uniformly correct.

For analyses that can be aligned to the same TK/K population, I would therefore retain both constructions and report whether substantive conclusions change across them. I would keep the midpoint only as a secondary descriptive sensitivity check rather than use it as a preferred estimator.

If an analysis requires a single annual denominator rather than a sensitivity range, the cleaner solution would be student-specific or otherwise duration-weighted expected attendance data. The underlying STAS Expected Attendance Days field represents that target more directly than either public enrollment proxy.

## Reproducibility note

The cleaning, joins, denominator constructions, district comparisons, and diagnostics are organized as a reproducible R workflow. Suppressed absenteeism cells remain missing rather than being converted to zero, and the Census and cumulative constructions remain explicitly labeled as proxies.

The workflow now includes the 2025–26 CDE Census, Irvine district attendance validation, and Lodi Kindergarten eligibility-report triangulation. The complete pipeline through `R/09_lodi_enrollment_triangulation.R` was rerun from the raw files after these additions, and all automated regression and integrity tests passed.
