# Irvine and Lodi comparison requested by PI

stopifnot(exists("denominator_panel"))

focus <- denominator_panel[
  ((denominator_panel$county_code == IRVINE_COUNTY &
      denominator_panel$district_code == IRVINE_DISTRICT) |
   (denominator_panel$county_code == LODI_COUNTY &
      denominator_panel$district_code == LODI_DISTRICT)) &
    !denominator_panel$flag_pseudo_entity &
    denominator_panel$tk_k_census_enrollment > 0,
  , drop = FALSE
]

focus$district_focus <- ifelse(
  focus$district_code == IRVINE_DISTRICT,
  "Irvine Unified",
  "Lodi Unified"
)

write.csv(
  focus,
  file.path(TABLE_DIR, "irvine_lodi_denominator_comparison_2024_25.csv"),
  row.names = FALSE, na = ""
)

usable <- focus[
  !is.na(focus$tk_k_total_absence_days) &
    !is.na(focus$tk_k_eligible_cumulative_enrollment),
  , drop = FALSE
]

districts <- unique(usable$district_focus)
summary_rows <- lapply(districts, function(d) {
  g <- usable[usable$district_focus == d, , drop = FALSE]
  A <- sum(g$proxy_attended_census_180)
  B <- sum(g$proxy_attended_cumulative_180)
  C <- sum(g$proxy_attended_midpoint_180)

  data.frame(
    district = d,
    schools_with_positive_tk_k =
      sum(focus$district_focus == d),
    schools_usable = nrow(g),
    census_tk_k = sum(g$tk_k_census_enrollment),
    eligible_cumulative_tk_k =
      sum(g$tk_k_eligible_cumulative_enrollment),
    total_absence_days = sum(g$tk_k_total_absence_days),
    proxy_attended_census_180 = A,
    proxy_attended_cumulative_180 = B,
    proxy_attended_midpoint_180 = C,
    cumulative_vs_census_pct = 100 * (B / A - 1),
    median_school_difference_pct =
      median(g$cumulative_vs_census_180_pct, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
})

focus_summary <- do.call(rbind, summary_rows)
focus_summary <- focus_summary[order(focus_summary$district), ]

write.csv(
  focus_summary,
  file.path(TABLE_DIR, "irvine_lodi_denominator_summary_2024_25.csv"),
  row.names = FALSE, na = ""
)

# Largest school-level sensitivity differences for memo review.
school_sensitivity <- usable[
  order(usable$cumulative_vs_census_180_pct, decreasing = TRUE),
  c("district_focus", "cds_code", "school",
    "tk_k_census_enrollment", "tk_k_eligible_cumulative_enrollment",
    "tk_k_total_absence_days",
    "proxy_attended_census_180", "proxy_attended_cumulative_180",
    "cumulative_vs_census_180_pct",
    "k_program", "tk_program")
]

write.csv(
  school_sensitivity,
  file.path(TABLE_DIR, "irvine_lodi_school_sensitivity_ranked_2024_25.csv"),
  row.names = FALSE, na = ""
)

message("Irvine/Lodi summary:")
print(focus_summary)
