# 2025–26 CDE attendance denominator extracts — October 29, 2026

## Current status and what was actually reproduced

The public-data side of Ventura's **2025–26** TK/K validation was independently recalculated from Census Day enrollment (`AggregateLevel=S`, `ReportingCategory=TA`) and Absenteeism by Reason (`Aggregate Level=S`, `Reporting Category=GRTKKN`) joined by **14-digit CDS code**. For the 17 Ventura schools with TK/K enrollment (Homestead excluded: zero TK/K Census and suppressed absences), the results exactly match the previously reported source-data totals to two decimals:

| 2025–26 Ventura, 17 schools | Students/day |
| --- | ---: |
| Census TK+K enrollment (P0) | 1,263.00 |
| Census − GRTKKN absence days / 180 (P1) | 1,186.06 |
| Cumulative − GRTKKN absence days / 180 (P2) | 1,236.06 |
| Observed annual TK/K ADA **as previously reported in the October technical appendix** | 1,179.14 |
| P1 gap against the reported observed aggregate | +6.92 (+0.59%) |

The public-side estimates and the **school-by-school comparison** were both reproduced against the team's archived independently checked benchmark table at [analysis/2026-10-25/tables/independent_benchmark_checks.csv](https://github.com/whippedfruit/Feed-California-Kinders/blob/main/analysis/2026-10-25/tables/independent_benchmark_checks.csv). Our new `results/2025_26/ventura_17_school_ada_validation.csv` reconciles all 17 schools: **Census-adjusted closer at 13, cumulative-adjusted closer at 2, equal at 2**. P1 MAE is **1.2516 students/day per school** and P2 MAE is **3.3480**. The two cumulative-favored exceptions are **Lincoln Elementary** (observed 61.08; P1 60.03; P2 62.03) and **Montalvo Elementary** (observed 85.26; P1 88.62; P2 86.62). Sunset and Will Rogers are the ties. This is not a fresh re-extraction of the original district Excel source, which remains in the shared team repo at `Ventura Unified/extracted data/Ventura 8:13:2025 - 6:4:2026 ADA clear_copy.xlsx`.

## District extracts now committed

Derived public-data files are in `results/2025_26/`. Each district has a **wide school-level extract** ending `_school_denominator_proxies.csv` and a **long school-by-grade sensitivity extract** ending `_school_grade_proxies.csv`. These are preliminary research handoff files; neither is a final meal participation dataset.

| District | TK/K Census schools | TK/K estimated (n) | Missing/suppressed (n) | TK/K Census total | Sum P1 across calculable schools (students/day) |
| --- | ---: | ---: | ---: | ---: | ---: |
| Lodi Unified | 35 | 34 | 1 | 2,877 | 2,613.56 |
| Ventura Unified | 17 | 17 | 0 | 1,263 | 1,186.06 |
| Irvine Unified | 31 | 30 | 1 | 3,318 | 3,123.12 |
| Elk Grove Unified | 47 | 44 | 3 | 6,503 | 5,912.13 |
| Ontario-Montclair | 26 | 26 | 0 | 2,357 | 2,250.92 |
| Ojai Unified | 5 | 5 | 0 | 234 | 221.69 |
| **Selected districts only** | **161** | **156** | **5** | **16,552** | **15,307.49** |

The P1 sums exclude suppressed or otherwise unusable TK/K records; they must **not** be compared with full Census totals as if each row were measured. These districts were prioritized from the project's current district records; they do **not** comprise a statewide census or establish statewide validity.

**Correction:** The previous 27-school Lodi extract was incomplete because the source retrieval stopped before eight school records. The complete 2025–26 CDE file contains 35 TK/K-serving schools for Lodi; the 27-school figures are superseded.

**Lodi review:** `Independence` (3 Census K students) has a suppressed TK/K absence estimate; it remains missing. `Rio Valley Charter` has 74 TK/K Census students and zero reported TK/K absence days; its independent-study arrangements require separate measurement review. Do not treat this as proof of perfect attendance. **Irvine / Elk Grove:** one and three missing TK/K proxies respectively. **Ojai:** the audit identified a 172-day source file versus 180-day calendar discrepancy; do not interpret the 180-day proxy as verified actual Ojai ADA.

## Definitions and reusable columns

For each school with TK/K Census enrollment, `P1 = GR_TK + GR_KN − (GRTKKN Total Days Absent / 180)`, expressed in **estimated attending students per day**. `estimated_tk_k_attended_days = P1 × 180`. CDE calls its absence group's population **eligible cumulative enrollment**, which is not equal to annual expected student-days.

The public Absenteeism by Reason file combines TK and kindergarten (`GRTKKN`) and grades 1–3 (`GR13`). The wide extract includes the **combined TK/K** P1, cumulative P2, Census counts for TK/K and grades 1–3, absence totals for both bands, CDS, district/school names, and missing/suppressed/zero-absence flags.

