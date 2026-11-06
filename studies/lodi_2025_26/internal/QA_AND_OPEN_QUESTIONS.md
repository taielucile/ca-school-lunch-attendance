# Lodi 2025–26: internal QA and open questions

**For research-team review, not part of the district-facing report.** This note is stored separately from `district_review/` and must not be attached to a district message by default. This repository is public, so the label “internal” describes intended use, not access control.

## Verified on November 6, 2026

- Original Lodi meal workbook has 31 distinct schools in each of its Breakfast and Lunch sheets; names match across sheets and exactly match the kindergarten eligibility extract’s 31 schools.
- All 31 meals schools matched the corrected 2025–26 CDE school extract. Four additional CDE schools not in the meal workbook were excluded from both numerator and denominator: Rio Valley Charter, Independence, Aspire Vincent Shalvey Academy, and Aspire River Oaks Charter. Independence has suppressed attendance inputs, but that does not affect any matched school.
- Kindergarten breakfast cells sum to **70,667** and lunch cells to **203,639**, reconciling to workbook printed grand totals.
- Across the 31 matched schools, kindergarten Census enrollment is **1,763** and TK Census enrollment is **853**. Estimated K ADA totals **1,595.413**, or **287,174.337 modeled attended K student-days** under 180 assumed days.
- The source-specific K allocation formula was checked school-by-school: `K_Census − (TKK_absence_days / 180) × K_Census / (TK_Census + K_Census)`.
- Breakfasts and lunches per 100 modeled K attendance days are respectively **24.6077** and **70.9113**, from total meals divided by total modeled days. School ratios span **4.10–68.78** and **35.91–97.12**, respectively.
- The reorganized base-R script and independent R checks passed from the standalone input snapshots. The directly imported XLSX route (`--meal-xlsx`) has not been execution-tested; it requires `readxl` and dependencies.

## Limits that must accompany interpretation

- A meal count is a meal transaction, not a unique student or a student headcount.
- Census enrollment is a snapshot; attendance days are modeled, not measured kindergarten days. The model allocates TK/K absences by Census shares, assumes 180 days and does not use enrollment durations or actual service calendars.
- Meal service days and attendance-source reporting dates may not align exactly.
- The workbook’s `Preschool` category is not verified as TK, and is not added to K.
- The kindergarten-filtered eligibility extract’s `Highest Eligible` and `Last Day` both total **3,481**, versus K Census enrollment 1,763. Definitions need confirmation. These figures are used only for school-list checks, never as attendance denominators.
- Neither the school ratios nor the district ratio is a validated meal take-up percentage; no causal explanation or significance test is supported.

## District clarification questions, for a separate conversation

1. What grades and exact service dates are counted in the meal workbook’s `Kindergarten` and `Preschool` fields?
2. Are the meal counts reimbursable meals or another transaction measure? Are noninstructional-day meals included?
3. Can Lodi provide school-by-kindergarten attended student-days (or at least K average daily attendance plus applicable calendar/service days) to check the modeled denominator?
4. How are `Highest Eligible`, `Last Day`, and schoolwide `Highest Enrollment` defined?
5. Does the observed variation match local breakfast/lunch service arrangements, or could school-level coding/reporting differ?

These questions are **not** part of the separate CDE Nutrition Services statewide FNS10 request or the attendance-records correspondence.