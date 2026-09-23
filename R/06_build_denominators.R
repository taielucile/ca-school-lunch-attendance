# Alternative TK/K attendance denominator constructions
#
# IMPORTANT:
# These are assumption-dependent proxies, not observed student-days attended.

stopifnot(exists("school_panel"))

denominator_panel <- school_panel |>
  dplyr::mutate(
    denom_census_180 =
      180 * tk_k_census_enrollment - tk_k_total_absence_days,
    denom_cumulative_180 =
      180 * tk_k_eligible_cumulative_enrollment - tk_k_total_absence_days,
    denom_midpoint_180 =
      180 * ((tk_k_census_enrollment + tk_k_eligible_cumulative_enrollment) / 2) -
      tk_k_total_absence_days,
    cumulative_to_census_ratio =
      tk_k_eligible_cumulative_enrollment / tk_k_census_enrollment,
    cumulative_vs_census_pct =
      100 * (denom_cumulative_180 / denom_census_180 - 1)
  )

readr::write_csv(
  denominator_panel,
  file.path(DERIVED_DIR, "school_denominator_sensitivity_2024_25.csv")
)
