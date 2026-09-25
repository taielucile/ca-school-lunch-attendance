# District-data validation: Irvine Unified, 2025-26
#
# Purpose:
# Compare 2025-26 CDE Census Day TK/K enrollment with observed Irvine
# district TK/K attendance for Nov. 3-7, 2025.
#
# This is a short-window validation of the Census enrollment stock against
# observed daily attendance. It is NOT validation of the annual 180-day
# denominator and should not be interpreted as such.

stopifnot(exists("FILES"))
stopifnot(file.exists(FILES$enrollment_2526))

# -------------------------------------------------------------------------
# 1. Read 2025-26 CDE Census Day enrollment
# -------------------------------------------------------------------------

enrollment_2526 <- read.delim(
  FILES$enrollment_2526,
  header = TRUE,
  sep = "\t",
  quote = "",
  comment.char = "",
  stringsAsFactors = FALSE,
  fileEncoding = "windows-1252",
  check.names = FALSE
)

required_census_cols <- c(
  "AcademicYear", "AggregateLevel",
  "CountyCode", "DistrictCode", "SchoolCode",
  "DistrictName", "SchoolName", "Charter",
  "ReportingCategory", "GR_TK", "GR_KN"
)

stopifnot(all(required_census_cols %in% names(enrollment_2526)))

# Standardize codes without converting school identifiers to numeric.
enrollment_2526$CountyCode <- sprintf(
  "%02d", as.integer(enrollment_2526$CountyCode)
)
enrollment_2526$DistrictCode <- sprintf(
  "%05d", as.integer(enrollment_2526$DistrictCode)
)
enrollment_2526$SchoolCode <- sprintf(
  "%07d", as.integer(enrollment_2526$SchoolCode)
)

irvine_census_2526 <- enrollment_2526[
  enrollment_2526$AggregateLevel == "S" &
    enrollment_2526$CountyCode == IRVINE_COUNTY &
    enrollment_2526$DistrictCode == IRVINE_DISTRICT &
    enrollment_2526$ReportingCategory == "TA",
  , drop = FALSE
]

irvine_census_2526$GR_TK <- as.numeric(irvine_census_2526$GR_TK)
irvine_census_2526$GR_KN <- as.numeric(irvine_census_2526$GR_KN)

stopifnot(
  nrow(irvine_census_2526) == 47,
  !anyDuplicated(irvine_census_2526$SchoolCode),
  !anyNA(irvine_census_2526$GR_TK),
  !anyNA(irvine_census_2526$GR_KN),
  sum(irvine_census_2526$GR_TK) == 1296,
  sum(irvine_census_2526$GR_KN) == 2022
)

irvine_census_2526$tk_k_census_2526 <-
  irvine_census_2526$GR_TK + irvine_census_2526$GR_KN

# -------------------------------------------------------------------------
# 2. Read observed Irvine attendance, Nov. 3-7, 2025
# -------------------------------------------------------------------------

irvine_attendance_file <- file.path(
  RAW_DIR,
  "irvine_k_pk_attendance_2025_11_03_07.csv"
)

stopifnot(file.exists(irvine_attendance_file))

