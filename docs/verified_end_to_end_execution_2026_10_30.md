# Source-backed verification: October 30, 2026

**Status:** All three requested execution workstreams have been run. The original 2024–25 R pipeline and regression suite, the full 2025–26 CDE source build and reconciliation, and the Angela Ventura R integration test have successful GitHub Actions logs. Unmatched FNS10 sites are **not** automatically resolved by a successful candidate-generation audit.

## Verifiable run and source versions

[Successful full-data GitHub Actions run #40997088505](https://github.com/taielucile/ca-school-lunch-attendance/actions/runs/40997088505) — executed source downloads, SHA-256 verification, Python tests, 2025–26 source-wide regeneration, six-district matching, original XLSX FNS10 audit, original 2024–25 R pipeline/regression suite, and original Ventura R integration harness. See the attached `fck-full-data-provenance` artifact for the full source manifest and the R execution logs.

| Input | SHA-256 |
| --- | --- |
| 2025–26 Census Day `cdenroll2526.txt` | `10d074101bc1aa3e9dc7433200a3825e430e261b1382e5c5f3102d989f4fa149` |
| 2025–26 Absenteeism by Reason `absenteeismreason26.txt` | `59458d5a12a5c5e104633683f50c741e8d3a7e1e477fd12cc69192aee5581c0a` |
| 2024–25 Census Day `cdenroll2425.txt` | `ff65bf6e2c4a0928dc1533106af29716a2cefb71e2e521e5c0e174fa737f8bbc` |
| 2024–25 Absenteeism by Reason `absenteeismreason25-v2.txt` | `07a12d7f3b20b19ba02c6363f87becb5b3c03ee1e87c0aca7ddf5012c72a6bd7` |
| 2024–25 CBEDS `CA_sites_cbedsora24b.txt` | `cda8c7e3b0c573506acdda567d83494e93d19ec9ff7a4fd1caa95e08c09faa2f` |

## 2025–26 attendance denominator rebuild

- 6,261 Census records have positive TK/K; 5,917 yield a calculable combined TK/K proxy.
- 96 such records are pseudo-school identifiers (`school_code = 0000000` or `0000001`), so among **6,165 actual school records**, **5,912 (95.90%)** yield calculable combined TK/K proxies.
- Six selected districts: **161** schools with positive TK/K Census counts; **156** combined proxies calculable.
- Corrected Lodi includes **35** TK/K school records, **34** calculable, with **2,613.56** estimated attending students per day across complete cases. The previously published 27-school Lodi extract was incomplete and is superseded.
- A generator bug that grouped identical district names was fixed; statewide district files are now keyed by county–district identifier.
- Every six-district wide extract reconciled against the official complete source run. Suppressed records remain missing; zeros are not converted to perfect-attendance claims. The 180-day assumption is kept explicitly and is not verified as every district's actual instructional calendar.

## Original 2024–25 R regression pipeline

`Rscript tests/test_pipeline.R` sources the complete `RUN_ALL.R` workflow and then runs the frozen regression and data integrity checks. The exact completed run log (artifact `legacy-r/test_pipeline.log`) ends:

> Build complete.  
> All pipeline regression and integrity tests passed.

This confirms current executable regression integrity for the pre-existing 2024–25 workflow; it does not convert its Census-based proxy into observed annual student attendance.

## Angela's actual Ventura scripts: execution test and explicit adapter

The [shared-team Ventura attendance, meal, and final R scripts](https://github.com/whippedfruit/Feed-California-Kinders/tree/main/Ventura%20Unified) were sourced with their original 2025–26 Ventura workbooks. The original meal R script **fails without a workaround** because it contains a duplicate top-level section referring to function-local `breakfast_start`. The test records that error and executes an *in-memory* copy with only the duplicate unscoped block removed. **No changes were made to Angela's source files**.

After the workaround, the original final analysis ran and the new long grade-specific proxy extract was aligned with a CDS-to-name crosswalk and `01 → 1` grade-label transformation. The test summary reads:

| Integration metric | Result |
| --- | ---: |
| Observed ADA rows imported from original workbook | 130 |
| Meal rows imported from original workbook | 131 |
| Original ADA–meal join rows | 130 |
| Grade-specific proxy rows aligned | 50 |
| Proxy rows matching observed ADA school/grade | 50 / 50 |
| Proxy rows matching meal numerator school/grade | 50 / 50 |
| Reference schools in CDS crosswalk | 17 |
| Original meal R script runs unmodified | **No** |
| Original final R script hardcodes 178 student days | **Yes** |
| Original final R script assumes all TK/K are half-day | **Yes** |

The 50/50 results validate **record linkage and import mechanics only**. The individual TK, kindergarten, and first-grade values are Census-share-allocated estimates from combined grade bands, not observed grade-specific ADA. Existing Ventura percentage/meal-per-student-day figures should not be silently recalculated from these proxies, especially with the incorrect 178-day denominator and unverified half-day assumptions.

## Full 2024–25 FNS10 name matching

The original full workbook was audited: **327,641,211 breakfasts** and **557,472,855 lunches**, matching existing source totals. The new conservative normalizer yielded **9,985** unique sponsor-site keys, **6,282** unique exact district-and-school-name candidate links, **3,703** unmatched keys, and **four** duplicate CBEDS name keys. The earlier 9,988/6,515 match counts used a different standardizer, so no change in the underlying source data can be inferred from their difference.

Full candidate and unmatched files are in [`results/2024_25/`](../results/2024_25/). The review-only fallback also identifies **1,821 unmatched candidates** whose proposed CDE school has a kindergarten program classification; even those require sponsor, site, school, and calendar verification. The outstanding requests for stable Nutrition Services site IDs or a site-to-CDS crosswalk remain worthwhile. **No kindergarten-specific statewide meal numerator exists in this FNS10 extract.**

## Decision before merging

Technical execution has passed; **substantive data interpretation and identity decisions are still needed**. Do not merge or publish a statewide kindergarten meal participation rate, reclassify ambiguous FNS10 names as verified schools, or treat the grade-level proxies as measured ADA. Keep this pull request draft until the PI and downstream analyst review intended use, particularly independent-study/charter schools, service periods, and the school schedule classifications.


## Post-run independent integrity check (31 October 2026)

The original Ventura ADA workbook was subsequently read directly (not only via the archived comparison) and all 17 matched observed ADA values were confirmed; Homestead's separate 1.04 ADA is excluded from the 17-school population. Independent raw-TSV arithmetic for **6,261** Census records reproduced the statewide 2025–26 P1 estimates to floating-point precision. The missing records consist of **274 suppressed GRTKKN values and 70 absent GRTKKN records**; these are not zeros. See `docs/district_denominators_2025_26.md` for details.

The Elk Grove and Ontario workbooks were directly compared to internal handoff rows. Elk Grove's attendance sheet runs through row 1,156, and all 43 K meal sites had matching K/TK attendance rates. Ontario's 2,340 target handoff records match the original source values for meals, enrollment, ADA and ADP. These checks **do not** validate school-program identifiers, attendance-rate definitions, grade code 19, or participation rates.

Historical CI success verifies the code and specified source snapshot, not the inferential identification of a statewide kindergarten participation rate. Current pull-request checks are source-independent; full source downloads can fail from external redirects without indicating a data discrepancy.
