# Independent FCK research-integrity audit — 31 October 2026

**Disposition: share source findings with caveats; do not publish kindergarten participation estimates.**

This audit directly rechecked the **specific CDE source bytes, original archived Ventura ADA workbook, and the user's original Elk Grove and Ontario-Montclair uploads**, not just cached analyses. Numerical claims below identify the population, year, source and test. The review covers the main current analysis files and their matching and methodological assumptions, but cannot certify the entire project as error-free.

## Sources and versions checked

| Source | Version / SHA-256 | Verified population |
| --- | --- | --- |
| CDE Census Day enrollment | `cdenroll2526.txt` — `10d074101bc1aa3e9dc7433200a3825e430e261b1382e5c5f3102d989f4fa149` | 2025–26 school-level `TA` records |
| CDE Absenteeism by Reason | `absenteeismreason26.txt` — `59458d5a12a5c5e104633683f50c741e8d3a7e1e477fd12cc69192aee5581c0a` | 2025–26 school-level `GRTKKN` records |
| Ventura observed ADA | original source archive `ventura_ada_2025_26.xlsx` — `858457fa80dc5d539a551993dd59ec491153230c0c9838561f19f5a9db255782` | Grade-level TK/K attendance in 18 school worksheets |
| Elk Grove provided workbook | `Elk Grove Meal and Attendance Data.xlsx` — `f30c4a718c339e58ecac96caebc2ce026fd346c698f516de30130ec4bc040603` | Source-labelled 2025–26 July–March meals and grade attendance rates |
| Ontario-Montclair provided workbook | `Ontario-Montclair Meal and Attendance Data.xlsx` — `906eb421b5be21ba13051b62a4640fe29ebd350420e4eb97ca266878ee251635` | Source-labelled 2025–26 August–May monthly meals and schoolwide ADA/ADP |
| 2024–25 FNS10 | archived report `DR-20260729-160143 EXT_PRA_Penner_SNP_FNS10Meals.xlsx` | 2024–25 site-level meals, **no kindergarten grade** |
| 2024–25 CBEDS | `CA_sites_cbedsora24b.txt` — `cda8c7e3b0c573506acdda567d83494e93d19ec9ff7a4fd1caa95e08c09faa2f` | Site-name candidate matching; not an official FNS10 site-to-CDS crosswalk |

## Independent checks and results

**1. All-school 2025–26 Census–absence calculation (PASS, *arithmetic only*).**
- Source records: 269,090 Census rows; **10,558** school-level `TA` rows, with **6,261** records positive for TK or K. Of these, 96 have placeholder school codes `0000000`/`0000001`; **6,165** remain.
- Exact 14-digit CDS source keys in the school-level population are unique and complete.
- Of 6,261 positive-TK/K Census records, **5,917** have calculable combined TK/K proxies. **344** do not: **274** matched absence rows are suppressed, and **70** have no matching GRTKKN row. Among the 344 missing records, **342** have fewer than 20 TK/K Census students.
- In the non-placeholder group, **5,912 of 6,165 (95.90%)** have calculable proxies. The 253 missing have a combined **1,091** TK/K Census students of **568,165**. School-count coverage is not empirical attendance-validation coverage.
- An independently implemented raw-file join and formula agrees with each saved 2025–26 proxy to within **2.3 × 10⁻¹³**. All nine selected district source totals and identifiers were independently rechecked; corrected Lodi has **35** Census school records, **34** calculable, and **2,613.56** estimated TK/K daily attendance across complete cases.
- The 180-day denominator is an explicit modeling **assumption**, not an actual-calendar confirmation for every district. The reported `estimated_attended_student_days` are *model-derived*, not CALPADS STAS field 13.16, observed TK/K attended days, or a verified participant count.
- **Population warning:** excluding administrative placeholders does not prove every remaining row is a conventional elementary campus. Virtual, charter, CDC or county-program entities may require separate eligibility rules.

