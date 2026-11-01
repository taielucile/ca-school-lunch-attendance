# Elk Grove and Ontario-Montclair: original workbook audit and analysis eligibility
**Research handoff | 31 October 2026 | school year 2025–26**

## Scope and source provenance

The **two original uploaded district workbooks** were opened and audited sheet by sheet. This supersedes the preliminary inventory-only note. Counts below are source-reported **meals**, not distinct children or individual meal participation rates.

| District | Exact source file | SHA-256 |
| --- | --- | --- |
| Elk Grove Unified | `Elk Grove Meal and Attendance Data.xlsx` | `f30c4a718c339e58ecac96caebc2ce026fd346c698f516de30130ec4bc040603` |
| Ontario-Montclair | `Ontario-Montclair Meal and Attendance Data.xlsx` | `906eb421b5be21ba13051b62a4640fe29ebd350420e4eb97ca266878ee251635` |

Original workbooks were **not committed**. Derived internal school-grade meal data remain in the restricted handoff, not this GitHub branch. This branch contains only audit summaries and **unadjudicated school/CDS name-link candidates**.

## 1. Elk Grove: school-grade meal records and grade attendance rates

The source workbook contains an `Attendance` summary, `Attendance details`, `Source data`, and **44 named school worksheets**. All 44 school tabs identify the same period: **July 1, 2025–March 31, 2026**. Their printed meal totals reconcile to the detailed source rows, including the special **Jessie Baker** sheet, whose three separately labeled elementary/middle/secondary source segments must be combined *only to check the printed worksheet total*, never forced into an elementary-school CDS.

The school-grade source has **442 actual detail rows** and a separate printed **TOTAL** row. The latter must **not be summed again**. The correctly reconciled source totals are **711,424 breakfasts** and **2,429,657 lunches**. There are 43 kindergarten rows (`K`), 44 first-grade rows (`1`), and **43 rows with original grade code `19`**.

**Important: `19` is not verified as TK.** All 43 sites with a code-19 meal row also have positive TK enrollment and a TK attendance rate in the workbook's separate attendance section, which makes the interpretation plausible, **but does not supply an authoritative grade-code definition**. Keep the raw `19` label; do not aggregate it with TK counts until confirmed with the district/source-system data dictionary. Source code strings `03; 3` (Ellen Feickert) and `KG; 0` (Miwok Village) are also preserved as reported rather than silently standardized.

`Attendance details` has school-by-grade **enrollment and attendance rates**. For each of the 43 K/code-19 elementary sites, a nonmissing K and a nonmissing TK rate appear. But rates are not annual grade-specific attended student-days, and the exact grade-code and exposure definitions remain unverified. The district's July–March range is **not the full 180-day school year**. Do not divide the July–March meal totals by a 180-day Census-based proxy.

**CDS linkage:** among the 43 meal-source school names with K and code-19 entries, **40 are unique normalized CDE school-name candidates** and **three** require confirmation of middle-initial variants: Charles Mack / Charles E. Mack; James McKee / James A. McKee; Maeola Beitzel / Maeola R. Beitzel. The 2025–26 CDE file has **two additional TK/K-serving entities without corresponding K meal-source rows**, California Montessori Project – Elk Grove Campus and Las Flores High (Alternative); this is **not** proof of zero meal service. See `results/2025_26/elk_grove_unified_source_cds_candidates_review_only.csv`. No name-only link is officially accepted.

**Assessment:** good source for descriptive school-grade meal volume and **potential** additional attendance-check work after grade-code, enrollment measure and matched-period instructional-day verification. **Not yet an identified grade-specific meal participation rate.**

## 2. Ontario-Montclair: monthly grade-specific meals, but schoolwide attendance

The workbook contains `Source meals`, `Source ADA ADP`, an `Attendance` summary (May 2026), **32 current school worksheets**, and **32 backup worksheets**. The full contents of all 32 backups matched their current worksheets; count each school **once**. The school tabs and source headers describe **August 2025–May 2026**.

`Source meals` has **32 school blocks**, comprising **26 elementary schools with both TK and K rows** and six middle schools. It reports Breakfast, Lunch, and Supper **by school, grade and month**. The **245 original school-grade rows** yield 7,350 possible grade-month-meal cells (of which six PS/Supper cells are blank). All **1,056 source school-total column checks** reconcile, with each school's `STUDENTS EXITED` line included in the printed total. The printed school `TOTAL` lines sum to **972,190**, **2,492,558**, and **764,628** under the Breakfast, Lunch, and Supper headings. **Important:** those printed totals include a row labeled `STUDENTS EXITED` with respective entries summing to **22,606**, **65,558**, and **14,848**. The workbook does **not independently define** whether that category represents otherwise-unassigned meals or another administrative quantity; do not present it as a count of distinct children or verified reimbursable meals. The quantities attached to explicit grade rows, excluding `STUDENTS EXITED`, total **949,584**, **2,427,000**, and **749,780** under those headings, respectively.

Within the 26 elementary sites, the source labels **TK** and **K** separately. Across August–May, it reports:

| Grade | Breakfast meals | Lunch meals | Supper quantities |
| --- | ---: | ---: | ---: |
| TK | 53,194 | 123,987 | 33,984 |
| K | 90,715 | 231,040 | 72,039 |

These are **grade-labeled reported quantities** under each meal-type heading; the workbook alone does not independently establish reimbursement status, and these are not participation rates. The source label `PS` is retained as preschool and **not reclassified as TK**. All **2,340** targeted TK/K/first-grade × month × meal-type cells are populated; the six blanks elsewhere are PS/Supper, not zeros.

