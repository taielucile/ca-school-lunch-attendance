# TK/K attendance denominator: identification note

## Estimand

The downstream meal take-up calculation requires a measure proportional to the number of TK/K student-days actually attended at each school:

`student-days attended = expected student-days - absent student-days`.

## Public-data limitation

The 2024–25 public CDE absenteeism release reports TK and K jointly and includes eligible cumulative enrollment and total absence days. It does not expose school-by-grade expected attendance days.

Because cumulative enrollment is a count of distinct eligible students rather than a duration-weighted exposure measure, multiplying cumulative enrollment by a full-year day count is not an exact reconstruction of expected student-days.

Census Day enrollment has the opposite problem: it is a point-in-time snapshot and does not capture all students who enter or leave during the year.

## Why 180 days appears in the current comparison

Irvine Unified's audited 2024–25 instructional-time schedule reports 180 actual kindergarten days for its traditional calendar. Lodi Unified's school-calendar policy calls for 180 days of instruction. Thus 180 is a defensible **full-year calendar benchmark** for the main district comparison.

It is not a claim that every student in cumulative enrollment had 180 expected attendance days. School-specific charter calendars are being checked separately.

## Current comparison

### A. Census snapshot proxy

`180 × TK/K Census enrollment - observed TK/K absence days`

### B. Eligible cumulative proxy

`180 × TK/K eligible cumulative enrollment - observed TK/K absence days`

### C. Midpoint sensitivity proxy

`180 × mean(Census enrollment, eligible cumulative enrollment) - observed TK/K absence days`

Approach C is a sensitivity construction only. It is not claimed to identify the true midpoint of annual exposure.

A 175-day alternative is retained only as a sensitivity benchmark, particularly while charter-specific calendars are being audited.

## Initial Irvine/Lodi result

The cumulative-enrollment construction produces an aggregate attended-days proxy approximately 8% larger than the Census construction in both Irvine and Lodi. School-level differences are more heterogeneous and exceed 20% for some schools.

These differences arise mechanically from the difference between cumulative and Census enrollment when the same observed absence-days quantity is subtracted from both constructions:

`B - A = 180 × (eligible cumulative enrollment - Census enrollment)`.

## Interpretation

The comparison measures sensitivity to competing exposure assumptions. It does not establish that either proxy equals true student-days attended.

## Next methodological task

Audit focus-district charter calendars and continue searching for any defensible public duration-weighted exposure measure. If none exists, present the competing constructions transparently and identify the assumptions required for each.