The long `_school_grade_proxies.csv` files provide `grade=TK`, `K`, and `01` estimates for analysis **only as assumption-dependent sensitivities**, not observed grade-level ADA:

- `estimated_TK = Census_TK − (GRTKKN absences × Census_TK / (Census_TK+Census_K)) / 180`.
- `estimated_K = Census_K − (GRTKKN absences × Census_K / (Census_TK+Census_K)) / 180`.
- `estimated_grade_1 = Census_1 − (GR13 absences × Census_1 / (Census_1+Census_2+Census_3)) / 180`.

This assumes equal per-student absence exposure **within each public grade band**. The assumption is unverified and might mask actual TK/K/first-grade differences. Do not label these values measured, or use them for final kindergarten-versus-first-grade participation comparisons without appropriate checks. `GR13` **does not** provide observed first-grade absences.

The 180-day benchmark follows Ventura's board-approved 2025–26 180-student-day calendar and Dr. Penner's project decision to use 180 as the initial standard across districts. A school with 178 days may have 178 for both kindergarten and first grade, but that **does not prove** grade-specific exposure assumptions or remove possible absolute bias. Exceptions and varying grades/days require review. Observed attendance uses days attended, not meals or distinct students.

## Source manifest and reproducibility

- **CDE Census Day Enrollment 2025–26:** `cdenroll2526.txt`, file available in the project Library, version 1, last modified 2026-10-25; school TA rows recovered from that indexed source. CDE page: https://www.cde.ca.gov/ds/ad/filesenrcensus.asp . Official release listed as posted April 16, 2026. The complete original CDE Census file was subsequently recovered and verified against SHA-256 `10d074101bc1aa3e9dc7433200a3825e430e261b1382e5c5f3102d989f4fa149`.
- **CDE Absenteeism by Reason 2025–26:** `absenteeismreason26.txt`, uploaded October 29, 2026 (374,359 data rows; 23 tabular columns). **SHA-256:** `59458d5a12a5c5e104633683f50c741e8d3a7e1e477fd12cc69192aee5581c0a`. CDE context: https://www.cde.ca.gov/ds/ad/filesabr.asp .
- **Observed Ventura ADA aggregate and earlier per-school ranking:** `FCK_Technical_Appendix_INTERNAL_REVISED.pdf` and `FCK_Kindergarten_Meal_Service_Report_CDE_2026-10_REVISED(2).docx`; these are **reported prior analyses**, not observed student-level records. Original ADA source is still required for independent per-school reconciliation.
- **Transformation:** strict school-level `TA` and `GRTKKN`/ `GR13`, same `AcademicYear=2025-26`, exact 14-character CDS joins, no name-only linking, and no imputation of `*` suppressed cells.
- **Checks:** 17 Ventura schools reproduced the published P0/P1/P2 aggregate targets; all six district CSVs were read back from GitHub, with zero repeated CDS keys within each district. The full 2025–26 CDE source download and statewide Python builder have now executed, with source hash checks. Separate original 2024–25 legacy R and Angela integration tests are reported in their GitHub Actions logs.

## Rebuild for every district once source files are mounted locally

```sh
python scripts/build_denominators_2526.py 
  data/raw/cdenroll2526.txt data/raw/absenteeismreason26.txt 
  output/district_denominators
python -m unittest discover -s tests -p 'test_denominators_2526.py' -v
```

Use repeatable `--district 'Lodi Unified'` filters for specific districts. Raw official source files remain excluded from version control. The original `R/11_district_denominator_extracts_2526.R` remains as a combined-TK/K-only prototype. The Python generator was subsequently run against complete checksum-verified 2025–26 CDE source files. Its statewide output and quality summary are committed under `results/2025_26/`.

## Handoff to Angela's figures and FNS10

The standardized long output uses stable fields: `school_year`, `cds_code`, `district_code`, `district_name`, `school_name`, `grade`, `census_enrollment`, `estimated_ada`, `estimated_attended_student_days`, `proxy_method`, and `status`. A district meal numerator must match the **same school, grade, meal type and service period** before any meal rate can be computed. A figure must label estimates as proxies. The program in `scripts/audit_fns10_links.py` produces **review-only** crosswalk suggestions, not a verified join.

2024–25 statewide FNS10 claims should be linked to **2024–25** school attributes and public denominator files. The 2025–26 outputs here are intended for **2025–26 district-provided meal data**. The 2025–26 CBEDS schedule classifications will be obtained from public files, separately from the Nutrition Services request. Attendance public-records correspondence is a different workstream.

## Long-format regeneration