`Source ADA ADP` reports **schoolwide** Enrollment, ADA and meal-type ADP by month, **not TK- or K-specific ADA**. For **17 of 320 school-month pairs**, the ADA column associated with Supper differs by 1–3 from the Breakfast/Lunch ADA columns. These differences are flagged; no column was silently substituted or averaged. The separate May `Attendance` table agrees with the schoolwide May figures for the named schools.

**CDS linkage:** all **26 elementary TK/K meal-source schools** have unique CDE candidates: **24 unique normalized name candidates** and **two aliases requiring confirmation** (`Euclid Elementary` / `Euclid Language Academy`; `Haynes Elementary` / `Richard Haynes Elementary`). The six middle schools have no TK/K Census school in this extract and are not included in the TK/K linkage. See `results/2025_26/ontario_montclair_source_cds_candidates_review_only.csv`. These are candidates, not an authoritative site-to-CDS crosswalk.

**New measurement finding (31 October):** the additional school/month/meal-type diagnostic finds that monthly meal totals divided by corresponding ADP imply about **26 days for November 2025** at all 32 schools, despite only **20 weekdays** in that month. Removing the undefined `STUDENTS EXITED` category does not resolve the discrepancy. The records therefore do **not** establish that the monthly meal totals and ADP share identical service days, population, or calculation rules. See [the ADP-period consistency diagnostic](ontario_monthly_ADP_measurement_consistency_2026_10_31.md) and its [30-row summary](../results/2025_26/ontario_adp_monthly_consistency_summary_review_only.csv).

**Assessment:** monthly source columns correspond by label, but their actual exposure periods have **not been validated**. The workbook supports descriptive school-grade meal quantities with source labels, **not** kindergarten-specific attended days or validated participation rates.

## 3. Denominator compatibility and decisions

| Dimension | Elk Grove | Ontario-Montclair |
| --- | --- | --- |
| School meal totals by K | Yes | Yes |
| Explicit source TK meal label | **No — code 19 unverified** | Yes |
| First-grade meals | Yes | Yes |
| Grade-specific attendance | Enrollment plus rates, no verified student-day denominator | **No**; monthly schoolwide ADA/ADP only |
| Period | July 2025–March 2026 | August 2025–May 2026 |
| Model-based annual 2025–26 CDE proxy | Available, 180-day assumption | Available, 180-day assumption |
| Exact grade × school × period attendance denominator | **Not established** | **Not established** |
| Rate-ready? | **No** | **No** |

**Do not use the full-year CDE 180-day estimate as a direct denominator for a partial-year meal numerator.** Nor should an Ontario-Montclair schoolwide ADA measure be reassigned to TK/K. The separate TK, K, and Grade 1 model estimates allocate publicly reported **combined** absence-band days by Census shares and are therefore **sensitivity estimates, not observed ADA**.

## 4. Reproducible artifacts and remaining decisions

- [QA metrics, input hashes and explicit limitations](../results/2025_26/elk_ontario_uploaded_workbook_source_audit_2026_10_31.json)
- [Elk Grove CDS candidate review table](../results/2025_26/elk_grove_unified_source_cds_candidates_review_only.csv)
- [Ontario-Montclair CDS candidate review table](../results/2025_26/ontario_montclair_source_cds_candidates_review_only.csv)

For **Elk Grove**, ask the district to define original meal-grade code 19 and to confirm the enrollment/attendance-rate denominators and the number of service/instructional days in July–March. For **Ontario-Montclair**, request TK/K grade-specific average daily attendance or attended student-days by school and month if available, and clarify the Supper-column ADA anomalies. For **both**, obtain official program site/CDS identifiers before accepting the name variants. These are **external-source limitations**; they cannot be repaired with more name matching or an assumption.

The **Nutrition Services 2024–25 FNS10 matching audit** remains a separate effort: 2024–25 whole-site FNS10 quantities cannot be used as the grade-specific numerators for these 2025–26 district comparisons. The attendance-records correspondence is also separate and is not included in the Nutrition Services report.

**Research status:** source-level extraction, reconciliation, name-link candidate generation and reporting-period assessment are complete for both uploaded workbooks. Official grade-code/identity definitions and matched-period grade-specific attendance remain unresolved; no participation-rate estimate is claimed.


## Independent source-to-handoff check (31 October)

An additional **full-sheet** audit checked the original uploaded workbook against the internal meal/attendance handoff. Elk Grove's `Attendance details` sheet has populated records through **row 1,156**. Its 43 kindergarten meal-service sites each have nonmissing **K, TK, and first-grade attendance rates**. A previous audit that stopped at row 460 falsely labeled 16 of these schools as missing; that truncated read is invalid and has been superseded. **All 260** targeted Elk Grove grade × meal-type internal handoff rows matched source grade-level enrollment and attendance-rate values exactly.

Ontario-Montclair's **2,340** K/TK/grade-1 × month × meal-type internal handoff records were checked against the source's meal, schoolwide enrollment, ADA and ADP columns. **All 2,340 records matched on all four values**, with unique school-grade-month-meal keys and no source lookup misses. These checks validate *transcription and join mechanics*, not the substantive grade-specific suitability of schoolwide attendance.

Elk Grove's compiled `Source data` includes **PDF page references**; the cited underlying district PDF pages have **not** been separately authenticated in this audit. The uploaded Excel file's hash and internal arithmetic were verified, which is narrower than independent confirmation of the original district source report.
