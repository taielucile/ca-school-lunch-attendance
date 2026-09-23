# Memo: Public-data approaches to TK/K attendance denominators in Irvine and Lodi

**To:** Andrew Penner  
**From:** Taiel Lucile  
**Date:** Working draft  
**Re:** 2024–25 TK/K attendance denominator

## Bottom line

I can construct school-level TK/K attendance-denominator proxies from the public CDE files, but I cannot recover the exact denominator from the public aggregate releases. The missing quantity is duration-weighted expected attendance days.

For the main 180-day benchmark, two simple public-data constructions differ by about 8% at the district level in both Irvine and Lodi. The differences are larger for some individual schools. This makes the annual-exposure assumption consequential for school-level meal take-up rates even though the aggregate sensitivity looks similar across the two districts.

I do **not** currently think the eligible-cumulative-enrollment × 180 construction should be interpreted as the preferred estimate: it assigns a full school year to every eligible student even when the student was enrolled for only part of the year. I also do not think Census enrollment × 180 can be treated as exact, because Census Day is only a snapshot. My current preference is to treat the Census construction as a parsimonious main proxy and the cumulative construction as an upper-exposure sensitivity specification, while being explicit that neither identifies true student-days attended. This recommendation should be revisited if a better duration-weighted public measure or the underlying STAS expected-days data become available.

## Target quantity

For each school, the desired denominator is:

`TK/K student-days attended = TK/K expected attendance days − TK/K absence days`.

The public Absenteeism by Reason file gives the TK/K absence component directly. It does not publish the corresponding sum of expected attendance days.

CDE's CALPADS documentation makes clear that the underlying Student Absence Summary (STAS) records do contain student-level Expected Attendance Days and Days Attended. Expected Attendance Days are based on the days the student was actually scheduled to attend at that school. This is exactly the exposure concept needed here, but it is not included in the public school-by-grade aggregate file.

## Why TK and K are combined

The public 2024–25 absenteeism file reports TK and kindergarten jointly as GRTKKN. Based on our September 23 exchange, I keep TK and K combined rather than allocating the band to kindergarten using Census enrollment shares. This avoids introducing an unnecessary grade-allocation assumption.

## Public inputs

The current build links three CDE sources by 14-digit CDS code:

1. **Census Day enrollment:** separate TK and K enrollment counts.
2. **Absenteeism by Reason:** TK/K eligible cumulative enrollment and total absence days.
3. **CBEDS:** TK and K full-day/part-day program classifications and calendar information.

The focus sample contains 30 Irvine schools with positive TK/K Census enrollment and 34 Lodi schools. All 30 Irvine schools have usable TK/K absenteeism values. Thirty-three of the 34 Lodi schools do; one small school has a suppressed TK/K absenteeism cell.

## Approach 1: Census snapshot × 180

`D_census = 180 × Census TK/K enrollment − observed TK/K absence days`

This treats the Census Day TK/K enrollment stock as if it represented the school's full-year exposure.

**What it handles reasonably:** it does not assign 180 days to every child who appears at the school at any point during the year.

**What it misses:** students who enter after Census Day are not represented in the enrollment multiplier. It can also overstate exposure for a Census Day student who leaves before the end of the year.

I view this as the simplest public-data approximation, not as an exact attendance denominator.

## Approach 2: eligible cumulative enrollment × 180

`D_cumulative = 180 × eligible cumulative TK/K enrollment − observed TK/K absence days`

This includes students who appear during the year rather than relying on one snapshot.

Its major problem is that cumulative enrollment is a headcount, not an exposure measure. A student expected to attend only part of the year is counted once just like a full-year student. Multiplying every eligible cumulative student by 180 therefore assigns full-year exposure to partial-year students.

CDE's eligibility rule reduces the most extreme version of this problem because students expected to attend fewer than 31 instructional days are excluded from eligible cumulative enrollment. It does not solve the problem for students expected to attend 31–179 days.

I therefore treat this as an upper-exposure sensitivity construction rather than the preferred denominator.

## Approach 3: midpoint sensitivity

`D_midpoint = 180 × mean(Census enrollment, eligible cumulative enrollment) − observed absence days`

This mechanically lies between Approaches 1 and 2. I do not have an identification argument that the true denominator should lie at the arithmetic midpoint, so I would use it only to illustrate sensitivity, not as the main specification.

## Irvine and Lodi comparison

| District | Usable schools | Census TK/K | Eligible cumulative TK/K | TK/K absence days | Census proxy | Cumulative proxy | Cumulative vs. Census |
|---|---:|---:|---:|---:|---:|---:|---:|
| Irvine Unified | 30 | 3,172 | 3,417 | 33,152 | 537,808 | 581,908 | +8.20% |
| Lodi Unified | 33 | 2,632 | 2,823 | 43,256 | 430,504 | 464,884 | +7.99% |

The district-level difference is nearly identical: the cumulative construction produces a denominator about 8% larger in each district.

That does not mean the choice is innocuous. School-level differences are heterogeneous. Several schools have cumulative-based denominators more than 20% above their Census-based denominators. Because the meal numerator will be held fixed within a school, a larger attendance denominator mechanically produces a lower estimated meal take-up rate.

The difference between the two constructions can be written directly as:

`D_cumulative − D_census = 180 × (eligible cumulative enrollment − Census enrollment)`.

The absence-days term cancels. The comparison is therefore specifically a test of the annual-enrollment/exposure assumption.

## Calendar and charter checks

The 180-day multiplier is a full-year calendar benchmark, not an assumption about each student's actual enrollment duration. Irvine's 2024–25 audited instructional-time schedule reports 180 kindergarten days, and Lodi policy uses a 180-day instructional calendar. The charter audit also supports 180 days for several focus charters.

One Lodi charter, Rio Valley, is a homeschool/independent-study program. I would flag it separately in a meal-access analysis because the substantive meaning of access to school meals may differ from a conventional campus-based program. Excluding charters altogether does not explain the denominator sensitivity: the cumulative construction remains about 8.76% above the Census construction in Irvine and 8.52% above it in Lodi among non-charter schools.

## What I think makes the most sense

For the public-data version, my current ordering is:

- **Main proxy:** Census TK/K enrollment × 180 minus observed TK/K absence days.
- **Primary sensitivity:** eligible cumulative TK/K enrollment × 180 minus observed TK/K absence days.
- **Secondary sensitivity:** midpoint construction, clearly labeled as descriptive rather than identified.

The reason for putting Census first is not that Census enrollment equals annual exposure. It does not. The reason is that the cumulative alternative has a known directional problem: it necessarily treats every eligible cumulative student as a full-year student. Census has offsetting entry/exit errors whose direction is not known a priori.

The strongest version of the denominator would instead aggregate STAS Expected Attendance Days directly for TK/K students at each school. If those data become accessible, that would supersede these proxies.

## Remaining items

Before freezing the memo/results, I would:

1. finish the one unresolved charter-calendar/program audit;
2. run the repository's R regression test in an R-enabled environment;
3. link the school-meal numerator and show how much the denominator alternatives change actual take-up estimates;
4. decide whether the independent-study charter belongs in the main analytic sample or a sensitivity sample.

The reproducible build and diagnostics are in the project repository.
