#!/usr/bin/env Rscript
# Source-only Ontario-Montclair consistency diagnostic (2025-26 workbook).
# Do not interpret meal quantity / reported ADP as observed service days without
# confirming how the district computed ADP and allocated STUDENTS EXITED.
args <- commandArgs(trailingOnly=TRUE)
if(length(args)!=2L)stop("Usage: Rscript scripts/diagnose_ontario_month_ADP_2526.R ORIGINAL.xlsx OUTPUT_DIR")
suppressPackageStartupMessages(library(readxl))
input <- normalizePath(args[[1]],mustWork=TRUE)
out <- args[[2]]
dir.create(out,recursive=TRUE,showWarnings=FALSE)
read_source <- function(sheet) {
 as.data.frame(read_excel(input,sheet=sheet,col_names=FALSE,
   col_types="text",.name_repair="minimal"),stringsAsFactors=FALSE)
}
number <- function(v){
 v <- as.character(v)
 v[is.na(v) | trimws(v)==""] <- NA_character_
 suppressWarnings(as.numeric(v))
}
meal <- read_source("Source meals")
summary_ada <- read_source("Source ADA ADP")
stopifnot(nrow(meal)==342,nrow(summary_ada)==98)
totals <- which(as.character(meal[[1]])=="TOTAL")
stopifnot(length(totals)==32)
months <- c("Aug","Sep","Oct","Nov","Dec","Jan","Feb","Mar","Apr","May")
years <- c(rep(2025,5),rep(2026,5))
nums <- c(8:12,1:5)
meal_types <- c("Breakfast","Lunch","Supper")
school_rows <- list()
for (j in seq_along(totals)){
 idx <- totals[[j]]
 first <- if (j==1L) 2L else totals[[j-1L]]+1L
 source_school <- as.character(meal[[1]][[first]])
 ada_start <- 3L+(j-1L)*3L
 stopifnot(identical(source_school,as.character(summary_ada[[1]][[ada_start]])))
 stopifnot(identical(as.character(summary_ada[[2]][[ada_start+2L]]),"ADP"))
 exit_idx <- which(as.character(meal[[1]])=="STUDENTS EXITED" &
                    seq_len(nrow(meal)) > first &
                    seq_len(nrow(meal)) < idx)
 if(length(exit_idx)!=1L)stop("Source missing STUDENTS EXITED: ",source_school)
 for(k in seq_along(months)){
  first_day <- as.Date(sprintf("%d-%02d-01",years[[k]],nums[[k]]))
  last_day <- seq(first_day,by="month",length.out=2)[2]-1
  dates <- seq(first_day,last_day,by="day")
  weekdays <- sum(!(as.POSIXlt(dates)$wday %in% c(0,6)))
  for(t in seq_along(meal_types)){
   mcol <- 2L+3L*(k-1L)+t-1L
   acol <- 3L+3L*(k-1L)+t-1L
   reported <- number(meal[idx,mcol]); exited <- number(meal[exit_idx,mcol])
   adp <- number(summary_ada[ada_start+2L,acol])
   if(any(is.na(c(reported,exited,adp))) || adp<=0)
      stop("Absent source value: ",source_school," / ",months[[k]]," / ",meal_types[[t]])
   grade_only <- reported-exited
   if(grade_only<0)stop("Negative grade-only figure")
   school_rows[[length(school_rows)+1L]] <- data.frame(
     school=source_school,year=years[[k]],month=months[[k]],
     meal_type=meal_types[[t]],calendar_weekdays=weekdays,
     source_total=reported,students_exited_category=exited,
     grade_attributed_quantity=grade_only,reported_ADP=adp,
     total_over_ADP=reported/adp,grade_only_over_ADP=grade_only/adp,
     stringsAsFactors=FALSE
   )
  }
 }
}
detail <- do.call(rbind,school_rows)
stopifnot(nrow(detail)==960L)
out_summary <- list()
for(k in seq_along(months)) for(t in meal_types){
 d <- detail[detail$year==years[[k]] & detail$month==months[[k]] &
             detail$meal_type==t,]
 stopifnot(nrow(d)==32L)
 wd <- unique(d$calendar_weekdays)
 out_summary[[length(out_summary)+1L]] <- data.frame(
  year=years[[k]],month=months[[k]],meal_type=t,n_school_months=nrow(d),
  weekday_calendar_max=wd,
  median_total_over_ADP=round(median(d$total_over_ADP),3),
  median_grade_only_over_ADP=round(median(d$grade_only_over_ADP),3),
  n_quotients_total_above_weekdays_plus_half=sum(d$total_over_ADP>wd+0.5),
  n_quotients_gradeonly_above_weekdays_plus_half=sum(d$grade_only_over_ADP>wd+0.5),
  max_total_over_ADP=round(max(d$total_over_ADP),3),
  max_grade_only_over_ADP=round(max(d$grade_only_over_ADP),3)
 )
}
summ <- do.call(rbind,out_summary)
nov <- summ[summ$year==2025 & summ$month=="Nov",]
stopifnot(nrow(nov)==3L,
  all(nov$weekday_calendar_max==20L),
  all(nov$n_quotients_gradeonly_above_weekdays_plus_half==32L),
  all(abs(nov$median_grade_only_over_ADP-26)<0.06))
write.csv(summ,file.path(out,"ontario_adp_monthly_consistency_summary.csv"),row.names=FALSE,na="")
write.csv(detail,file.path(out,"INTERNAL_ontario_school_month_ADP_diagnostic.csv"),row.names=FALSE,na="")
cat("Source diagnostic complete: 960 school-month-meal records and 30 month-type summaries.\n")
cat("November 2025: all 32 schools exhibit total/ADP and grade-only/ADP",
    "quotients near 26 despite only 20 weekdays.\n")
cat("Interpretation requires the district ADP denominator definition.\n")
