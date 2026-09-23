# Hard integrity checks and join diagnostics

stopifnot(exists("school_panel"))

if (any(school_panel$tk_k_total_absence_days < 0, na.rm = TRUE)) {
  stop("Negative TK/K absence days found.")
}

bad_abs_count <- with(
  school_panel,
  !is.na(tk_k_students_with_absence) &
    !is.na(tk_k_eligible_cumulative_enrollment) &
    tk_k_students_with_absence > tk_k_eligible_cumulative_enrollment
)
if (any(bad_abs_count)) {
  stop("Students with >=1 absence exceeds eligible cumulative enrollment.")
}

if (any(school_panel$tk_k_census_enrollment < 0, na.rm = TRUE)) {
  stop("Negative TK/K Census enrollment found.")
}

diagnostics <- data.frame(
  metric = c(
    "census_school_TA_rows",
    "unique_panel_schools",
    "schools_with_absenteeism_GRTKKN_row",
    "schools_with_cbeds_program_data",
    "schools_with_positive_TK_K_census",
    "positive_TK_K_schools_with_absenteeism_row",
    "positive_TK_K_schools_absenteeism_suppressed",
    "schools_with_positive_K_census",
    "K_enrollment_but_cbeds_none",
    "K_program_but_zero_census_K",
    "pseudo_entity_rows"
  ),
  value = c(
    nrow(enrollment_clean),
    nrow(school_panel),
    sum(school_panel$source_match_absenteeism),
    sum(school_panel$source_match_cbeds),
    sum(school_panel$tk_k_serving_census),
    sum(school_panel$tk_k_serving_census &
          school_panel$source_match_absenteeism),
    sum(school_panel$tk_k_serving_census &
          school_panel$tk_k_absenteeism_suppressed, na.rm = TRUE),
    sum(school_panel$k_serving_census),
    sum(school_panel$flag_k_enrollment_but_cbeds_none, na.rm = TRUE),
    sum(school_panel$flag_k_program_but_zero_census_k, na.rm = TRUE),
    sum(school_panel$flag_pseudo_entity)
  ),
  stringsAsFactors = FALSE
)

write.csv(diagnostics,
          file.path(DIAGNOSTIC_DIR, "join_diagnostics_2024_25.csv"),
          row.names = FALSE)

# Focus-district audit: distinguish suppression from missing rows.
focus_audit <- school_panel[
  (school_panel$county_code == IRVINE_COUNTY &
     school_panel$district_code == IRVINE_DISTRICT) |
  (school_panel$county_code == LODI_COUNTY &
     school_panel$district_code == LODI_DISTRICT),
  c("cds_code", "county_code", "district_code", "school_code", "school",
    "tk_census_enrollment", "k_census_enrollment",
    "tk_k_census_enrollment", "source_match_absenteeism",
    "tk_k_absenteeism_suppressed", "source_match_cbeds",
    "k_program", "tk_program", "flag_pseudo_entity")
]

write.csv(focus_audit,
          file.path(DIAGNOSTIC_DIR, "irvine_lodi_source_audit_2024_25.csv"),
          row.names = FALSE, na = "")
