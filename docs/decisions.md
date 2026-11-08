# Research decision log

## 2026-09-23 — Unit of analysis: combined TK and K

**Decision:** Use the public CDE TK–K band as the primary grade unit rather than allocating the band to kindergarten alone.

**Reason:** Andrew Penner confirmed that combining TK and K is acceptable for the project given the data limitation and noted that TK and K are generally similar in their half-day/full-day schedules.

**Consequence:** The primary analysis no longer requires allocating TK–K absence days to kindergarten using Census Day grade shares. This removes a substantial assumption from the main denominator construction.

---

## 2026-09-23 — Expected attendance exposure remains unidentified

**Status:** Confirmed identification limitation.

The public absenteeism file supplies TK–K eligible cumulative enrollment and total absence days, but not Expected Attendance Days. Census enrollment is a snapshot; cumulative enrollment counts eligible students with different lengths of enrollment.

Therefore:

- `Census TK/K enrollment × 180 - absence days` treats a point-in-time enrollment stock as a full-year exposure base.
- `eligible cumulative TK/K enrollment × 180 - absence days` assigns every eligible cumulative student the equivalent of a full 180-day exposure.
- Neither is treated as observed student-days attended.

The underlying CALPADS STAS Expected Attendance Days concept is closer to the target because it can reflect student-specific exposure duration.

---

## 2026-09-23 — PI deliverable

Andrew requested a memo detailing the alternative approaches and the differences produced in Irvine and Lodi, followed by a short presentation at the October 15, 2026 research meeting.

---

## 2026-09-24 — Keep both annual public-data constructions

**Decision:** Retain the Census and eligible-cumulative constructions as parallel sensitivity specifications. Do not designate either as the empirically validated annual denominator.

**Evidence:** Under a 180-day benchmark, the cumulative construction is 8.20% above the Census construction in Irvine and 7.99% above it in Lodi. The difference remains roughly 8–9% when the analysis is restricted to non-charter schools.

**Reason:** The available data quantify the consequence of the competing exposure assumptions but do not identify annual school × TK/K Expected Attendance Days.

**Consequence:** The midpoint construction remains descriptive sensitivity only and is not used as a preferred estimator.

---

## 2026-09-24 — Irvine district data are a short-window validation check

**Decision:** Use the November 3–7, 2025 Irvine district attendance reports to compare observed daily TK/K attendance with same-year 2025–26 CDE Census enrollment, but do not annualize the five-day attendance data or use them to select an annual proxy.

**Evidence:** Across the 30 schools represented in the district reports, same-year Census TK/K enrollment is 3,043 and observed TK/K attendance averages 2,820.8 students per day, a ratio of 92.70%.

**Reason:** The gap between Census enrollment and observed attendance includes ordinary absences and may also reflect enrollment differences. Five observed days cannot identify annual expected attendance exposure.

---

## 2026-09-24 — Irvine PK is aligned to TK for the district check

**Decision:** Treat Irvine's district-report PK category as TK in the Irvine validation.

**Reason:** Irvine Unified identifies Pre-Kindergarten as the program formerly known as Transitional Kindergarten.

**Consequence:** PK and K district attendance can be combined for comparison with CDE TK+K enrollment. The two K schools without PK/TK report rows are reconciled to zero TK attendance only because the same-year CDE Census reports zero TK enrollment at both schools.

---

## 2026-09-24 — Lodi district files do not validate TK/K attendance

**Decision:** Do not use Lodi school-wide ADA or grade-level meal ADP as TK/K attendance ground truth.

**Reason:** The available Lodi files provide school-wide Average Daily Attendance and grade-specific meal participation, not grade-specific student attendance.

**Consequence:** The full-year Lodi files do not currently adjudicate which annual public-data denominator construction is closer to true TK/K attended student-days.

---

## 2026-09-24 — Do not relabel Lodi Preschool as TK

**Decision:** Do not combine Lodi `Preschool` and `Kindergarten` meal fields and call the result TK/K without additional documentation.

**Reason:** The repository does not establish that the Lodi `Preschool` category represents Transitional Kindergarten, and Lodi program materials distinguish preschool from TK.

**Consequence:** A population-aligned TK/K meal numerator remains unresolved for Lodi.


---

## 2026-09-24 — Pause annual denominator development absent new evidence

**Decision:** Treat the annual public-data denominator work as complete under the currently available data. Do not continue modifying the annual specification merely to force a single preferred estimator.

**Reason:** The public CDE data, the five-day Irvine attendance check, and the available full-year Lodi files do not identify annual school × TK/K Expected Attendance Days or empirically select between the Census and eligible-cumulative constructions.

**Consequence:** Revisit the annual denominator only if the team supplies new grade-aligned attendance/exposure data or another source that materially changes identification.

---

## 2026-09-24 — Next substantive analysis: Irvine five-day meal participation

**Decision:** The next planned analysis is a short-window Irvine meal-participation analysis for November 3–7, 2025.

