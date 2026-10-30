# 2025-26 CDE school-level TK/K denominator extracts
# Standalone base-R module. No grade-specific TK or K ADA is inferred from GRTKKN.
# Usage:
# Rscript R/11_district_denominator_extracts_2526.R data/raw/cdenroll2526.txt data/raw/absenteeismreason26.txt output/district_denominators
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3L) stop("Usage: Rscript R/11_district_denominator_extracts_2526.R ENROLLMENT_TSV ABSENCE_TSV OUTPUT_DIR")
enroll_path <- args[1]; absence_path <- args[2]; out_dir <- args[3]
if (!file.exists(enroll_path) || !file.exists(absence_path)) stop("Missing input file(s); see docs/district_denominators_2025_26.md")
read_cde <- function(path) read.delim(path, sep="\t", header=TRUE, check.names=FALSE,
  quote="", comment.char="", colClasses="character", fileEncoding="latin1", na.strings=c("", "NA"))
required <- function(df, names, source) {
  missing <- setdiff(names, names(df))
  if (length(missing)) stop(source, " missing columns: ", paste(missing, collapse=", "))
}
numeric_metric <- function(x) {
  x <- trimws(as.character(x))
  suppressWarnings(as.numeric(gsub(",", "", x, fixed=TRUE)))
}
cds <- function(df, county, district, school) {
  codes <- list(df[[county]], df[[district]], df[[school]])
  widths <- c(2L,5L,7L)
  pieces <- Map(function(x,w) {
    x <- trimws(as.character(x))
    bad <- is.na(x) | !grepl("^[0-9]+$", x) | nchar(x)>w
    y <- ifelse(bad, NA_character_, sprintf(paste0("%0",w,"d"), as.integer(x)))
    y
  }, codes, widths)
  do.call(paste0, pieces)
}
e <- read_cde(enroll_path); a <- read_cde(absence_path)
required(e, c("AggregateLevel","ReportingCategory","CountyCode","DistrictCode","SchoolCode",
 "CountyName","DistrictName","SchoolName","GR_TK","GR_KN"), "Enrollment")
required(a, c("Aggregate Level","Reporting Category","County Code","District Code","School Code",
 "Total Days Absent","Eligible Cumulative Enrollment"), "Absenteeism")
e <- e[e$AggregateLevel=="S" & e$ReportingCategory=="TA",,drop=FALSE]
a <- a[a[["Aggregate Level"]]=="S" & a[["Reporting Category"]]=="GRTKKN",,drop=FALSE]
if (!nrow(e) || !nrow(a)) stop("Missing school-level TA enrollment or GRTKKN absence rows")
e$cds_code <- cds(e,"CountyCode","DistrictCode","SchoolCode")
a$cds_code <- cds(a,"County Code","District Code","School Code")
if (anyNA(e$cds_code) || anyNA(a$cds_code) ||
    anyDuplicated(e$cds_code) || anyDuplicated(a$cds_code))
  stop("Invalid or duplicate CDS identifiers; inspect source before joining")
e$tk <- numeric_metric(e$GR_TK); e$k <- numeric_metric(e$GR_KN)
a$absent <- numeric_metric(a[["Total Days Absent"]])
a$cumulative <- numeric_metric(a[["Eligible Cumulative Enrollment"]])
a$suppressed <- trimws(a[["Total Days Absent"]])=="*" |
  trimws(a[["Eligible Cumulative Enrollment"]])=="*"
# Retain all Census schools; no silently dropped unmatched schools.
idx <- match(e$cds_code, a$cds_code)
out <- data.frame(
 school_year="2025-26", cds_code=e$cds_code,
 county_code=sprintf("%02d",as.integer(e$CountyCode)),
 district_code=sprintf("%05d",as.integer(e$DistrictCode)),
 school_code=sprintf("%07d",as.integer(e$SchoolCode)),
 county=e$CountyName, district=e$DistrictName, school=e$SchoolName,
 grade_band="TK_K_COMBINED", tk_census_enrollment=e$tk,
 k_census_enrollment=e$k, tk_k_census_enrollment=e$tk+e$k,
 tk_k_eligible_cumulative_enrollment=a$cumulative[idx],
 tk_k_absence_days=a$absent[idx],
 absence_row_matched=!is.na(idx),
 absence_suppressed=ifelse(is.na(idx),NA,a$suppressed[idx]),
 instructional_days_assumed=180L,
 stringsAsFactors=FALSE)
out$estimated_tk_k_ada <- out$tk_k_census_enrollment -
  out$tk_k_absence_days/out$instructional_days_assumed
out$flag_negative_estimate <- !is.na(out$estimated_tk_k_ada) & out$estimated_tk_k_ada<0
out$flag_above_census <- !is.na(out$estimated_tk_k_ada) &
  out$estimated_tk_k_ada>out$tk_k_census_enrollment
out$flag_missing_inputs <- is.na(out$estimated_tk_k_ada)
if (!dir.exists(out_dir)) dir.create(out_dir, recursive=TRUE)
write.csv(out, file.path(out_dir,"statewide_school_tkk_ada_proxy_2025_26.csv"),row.names=FALSE,na="")
districts <- unique(out[c("county_code","district_code","district")])
for (i in seq_len(nrow(districts))) {
  subset <- out[out$county_code==districts$county_code[i] &
                out$district_code==districts$district_code[i],,drop=FALSE]
  file <- paste0("district_",districts$county_code[i],"_",districts$district_code[i],"_tkk_2025_26.csv")
  write.csv(subset,file.path(out_dir,file),row.names=FALSE,na="")
}
qc <- data.frame(metric=c("census_schools","matched_absence_rows","missing_proxy",
                           "negative_proxy","proxy_above_census","districts"),
 value=c(nrow(out),sum(out$absence_row_matched),sum(out$flag_missing_inputs),
         sum(out$flag_negative_estimate),sum(out$flag_above_census),nrow(districts)))
write.csv(qc,file.path(out_dir,"quality_summary_2025_26.csv"),row.names=FALSE)
message("Wrote ",nrow(out)," school rows across ",nrow(districts)," districts. Review quality_summary_2025_26.csv")
