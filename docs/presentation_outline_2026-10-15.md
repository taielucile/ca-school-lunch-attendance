# October 15 research meeting: quick walkthrough

## 1. What I was trying to build

The meal take-up denominator is student-days attended, not simply enrollment.

At school × TK/K:

`attended days = expected attendance days − absence days`.

## 2. What the public data give us

- Absenteeism by Reason: combined TK/K eligible cumulative enrollment and total absence days.
- Census enrollment: Census Day TK and K counts.
- CBEDS: full-day/part-day TK/K program type.

Andrew confirmed that keeping TK and K combined is acceptable.

## 3. What is missing

The public aggregate file does not give the sum of Expected Attendance Days.

CALPADS STAS collects that quantity at the student-school level, so this is a public-release limitation rather than a conceptual ambiguity about the desired measure.

## 4. Approaches compared

**Census proxy**  
180 × Census TK/K enrollment − absence days.

**Cumulative proxy**  
180 × eligible cumulative TK/K enrollment − absence days.

**Midpoint sensitivity**  
180 × mean(Census, cumulative) − absence days.

None is labeled as observed student-days attended.

## 5. Irvine/Lodi result

- Irvine: cumulative proxy is 8.20% above Census proxy.
- Lodi: cumulative proxy is 7.99% above Census proxy.
- School-level differences exceed 20% in several cases.
- Restricting to non-charters leaves the aggregate difference around 8–9%.

## 6. Why the difference occurs

The same absence-days value is subtracted in both constructions.

Therefore:

`difference = 180 × (cumulative enrollment − Census enrollment)`.

The sensitivity is about annual exposure, not the absence measure.

## 7. Current judgment

Use Census × 180 as the parsimonious public-data main proxy and cumulative × 180 as the primary sensitivity specification.

Reason: cumulative × 180 has a known overexposure mechanism for every partial-year eligible student. Census is still imperfect, so results should not be presented as exact attendance days.

If STAS expected-days data become available, replace both proxies with the direct aggregate.

## 8. Where I am still stuck / what I need feedback on

- whether Rio Valley's independent-study model belongs in the main meal-access sample;
- whether Andrew prefers one public proxy as the main denominator or parallel specifications;
- whether restricted STAS access is worth pursuing if the meal results prove sensitive to the denominator choice.
