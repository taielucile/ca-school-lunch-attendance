# Data dictionary

This dictionary covers variables used mainly in the original 2024–25 R workflow. For the newer 2025–26 statewide and district CSVs, see the [2025–26 file guide](reading_2025_26_files.md); those outputs use different column names.

The definitions below distinguish source variables from calculated values and assumptions.

| Variable | Type | Meaning |
|---|---|---|
| cds_code | identifier | 14-digit County-District-School code |
| county_code | identifier | 2-digit county code |
| district_code | identifier | 5-digit district code |
| school_code | identifier | 7-digit school code |
| tk_census_enrollment | observed | TK enrollment in the Census Day enrollment file |
| k_census_enrollment | observed | Kindergarten enrollment in the Census Day enrollment file |
| tk_k_census_enrollment | derived from observed | Sum of Census Day TK and K enrollment |
| tk_k_eligible_cumulative_enrollment | observed aggregate | Eligible cumulative enrollment in the public TK–K absenteeism band; may be suppressed |
| tk_k_students_with_absence | observed aggregate | Students with at least one absence in the public TK–K band; may be suppressed |
| tk_k_average_days_absent | observed aggregate | Average days absent in the public TK–K band; may be suppressed |
| tk_k_total_absence_days | observed aggregate | Total absence days in the public TK–K band; may be suppressed |
| tk_k_absenteeism_suppressed | derived flag | At least one core public absenteeism metric is suppressed with an asterisk |
| k_program | observed CBEDS classification | Full-day, Part-day, Both full and part day, None, or missing |
| tk_program | observed CBEDS classification | Full-day, Part-day, Both full and part day, None, or missing |
| school_start_date | observed CBEDS field | Reported calendar start date; not an instructional-day count |
| school_end_date | observed CBEDS field | Reported calendar end date; not an instructional-day count |
| source_match_absenteeism | derived flag | School has a TK–K absenteeism row, including rows whose values are suppressed |
| source_match_cbeds | derived flag | School has a usable K or TK CBEDS program classification |
| flag_pseudo_entity | derived flag | School code is 0000000 or 0000001; retained for audit but excluded from focus analysis |
| cumulative_to_census_ratio_tkk | derived diagnostic | Eligible cumulative TK–K enrollment divided by Census Day TK–K enrollment |
| proxy_attended_census_180 | assumption-dependent proxy | 180 × Census TK–K enrollment − observed absence days |
| proxy_attended_cumulative_180 | assumption-dependent proxy | 180 × eligible cumulative TK–K enrollment − observed absence days |
| proxy_attended_midpoint_180 | sensitivity only | 180 × mean(Census, cumulative enrollment) − observed absence days |
| proxy_attended_census_175 | sensitivity only | 175 × Census TK–K enrollment − observed absence days |
| proxy_attended_cumulative_175 | sensitivity only | 175 × cumulative TK–K enrollment − observed absence days |
| conditional_lb_expected_31 | conditional sensitivity | 31 × eligible cumulative enrollment, using the eligibility threshold |
| conditional_lb_attended_31 | conditional sensitivity | max(0, 31 × eligible cumulative enrollment − absence days) |

## Variables intentionally not created as observed measures

The project does **not** create a variable named simply `expected_student_days` or `attended_student_days` from the public files because those quantities are not directly identified at the required school × TK/K level.

Every assumption-dependent denominator includes `proxy`, `sensitivity`, or `conditional` in its interpretation.