**2. Original Ventura observed ADA (PASS for 17-school comparison).**
- The original team Excel workbook has **18** sheets, including Homestead (observed kindergarten ADA **1.04**), which has no positive-TK/K Census match in the 17-school comparison. Its 18-school total is **1,180.18**; the correct, explicitly restricted **17-school** observed ADA is **1,179.14**.
- Every one of the 17 observed figures matches the previously archived benchmark. The independently calculated Census–absence proxy totals **1,186.06**, cumulative–absence **1,236.06**; school-level winner split **13 Census / 2 cumulative / 2 ties**, with mean absolute errors **1.252** and **3.348** students per school.
- This independently confirms the *same-year descriptive comparison*. It does **not** justify generalizing the estimator's 0.59% aggregate error to other California districts or claiming a causal attendance effect.

**3. Elk Grove user-provided workbook (PASS for workbook arithmetic and handoff, *definitions remain unresolved*).**
- **442** school-grade meal-source detail rows correctly sum to **711,424** Breakfast and **2,429,657** Lunch entries; separate printed TOTAL lines were **not** double-counted.
- The workbook has 43 kindergarten meal-source sites, 43 original meal grade-code `19` sites and 44 grade-1 sites. Grade `19` was labeled `19 (check TK)` in the supplied **compiled source sheet**; the original source-system meaning is **not confirmed**.
- **Critical full-sheet read boundary:** the `Attendance details` sheet contains populated rows through **row 1,156**, not just its first 460 rows. A temporary audit that read only the first 460 falsely suggested 16 schools were missing attendance rates. That result was **retracted**. Reading the full sheet confirms **all 43 K meal sites have nonmissing K and TK attendance rates**, and the corresponding grade-1 rates.
- All **260** internal school × grade × meal-type handoff rows reconcile to source grade enrollment and attendance rates, with **zero** differences.
- The uploaded `Source data` has PDF-page references. The underlying original district PDF pages were **not separately authenticated** here; checked source provenance is the user-provided XLSX file with the stated SHA.
- The July–March period, unknown meal-code definition and absence of confirmed grade-specific attended days mean **not participation-rate-ready**.

**4. Ontario-Montclair supplied workbook (PASS for transcription and arithmetic, *measurement contradiction remains*).**
- School worksheets (32) and matching Backup worksheets were checked as duplicate representations, not added together. The source has 26 school blocks with separate TK and K meal rows.
- Internal handoff has **2,340** school × grade (TK,K,1) × month × meal-type rows; every record was compared to the original source's **meal quantity, schoolwide enrollment, schoolwide ADA and meal-type ADP**, with **zero value mismatches** and no duplicated source keys.
- School total lines include a `STUDENTS EXITED` category whose meaning is **undefined**. The report-wide printed quantities of **972,190 / 2,492,558 / 764,628** under Breakfast/Lunch/Supper include that category; they must not be called verified reimbursable meals or numbers of children.
- The monthly ADP check found that November 2025 source totals / ADP yield roughly **26** across all 32 sites and three meal types, although November had only **20 weekdays**. The anomaly persists if `STUDENTS EXITED` is excluded. This is a diagnostic inconsistency, **not proof a specific field is wrong** or a determination of true service days.
- Monthly ADA/ADP are **schoolwide**, not TK/K grade-specific. Some Supper-linked schoolwide ADA fields differ from Breakfast/Lunch (17 school-months). Do not silently substitute, average or infer grade-specific attendance.
- No supported matched-period kindergarten participation rate is yet identified.

**5. Statewide 2024–25 FNS10 site matching (PASS for claims reconciliation and candidate-count arithmetic; **identity not verified**).**
- The previously run original-workbook audit reconciled **327,641,211** Breakfast and **557,472,855** Lunch claim quantities. Independently summing the retained sponsor/site review export reproduces those totals.
- Under the conservative normalization, the review export has **9,985** unique sponsor/site keys, **6,282** unique normalized district/site-name candidates and **3,703** unmatched keys; all 6,282 exact candidates have a unique 14-digit CDS and none is a placeholder code. This is **name-candidate quality**, not proof a nutrition-service site corresponds one-to-one to the candidate school.
- The earlier **6,515 / 9,988** result used different standardization rules and is **not directly comparable**. The 2024–25 FNS10 data contain site-level meal counts, **not a kindergarten-specific numerator**. Do not combine 2024–25 FNS10 with 2025–26 attendance.

