# Results

The files here are derived from CDE releases or district records. They are organized by school year, not by the date the files were added. The original source files are kept separately.

For the latest checked figures and known problems, see the [research status](../docs/current_status.md). The [data dictionary](../docs/data_dictionary.md) explains the main attendance fields.

## 2025–26 attendance estimates

The [statewide school file](2025_26/statewide_school_denominator_proxies.csv) contains Census Day enrollment and estimated attendance for schools with positive TK/K enrollment. Its school-level calculation is:

`estimated_tk_k_ada = tk_k_census_enrollment − tk_k_total_absence_days / 180`

This is an estimate of students attending per day, not observed average daily attendance (ADA). The raw file includes administrative placeholder school codes; filter those out when counting schools for analysis. The October 31 source check found 6,165 non-placeholder records with positive TK/K enrollment, of which 5,912 had enough information for this estimate. Missing or suppressed absence values are not zero.

The district files below use the same 2025–26 CDE sources. A `school_denominator_proxies` file has one row per school with TK/K enrollment. A `school_grade_proxies` file has separate TK, K, and grade 1 rows, but their absence totals were allocated from combined-grade CDE records. Those grade-level figures are sensitivity estimates, not recorded grade-level attendance.

| District | School file | Grade-level estimates |
| --- | --- | --- |
| Chino Valley Unified | [School](2025_26/chino_valley_unified_school_denominator_proxies.csv) | [Grades](2025_26/chino_valley_unified_school_grade_proxies.csv) |
| Davis Joint Unified | [School](2025_26/davis_joint_unified_school_denominator_proxies.csv) | [Grades](2025_26/davis_joint_unified_school_grade_proxies.csv) |
| Elk Grove Unified | [School](2025_26/elk_grove_unified_school_denominator_proxies.csv) | [Grades](2025_26/elk_grove_unified_school_grade_proxies.csv) |
| Irvine Unified | [School](2025_26/irvine_unified_school_denominator_proxies.csv) | [Grades](2025_26/irvine_unified_school_grade_proxies.csv) |
| Lodi Unified | [School](2025_26/lodi_unified_school_denominator_proxies.csv) | [Grades](2025_26/lodi_unified_school_grade_proxies.csv) |
| Oak Park Unified | [School](2025_26/oak_park_unified_school_denominator_proxies.csv) | [Grades](2025_26/oak_park_unified_school_grade_proxies.csv) |
| Ojai Unified | [School](2025_26/ojai_unified_school_denominator_proxies.csv) | [Grades](2025_26/ojai_unified_school_grade_proxies.csv) |
| Ontario-Montclair | [School](2025_26/ontario_montclair_school_denominator_proxies.csv) | [Grades](2025_26/ontario_montclair_school_grade_proxies.csv) |
| Ventura Unified | [School](2025_26/ventura_unified_school_denominator_proxies.csv) | [Grades](2025_26/ventura_unified_school_grade_proxies.csv) |

The Lodi school file contains the corrected 35-school source population (34 calculable estimates). An earlier 27-school extract was incomplete. See the [2025–26 methods and district notes](../docs/district_denominators_2025_26.md) for record counts, exclusions, and the differences between source and analysis populations.

For district coverage checks, start with [all-district quality summary](2025_26/all_district_quality_summary.csv), [district extract checks](2025_26/district_extract_quality_summary.csv), and [additional meal-district checks](2025_26/additional_meal_district_quality_summary.csv). These are audit/coverage tables, not meal participation rates.

### Ventura comparison

The [17-school Ventura comparison](2025_26/ventura_17_school_ada_validation.csv) pairs the CDE estimates with district-reported TK/K ADA. It is the relevant file for comparing estimated and observed attendance; the regular Ventura school file contains the CDE estimates alone. See the [Ventura notes](../docs/ventura_tkk_ada_validation_2026-10.md) and the later [October 31 source recheck](../docs/independent_research_integrity_audit_2026_10_31.md).

### District meal-file checks

These are for source review, not established school links or participation estimates:

- [Elk Grove school/CDS candidates](2025_26/elk_grove_unified_source_cds_candidates_review_only.csv), [Ontario-Montclair candidates](2025_26/ontario_montclair_source_cds_candidates_review_only.csv), and [Chino candidates](2025_26/chino_site_to_cds_candidates_review_only.csv).
- [Elk Grove and Ontario-Montclair review queue](2025_26/elk_ontario_review_queue_2026_10_31.csv) and [original-workbook audit summary](2025_26/elk_ontario_uploaded_workbook_source_audit_2026_10_31.json).
- [Ontario-Montclair monthly ADP consistency check](2025_26/ontario_adp_monthly_consistency_summary_review_only.csv).

The original district workbooks and internal meal-row handoffs are not in this repository. The [workbook review](../docs/elk_grove_ontario_montclair_new_sources_2026_10_31.md) explains the grade-code and reporting-period questions, including the unresolved Ontario-Montclair ADP issue.

## 2024–25 statewide meal claims

The FNS10 files summarize 2024–25 meal claims and possible links between meal-service sites and CDE schools. FNS10 counts meals, not individual students, and does not report kindergarten meals separately.

- [Site-match candidates](2024_25/fns10_all_site_link_candidates_2024_25.csv) — all normalized sponsor/site combinations and review status; matching names do not establish a confirmed site-to-CDS link.
- [Audit summary](2024_25/fns10_audit_summary.json) — claim totals and matching counts.
- [250 unmatched sites for review](2024_25/fns10_unmatched_priority_250.csv) — prioritized by lunch volume, not a representative sample.
- [Ambiguous CBEDS school names](2024_25/cbeds_ambiguous_keys.csv) — duplicate normalized keys that need separate review.

The [FNS10 matching notes](../docs/fns10_cde_linkage_review_2026_10.md) explain the two matching methods and why their reported totals differ. Do not combine 2024–25 statewide meal claims with 2025–26 attendance estimates to calculate a kindergarten participation rate.

## Reproducing the files

See [original data requirements](../data/README.md) for the exact CDE source filenames and [research code](../scripts/) for the 2025–26 processing steps. The [October 30 full-source run](../docs/verified_end_to_end_execution_2026_10_30.md) records the input versions and execution checks.
