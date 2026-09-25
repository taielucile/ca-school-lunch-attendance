# Meal numerator audit

## Target

For each school, the eventual take-up calculation needs a meal count whose population and time period align with the TK/K student-days-attended denominator.

A generic expression is:

`meal take-up = TK/K meals served / TK/K student-days attended`.

Breakfast and lunch should remain separate unless the substantive analysis explicitly defines a combined measure.

## Public CDE sources

The public CDE sources reviewed for the denominator work do not supply the required school × TK/K meals-served numerator. Enrollment, absenteeism, FRPM/eligibility measures, reimbursement dollars, and geographically aggregated participation products are not substitutes for grade-aligned meals actually served.

## District/project meal files

Andrew's Feed-California-Kinders repository supplies meal-service data for the focus-district validation work, but numerator alignment differs by district.

### Irvine

The Irvine files contain daily meal-served reports for November 3–7, 2025 with separate grade labels, including Kindergarten and PK. Irvine Unified identifies PK as the program formerly known as Transitional Kindergarten, so these files potentially support a population-aligned **short-window** TK/K meal numerator for the same week as the district attendance reports.

That calculation is distinct from the 2024–25 annual public-data denominator analysis. A one-week meal/attendance rate should not be presented as an annual take-up rate.

### Lodi

The Lodi files contain grade-specific meal counts over the 2025–26 reporting period, but the meal fields separate `Preschool` and `Kindergarten`.

The available repository documentation does not establish that `Preschool` represents Transitional Kindergarten. Lodi's program materials distinguish preschool from TK. Therefore:

- Preschool is not relabeled as TK;
- Preschool + Kindergarten is not presented as a TK/K numerator without additional documentation; and
- Kindergarten-only meals should not be paired with the combined TK/K public attendance denominator as though the populations were identical.

The workbook's grade-level ADP fields are meal participation measures, not attendance denominators. School-wide Average Daily Attendance also cannot be substituted for grade-specific TK/K attendance.

## Current alignment status

The denominator workflow is reproducible, but a full-year population-aligned TK/K meal take-up calculation is not yet identified from the available Lodi data.

Irvine can support a separate five-day TK/K meal-participation analysis for November 3–7, 2025 if that short-window analysis is substantively useful. It should remain clearly separated from the annual 2024–25 denominator sensitivity analysis.

## Intake checks for additional meal data

For any new numerator source:

1. identify the unit of observation and reporting period;
2. identify school/site IDs and map them to CDS codes;
3. preserve breakfast and lunch separately;
4. determine whether counts are daily, monthly, claim-period, or annual;
5. verify exactly how TK, PK, preschool, and K are defined;
6. check duplicate site-period records;
7. determine whether counts represent meals claimed, prepared, served, or reimbursed;
8. reconcile school-year coverage with the denominator;
9. join without silently dropping unmatched schools; and
10. flag impossible or suspicious take-up rates rather than silently capping them.
