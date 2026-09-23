# 2024-25 Absenteeism by Reason: school-level TK-K band

if (!exists("read_tab_latin1")) stop("Run R/01_clean_enrollment.R first.")

absenteeism_raw <- read_tab_latin1(FILES$absenteeism)
absenteeism <- absenteeism_raw[
  absenteeism_raw[["Aggregate Level"]] == "S" &
    absenteeism_raw[["Reporting Category"]] == "GRTKKN", ,
  drop = FALSE
]

if (nrow(absenteeism) == 0) stop("No school-level GRTKKN absenteeism rows found.")

absenteeism$county_code <- pad_code(absenteeism[["County Code"]], 2)
absenteeism$district_code <- pad_code(absenteeism[["District Code"]], 5)
absenteeism$school_code <- pad_code(absenteeism[["School Code"]], 7)
absenteeism$cds_code <- paste0(absenteeism$county_code,
                               absenteeism$district_code,
                               absenteeism$school_code)

if (anyDuplicated(absenteeism$cds_code)) {
  stop("Duplicate CDS codes among school-level GRTKKN absenteeism rows.")
}

metric_cols <- c(
  "Eligible Cumulative Enrollment",
  "Count of Students with One or More Absences",
  "Average Days Absent",
  "Total Days Absent"
)

# Preserve suppression as an explicit flag before numeric parsing.
suppressed <- apply(absenteeism[metric_cols], 1, function(z) {
  any(trimws(z) == "*", na.rm = TRUE)
})

absenteeism_clean <- data.frame(
  cds_code = absenteeism$cds_code,
  absenteeism_row_present = TRUE,
  tk_k_absenteeism_suppressed = suppressed,
  tk_k_eligible_cumulative_enrollment =
    num(absenteeism[["Eligible Cumulative Enrollment"]]),
  tk_k_students_with_absence =
    num(absenteeism[["Count of Students with One or More Absences"]]),
  tk_k_average_days_absent =
    num(absenteeism[["Average Days Absent"]]),
  tk_k_total_absence_days =
    num(absenteeism[["Total Days Absent"]]),
  stringsAsFactors = FALSE
)

write.csv(absenteeism_clean,
          file.path(DERIVED_DIR, "absenteeism_tkk_school_2024_25.csv"),
          row.names = FALSE, na = "")
