# R/09_lodi_enrollment_triangulation.R
#
# Purpose:
# Audit Lodi 2025-26 Kindergarten Highest Eligible / Last Day measures
# against same-year CDE Census Day Kindergarten enrollment.
#
# The Lodi source is a meal-program eligibility report filtered to
# Kindergarten and the 7/29/2025-5/29/2026 eligibility date range.
# "Last Day" is defined in the source as the number of enrolled students
# on the last day of the selected date range.
#
# IMPORTANT:
# These measures are useful for source triangulation but do NOT identify
# annual expected or attended student-days. Highest Eligible and Last Day
# are identical at every reported school, so they are not independent
# observations. This module must not be used to select an annual
# denominator construction.

library(dplyr)
library(readr)
library(stringr)

lodi_district_file <- file.path(
  RAW_DIR,
  "lodi_kindergarten_enrollment_measures_2025_26.csv"
)

stopifnot(file.exists(lodi_district_file))
stopifnot(file.exists(FILES$enrollment_2526))

# ---------------------------------------------------------------------
# District-provided Kindergarten enrollment measures
# ---------------------------------------------------------------------

lodi_k_district <- read_csv(
  lodi_district_file,
  show_col_types = FALSE
) |>
  mutate(
    kindergarten_highest_eligible =
      as.numeric(kindergarten_highest_eligible),
    kindergarten_last_day =
      as.numeric(kindergarten_last_day)
  )

stopifnot(nrow(lodi_k_district) == 31L)
stopifnot(n_distinct(lodi_k_district$school) == 31L)
stopifnot(!anyNA(lodi_k_district$kindergarten_highest_eligible))
stopifnot(!anyNA(lodi_k_district$kindergarten_last_day))
stopifnot(
  sum(lodi_k_district$kindergarten_highest_eligible) == 3481
)
stopifnot(
  sum(lodi_k_district$kindergarten_last_day) == 3481
)
stopifnot(
  all(
    lodi_k_district$kindergarten_highest_eligible ==
      lodi_k_district$kindergarten_last_day
  )
)

# Highest Eligible and Last Day are identical in all 31 reported schools.
# Preserve both source variables. For descriptive comparison only, use
# Highest Eligible as the report-side quantity; do not treat it as an
# independently validated enrollment denominator.
lodi_k_district <- lodi_k_district |>
  mutate(
    lodi_report_k_highest_eligible = kindergarten_highest_eligible
  )

# ---------------------------------------------------------------------
# 2025-26 CDE Census Day enrollment: true school-level TA rows only
# ---------------------------------------------------------------------

cde_2526 <- read_delim(
  FILES$enrollment_2526,
  delim = "\t",
  locale = locale(encoding = "Windows-1252"),
  show_col_types = FALSE,
  trim_ws = TRUE
)

lodi_cde_k <- cde_2526 |>
  filter(
    AggregateLevel == "S",
    CountyCode == LODI_COUNTY,
    DistrictCode == LODI_DISTRICT,
    ReportingCategory == "TA",
    !is.na(SchoolCode)
  ) |>
  transmute(
    cds_code_14char = paste0(CountyCode, DistrictCode, SchoolCode),
    cde_school = SchoolName,
    charter = Charter,
    cde_k_census = as.numeric(GR_KN),
    cde_tk_census = as.numeric(GR_TK)
  )

stopifnot(!anyDuplicated(lodi_cde_k$cds_code_14char))

# ---------------------------------------------------------------------
# Explicit district-report -> CDE school-name reconciliation
# ---------------------------------------------------------------------