**6. Handoff and file-version checks (PASS within checked extracts).**
- The earlier 6-district ZIP contains the **corrected 35-row Lodi** file, not the initial 27-row file. The nine-district handoff ZIP contains **196 non-placeholder school-code records**, with unique CDS codes; no raw student-level dataset was committed.
- The 2025–26 source-derived TK/K proxies are never negative; TK and K allocation estimates sum to the combined TK/K proxy for every complete source row, and no negative grade-1 allocated proxy was observed.
- **Spreadsheet-import warning:** treat 14-digit CDS identifiers as **text**. Automatic numeric import can strip leading zeroes from county identifiers and break links.
- The legacy `R/11` 2025–26 standalone prototype retains **10,558** school-level Census `TA` records instead of the Python generator's **6,261** positive-TK/K rows. Those are **different populations**, not contradictory district results. Its identifier and year guards were strengthened in the working branch but were **not run through an R runtime in this audit**.

## Prioritized findings and decisions

| Severity | Issue | Action/status |
| --- | --- | --- |
| **High — needs source authority** | The requested actual kindergarten meal participation numerator and grade-specific, period-aligned attended-days denominator are not jointly observed in the current statewide claims and public CDE files. | **Do not publish participation rates** from these sources alone; identify required comparable numerator/denominator fields with Dr. Penner. |
| **High — needs source authority** | Elk Grove original meal grade code `19`; five candidate school/CDS name variants across two districts; some meal reporting periods differ from the annual 180-day assumption. | Keep all as review-only; obtain grade-code dictionary, confirmed site/CDS IDs, attendance exposure and schedule. |
| **High — needs definition** | Ontario-Montclair's month-to-ADP discrepancy and `STUDENTS EXITED` category. | Keep quantities descriptive; request how ADP, date windows and exited category were constructed. |
| **Medium — corrected and rechecked** | The original 27-school Lodi extract dropped eight records because initial retrieval was incomplete. | Full-source official data rebuild corrected to 35; separate source calculation and ZIP checks passed. |
| **Medium — corrected and rechecked** | Temporary audit of Elk Grove `Attendance details` stopped at row 460 and falsely suggested 16 absent rates. | **Retracted**. Full 1,156-row read confirms 43/43 K and TK rate coverage. Added full-sheet check to source audit script and metadata. |
| **Medium — documented** | Source workbook includes PDF page references, but original district PDFs were not independently checked. | Preserve SHA and label workbook as verified supplied **extraction**, not authenticated upstream PDF transcription. |
| **Medium — pending runtime test** | Separate legacy R prototype had weak detection of pasted missing CDS and omitted an explicit source-year guard. | Added source-code guards in draft branch; R runtime verification remains pending. |
| **Low — interpretation** | Possible school-code population includes nontraditional schools; coverage and participation can be confused in summaries. | State source population and eligibility explicitly; never call percentage coverage validation accuracy. |

## Limitations and next verification gate

This is a **deep focused audit of consequential evidence**; it is not a claim of mathematical certainty for every file in two changing repositories. Source-level tests used the exact files identified above and are reproducible from retained scripts and summaries. It did not independently authenticate every underlying district PDF, resolve program-site identity aliases, independently execute the modified legacy R code, or produce grade-level attended-day measures that the sources do not contain.

**Describing the Lodi correction:** The initial 27-school file came from a preliminary automated extraction; the complete 35-school version was subsequently rebuilt through GitHub Actions. The source coverage check established the omission. Report that **the full-source recheck found an incomplete preliminary Lodi extract, now corrected**, rather than presenting the correction as a separate manual discovery.

**Before merging PR #10:** review the source claims and committed unit-test checks; independently run the modified R source-audit script with the private uploads if it is to be represented as executable-verified. Do not silently merge a still-draft research handoff.

**CDE workstreams remain separate:** Nutrition Services receives the 2024–25 FNS10 report and requests for comparable 2025–26 claims and stable sponsor/site IDs or a site-to-CDS crosswalk; get kindergarten schedule classifications from public CBEDS. The unrelated attendance-records correspondence does not belong in that report.
