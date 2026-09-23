# Meal numerator audit

## Target

For each school, the eventual take-up calculation needs a meal count whose population and time period align with the TK/K student-days-attended denominator.

A generic expression is:

`meal take-up = TK/K meals served / TK/K student-days attended`.

Breakfast and lunch should remain separate unless the substantive analysis explicitly defines a combined measure.

## What the public CDE sources currently support

CDE's Food Programs page describes its Annual Child Nutrition Programs Participation Data as **county data** from school districts and local agencies. The School Nutrition Programs county profiles currently listed there run through 2022–23, not 2024–25.

CDE's nutrition finance documentation states that participating sponsors submit monthly reimbursement claims through the Child Nutrition Information and Payment System (CNIPS). Public CDE guidance also states that California Universal Meals allows one breakfast and one lunch to be claimed per student per school day.

Those facts establish the administrative meal-counting system, but the public sources located in this audit do **not** provide the required 2024–25 school × TK/K meals-served numerator.

## Sources that are not valid substitutes

### FRPM / student-poverty files

These measure eligibility/enrollment, not meals actually taken. They should not be used as a meal-service numerator.

### County participation profiles

These are too geographically aggregated for the school-level Irvine/Lodi analysis and the posted SNP series is not current to 2024–25.

### Reimbursement dollars

Reimbursement amounts should not be reverse-engineered into TK/K meals without a source-specific accounting model. Multiple meal types, eligibility/reimbursement categories, adjustments, and aggregation levels can break that inference.

### Whole-school meal counts without grade information

These could become useful only if Andrew's project has a defensible way to identify or allocate TK/K meals. A TK/K attendance denominator cannot simply be paired with an all-grade meal numerator.

## Current blocker

The numerator must come from Andrew's project data or another source with sufficient school/grade detail. Until that source is available, the repository can complete the denominator analysis but cannot honestly report meal take-up rates.

## Intake checks when the file arrives

1. Identify the unit of observation.
2. Identify school/site IDs and map them to CDS codes.
3. Preserve breakfast and lunch separately.
4. Determine whether counts are daily, monthly, claim-period, or annual.
5. Determine whether TK/K are directly identified.
6. Check duplicate site-period records.
7. Check whether meal counts are claims, meals prepared, meals served, or meals reimbursed.
8. Reconcile school-year coverage.
9. Join without dropping unmatched schools.
10. Flag impossible or suspicious take-up rates rather than silently capping them.