irvine_attendance <- read.csv(
  irvine_attendance_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

attendance_cols <- paste0(
  "attendance_11_0",
  c(3, 4, 5, 6, 7)
)

stopifnot(
  nrow(irvine_attendance) == 58,
  sum(irvine_attendance$grade == "K") == 30,
  sum(irvine_attendance$grade == "PK_TK") == 28,
  !anyDuplicated(irvine_attendance[c("school", "grade")]),
  all(attendance_cols %in% names(irvine_attendance)),
  !anyNA(irvine_attendance[attendance_cols])
)

irvine_attendance$five_day_student_days <- rowSums(
  irvine_attendance[attendance_cols]
)

stopifnot(
  sum(
    irvine_attendance$five_day_student_days[
      irvine_attendance$grade == "K"
    ]
  ) == 8703,
  sum(
    irvine_attendance$five_day_student_days[
      irvine_attendance$grade == "PK_TK"
    ]
  ) == 5401
)

# -------------------------------------------------------------------------
# 3. Put K and PK/TK attendance on one school row
# -------------------------------------------------------------------------

k_att <- irvine_attendance[
  irvine_attendance$grade == "K",
  c("school", attendance_cols, "five_day_student_days"),
  drop = FALSE
]

names(k_att)[names(k_att) == "five_day_student_days"] <-
  "k_five_day_student_days"

names(k_att)[match(attendance_cols, names(k_att))] <-
  paste0("k_", attendance_cols)

pk_att <- irvine_attendance[
  irvine_attendance$grade == "PK_TK",
  c("school", attendance_cols, "five_day_student_days"),
  drop = FALSE
]

names(pk_att)[names(pk_att) == "five_day_student_days"] <-
  "tk_five_day_student_days"

names(pk_att)[match(attendance_cols, names(pk_att))] <-
  paste0("tk_", attendance_cols)

attendance_wide <- merge(
  k_att,
  pk_att,
  by = "school",
  all.x = TRUE,
  sort = FALSE
)

stopifnot(nrow(attendance_wide) == 30)

# -------------------------------------------------------------------------
# 4. Normalize district report names for exact Census matching
# -------------------------------------------------------------------------

attendance_wide$census_school_name <- attendance_wide$school

name_map <- c(
  "Alderwood Elementary" = "Alderwood Elementary",
  "Bonita Canyon Elementary" = "Bonita Canyon Elementary",
  "Brywood Elementary" = "Brywood Elementary",
  "College Park Elementary" = "College Park Elementary",
  "Culverdale Elementary" = "Culverdale Elementary",
  "Cypress Village Elementary" = "Cypress Village Elementary",
  "Deerfield Elementary" = "Deerfield Elementary",
  "Eastshore Elementary" = "Eastshore Elementary",
  "Eastwood Elementary" = "Eastwood Elementary",
  "Greentree Elementary" = "Greentree Elementary",
  "Loma Ridge Elementary" = "Loma Ridge Elementary",
  "Meadow Park Elementary" = "Meadow Park Elementary",
  "Northwood Elementary" = "Northwood Elementary",
  "Oak Creek Elementary" = "Oak Creek Elementary",
  "Canyon View Elementary" = "Canyon View Elementary",
  "Portola Springs Elementary" = "Portola Springs Elementary",
  "Santiago Hills Elementary" = "Santiago Hills Elementary",
  "Springbrook Elementary" = "Springbrook Elementary",
  "Stone Creek Elementary" = "Stone Creek Elementary",
  "Stonegate Elementary" = "Stonegate Elementary",
  "Turtle Rock Elementary" = "Turtle Rock Elementary",
  "University Park Elementary" = "University Park Elementary",
  "Westpark Elementary" = "Westpark Elementary",
  "Woodbury Elementary" = "Woodbury Elementary",
  "Plaza Vista School" = "Plaza Vista",
  "Solis Park K - 8" = "Solis Park",
  "Vista Verde K-8" = "Vista Verde",
  "Beacon Park K-8" = "Beacon Park",
  "Cadence Park K - 8" = "Cadence Park",
  "IUSD Virtual Academy Elementary" = "Irvine Unified School District Virtual Academy"
)

attendance_wide$census_school_name <- unname(
  name_map[attendance_wide$school]
)

stopifnot(!anyNA(attendance_wide$census_school_name))

# -------------------------------------------------------------------------
# 5. Join district attendance to same-year Census enrollment
# -------------------------------------------------------------------------

census_keep <- irvine_census_2526[
  ,
  c(
    "SchoolCode", "SchoolName", "Charter",
    "GR_TK", "GR_KN", "tk_k_census_2526"
  ),
  drop = FALSE
]

validation <- merge(
  attendance_wide,
  census_keep,
  by.x = "census_school_name",
  by.y = "SchoolName",
  all.x = TRUE,
  sort = FALSE
)

if (anyNA(validation$SchoolCode)) {
  stop(
    "Unmatched Irvine attendance school(s): ",
    paste(
      validation$school[is.na(validation$SchoolCode)],
      collapse = "; "
    )
  )
}

stopifnot(
  nrow(validation) == 30,
  !anyDuplicated(validation$SchoolCode)
)

# -------------------------------------------------------------------------
# 6. Reconcile missing PK/TK attendance rows
# -------------------------------------------------------------------------

validation$tk_attendance_reported <-
  !is.na(validation$tk_five_day_student_days)

validation$tk_zero_census_and_not_reported <-
  !validation$tk_attendance_reported &
  validation$GR_TK == 0

validation$tk_missing_unresolved <-
  !validation$tk_attendance_reported &
  validation$GR_TK > 0

# Missing PK/TK attendance is treated as zero ONLY where same-year Census
# reports zero TK enrollment. Any school with positive Census TK and no
# district TK attendance row remains unresolved and causes the build to stop.

if (any(validation$tk_missing_unresolved)) {
  stop(
    "Positive Census TK enrollment but no district PK/TK attendance row: ",
    paste(
      validation$school[validation$tk_missing_unresolved],
      collapse = "; "
    )
  )
}

validation$tk_five_day_student_days_reconciled <-
  validation$tk_five_day_student_days

validation$tk_five_day_student_days_reconciled[
  validation$tk_zero_census_and_not_reported
] <- 0

# -------------------------------------------------------------------------
# 7. Construct observed five-day TK+K attendance benchmark
# -------------------------------------------------------------------------

validation$observed_tk_k_five_day_student_days <-
  validation$k_five_day_student_days +
  validation$tk_five_day_student_days_reconciled

validation$mean_daily_tk_k_attendance <-
  validation$observed_tk_k_five_day_student_days / 5

validation$attendance_to_census_ratio <-
  validation$mean_daily_tk_k_attendance /
  validation$tk_k_census_2526

validation$census_minus_mean_daily_attendance <-
  validation$tk_k_census_2526 -
  validation$mean_daily_tk_k_attendance

validation$pct_below_census <-
  100 * (
    1 -
      validation$mean_daily_tk_k_attendance /
      validation$tk_k_census_2526
  )

# -------------------------------------------------------------------------
# 8. Output school-level validation table
# -------------------------------------------------------------------------

validation_out <- data.frame(
  cds_code_14char = paste0(
    IRVINE_COUNTY,
    IRVINE_DISTRICT,
    validation$SchoolCode
  ),
  district_report_school = validation$school,
  census_school = validation$census_school_name,
  charter = validation$Charter,
  census_tk_2025_26 = validation$GR_TK,
  census_k_2025_26 = validation$GR_KN,
  census_tk_k_2025_26 = validation$tk_k_census_2526,
  observed_k_five_day_student_days =
    validation$k_five_day_student_days,
  observed_tk_five_day_student_days =
    validation$tk_five_day_student_days_reconciled,
  tk_attendance_reported =
    validation$tk_attendance_reported,
  tk_zero_census_and_not_reported =
    validation$tk_zero_census_and_not_reported,
  observed_tk_k_five_day_student_days =
    validation$observed_tk_k_five_day_student_days,
  mean_daily_tk_k_attendance =
    validation$mean_daily_tk_k_attendance,
  attendance_to_census_ratio =
    validation$attendance_to_census_ratio,
  census_minus_mean_daily_attendance =
    validation$census_minus_mean_daily_attendance,
  pct_below_census =
    validation$pct_below_census,
  stringsAsFactors = FALSE
)

validation_out <- validation_out[
  order(validation_out$district_report_school),
  , drop = FALSE
]

stopifnot(
  nrow(validation_out) == 30,
  all(nchar(validation_out$cds_code_14char) == 14),
  !anyDuplicated(validation_out$cds_code_14char),
  sum(validation_out$tk_zero_census_and_not_reported) == 2,
  !anyNA(validation_out$observed_tk_k_five_day_student_days)
)

write.csv(
  validation_out,
  file.path(
    TABLE_DIR,
    "irvine_census_vs_observed_attendance_2025_26.csv"
  ),
  row.names = FALSE,
  na = ""
)

# -------------------------------------------------------------------------
# 9. Aggregate descriptive summary
# -------------------------------------------------------------------------

irvine_validation_summary <- data.frame(
  schools = nrow(validation_out),
  census_tk = sum(validation_out$census_tk_2025_26),
  census_k = sum(validation_out$census_k_2025_26),
  census_tk_k = sum(validation_out$census_tk_k_2025_26),
  observed_k_five_day_student_days =
    sum(validation_out$observed_k_five_day_student_days),
  observed_tk_five_day_student_days =
    sum(validation_out$observed_tk_five_day_student_days),
  observed_tk_k_five_day_student_days =
    sum(validation_out$observed_tk_k_five_day_student_days),
  mean_daily_tk_k_attendance =
    sum(validation_out$observed_tk_k_five_day_student_days) / 5,
  aggregate_attendance_to_census_ratio =
    (sum(validation_out$observed_tk_k_five_day_student_days) / 5) /
    sum(validation_out$census_tk_k_2025_26),
  median_school_attendance_to_census_ratio =
    median(validation_out$attendance_to_census_ratio),
  stringsAsFactors = FALSE
)

write.csv(
  irvine_validation_summary,
  file.path(
    TABLE_DIR,
    "irvine_census_vs_observed_attendance_summary_2025_26.csv"
  ),
  row.names = FALSE,
  na = ""
)

message("Irvine 2025-26 Census vs observed attendance validation:")
print(irvine_validation_summary)

message(
  "Interpretation caution: observed attendance covers Nov. 3-7, 2025 only; ",
  "the Census comparison does not validate an annual 180-day denominator."
)
