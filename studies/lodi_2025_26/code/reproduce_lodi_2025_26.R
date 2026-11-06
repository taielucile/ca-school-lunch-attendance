#!/usr/bin/env Rscript
# Feed California Kinders — Lodi K meal/attendance review, 2025–26
# Standalone, base-R analysis; readxl only needed for --meal-xlsx.
# Run from any directory: Rscript studies/lodi_2025_26/code/reproduce_lodi_2025_26.R
# Optional: Rscript reproduce_lodi_2025_26.R --meal-xlsx='/path/to/Lodi Data_copy.xlsx'
# Invariant: K meals must be matched to K-only allocated ADA, not TK+K ADA.

args <- commandArgs(trailingOnly = TRUE)
file_arg <- grep('^--meal-xlsx=', args, value = TRUE)
out_arg <- grep('^--output-dir=', args, value = TRUE)
source_xlsx <- if (length(file_arg)) sub('^--meal-xlsx=', '', file_arg[1]) else NULL
script_dir <- dirname(normalizePath(sub('^--file=', '', grep('^--file=', commandArgs(), value = TRUE)[1])))
base_dir <- dirname(script_dir)
input_dir <- file.path(base_dir, 'inputs')
output_dir <- if (length(out_arg)) sub('^--output-dir=', '', out_arg[1]) else file.path(base_dir, 'outputs')
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

read_char_csv <- function(file) {
  read.csv(file, stringsAsFactors = FALSE, check.names = FALSE,
           colClasses = 'character', na.strings = c('', 'NA'))
}
canonical_name <- function(x) {
  x <- tolower(gsub('[.-]', ' ', x))
  x <- sub(' elementary school$', '', x)
  x <- sub(' elementary$', '', x)
  trimws(gsub('[[:space:]]+', ' ', x))
}
stop_unique <- function(names, source) {
  bad <- names[duplicated(names)]
  if (length(bad)) stop('Duplicate school(s) in ', source, ': ', paste(bad, collapse = ', '))
}

meals <- read_char_csv(file.path(input_dir, 'lodi_meals_extracted_2025_26.csv'))
if (!is.null(source_xlsx)) {
  if (!requireNamespace('readxl', quietly = TRUE))
    stop('Install readxl to read the original source: install.packages("readxl")')
  if (!file.exists(source_xlsx)) stop('Source workbook not found: ', source_xlsx)
  bk <- as.data.frame(readxl::read_excel(source_xlsx, sheet = 1))
  lu <- as.data.frame(readxl::read_excel(source_xlsx, sheet = 2))
  bk <- bk[!is.na(bk$School) & !bk$School %in% c('Grand Total', 'ADP by Grade'), ]
  lu <- lu[!is.na(lu$School) & !lu$School %in% c('Grand Total', 'ADP by Grade'), ]
  if (nrow(bk) != 31L || nrow(lu) != 31L ||
      anyDuplicated(bk$School) || anyDuplicated(lu$School) ||
      !setequal(bk$School, lu$School))
    stop('Original meal workbook school coverage changed; inspect before joining.')
  # The named source totals must reconcile to all school rows, not only
  # to one another. Abort rather than publish an incomplete extraction.
  source_totals <- function(sheet) {
    row <- sheet[sheet$School == 'Grand Total', , drop=FALSE]
    if (nrow(row) != 1L) stop('Expected one source Grand Total row.')
    as.numeric(row$Kindergarten)
  }
  raw_bk <- as.data.frame(readxl::read_excel(source_xlsx, sheet=1))
  raw_lu <- as.data.frame(readxl::read_excel(source_xlsx, sheet=2))
  if (sum(as.numeric(bk$Kindergarten)) != source_totals(raw_bk) ||
      sum(as.numeric(lu$Kindergarten)) != source_totals(raw_lu))
    stop('Workbook kindergarten school rows do not reconcile to printed Grand Total.')
  meals <- data.frame(source_school = bk$School,
                      breakfast_k = bk$Kindergarten,
                      lunch_k = lu$Kindergarten[match(bk$School, lu$School)],
                      breakfast_preschool = bk$Preschool,
                      lunch_preschool = lu$Preschool[match(bk$School, lu$School)],
                      stringsAsFactors = FALSE)
}
state <- read_char_csv(file.path(input_dir, 'lodi_state_proxy_snapshot_2025_26.csv'))
elig <- read_char_csv(file.path(input_dir, 'lodi_eligibility_31_schools_source_snapshot.csv'))

