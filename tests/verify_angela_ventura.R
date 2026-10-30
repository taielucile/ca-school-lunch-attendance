# Integration test: run Angela's original 2025-26 Ventura R files without modification.
args <- commandArgs(trailingOnly=TRUE)
stopifnot(length(args)==3L)
team_root <- normalizePath(args[[1]],mustWork=TRUE)
long_path <- normalizePath(args[[2]],mustWork=TRUE)
output_dir <- args[[3]]
dir.create(output_dir,recursive=TRUE,showWarnings=FALSE)
output_dir <- normalizePath(output_dir)
setwd(team_root)
suppressPackageStartupMessages({
 library(readxl);library(dplyr);library(stringr);library(purrr);library(here);library(ggplot2)
})
attendance_script <- file.path(team_root,"Ventura Unified","Ventura attendance analysis_copy.R")
meal_script <- file.path(team_root,"Ventura Unified","Ventura meal analysis_copy.R")
final_script <- file.path(team_root,"Ventura Unified","Ventura final analysis_copy.R")
stopifnot(file.exists(attendance_script),file.exists(meal_script),file.exists(final_script))
source(attendance_script,local=FALSE)
source(meal_script,local=FALSE)
stopifnot(all(c("school_name","grade","attendance") %in% names(ADA_clean)),
          all(c("school_name","grade","Breakfast","Lunch") %in% names(ventura_meal)))
# Execute the original final analysis, suppressing interactive plotting without modifying output figures.
pdf(file.path(output_dir,"original_ventura_integration_plots.pdf"))
tryCatch(source(final_script,local=FALSE),finally=dev.off())
stopifnot(exists("ventura_analysis"),nrow(ventura_analysis)>0L)
ref <- read.csv(file.path(team_root,"analysis/2026-10-25/tables/independent_benchmark_checks.csv"),
                colClasses=c(cds="character"),stringsAsFactors=FALSE)
ref <- ref[ref$group=="TK+K" & ref$field=="obs_ada" & startsWith(ref$cds,"5672652"),
           c("cds","school")]
stopifnot(nrow(ref)==17L,!anyDuplicated(ref$cds),!anyDuplicated(ref$school))
long <- read.csv(long_path,colClasses=c(cds_code="character",county_code="character",
                district_code="character"),stringsAsFactors=FALSE,na.strings=c("","NA"))
long <- long[long$cds_code %in% ref$cds,]
long$school_name <- ref$school[match(long$cds_code,ref$cds)]
long$grade <- ifelse(long$grade=="01","1",long$grade)
stopifnot(all(!is.na(long$school_name)),!anyDuplicated(long[c("school_name","grade")]))
bridge <- merge(long[c("cds_code","school_name","grade","estimated_ada","proxy_method","status")],
                ADA_clean[c("school_name","grade","attendance")],
                by=c("school_name","grade"),all.x=TRUE,sort=FALSE)
bridge <- merge(bridge,ventura_meal[c("school_name","grade","Breakfast","Lunch")],
                by=c("school_name","grade"),all.x=TRUE,sort=FALSE)
stopifnot(nrow(bridge)==nrow(long),!anyDuplicated(bridge[c("cds_code","grade")]))
actual_coverage <- sum(!is.na(bridge$attendance))
meal_coverage <- sum(!is.na(bridge$Breakfast)|!is.na(bridge$Lunch))
if(actual_coverage==0L) stop("No proxy school-grade rows matched Angela's extracted attendance")
original_script <- paste(readLines(final_script,warn=FALSE),collapse="\n")
old_178 <- grepl("school_days\\s*<-\\s*178",original_script)
half_day_assumed <- grepl('grade %in% c\\("TK", "K"\\)',original_script)
summary <- data.frame(metric=c("original_ada_rows","original_meal_rows",
 "original_join_rows","aligned_proxy_grade_rows","rows_matching_original_ada",
 "rows_matching_meal_numerator","archived_school_cds_count",
 "original_script_uses_178_days","original_script_assumes_all_TK_K_half_day",
 "model_denominator_import_requires_grade_01_to_1_and_cds_to_name"),
 value=as.character(c(nrow(ADA_clean),nrow(ventura_meal),nrow(ventura_analysis),
 nrow(bridge),actual_coverage,meal_coverage,nrow(ref),old_178,half_day_assumed,TRUE)))
write.csv(bridge,file.path(output_dir,"ventura_angela_bridge_proxies_not_measured.csv"),row.names=FALSE,na="")
write.csv(summary,file.path(output_dir,"angela_integration_summary.csv"),row.names=FALSE)
print(summary,row.names=FALSE)
