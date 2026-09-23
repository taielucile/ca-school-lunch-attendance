# TK/K attendance denominator: identification note

## Estimand

The downstream meal take-up calculation requires a measure proportional to the number of TK/K student-days actually attended at each school:

`student-days attended = expected student-days - absent student-days`.

## Public-data limitation

The 2024–25 public CDE absenteeism release reports TK and K jointly and includes eligible cumulative enrollment and total absence days. It does not expose school-by-grade expected attendance days.

Because cumulative enrollment is a count of distinct eligible students rather than a duration-weighted exposure measure, multiplying cumulative enrollment by 180 is not an exact reconstruction of expected student-days.

Census Day enrollment has the opposite problem: it is a point-in-time snapshot and does not capture all students who enter or leave during the year.

## Current comparison

### A. Census snapshot proxy

`180 × TK/K Census enrollment - observed TK/K absence days`

### B. Eligible cumulative proxy

`180 × TK/K eligible cumulative enrollment - observed TK/K absence days`

### C. Midpoint sensitivity proxy

`180 × mean(Census enrollment, eligible cumulative enrollment) - observed TK/K absence days`

Approach C is a sensitivity construction only. It is not claimed to identify the true midpoint of annual exposure.

## Initial Irvine/Lodi result

Using the current cleaned files, the cumulative-enrollment construction produces an aggregate attended-days proxy approximately 8% larger than the Census construction in both Irvine and Lodi. School-level differences are more heterogeneous and exceed 20% for some schools.

These differences arise mechanically from the difference between cumulative and Census enrollment when the same observed absence-days quantity is subtracted from both constructions.

## Next methodological task

Evaluate whether a better duration-weighted public proxy is defensible. If not, present the competing constructions transparently and identify the assumptions required for each.
