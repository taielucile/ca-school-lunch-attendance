# 2024-25 Census Day enrollment: school-level total rows

read_tab_latin1 <- function(path) {
  read.delim(path, sep = "\t", header = TRUE, quote = "", comment.char = "",
             check.names = FALSE, fileEncoding = "latin1",
             na.strings = c("", "NA"), colClasses = "character")
}
num <- function(x) suppressWarnings(as.numeric(x))
pad_code <- function(x, width) {
  x <- trimws(as.character(x))
  x[is.na(x)] <- ""
  sprintf(paste0("%0", width, "d"), suppressWarnings(as.integer(x)))
}

enrollment_raw <- read_tab_latin1(FILES$enrollment)
enrollment <- enrollment_raw[
  enrollment_raw$AggregateLevel == "S" &
    enrollment_raw$ReportingCategory == "TA", ,
  drop = FALSE
]

if (nrow(enrollment) == 0) stop("No school-level TA Census enrollment rows found.")

enrollment$county_code <- pad_code(enrollment$CountyCode, 2)
enrollment$district_code <- pad_code(enrollment$DistrictCode, 5)
enrollment$school_code <- pad_code(enrollment$SchoolCode, 7)
enrollment$cds_code <- paste0(enrollment$county_code,
                              enrollment$district_code,
                              enrollment$school_code)

if (anyDuplicated(enrollment$cds_code)) {
  stop("Duplicate CDS codes among school-level TA Census rows.")
}

grade_cols <- c("GR_TK", "GR_KN", sprintf("GR_%02d", 1:12))
numeric_cols <- c("TOTAL_ENR", grade_cols)
for (v in numeric_cols) enrollment[[v]] <- num(enrollment[[v]])

grade_sum <- rowSums(enrollment[grade_cols], na.rm = TRUE)
bad_grade_sum <- !is.na(enrollment$TOTAL_ENR) & grade_sum != enrollment$TOTAL_ENR
if (any(bad_grade_sum)) {
  stop("At least one Census school has grade counts that do not sum to TOTAL_ENR.")
}

enrollment_clean <- data.frame(
  cds_code = enrollment$cds_code,
  county_code = enrollment$county_code,
  district_code = enrollment$district_code,
  school_code = enrollment$school_code,
  county = enrollment$CountyName,
  district = enrollment$DistrictName,
  school = enrollment$SchoolName,
  charter_census = enrollment$Charter,
  total_census_enrollment = enrollment$TOTAL_ENR,
  tk_census_enrollment = enrollment$GR_TK,
  k_census_enrollment = enrollment$GR_KN,
  stringsAsFactors = FALSE
)

for (g in 1:12) {
  enrollment_clean[[sprintf("gr%02d_census_enrollment", g)]] <-
    enrollment[[sprintf("GR_%02d", g)]]
}

enrollment_clean$tk_k_census_enrollment <-
  enrollment_clean$tk_census_enrollment + enrollment_clean$k_census_enrollment

write.csv(enrollment_clean,
          file.path(DERIVED_DIR, "census_school_enrollment_2024_25.csv"),
          row.names = FALSE, na = "")
