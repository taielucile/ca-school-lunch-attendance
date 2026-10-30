# FNS10–CDE site linkage: auditable review workflow (October 29, 2026)

## Scope

**2024–25 statewide FNS10:** the meal-claims workbook contains sponsor and site names, not a reliable 14-digit County–District–School (CDS) key. The October 23 technical appendix records **9,988 standardized sponsor–site pairs**, **6,515 exact normalized-name links** to 2024–25 CBEDS schools (**65.23%** of pairs), and **423,787,742 lunches at those linked sites** (**76.02%** of statewide lunch volume). It excluded **four ambiguous normalized CBEDS keys**. Those figures remain the previously published exact-standardization results. **The complete FNS10 workbook and 2024–25 CBEDS source have now been reprocessed directly** using a conservative, separately specified matching method. The two methods are not equivalent; their results should be reported side by side, not silently combined.

**2025–26 district meal files:** use their own school/grade/meal-type/date fields and link to this branch's 2025–26 school extract via a documented crosswalk; do not link 2024–25 statewide claims to 2025–26 attendance or assume that a meal-service site and a school are always one-to-one.

## Matching order and safety

1. **Best option:** obtain from CDE Nutrition Services stable sponsor identifiers, site identifiers, and ideally an authoritative **site-to-CDS crosswalk**. A nutrition program site ID is not automatically a CDS code. Verify whether it is school-, kitchen-, program-, or service-location-based, especially for charter and multischool sites.
2. **Exact first:** standardize case, whitespace, accent marks, punctuation and documented district-name variants; match the pair of district/sponsor and site/school names and validate unique CDS. Preserve original values alongside normalized keys. Report school-name collisions across districts and one-to-many candidates.
3. **Fuzzy suggestions only:** run `scripts/audit_fns10_links.py` with two UTF-8 CSVs: FNS10 pairs with `sponsor_name,site_name` and CDE catalog with `district_name,school_name,cds_code`. It uses district-key blocking and an average of token cosine and character similarity. Output statuses are `exact_normalized_candidate`, `ambiguous_exact`, `fuzzy_review_only`, `no_district_block`. **Even normalized exact candidates require a one-to-one identity review before final adoption; all fuzzy suggestions require human verification**. A sponsor is not necessarily a district; `no_district_block` is not proof a site does not exist.
4. **Manual adjudication:** keep reviewer, date, evidence URL/file, source names, assigned CDS, basis for acceptance/rejection, ambiguity flag, and coverage / meals affected. Review alternate campuses, school renames, grade configurations, charter management organizations, service sites, and multi-school kitchens.
5. **Analysis eligibility:** do not use an unresolved link in a school-level meal participation statistic. Report both pair-weighted and meal-volume-weighted linkage coverage, unmatched and ambiguous proportions, and whether exclusions differ by school type and kindergarten schedule.

## Run

```sh
python scripts/audit_fns10_links.py \
  data/private/fns10_2024_25_pairs.csv \
  data/derived/cbeds_2024_25_school_catalog.csv \
  output/diagnostics/fns10_link_candidates_2024_25.csv
```

The file paths are *expected inputs*, not currently committed files. Never commit restricted district meal files or private contact information. The CDE request for comparable 2025–26 claims and identifiers belongs in the separate Nutrition Services workstream. Obtain kindergarten schedule classifications from **public CBEDS**, not through the Nutrition Services request. Do not mix unrelated attendance-records correspondence into that report.

## Interpretation

FNS10 breakfast/lunch counts are **meals**, not distinct students, and FNS10 claims have no kindergarten grade numerator. A denominator alone cannot identify kindergarten-specific participation from statewide FNS10 records. The district grade-specific meal files may support school-grade comparisons after period, unit, numerator and school crosswalk are verified. A fuzzy-match score is a candidate ranking, never a probability that a link is correct.


## Complete workbook re-audit and triage outputs — October 29–30, 2026

The complete original **2024–25** FNS10 Excel workbook (retrieved August 10, 2026) and UTF-8 2024–25 CBEDS school file were processed by `scripts/run_fns10_source_audit.py`. Raw workbook totals were verified: **108,259 breakfast claim rows / 327,641,211 breakfasts** and **108,666 lunch claim rows / 557,472,855 lunches**. These are *meal counts*, not unique student counts.

The new conservative standardizer produced **9,985 normalized sponsor–site keys** (versus 9,988 using the earlier analysis's different rules). Of these, **6,282** are unique **exact normalized sponsor-name + school-name candidate links** to 2024–25 CBEDS schools (**62.91% of the new key denominator**). They represent **407,150,310 lunches (73.04% of statewide lunches)** and **238,435,952 breakfasts (72.77% of statewide breakfasts)**. The previous analysis had matched **6,515 / 9,988 keys (65.23%)** and **423,787,742 lunches (76.02%)**. The difference is attributable to **matching-rule differences and therefore requires common-rule reconciliation**; neither figure should be interpreted as a change in school participation.

Under the new rules, **3,703** sponsor/site keys remain unmatched, subdivided into **848 within-district fuzzy candidates** and **2,855 without a reliably matched district block**. As prioritization *only*, a statewide-unique school-name fallback suggests **1,874** of the latter for human review; **19** same-district high-similarity possibilities are also flagged. No fuzzy/global fallback has been accepted as an established link. **Four duplicated CBEDS district/school normalized name keys** are isolated in `cbeds_ambiguous_keys.csv` for adjudication.

Deliverables committed under `results/2024_25/`:

- `fns10_audit_summary.json` — full original meal counts and matching denominators.
- `fns10_all_site_link_candidates_2024_25.csv` — original and standardized names, candidate CDS and tier, breakfast/lunch volume, confidence diagnostics, and review status for every normalized pair.
- `fns10_unmatched_priority_250.csv` — 250 unmatched keys sorted by reported lunch volume; **not** a random or representative sample.
- `cbeds_ambiguous_keys.csv` — duplicate CBEDS candidate identity combinations.

**Not yet achieved:** authoritative determination of unmatched school/site identities. Sponsors sometimes represent non-district operators, charters, joint nutrition agencies or meal-service sites, so a unique school name does not automatically establish one-to-one program-site identity. A **CDE Nutrition Services site-ID-to-CDS crosswalk** would materially improve this work; manual verification and an accepted/rejected match ledger remain necessary. Do not calculate statewide kindergarten meal participation from schoolwide FNS10 claims.
