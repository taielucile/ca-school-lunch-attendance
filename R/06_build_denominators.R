# Alternative TK/K attendance denominator constructions
#
# These are assumption-dependent proxies. They are never labeled as observed
# expected or attended student-days.

stopifnot(exists("school_panel"))

denominator_panel <- school_panel

denominator_panel$proxy_attended_census_180 <-
  DAYS_PRIMARY * denominator_panel$tk_k_census_enrollment -
  denominator_panel$tk_k_total_absence_days

denominator_panel$proxy_attended_cumulative_180 <-
  DAYS_PRIMARY * denominator_panel$tk_k_eligible_cumulative_enrollment -
  denominator_panel$tk_k_total_absence_days

# Sensitivity construction only; no claim that true exposure is the midpoint.
denominator_panel$proxy_attended_midpoint_180 <-
  DAYS_PRIMARY *
  ((denominator_panel$tk_k_census_enrollment +
      denominator_panel$tk_k_eligible_cumulative_enrollment) / 2) -
  denominator_panel$tk_k_total_absence_days

# 175-day sensitivity benchmark.
denominator_panel$proxy_attended_census_175 <-
  DAYS_ALT * denominator_panel$tk_k_census_enrollment -
  denominator_panel$tk_k_total_absence_days

denominator_panel$proxy_attended_cumulative_175 <-
  DAYS_ALT * denominator_panel$tk_k_eligible_cumulative_enrollment -
  denominator_panel$tk_k_total_absence_days

denominator_panel$cumulative_vs_census_180_pct <- with(
  denominator_panel,
  100 * (proxy_attended_cumulative_180 / proxy_attended_census_180 - 1)
)

# Conditional lower-bound sensitivity using the public eligibility threshold:
# only meaningful for students represented in eligible cumulative enrollment,
# and still not an identified attendance denominator.
denominator_panel$conditional_lb_expected_31 <-
  31 * denominator_panel$tk_k_eligible_cumulative_enrollment
denominator_panel$conditional_lb_attended_31 <- pmax(
  0,
  denominator_panel$conditional_lb_expected_31 -
    denominator_panel$tk_k_total_absence_days
)

# Impossible negative proxies are flagged rather than silently truncated.
denominator_panel$flag_negative_census_180 <-
  denominator_panel$proxy_attended_census_180 < 0
denominator_panel$flag_negative_cumulative_180 <-
  denominator_panel$proxy_attended_cumulative_180 < 0

write.csv(
  denominator_panel,
  file.path(DERIVED_DIR, "school_denominator_sensitivity_2024_25.csv"),
  row.names = FALSE, na = ""
)
