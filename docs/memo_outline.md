# Memo outline: TK/K attendance denominator approaches in Irvine and Lodi

**To:** Andrew Penner  
**From:** Taiel Lucile  
**Status:** Working outline, not final memo  
**Target:** October 15, 2026

## Question

Using public California data, how closely can we approximate school-level TK/K student-days attended for use as the denominator of school-meal take-up rates, and how much do plausible constructions differ in Irvine Unified and Lodi Unified?

## What is directly observed

At school level for 2024–25 we observe Census Day TK and K enrollment, TK–K eligible cumulative enrollment, TK–K total absence days, and CBEDS TK/K program type.

The public absenteeism file does not directly provide the duration-weighted expected attendance days needed to recover exact student-days attended.

## Why TK and K remain combined

The public absenteeism file reports TK and K as one grade span. Andrew confirmed on September 23 that combining TK and K is acceptable for the current project. The primary analysis therefore uses the observed TK–K band rather than allocating it to K.

## Approach A: Census snapshot full-year proxy

Formula: 180 × Census TK/K enrollment − observed TK/K absence days.

Interpretation: treats the Census Day snapshot as the full-year enrollment stock.

Strength: uses a directly observed point-in-time enrollment count and does not count every student who ever appears during the year as a full-year student.

Weakness: students entering after Census Day are absent from the enrollment multiplier; students present on Census Day but enrolled for only part of the year are still assigned a full-year exposure.

## Approach B: eligible cumulative full-year proxy

Formula: 180 × eligible cumulative TK/K enrollment − observed TK/K absence days.

Interpretation: treats every student represented in eligible cumulative enrollment as a full-year exposure.

Strength: incorporates students who appear during the year rather than relying on one snapshot.

Weakness: overstates expected days for students enrolled for only part of the year.

## Approach C: midpoint sensitivity construction

Formula: 180 × mean(Census TK/K enrollment, eligible cumulative TK/K enrollment) − observed TK/K absence days.

This is included only as a sensitivity construction. There is currently no identification argument that the true exposure is the midpoint.

## Initial results

| District | Census TK/K | Eligible cumulative TK/K | Absence days | Census proxy | Cumulative proxy | Difference |
|---|---:|---:|---:|---:|---:|---:|
| Irvine Unified | 3,172 | 3,417 | 33,152 | 537,808 | 581,908 | +8.20% |
| Lodi Unified | 2,632 | 2,823 | 43,256 | 430,504 | 464,884 | +7.99% |

The district-level sensitivity is similar, but school-level differences are heterogeneous and exceed 20% at several schools. This matters because meal take-up is ultimately constructed at the school level.

## Key interpretation

The difference between Approaches A and B is mechanically driven by the enrollment measure because both subtract the same observed absence-days quantity:

B − A = 180 × (eligible cumulative enrollment − Census enrollment).

The comparison therefore quantifies sensitivity to the annual-exposure assumption; it does not validate either approach.

## Remaining work before recommendation

1. Verify school-specific calendar exceptions, especially charter schools in the two focus districts.
2. Characterize suppressed TK/K absenteeism cells separately from missing records.
3. Examine whether another public source supplies a defensible duration-weighted exposure measure.
4. Compare resulting meal take-up rates once the meal numerator is linked.
5. Decide whether one proxy is suitable for the main specification or whether results should be shown across multiple denominator constructions.
