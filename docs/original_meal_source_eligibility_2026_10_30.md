# Original meal-source eligibility review — October 30, 2026

This review directly inspected the original files in `whippedfruit/Feed-California-Kinders`, **not just their filenames**. It is distinct from the **2024–25 statewide FNS10** matching work. All proposed source-to-CDS joins below are review candidates, not automatically accepted administrative identifiers.

## Chino Valley Unified — useful school-grade meal counts, incomplete reporting-period evidence

**Source:** `Chino/July 2025 to March 2026 - Meals by School & Grade.xls` (SHA-256 `0e58d28541262e25ce361ec5e98ff773945e1639ab57237530c2318d02d2d4dc`).

The workbook has a single sheet (`ReportPageHeaderPortrait`) with **452 rows including the header**, of which **451 are school-grade-meal-type observations**. Four fields: `School`, `Grade`, `Meal Type`, `Total`. It contains **34 source school names**. Of those, **23** have kindergarten, transitional kindergarten, or grade-1 observations. In the target grades the source has:

| School-grade-meal rows | Reported rows |
| --- | ---: |
| Kindergarten: Breakfast + Lunch | 46 (23 of each) |
| Grade 1: Breakfast + Lunch | 46 (23 of each) |
| Transitional Kindergarten: Breakfast + Lunch | 23 (12 schools; one missing Breakfast entry) |
| **Total** | **115** |

**Exception:** `Marshall Elem School` has a TK **Lunch** row but no TK **Breakfast** row. This is unreported, **not a verified zero**. `Pre-Kindergarten` is a separate grade label in the source and must **not be relabeled TK**; `Transitional Kindergarten` is separately present.

School names differ from the CDE names (e.g., `Borba Fundamental` versus `Anna A. Borba Fundamental Elementary`). After an explicit, deterministic name-signature transformation, **23 source school names each have one unique candidate CDE school/CDS**. These are included in `results/2025_26/chino_site_to_cds_candidates_review_only.csv`. The 24th CDE TK/K school, **Allegiance STEAM Academy - Thrive**, has **no corresponding K/TK/1 site in the Chino workbook**. *A unique name match is not proof of the official meal-site identity.* Do not merge counts into a participation estimate until the crosswalk is verified by district records.

The filename describes a period **July 2025–March 2026**, but there is **no service-date column, interval field, or calendar metadata inside the four-column workbook**. Therefore the counts cannot safely be divided by a **full-year 180-day attendance proxy**. A source report explicitly identifying the service dates, and attendance/exposure over the **same actual period**, are still required.

**Verdict:** **Useful for descriptive school-grade meal counts and candidate matching. Not yet rate-ready.**

## Davis Joint Unified — not suitable for the requested school-grade rates

**Source:** `Davis Joint Unified/raw data/Davis Joint Unified Meal cleaned_copy.xlsx` (SHA-256 `bbbd1f582faeaee8b70e2b916b8d7049df16bbdbbf49088444ebbf1224c552be`).

Single sheet `Sheet1`, **28 rows × 2 columns**, headed `School Name` and `Total`. Nine schools appear. Four have an adjacent `KTotal` row with numeric values (Birch Lane 8,135; Monarca 11,371; Fairfield 865; Korematsu 9,223). The `KTotal` cells for the other five schools are **blank**, not zeros. The workbook does not identify **breakfast versus lunch**, **date range**, or whether `KTotal` means reimbursable kindergarten meals rather than another report total. It provides no separate TK or Grade 1 records.

**Verdict:** **Not rate-ready.** Do not assign `KTotal` to Breakfast/Lunch or infer missing values; request the source report's field definitions, meal types, and service dates.

## Oak Park Unified — district-by-grade quantities, not school-level numerators

**Source:** `Oak Park Unified/raw data/Oak Park Meals served by grade 12.20.25-6.30.26_copy.pdf` (SHA-256 `101a5366db1f87a571c96a76e12fc4b0b9767c0ea82144fdd469671d86493b2f`), **15 pages**.

Page 15 explicitly filters the report to **December 20, 2025–June 30, 2026**, with `Is Reimbursable Item=True`, `Is Void=False`. Pages show **district-wide grade aggregates**, with no individual school/CDS or service-site column. Examples of source-labelled `Total Quantity`:

| Grade | Breakfast | Lunch | Where |
| --- | ---: | ---: | --- |
| Kindergarten | 9,879 | 8,004 | PDF p. 13 |
| Grade 1 | 9,060 | 8,791 | PDF p. 4 |
| Preschool | 9,618 | 8,088 | PDF p. 14 |

The PDF labels **Preschool**, not TK; do not assume these populations coincide. Quantities are not distinct children. Its **district-wide** grade aggregates cannot be assigned to three separate schools' CDE attendance estimates. The reporting period also does not cover the full school year.

**Verdict:** **Descriptive district-grade quantities only; not school-level rate-ready.** Request school identifiers and meal totals by school, grade, meal type, and service dates. If only district totals can be obtained, do not manufacture school-level numerators.

## Consequences for Dr. Penner's five requested tasks

1. **Ventura:** 2025–26, 17-school ADA proxy validation completed against the team's archived observed benchmark; Lincoln and Montalvo were the cumulative-favored exceptions.
2. **District denominators:** **Nine district extracts** have been generated from official 2025–26 CDE sources. There are **199 positive-TK/K Census records**, including **three administrative pseudo-entities**. The **actual-school analysis-ready subset is 196 schools; 192 have calculable combined TK/K proxies**. The available CDE school-by-grade values are model-allocated sensitivity calculations, not measured grade-specific ADA.
3. **Standardization:** Files use 14-digit CDS identifiers, school-year labels, consistent grades and estimator/status fields. Angela's original Ventura R integration test previously joined 50/50 target school-grade rows after an explicit name crosswalk and grade `01→1` conversion; its script needs a recorded workaround, and the existing 178-day constant must not be used uncritically.
4. **Methodology:** Retain the **180-day modeling assumption** with source limitations. Do not infer same-period student attendance from a partial-year meal report.
5. **FNS10 statewide linkage:** The separate **2024–25** FNS10 matching audit produced **6,282 unique exact-name candidates among 9,985 normalized sponsor/site keys** and **3,703 unresolved keys**. The 2024–25 claims provide **whole-site meals, not kindergarten-specific numerators**. Obtain stable Nutrition Services site identifiers or a site-to-CDS crosswalk if possible. Do **not** mix unrelated attendance-records correspondence into the Nutrition Services report.

### What is actually blocked on external data or research judgment?

- Chino needs authoritative site identity verification and a **precisely defined reporting period with matched-period attendance**.
- Davis needs a grade/meal-type/date-defined source report; the current file cannot support the requested rate.
- Oak Park needs **school-specific** grade and meal-type breakdowns and matched-period attendance.
- The unresolved 2024–25 statewide FNS10 site names require source-backed adjudication or an authoritative crosswalk; **no automatic fuzzy match is accepted**.

These are source limitations, not unrun scripts. **Do not present all nine districts as analysis-ready participation observations.**

### Verification

GitHub Actions [successful full 2025–26 and 2024–25 source-backed run](https://github.com/taielucile/ca-school-lunch-attendance/actions/runs/40997088505), plus the [Chino/Davis/Oak Park source-inspection run](https://github.com/taielucile/ca-school-lunch-attendance/actions/runs/41094988820). The Chino XLS binary was also independently parsed against its 451 school-grade-meal rows; Davis was inspected as an XLSX; Oak Park PDF pages were visually checked.
