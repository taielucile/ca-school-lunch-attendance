# Reading the 2025–26 results

This guide covers the current 2025–26 CSVs in [results](../results/README.md). The older [data dictionary](data_dictionary.md) mostly describes the original 2024–25 R analysis, so its column names should not be assumed to match these files.

## Which file do I need?

- [Statewide school file](../results/2025_26/statewide_school_denominator_proxies.csv): one record for each school-level CDE entry with positive TK/K Census enrollment, including records with missing attendance estimates.
- [District school files](../results/README.md#district-files): the same kind of combined TK/K estimate, restricted to one district.
- [District grade files](../results/README.md#district-files): separate TK, K, and grade 1 rows made by allocating broader grade-group absences. Use only when that additional assumption is appropriate.
- [Ventura comparison](../results/2025_26/ventura_17_school_ada_validation.csv): district-reported attendance alongside the public-data estimates for 17 matched schools.
- [School-count and missingness summaries](../results/README.md#coverage-and-source-checks): counts of usable records, not attendance rates.

## School-level files

The filenames end in `school_denominator_proxies.csv`. The key columns are:

| Column | Meaning |
| --- | --- |
| `school_year` | 2025–26 |
| `cds_code` | 14-digit County-District-School identifier. Keep it as text so leading zeroes are preserved. |
| `district_name`, `school_name` | Names from the CDE enrollment file |
| `tk_census_enrollment`, `k_census_enrollment` | Students enrolled on Census Day in each grade |
| `tk_k_census_enrollment` | Combined TK and K Census enrollment |
| `tk_k_eligible_cumulative_enrollment` | Students counted in the CDE's cumulative TK/K absence-reporting population; not the number attending each day |
| `tk_k_total_absence_days` | Combined TK/K days absent reported by CDE |
| `instructional_days_assumed` | 180 in these estimates; not verified for each school |
| `estimated_tk_k_ada` | Census TK/K enrollment minus combined absence days divided by 180: **estimated students attending per day** |
| `estimated_tk_k_cumulative_ada` | The alternative estimate using cumulative rather than Census enrollment |
| `estimated_tk_k_attended_days` | `estimated_tk_k_ada × 180`; calculated student-days, **not reported attended days** |
| `estimated_tk_ada_allocated`, `estimated_k_ada_allocated`, `estimated_grade1_ada_allocated` | Grade estimates using allocated absence totals, not observed grade-specific attendance |
| `flag_missing_tkk_estimate`, `flag_suppressed_tkk`, `estimator_status` | Whether the attendance estimate could be calculated and whether source absence values were suppressed |

A blank estimate is missing, not zero. The statewide file contains 6,261 school-level CDE records with positive TK/K enrollment; 96 have administrative placeholder school codes `0000000` or `0000001`. Excluding those leaves 6,165 records, of which 5,912 have a combined TK/K estimate. That is coverage of a calculation, not proof that the estimate is accurate.

## Grade-level files

Filenames end in `school_grade_proxies.csv`. Each row identifies a school, a grade (`TK`, `K`, or `01` for first grade), and Census enrollment. The key numeric field is `estimated_ada`, an estimate of the number attending per day in that grade.

The public CDE absence data report TK and K together, and grades 1–3 together. These files divide each group's absences across individual grades using Census enrollment shares. The `absence_group`, `proxy_method`, and `status` columns keep that assumption visible. `estimated_attended_student_days` is modeled by multiplying the daily estimate by 180; it is not a recorded annual count.

## Ventura

The [17-school file](../results/2025_26/ventura_17_school_ada_validation.csv) is different because it includes `observed_tkk_ada` from district records. That field is the district-reported average number of TK/K students attending per day for the matched school.

It also contains `p0_census` (Census enrollment), `p1_census_minus_absences` (Census-based estimate), and `p2_cumulative_minus_absences` (cumulative-based estimate). `p1_absolute_error`, `p2_absolute_error`, and `closer_proxy` compare these estimates with district-reported attendance. The comparison is for 17 matched Ventura schools, not for every school in the district or California.

## Before combining files

Check the school year, the 14-digit CDS identifier, grades, and dates covered. Most of these attendance estimates refer to a full school-year calculation. Some district meal files cover only a few days or months.

A *meal count* is the number of meals recorded or claimed. *Meal average daily participation (ADP)* is a meal-program measure. *Student average daily attendance (ADA)* is the average number of students attending per day. None of these is interchangeable with a count of individual students who ate a meal.

For the calculations and source checks, see the [2025–26 methods](district_denominators_2025_26.md) and [October 31 audit](independent_research_integrity_audit_2026_10_31.md).