stopifnot(nrow(meals) == 31L, nrow(elig) == 31L, nrow(state) == 35L)
meals$key <- canonical_name(meals$source_school)
state$key <- canonical_name(state$school_name)
elig$key <- canonical_name(elig$school)
stop_unique(meals$key, 'meal workbook')
stop_unique(state$key, 'state school extract')
stop_unique(elig$key, 'eligibility report')
if (!setequal(meals$key, elig$key)) stop('Meal and eligibility school lists differ.')
if (!all(meals$key %in% state$key))
  stop('Meal school(s) unmatched to state proxy: ',
       paste(meals$source_school[!meals$key %in% state$key], collapse=', '))
if (length(setdiff(state$key, meals$key)) != 4L)
  stop('Expected four non-meal state schools; coverage changed.')

matched <- state[match(meals$key, state$key), , drop = FALSE]
N <- nrow(meals)
as_num <- function(x) suppressWarnings(as.numeric(x))
k_enrolled <- as_num(matched$k_census_enrollment)
tk_enrolled <- as_num(matched$tk_census_enrollment)
combined_absences <- as_num(matched$tk_k_total_absence_days)
assumed_days <- as_num(matched$instructional_days_assumed)
k_ada <- as_num(matched$estimated_k_ada_allocated)
if (anyNA(k_enrolled) || anyNA(tk_enrolled) || anyNA(combined_absences) ||
    anyNA(assumed_days) || anyNA(k_ada) || any(k_ada <= 0))
  stop('Missing or invalid K denominators in matched schools.')
if (!all(assumed_days == 180)) stop('Days assumption changed; review first.')
# Replicate the model: allocate TK+K absence days in proportion to Census enrollment.
replicated_ada <- k_enrolled - (combined_absences / assumed_days) *
                  (k_enrolled / (k_enrolled + tk_enrolled))
if (any(abs(replicated_ada-k_ada)>1e-7)) stop('K ADA proxy fails source formula check.')

b <- as_num(meals$breakfast_k)
l <- as_num(meals$lunch_k)
if (anyNA(b) || anyNA(l) || any(b<0) || any(l<0))
  stop('Invalid K meal counts in workbook.')
attended <- k_ada * assumed_days
review <- data.frame(
  source_school=meals$source_school, cde_school=matched$school_name,
  cds_code=matched$cds_code, tk_census=as.integer(tk_enrolled),
  k_census=as.integer(k_enrolled), tk_k_absence_days=as.integer(combined_absences),
  assumed_days=as.integer(assumed_days), estimated_k_ada=round(k_ada,9),
  estimated_k_attended_days=round(attended,7),
  k_breakfast_meals=as.integer(b), k_lunch_meals=as.integer(l),
  breakfast_per_100_attended_days=round(100*b/attended,5),
  lunch_per_100_attended_days=round(100*l/attended,5),
  preschool_breakfast_meals=meals$breakfast_preschool,
  preschool_lunch_meals=meals$lunch_preschool,
  stringsAsFactors=FALSE
)
write.csv(review, file.path(output_dir, 'lodi_31_school_k_meal_attendance_review.csv'), row.names=FALSE, na='')

coverage <- data.frame(
  cde_school=state$school_name, cds_code=state$cds_code,
  meal_workbook=ifelse(state$key %in% meals$key, 'yes', 'no'),
  attendance_proxy_available=ifelse(state$flag_missing_tkk_estimate=='yes', 'no', 'yes'),
  reason=ifelse(state$key %in% meals$key,'matched',
                ifelse(state$flag_missing_tkk_estimate=='yes','suppressed absence data','not in meal workbook'))
)
write.csv(coverage, file.path(output_dir,'lodi_coverage_audit.csv'),row.names=FALSE)

summary <- data.frame(
  school_count=N, k_census_sum=sum(k_enrolled),
  estimated_k_ada_sum=sum(k_ada), estimated_k_attended_days=sum(attended),
  k_breakfast_meals=sum(b), k_lunch_meals=sum(l),
  breakfasts_per_100_attended_days=100*sum(b)/sum(attended),
  lunches_per_100_attended_days=100*sum(l)/sum(attended)
)
write.csv(summary,file.path(output_dir,'lodi_k_summary_2025_26.csv'),row.names=FALSE)
# Known audited-source invariants apply to both the snapshot and the XLSX route.
# Do not silently accept a modified workbook without reviewing its provenance.
stopifnot(sum(b)==70667, sum(l)==203639)
stopifnot(sum(k_enrolled)==1763, sum(tk_enrolled)==853)
stopifnot(abs(sum(attended)-287174.3372854)<1e-4)
stopifnot(abs(100*sum(b)/sum(attended)-24.607700210262735)<1e-7)
stopifnot(abs(100*sum(l)/sum(attended)-70.91128055694587)<1e-7)

# Figure design and reporting are handled separately; this script produces analysis-ready tables.
cat('OK: ', N,' matched schools; K breakfasts=',sum(b), ', lunches=',sum(l),
    '; K attended-days=',round(sum(attended)), '\n',sep='')