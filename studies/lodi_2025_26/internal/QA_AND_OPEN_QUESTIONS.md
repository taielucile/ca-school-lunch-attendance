# Lodi 2025–26 | Source and methods QA

Research-team source audit. This repository is public; this file is not access-restricted. The study contains analysis outputs, not a district report or a visualization deliverable.

## Checks completed November 8, 2026

- The original Lodi workbook, Git blob `f71fc0f26933011f14a05586f67a475aedccc643`, contains 31 school records in both Breakfast and Lunch. All 62 kindergarten meal values agree with the preserved extract at the school level. Grade counts reconcile to every school's total. Grand kindergarten totals are **70,667 breakfasts** and **203,639 lunches**.
- Workbook total meal counts across all grades and Preschool are 669,234 breakfasts and 1,850,382 lunches; school totals reconcile to both figures. The workbook reports rounded kindergarten meal ADP values of 393 and 1,131, consistent with the respective totals divided by 180.
- The independent eligibility source and the meal workbook contain the same 31 school names; the 31 name keys match uniquely to the corrected 35-school CDE extract. Four CDE records are not in the meal workbook: Rio Valley Charter, Independence, Aspire Vincent Shalvey Academy, and Aspire River Oaks Charter. These are excluded from the analysis numerator and denominator.
- A November 4, 2026 CDE directory export separately confirms all **35 CDS codes, school names, and Lodi Unified district assignments** in the state extract. This does not independently verify the meal workbook's site identities: the workbook has school names but no CDS codes.
- The state source snapshot agrees with all 35 rows of the current source extract in `results/2025_26/lodi_unified_school_denominator_proxies.csv`. Numeric formatting such as `39` versus `39.0` is the only difference in those fields. The eligibility snapshot has identical data rows to its current upstream file.
- Using the preserved input rows, independent calculations return K Census enrollment **1,763**, TK Census enrollment **853**, modeled K ADA **1,595.412985**, modeled K attended student-days **287,174.337285**, and pooled breakfast/lunch ratios **24.607700** and **70.911281 per 100 modeled days**. All 31 published school rows match after rounding.
- The R reproduction and separate tests passed on the CSV snapshot route, as recorded in `R_VERIFICATION.md`; the independent computation was rerun for this audit. The `readxl` direct-import route has not been tested.

## Limits and unresolved source definitions

- **Attendance exposure.** The model uses 180 days and school Census enrollment as an annual enrollment stock, then proportionally allocates combined TK/K absences to K. Neither expected attendance days nor actual K attended days are available at the school level in these inputs.
- **Population mismatch.** CDE's absenteeism file is organized around *eligible cumulative enrollment*, excluding some short-duration/nonattending/exempt students; its absence measure and the Census enrollment snapshot are not necessarily the same population. Across the 31 matched schools, TK/K eligible cumulative enrollment totals **2,794**, versus **2,616** TK/K Census enrollment (difference **178**, with eligible cumulative higher at all 31 schools). See [CDE file definitions](https://www.cde.ca.gov/ds/ad/fsabr.asp). The size and direction of any resulting error in this K proxy cannot be determined from these files.
- **Timing.** The original meal workbook does not print a service-date range. Its ADP calculations are consistent with a 180-day divisor, but do not independently establish the covered service dates. The [2025–26 district calendar](https://resources.finalsite.net/images/v1736443433/lodiusdnet/fsjjkrvfjsh0bwpqtvlh/LodiUSD_InstructionalCalendar_2025-26.pdf) is July 29, 2025–May 29, 2026 for the modified traditional schedule; a school-specific calendar check may matter for other sites.
- **Grades.** Kindergarten meals are explicitly labeled in the workbook. `Preschool` is a separate category, not established as TK. The workbook's schoolwide Enrollment and Average Daily Attendance fields cannot validate K attendance.
- **Eligibility report discrepancy.** The independent kindergarten eligibility extract's `Highest Eligible` and `Last Day` columns each total **3,481**. They exceed K Census enrollment (1,763) at all 31 schools, by ratios ranging from 1.30 to 3.18. Their definitions and grade scope remain unresolved; they are not used in the model.
- **Small-school sensitivity.** Valley Robotics Academy has 12 K Census pupils, TK Census zero, and 13 reported TK/K absent days; its low lunch ratio is computed correctly but sensitive to the attendance-exposure assumptions. This is a review flag, not proof of a source error.
- **Measure meaning.** A meal count is a count of meals, not distinct pupils. Ratios per modeled student-day are not validated meal-participation percentages. These results support description, not causal explanations of school differences.

## Follow-up questions

1. Which dates and grades does the district meal workbook cover, and do `Preschool` and `Kindergarten` have consistent definitions across all schools?
2. What exactly do the kindergarten eligibility report's `Highest Eligible` and `Last Day` measures count?
3. Are kindergarten attended student-days or grade-specific ADA available for the same service dates?
4. Do any schools in the matched set use different calendars or meal-reporting periods?
5. Are the recorded meals reimbursements, served meals, or another transaction definition?

These questions concern the Lodi handoff, not the separate CDE Nutrition Services FNS10 work or attendance-records correspondence.