**Reason:** Irvine provides observed K and PK/TK attendance and daily grade-specific meal-served reports for the same five-day period. This creates an opportunity to study meal participation with an observed attendance denominator rather than an annual reconstructed proxy.

**Requirements before estimation:** Verify school, date, grade, and meal-type alignment; preserve breakfast and lunch separately; document unmatched or ambiguous records; and do not annualize the five-day result.

**Consequence:** This analysis remains separate from the 2024–25 annual denominator sensitivity analysis. Lodi is not included in an analogous TK/K take-up calculation unless its numerator and attendance populations can be aligned.


---

## 2026-09-25 — Reopen denominator audit for Lodi grade-specific report fields

**Decision:** Follow up on Andrew Penner's observation that the original Lodi report contains Kindergarten `Highest Eligible` and `Last Day` fields rather than leaving the annual-denominator investigation closed without examining the new evidence.

**Evidence:** The source report is filtered to Kindergarten and the July 29, 2025–May 29, 2026 eligibility period. It labels `Highest Eligible` and `Last Day`, and defines `Last Day` as the number of enrolled students on the last day of the selected date range.

**Consequence:** The prior stopping rule was satisfied: this was new evidence worth testing. A dedicated `R/09_lodi_enrollment_triangulation.R` module now preserves and evaluates the measures.

---

## 2026-09-25 — Lodi eligibility-report measures do not identify annual attendance exposure

**Decision:** Retain the Lodi `Highest Eligible` and `Last Day` fields as source-triangulation evidence, but do not use either as an independently validated annual attendance denominator or as a basis for selecting between the Census and cumulative-enrollment constructions.

**Evidence:** Across the 31 Kindergarten schools in the report, `Highest Eligible` and `Last Day` are identical school-by-school and both total 3,481. Same-year CDE Kindergarten Census enrollment for the matched schools totals 1,763. The report-side quantity exceeds Census enrollment at all 31 schools.

**Reason:** The two report fields do not provide independent observations in these data, and neither supplies student-specific expected attendance days. The comparison therefore characterizes another enrollment/eligibility quantity but does not recover the duration-weighted exposure required for annual attended student-days.

**Consequence:** The Census and eligible-cumulative annual constructions remain parallel sensitivity specifications. The annual denominator investigation returns to its stopping point unless genuinely new grade-aligned attendance/exposure evidence becomes available.

---

## 2026-09-25 — Resume Irvine five-day meal-participation analysis

**Decision:** With the Lodi lead audited and its identification contribution documented, return to the planned Irvine November 3–7, 2025 meal-participation analysis.

**Consequence:** Before estimating participation, verify the meal-report row semantics, school/date/grade alignment, and whether `Total Quantity` represents meals rather than item quantities. Keep breakfast and lunch separate and do not annualize the five-day result.


---

## 2026-10-29 — Preserve calendar and meal-source distinctions

**Decision:** Retain the 180-day construction as the common comparison benchmark, but correct school-specific calendar documentation using official calendars. Aspire River Oaks' 2024–25 calendar lists 175 weekday instructional days and one Saturday School day; Vincent Shalvey's official family calendar supports a manually counted 184 weekdays; Joe Serna's calendar supports 180 weekdays. These counts inform a limited sensitivity check and do not identify student-specific attendance exposure. Keep Rio Valley in the denominator universe but separate it from the primary campus-based meal sample absent evidence about its meal-serving site and target population.

**Meal-data decision:** Record the Irvine November 3–7, 2025 meal extraction as provisional. The report totals reconcile, but 70 possible school-grade-day-meal slots have no row. Treat them as zero only as an explicit assumption until report semantics are confirmed. Keep breakfast and lunch separate and describe rates as meals per attending student-day.

---

## 2026-11-05 — Lodi kindergarten-specific analysis handoff

**Scope:** Lodi's kindergarten-labeled breakfast and lunch counts are being prepared for Angela's figures and district report. The data preparation uses a kindergarten-only **modeled** attendance denominator constructed by assigning combined public TK/K absence days to kindergarten in proportion to the school's TK/K Census enrollment.

**Reason:** The numerator is labeled Kindergarten, while the public absenteeism file only reports TK/K jointly. The Lodi-specific Census-based allocation was retained for the descriptive comparison, consistent with the team's recent Ventura discussion. This is a working model, not measured kindergarten attendance and not evidence that the Census approach is uniformly more accurate in Lodi.

**Relationship to the September decision:** The earlier choice to use combined TK/K as the main public-data denominator remains historically valid for that analysis. The Lodi kindergarten comparison has a different numerator and therefore uses an explicitly additional grade-allocation assumption. It does **not** replace the combined TK/K analysis across the repository.

**Remaining limitations:** School-by-kindergarten attended days, precise meal workbook service dates, and grade-field definitions remain unresolved. See [the Lodi study handoff](../studies/lodi_2025_26/HANDOFF_FOR_ANGELA.md) and [source QA](../studies/lodi_2025_26/internal/QA_AND_OPEN_QUESTIONS.md). Report writing and visualization are handled separately by Angela.