name_map <- tibble::tribble(
  ~school, ~cde_school,
  "Ansel Adams Elementary School", "Ansel Adams",
  "Beckman Elementary School", "Beckman Elementary",
  "Clairmont Elementary School", "Clairmont Elementary",
  "Clyde W. Needham Elementary School", "Clyde W. Needham Elementary",
  "Creekside Elementary School", "Creekside Elementary",
  "Davis Elementary School", "Davis Elementary",
  "Ellerth E. Larson Elementary School", "Ellerth E. Larson Elementary",
  "Erma B. Reese Elementary School", "Erma B. Reese Elementary",
  "George Lincoln Mosher Elementary School", "George Lincoln Mosher",
  "George Washington Elementary School", "George Washington Elementary",
  "Heritage Elementary School", "Heritage Elementary",
  "Joe Serna Jr. Charter Elementary School", "Joe Serna Jr. Charter",
  "John Muir Elementary School", "John Muir Elementary",
  "Julia Morgan Elementary School", "Julia Morgan Elementary",
  "Lakewood Elementary School", "Lakewood Elementary",
  "Lawrence Elementary School", "Lawrence Elementary",
  "Leroy Nichols Elementary School", "Leroy Nichols Elementary",
  "Live Oak Elementary School", "Live Oak Elementary",
  "Lockeford Elementary", "Lockeford Elementary",
  "Lois E. Borchardt Elementary School", "Lois E. Borchardt Elementary",
  "Manlio Silva Elementary School", "Manlio Silva Elementary",
  "Oakwood Elementary", "Oakwood Elementary",
  "Parklane Elementary", "Parklane Elementary",
  "Podesta Ranch Elementary School", "Podesta Ranch Elementary",
  "Sutherland Elementary School", "Sutherland Elementary",
  "Valley Robotics Academy", "Valley Robotics Academy",
  "Victor Elementary School", "Victor Elementary",
  "Vinewood Elementary School", "Vinewood Elementary",
  "Wagner Holt Elementary School", "Wagner-Holt Elementary",
  "Westwood Elementary School", "Westwood Elementary",
  "Woodbridge Elementary School", "Woodbridge"
)

stopifnot(nrow(name_map) == 31L)
stopifnot(!anyDuplicated(name_map$school))
stopifnot(!anyDuplicated(name_map$cde_school))

lodi_k_validation <- lodi_k_district |>
  left_join(name_map, by = "school") |>
  left_join(lodi_cde_k, by = "cde_school")

stopifnot(nrow(lodi_k_validation) == 31L)
stopifnot(!anyNA(lodi_k_validation$cde_school))
stopifnot(!anyNA(lodi_k_validation$cds_code_14char))
stopifnot(!anyNA(lodi_k_validation$cde_k_census))
stopifnot(n_distinct(lodi_k_validation$cds_code_14char) == 31L)

# ---------------------------------------------------------------------
# Comparison
# ---------------------------------------------------------------------

lodi_k_validation <- lodi_k_validation |>
  mutate(
    district_minus_cde_k =
      lodi_report_k_highest_eligible - cde_k_census,

    district_vs_cde_k_ratio =
      if_else(
        cde_k_census > 0,
        lodi_report_k_highest_eligible / cde_k_census,
        NA_real_
      ),

    district_vs_cde_k_pct_difference =
      if_else(
        cde_k_census > 0,
        100 * (lodi_report_k_highest_eligible - cde_k_census) / cde_k_census,
        NA_real_
      )
  ) |>
  arrange(cde_school)

lodi_k_summary <- lodi_k_validation |>
  summarise(
    schools = n(),
    district_highest_eligible_total =
      sum(kindergarten_highest_eligible),
    district_last_day_total =
      sum(kindergarten_last_day),
    cde_k_census_total =
      sum(cde_k_census),
    district_minus_cde_k_total =
      sum(lodi_report_k_highest_eligible) - sum(cde_k_census),
    aggregate_district_to_cde_ratio =
      sum(lodi_report_k_highest_eligible) / sum(cde_k_census),
    aggregate_pct_difference =
      100 * (
        sum(lodi_report_k_highest_eligible) - sum(cde_k_census)
      ) / sum(cde_k_census),
    median_school_ratio =
      median(district_vs_cde_k_ratio, na.rm = TRUE),
    median_school_pct_difference =
      median(district_vs_cde_k_pct_difference, na.rm = TRUE)
  )

# ---------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------

write_csv(
  lodi_k_validation,
  file.path(
    TABLE_DIR,
    "lodi_k_census_vs_district_enrollment_2025_26.csv"
  ),
  na = ""
)

write_csv(
  lodi_k_summary,
  file.path(
    TABLE_DIR,
    "lodi_k_census_vs_district_enrollment_summary_2025_26.csv"
  ),
  na = ""
)

cat("\nLodi 2025-26 Kindergarten enrollment triangulation:\n")
print(lodi_k_summary)

cat(
  "\nInterpretation: the Lodi source is a Kindergarten-filtered ",
  "meal-program eligibility report covering 7/29/2025-5/29/2026. ",
  "Highest Eligible and Last Day are identical at all 31 reported ",
  "schools. The report-side quantity is therefore retained as useful ",
  "source-triangulation evidence, but not as an independently validated ",
  "annual attendance denominator. It does not identify student-specific ",
  "expected attendance days and does not adjudicate between the Census ",
  "and cumulative-enrollment annual proxy constructions.\n",
  sep = ""
)
