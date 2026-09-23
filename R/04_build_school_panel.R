# Build school-level observed-data backbone using Census enrollment as the universe

stopifnot(exists("enrollment_clean"),
          exists("absenteeism_clean"),
          exists("cbeds_clean"))

school_panel <- merge(enrollment_clean, absenteeism_clean,
                      by = "cds_code", all.x = TRUE, sort = FALSE)
school_panel <- merge(school_panel, cbeds_clean,
                      by = "cds_code", all.x = TRUE, sort = FALSE)

if (nrow(school_panel) != nrow(enrollment_clean)) {
  stop("Left joins changed the number of Census school rows.")
}
if (anyDuplicated(school_panel$cds_code)) {
  stop("School panel contains duplicate CDS codes after joins.")
}

school_panel$source_match_census <- TRUE
school_panel$source_match_absenteeism <-
  !is.na(school_panel$absenteeism_row_present)
school_panel$source_match_cbeds <-
  !is.na(school_panel$k_program) | !is.na(school_panel$tk_program)

# Aggregate/pseudo-entity school codes are retained but explicitly flagged.
school_panel$flag_pseudo_entity <-
  school_panel$school_code %in% c("0000000", "0000001")

school_panel$tk_k_serving_census <-
  !is.na(school_panel$tk_k_census_enrollment) &
  school_panel$tk_k_census_enrollment > 0

school_panel$k_serving_census <-
  !is.na(school_panel$k_census_enrollment) &
  school_panel$k_census_enrollment > 0

school_panel$cumulative_to_census_ratio_tkk <- ifelse(
  school_panel$tk_k_census_enrollment > 0,
  school_panel$tk_k_eligible_cumulative_enrollment /
    school_panel$tk_k_census_enrollment,
  NA_real_
)

school_panel$flag_k_enrollment_but_cbeds_none <-
  school_panel$k_serving_census &
  !is.na(school_panel$k_program) &
  school_panel$k_program == "None"

school_panel$flag_k_program_but_zero_census_k <-
  !is.na(school_panel$k_program) &
  school_panel$k_program != "None" &
  !is.na(school_panel$k_census_enrollment) &
  school_panel$k_census_enrollment == 0

# Identification flags: these remain FALSE because public files do not directly
# provide school x TK/K expected or attended student-days.
school_panel$tk_k_expected_student_days_publicly_identified <- FALSE
school_panel$tk_k_attended_student_days_publicly_identified <- FALSE

write.csv(school_panel,
          file.path(DERIVED_DIR, "school_attendance_backbone_2024_25.csv"),
          row.names = FALSE, na = "")
