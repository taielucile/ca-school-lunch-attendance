# Irvine and Lodi comparison requested by PI

stopifnot(exists("denominator_panel"))

focus <- denominator_panel |>
  dplyr::filter(
    (county_code == IRVINE_COUNTY & district_code == IRVINE_DISTRICT) |
    (county_code == LODI_COUNTY & district_code == LODI_DISTRICT)
  ) |>
  dplyr::mutate(
    district_focus = dplyr::case_when(
      district_code == IRVINE_DISTRICT ~ "Irvine Unified",
      district_code == LODI_DISTRICT ~ "Lodi Unified",
      TRUE ~ NA_character_
    )
  ) |>
  dplyr::filter(tk_k_census_enrollment > 0)

readr::write_csv(
  focus,
  file.path(TABLE_DIR, "irvine_lodi_denominator_comparison_2024_25.csv")
)

focus_summary <- focus |>
  dplyr::filter(
    !is.na(tk_k_total_absence_days),
    !is.na(tk_k_eligible_cumulative_enrollment)
  ) |>
  dplyr::group_by(district_focus) |>
  dplyr::summarise(
    schools_usable = dplyr::n(),
    census_tk_k = sum(tk_k_census_enrollment),
    eligible_cumulative_tk_k = sum(tk_k_eligible_cumulative_enrollment),
    total_absence_days = sum(tk_k_total_absence_days),
    denom_census_180 = sum(denom_census_180),
    denom_cumulative_180 = sum(denom_cumulative_180),
    denom_midpoint_180 = sum(denom_midpoint_180),
    cumulative_vs_census_pct =
      100 * (denom_cumulative_180 / denom_census_180 - 1),
    median_school_difference_pct =
      median(cumulative_vs_census_pct, na.rm = TRUE),
    .groups = "drop"
  )

readr::write_csv(
  focus_summary,
  file.path(TABLE_DIR, "irvine_lodi_denominator_summary_2024_25.csv")
)