After running the Python builder, generate one standard long-grade sensitivity file from each output district CSV:

```sh
python scripts/reshape_district_denominators_2526.py \
  output/district_denominators/district_39_68585_school_proxies_2025_26.csv \
  output/district_denominators/district_39_68585_school_grade_proxies_2025_26.csv
```

The companion team repository contains Angela's Ventura R scripts, which use `school_name`, `grade`, and observed `attendance` as fields. These generated long files instead use `grade` and `estimated_ada` deliberately: **do not rename this proxy to observed attendance without an explicit labeled conversion**. Existing source-based figures should remain unchanged until a tested, grade- and period-matched join is implemented.

## Ventura school-level benchmark replication

Using the archived team benchmark CSV (not the original Excel binary), regenerate the 17-school observed-versus-estimated comparison:

```sh
python scripts/reproduce_ventura_2526.py \
  team/analysis/2026-10-25/tables/independent_benchmark_checks.csv \
  output/ventura_17_school_ada_validation.csv
```

The reproducibility script asserts 17 schools, exact aggregate targets, and a 13/2/2 winner split. The archived benchmark comes from the public shared team repository; the `team/` prefix represents where a local checkout would be placed. It is not part of this private denominator repository. This file is an **archived-reference replication**, not a new independent review of district records.


## Full statewide build — October 29–30, 2026

After downloading and verifying both complete 2025–26 CDE files against the team's source SHA-256 values, `scripts/build_denominators_2526.py` produced the complete statewide school table and district quality summary. **This is source-file coverage, not validation of actual ADA.**

- Positive TK/K Census rows: **6,261**; combined TK/K proxy calculable **5,917**; missing **344**.
- Of these, **96 are pseudo-school entities** with school code `0000000` or `0000001`. Excluding these yields **6,165 actual-school rows**, with **5,912** calculable (95.90%) and 253 missing.
- The statewide output includes **923 county–district CDS identifiers**. Ten district names are reused across different identifiers, so the generator was corrected to group by county and district code instead of name alone.
- No negative TK/K proxies arose in the statewide build; zero reported absence totals remain flagged, not assumed to mean perfect attendance.
- Six selected districts now include **161 TK/K Census school rows**, **156** calculable estimates and **5** missing/suppressed cases. Their combined complete-case estimate is **15,307.49 students attending per day**. This is not an observed district attendance total.

Review school program models, varying calendars and grade-band absence allocations before integrating with school-grade meal data. The 180-day calculation remains a project assumption outside the specifically verified Ventura calendar.


## Independent source recheck (31 October 2026)

**Source file coverage and direct formula verification:** Both complete official 2025–26 TSV files were independently loaded and joined by 14-digit CDS, rather than calling the project's reconstruction helper. All **6,261** positive-TK/K Census rows match the archived statewide output, with **5,917** calculable combined proxies; the largest absolute difference in a calculated estimate was under `3e-13`. Excluding 96 administrative pseudo-code records gives **6,165 coded records, 5,912 calculable**. That is **calculation availability**, not validated observed ADA or necessarily 6,165 conventional public elementary campuses.

Missingness is strongly concentrated in small programs: **274** positive-TK/K source rows have suppressed absence values; **70** have no matching GRTKKN absence row. Among those 344 missing, **342** have fewer than 20 TK/K Census students; on the non-pseudo subset, 253 are missing and their combined Census enrollment is 1,091 of 568,165. Do not impute missing cells or claim that school-count coverage guarantees representativeness. Some positive-TK/K records have nontraditional programs/virtual or county-operated services; filter eligibility separately for the intended population.

**Ventura original source verified:** The original workbook from the shared team source archive (SHA-256 `858457fa80dc5d539a551993dd59ec491153230c0c9838561f19f5a9db255782`) has 18 school sheets, including **Homestead**, which reports **1.04 kindergarten observed ADA** but has no TK/K Census-positive match in the 17-school comparison. Independently summing the original observed ADA for the **17 matched schools** gives **1,179.14**; including Homestead gives **1,180.18**. All 17 archived comparison entries match the original school workbook's observed ADA values, and the 13/2/2 estimator comparison and mean absolute errors reproduce. This **supersedes the earlier statement that only an archived-reference comparison was checked**. It does not establish statewide generalizability.

**Two implementations, different base populations:** `scripts/build_denominators_2526.py` is the controlling positive-TK/K output (6,261 Census rows including pseudo-codes). `R/11_district_denominator_extracts_2526.R` is a standalone experimental module retaining **all 10,558** school-level `TA` Census rows, including schools without TK/K enrollment. **Do not compare its row count directly to the Python builder's without applying identical eligibility criteria.** Its CDS and school-year guards were strengthened, but the updated R module still needs a separate executable runtime test before being certified.
