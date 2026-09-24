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

# Clean school-level handoff file for comparison with Irvine/Lodi district data.
# Keep one row per focus school, including suppressed/unusable rows so that the
# district comparison can distinguish missing public cells from true zeros.
school_handoff <- data.frame(
  cds_code = focus$cds_code,
  district = focus$district_focus,
  school = focus$school,
  charter = focus$charter_census,
  census_tk = focus$tk_census_enrollment,
  census_k = focus$k_census_enrollment,
  census_tk_k = focus$tk_k_census_enrollment,
  eligible_cumulative_tk_k = focus$tk_k_eligible_cumulative_enrollment,
  total_absence_days_tk_k = focus$tk_k_total_absence_days,
  proxy_attended_census_180 = focus$proxy_attended_census_180,
  proxy_attended_cumulative_180 = focus$proxy_attended_cumulative_180,
  proxy_attended_midpoint_180 = focus$proxy_attended_midpoint_180,
  cumulative_minus_census_student_days =
    focus$proxy_attended_cumulative_180 - focus$proxy_attended_census_180,
  cumulative_vs_census_pct = focus$cumulative_vs_census_180_pct,
  k_program = focus$k_program,
  tk_program = focus$tk_program,
  absenteeism_suppressed = focus$tk_k_absenteeism_suppressed,
  usable_public_denominator =
    !is.na(focus$tk_k_total_absence_days) &
    !is.na(focus$tk_k_eligible_cumulative_enrollment),
  notes = ifelse(
    focus$school == "Rio Valley Charter",
    "Homeschool/independent-study model; interpret campus meal access separately.",
    ""
  ),
  stringsAsFactors = FALSE
)

school_handoff <- school_handoff[
  order(school_handoff$district, school_handoff$school),
  , drop = FALSE
]

write.csv(
  school_handoff,
  file.path(TABLE_DIR, "irvine_lodi_tk_k_attendance_denominators_2024_25.csv"),
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


# Sample-composition sensitivity: charter calendars/program models may differ.
summarise_sample <- function(dat, sample_label) {
  dat <- dat[
    !is.na(dat$tk_k_total_absence_days) &
      !is.na(dat$tk_k_eligible_cumulative_enrollment),
    , drop = FALSE
  ]
  ds <- unique(dat$district_focus)
  do.call(rbind, lapply(ds, function(d) {
    g <- dat[dat$district_focus == d, , drop = FALSE]
    A <- sum(g$proxy_attended_census_180)
    B <- sum(g$proxy_attended_cumulative_180)
    data.frame(
      sample = sample_label,
      district = d,
      schools_usable = nrow(g),
      census_tk_k = sum(g$tk_k_census_enrollment),
      eligible_cumulative_tk_k = sum(g$tk_k_eligible_cumulative_enrollment),
      total_absence_days = sum(g$tk_k_total_absence_days),
      proxy_attended_census_180 = A,
      proxy_attended_cumulative_180 = B,
      cumulative_vs_census_pct = 100 * (B / A - 1),
      stringsAsFactors = FALSE
    )
  }))
}

sample_sensitivity <- rbind(
  summarise_sample(focus, "all focus schools"),
  summarise_sample(focus[focus$charter_census == "N", , drop = FALSE],
                   "non-charter schools only")
)
sample_sensitivity <- sample_sensitivity[
  order(sample_sensitivity$district, sample_sensitivity$sample), ]

write.csv(
  sample_sensitivity,
  file.path(TABLE_DIR, "irvine_lodi_sample_sensitivity_2024_25.csv"),
  row.names = FALSE, na = ""
)
