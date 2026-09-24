# Memo: Public-data approaches to TK/K attendance denominators in Irvine and Lodi

**To:** Andrew Penner  
**From:** Taiel Lucile  
**Date:** September 24, 2026  
**Re:** 2024–25 TK/K attendance denominator

## Bottom line

I compared three ways of approximating school-level TK/K student-days attended from the public 2024–25 CDE data. The public files provide TK/K absence days, but not the corresponding total expected attendance days needed to calculate the denominator directly.

The two main constructions differ by about 8% at the district level: using eligible cumulative enrollment produces a denominator 8.20% larger than using Census Day enrollment in Irvine and 7.99% larger in Lodi. The school-level differences are more variable and exceed 20% at several schools.

I do not think the public data establish that either construction is uniformly closer to the true denominator. Census enrollment is a point-in-time snapshot, while eligible cumulative enrollment captures students who appear during the year but, when multiplied by 180, assigns a full-year exposure to students who may have been enrolled for only part of the year. I therefore think the most defensible public-data approach is to show the Census and cumulative constructions in parallel as a sensitivity analysis rather than label either one as the observed or correct denominator.

## Target quantity

The quantity we ultimately want at each school is:

`TK/K student-days attended = TK/K expected attendance days − TK/K absence days`.

The public Absenteeism by Reason file provides the TK/K absence component. It does not publish the corresponding total expected attendance days.

The underlying CALPADS Student Absence Summary (STAS) records do contain Expected Attendance Days and Days Attended. CDE defines expected attendance days based on the days an individual student was scheduled to attend at that school. That is the exposure concept we need, but it is not released in the public school-by-grade absenteeism file.

## Data and sample

I linked three 2024–25 CDE sources by 14-digit CDS code:

1. Census Day enrollment, which reports TK and K separately;
2. Absenteeism by Reason, which reports eligible cumulative enrollment and total absence days for TK/K combined; and
3. CBEDS, which provides TK/K program information, including full-day and part-day classifications.

I kept TK and K combined based on our September 23 exchange rather than trying to allocate the combined absenteeism measures back to K.

The focus sample has 30 Irvine schools with positive TK/K Census enrollment and 34 Lodi schools. All 30 Irvine schools have usable TK/K absenteeism values. Thirty-three of the 34 Lodi schools do. The remaining Lodi school's TK/K absenteeism values are suppressed under CDE's small-cell rules, so I do not treat the suppressed values as zero.

## Approach 1: Census Day enrollment

`D_census = 180 × Census TK/K enrollment − observed TK/K absence days`

This uses the number of TK/K students enrolled on Census Day as the enrollment base for a full-year exposure calculation.

The advantage is that it does not assign 180 days to every student who appears at the school at any point during the year. The limitation is that Census Day is only a snapshot. It can miss exposure from students who enter later and overstate exposure for students present on Census Day who leave before the end of the year.

## Approach 2: eligible cumulative enrollment

`D_cumulative = 180 × eligible cumulative TK/K enrollment − observed TK/K absence days`

This uses the annual eligible cumulative enrollment rather than a single-day snapshot.

The advantage is that it captures eligible students who appear during the year. The limitation is that cumulative enrollment is a headcount rather than a duration-weighted exposure measure. Multiplying it by 180 gives every included student a full school year even if that student was expected to attend for only part of the year.

CDE excludes students expected to attend fewer than 31 instructional days from eligible cumulative enrollment, which removes some very short enrollments, but students expected to attend between 31 and 179 days can still be included.

## Approach 3: midpoint sensitivity

`D_midpoint = 180 × mean(Census enrollment, eligible cumulative enrollment) − observed TK/K absence days`

This produces a value between the first two approaches. I included it as a descriptive sensitivity check, but I do not think there is a substantive reason to assume the arithmetic midpoint is closer to the true denominator.

## Irvine and Lodi results

| District | Usable schools | Census TK/K | Eligible cumulative TK/K | TK/K absence days | Census proxy | Cumulative proxy | Cumulative vs. Census |
|---|---:|---:|---:|---:|---:|---:|---:|
| Irvine Unified | 30 | 3,172 | 3,417 | 33,152 | 537,808 | 581,908 | +8.20% |
| Lodi Unified | 33 | 2,632 | 2,823 | 43,256 | 430,504 | 464,884 | +7.99% |

The district-level sensitivity is very similar across Irvine and Lodi, but that aggregate result hides larger school-level differences. Several schools have cumulative-based denominators more than 20% above their Census-based denominators.

The difference between the two main constructions is mechanical:

`D_cumulative − D_census = 180 × (eligible cumulative enrollment − Census enrollment)`.

The same observed absence-days total is subtracted in both constructions, so it cancels when the two are compared. The sensitivity is therefore coming from how annual enrollment exposure is represented, not from different absence measures.

This matters for the eventual meal take-up calculation because, holding meals served fixed, a larger attendance denominator mechanically produces a lower estimated take-up rate. The similar district averages therefore do not necessarily mean the denominator choice will be inconsequential for school-level comparisons.

## Calendar and sample checks

I used 180 days as the full-year benchmark. Irvine's audited 2024–25 Schedule of Instructional Time reports 180 actual kindergarten days, and Lodi district policy specifies a 180-day instructional year. This supports 180 as a school-year benchmark, but it does not imply that every student was expected to attend all 180 days.

I also checked whether charters were driving the difference between the two constructions. They are not. Restricting the comparison to non-charter schools leaves the cumulative denominator 8.76% above the Census denominator in Irvine and 8.52% above it in Lodi.

One Lodi charter, Rio Valley, operates as a homeschool/independent-study program. I would treat that school separately when interpreting meal access because the meaning of access to an on-campus meal may differ from a conventional school setting.

## Interpretation

The public data let us quantify how sensitive the denominator is to alternative representations of enrollment exposure, but they do not tell us which proxy is closest to the unobserved true number of expected attendance days.

For that reason, I would carry both the Census and cumulative constructions forward when linking the meal data and test whether the substantive conclusions change across them. I would keep the midpoint only as a secondary descriptive sensitivity check rather than use it as a preferred estimator.

If the meal results are meaningfully sensitive to the denominator choice, the cleaner solution would be to investigate whether the underlying STAS Expected Attendance Days can be obtained through the appropriate CDE data-access process. Those records would allow the denominator to be constructed from students' actual expected enrollment durations rather than an annual headcount proxy.

## Reproducibility note

The data cleaning, joins, denominator constructions, and school-level diagnostics are organized as a reproducible R workflow. Suppressed absenteeism cells are retained as missing rather than converted to zero, and the analysis keeps the Census and cumulative constructions explicitly labeled as proxies rather than observed student-days attended.

I reran the full workflow from the three original CDE raw files on September 24. The pipeline reproduced the Irvine and Lodi results reported above, and all automated regression and integrity tests passed.
