# Find a result

The links below open the actual files, not just the folders they sit in. CSV files can be viewed on GitHub or downloaded for use in a spreadsheet. CDE refers to the California Department of Education. For column definitions, see [how to read the 2025–26 files](../docs/reading_2025_26_files.md).

## The files people are most likely to need

| Question | File | What it tells you |
| --- | --- | --- |
| What are the estimated TK/K attendance figures across California? | [2025–26 statewide school estimates](2025_26/statewide_school_denominator_proxies.csv) | Census enrollment and calculated attendance for schools with TK/K enrollment |
| How do those estimates compare with district attendance? | [Ventura: 17 schools](2025_26/ventura_17_school_ada_validation.csv) | Estimated and district-reported TK/K average daily attendance (ADA) |
| Which schools have enough data for an estimate? | [School counts by district](2025_26/all_district_quality_summary.csv) | How many CDE school records have usable TK/K estimates |
| Where are the 2024–25 meal-claim matching results? | [FNS10 school-name candidates](2024_25/fns10_all_site_link_candidates_2024_25.csv) | Possible links between meal-service sites and CDE schools; not confirmed links |
| What is the latest checked interpretation? | [Research status](../docs/current_status.md) | Corrections, source checks, and questions still open as of October 31, 2026 |

For a particular district, use the next table. The [October 31 source audit](../docs/independent_research_integrity_audit_2026_10_31.md) explains which results were checked against original files.

## District files

These nine districts have two types of files from the 2025–26 CDE attendance data:

- **Combined TK/K** gives one row per school with the combined enrollment and attendance estimate. This is the simpler file to start with.
- **Separate TK, K, and grade 1** gives grade rows calculated by dividing group absence totals in proportion to enrollment. These are modeled figures, not recorded attendance for each grade.

| District | Combined TK/K by school | Separate grade estimates |
| --- | --- | --- |
| Chino Valley Unified | [Open CSV](2025_26/chino_valley_unified_school_denominator_proxies.csv) | [Open CSV](2025_26/chino_valley_unified_school_grade_proxies.csv) |
| Davis Joint Unified | [Open CSV](2025_26/davis_joint_unified_school_denominator_proxies.csv) | [Open CSV](2025_26/davis_joint_unified_school_grade_proxies.csv) |
| Elk Grove Unified | [Open CSV](2025_26/elk_grove_unified_school_denominator_proxies.csv) | [Open CSV](2025_26/elk_grove_unified_school_grade_proxies.csv) |
| Irvine Unified | [Open CSV](2025_26/irvine_unified_school_denominator_proxies.csv) | [Open CSV](2025_26/irvine_unified_school_grade_proxies.csv) |
| Lodi Unified | [Open CSV](2025_26/lodi_unified_school_denominator_proxies.csv) | [Open CSV](2025_26/lodi_unified_school_grade_proxies.csv) |
| Oak Park Unified | [Open CSV](2025_26/oak_park_unified_school_denominator_proxies.csv) | [Open CSV](2025_26/oak_park_unified_school_grade_proxies.csv) |
| Ojai Unified | [Open CSV](2025_26/ojai_unified_school_denominator_proxies.csv) | [Open CSV](2025_26/ojai_unified_school_grade_proxies.csv) |
| Ontario-Montclair | [Open CSV](2025_26/ontario_montclair_school_denominator_proxies.csv) | [Open CSV](2025_26/ontario_montclair_school_grade_proxies.csv) |
| Ventura Unified | [Open CSV](2025_26/ventura_unified_school_denominator_proxies.csv) | [Open CSV](2025_26/ventura_unified_school_grade_proxies.csv) |

The Lodi file is the corrected version with 35 TK/K-serving school records (34 calculable estimates). The earlier 27-school version omitted eight schools.

The statewide school file contains 6,261 CDE records with positive TK/K Census enrollment. Excluding 96 administrative placeholder codes leaves 6,165, of which 5,912 have a calculable estimate. The calculation assumes 180 instructional days; the public absence file combines TK and K. These are not observed attended days. See [field definitions and exclusions](../docs/reading_2025_26_files.md).

## Coverage and source checks

These help answer whether a file is complete enough to use, rather than whether an attendance estimate is accurate:

- [All-district school counts and missing estimates](2025_26/all_district_quality_summary.csv)
- [Selected district extract counts](2025_26/district_extract_quality_summary.csv)
- [Chino, Davis, and Oak Park source checks](2025_26/additional_meal_district_quality_summary.csv)

For the underlying methods and the original sources, see [2025–26 district notes](../docs/district_denominators_2025_26.md) and the [source-file guide](../data/README.md).

## Ventura: reported versus estimated attendance

Use the [17-school Ventura comparison CSV](2025_26/ventura_17_school_ada_validation.csv), not the regular Ventura school estimate file, to examine the difference between district-reported attendance and the two estimates. The [Ventura notes](../docs/ventura_tkk_ada_validation_2026-10.md) explain the comparison; the [October 31 audit](../docs/independent_research_integrity_audit_2026_10_31.md) records the subsequent check against the original district workbook.

## District meal-file reviews

These files record outstanding questions about school identities and meal-file definitions. They are not finished participation estimates.

- **School-name candidates:** [Elk Grove](2025_26/elk_grove_unified_source_cds_candidates_review_only.csv), [Ontario-Montclair](2025_26/ontario_montclair_source_cds_candidates_review_only.csv), [Chino](2025_26/chino_site_to_cds_candidates_review_only.csv).
- **Workbook checks:** [Elk Grove/Ontario review queue](2025_26/elk_ontario_review_queue_2026_10_31.csv), [audit summary](2025_26/elk_ontario_uploaded_workbook_source_audit_2026_10_31.json), [Ontario-Montclair monthly meal ADP check](2025_26/ontario_adp_monthly_consistency_summary_review_only.csv).

The original district workbooks and internal school-grade meal rows are not stored here. See the [district workbook notes](../docs/elk_grove_ontario_montclair_new_sources_2026_10_31.md) for the unresolved grade-code, school-matching, and date questions.

## 2024–25 statewide meal claims

FNS10 contains breakfast and lunch claims by meal-service site, not a separate kindergarten meal count or the number of students served.

- [All site-name matching candidates](2024_25/fns10_all_site_link_candidates_2024_25.csv) — names and review status for each normalized sponsor/site pair.
- [Claim totals and matching summary](2024_25/fns10_audit_summary.json) — source counts and the matching method's results.
- [250 unmatched pairs prioritized by lunch volume](2024_25/fns10_unmatched_priority_250.csv) — review list, not a random sample.
- [Ambiguous CDE school-name keys](2024_25/cbeds_ambiguous_keys.csv) — cases that cannot be settled by normalized names alone.

The [FNS10 method notes](../docs/fns10_cde_linkage_review_2026_10.md) explain why two matching methods produced different totals. None of these name matches should be treated as a verified school identity without further review.

## Using these files together

The 2024–25 FNS10 claims and 2025–26 attendance estimates are from different school years. They cannot be divided to obtain a kindergarten meal participation rate. Even within the same year, the meal and attendance records must cover the same school, grade, and dates.

To rerun the attendance extracts, see [source files and commands](../data/README.md). The [October 30 execution record](../docs/verified_end_to_end_execution_2026_10_30.md) gives the original source versions used in the verified run.
