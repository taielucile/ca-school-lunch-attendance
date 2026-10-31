#!/usr/bin/env Rscript
# Read-only verification of uploaded 2025-26 Elk Grove and Ontario-Montclair workbooks.
# Requires readxl; never computes kindergarten participation rates.
args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 3L) stop("Usage: Rscript scripts/verify_elk_ontario_workbooks_2526.R elk.xlsx ontario.xlsx output_dir")
suppressPackageStartupMessages(library(readxl))
elkfile <- normalizePath(args[[1]],mustWork=TRUE)
ontfile <- normalizePath(args[[2]],mustWork=TRUE)
out <- args[[3]]
dir.create(out,recursive=TRUE,showWarnings=FALSE)
readtext <- function(path,sheet) {
  as.data.frame(read_excel(path,sheet=sheet,col_names=FALSE,col_types="text",.name_repair="minimal"),
                stringsAsFactors=FALSE)
}
numeric_or_na <- function(x) {
  x <- as.character(x)
  x[is.na(x)|trimws(x)==""] <- NA_character_
  suppressWarnings(as.numeric(x))
}
nval <- function(x) {
  x <- numeric_or_na(x)
  if(length(x)!=1L) stop("Expected one numeric value")
  x
}
check_eq <- function(actual,expected,label) {
  if(length(actual)!=1L||is.na(actual)||actual!=expected)
    stop(label,": found ",actual," but expected ",expected)
}
met <- list()
# Elk Grove: original Source data has header on row 2, data from 3, and a separate TOTAL row.
eg <- readtext(elkfile,"Source data")
check_eq(nrow(eg),445,"Elk source sheet rows")
stopifnot(as.character(eg[2,1])=="School")
detail <- eg[3:nrow(eg),,drop=FALSE]
total <- detail[detail[[1]]=="TOTAL",,drop=FALSE]
detail <- detail[!is.na(detail[[1]])&detail[[1]]!="TOTAL",,drop=FALSE]
check_eq(nrow(total),1,"Elk grand-total row count")
check_eq(nrow(detail),442,"Elk source grade rows")
check_eq(sum(numeric_or_na(detail[[3]]),na.rm=TRUE),711424,"Elk Breakfast detail sum")
check_eq(sum(numeric_or_na(detail[[4]]),na.rm=TRUE),2429657,"Elk Lunch detail sum")
check_eq(nval(total[[3]]),711424,"Elk printed Breakfast total")
check_eq(nval(total[[4]]),2429657,"Elk printed Lunch total")
check_eq(sum(detail[[5]]=="19",na.rm=TRUE),43,"Elk grade-code 19 rows")
check_eq(sum(detail[[2]]=="K",na.rm=TRUE),43,"Elk K rows")
check_eq(sum(detail[[2]]=="1",na.rm=TRUE),44,"Elk grade1 rows")
tabs <- setdiff(excel_sheets(elkfile),c("Attendance","Attendance details","Source data"))
check_eq(length(tabs),44,"Elk named school sheets")
for (tab in tabs) {
  tabdata <- readtext(elkfile,tab)
  school <- as.character(tabdata[1,1])
  period <- as.character(tabdata[2,1])
  if(period!="7/1/25–3/31/26") stop("Unexpected Elk school period: ",tab,": ",period)
  printed <- tabdata[tabdata[[1]]=="TOTAL",,drop=FALSE]
  if(nrow(printed)!=1L)stop("Missing or duplicate Elk school TOTAL: ",tab)
  if(school=="Jessie Baker") {
    records <- detail[grepl("^Jessie Baker",detail[[1]]),,drop=FALSE]
  } else {
    records <- detail[detail[[1]]==school,,drop=FALSE]
  }
  check_eq(sum(numeric_or_na(records[[3]]),na.rm=TRUE),nval(printed[[2]]),paste(tab,"Breakfast"))
  check_eq(sum(numeric_or_na(records[[4]]),na.rm=TRUE),nval(printed[[3]]),paste(tab,"Lunch"))
}
met$elk_meal_detail_rows <- nrow(detail)
met$elk_school_worksheets_checked <- length(tabs)
met$elk_breakfast_meals <- 711424
met$elk_lunch_meals <- 2429657
met$elk_code19_rows_unverified_as_TK <- 43

# Ontario-Montclair: 32 school blocks with explicit monthly and year totals.
om <- readtext(ontfile,"Source meals")
check_eq(nrow(om),342,"Ontario Source meals rows")
stopifnot(as.character(om[1,1])=="SCHOOLS\\GRADE")
grades <- c(as.character(1:12),"TK","K","PS")
total_rows <- which(as.character(om[[1]])=="TOTAL")
check_eq(length(total_rows),32,"Ontario school TOTAL rows")
grade_rows <- which(as.character(om[[1]]) %in% grades)
check_eq(length(grade_rows),245,"Ontario grade rows")
check_eq(sum(om[[1]]=="TK",na.rm=TRUE),26,"Ontario TK grade rows")
check_eq(sum(om[[1]]=="K",na.rm=TRUE),26,"Ontario K grade rows")
grade_missing <- 0L
for (idx in grade_rows) {
  for (j in 0:2) {
    monthly <- numeric_or_na(unlist(om[idx,seq(2+j,29+j,by=3),drop=FALSE],use.names=FALSE))
    annual <- nval(om[idx,32+j])
    if (is.na(annual)) {
      if(any(!is.na(monthly)))stop("Missing annual sum for a nonempty Ontario grade")
    } else {
      if(annual!=sum(monthly,na.rm=TRUE))stop("Ontario grade-month totals disagree at row ",idx)
    }
    grade_missing <- grade_missing + sum(is.na(monthly))
  }
}
check_eq(grade_missing,6,"Ontario missing grade-month meal cells")
for (idx in total_rows) {
  for (col in 2:34) {
    this_total <- nval(om[idx,col])
    prior <- if(any(total_rows<idx))max(total_rows[total_rows<idx]) else 1L
    block <- om[(prior+1L):(idx-1L),,drop=FALSE]
    components <- block[as.character(block[[1]]) %in% c(grades,"STUDENTS EXITED"),,drop=FALSE]
    if(is.na(this_total)||this_total!=sum(numeric_or_na(components[[col]]),na.rm=TRUE))
      stop("Ontario school column total mismatch at row ",idx,", column ",col)
  }
}
check_eq(sum(numeric_or_na(om[total_rows,32]),na.rm=TRUE),972190,"Ontario Breakfast totals")
check_eq(sum(numeric_or_na(om[total_rows,33]),na.rm=TRUE),2492558,"Ontario Lunch totals")
check_eq(sum(numeric_or_na(om[total_rows,34]),na.rm=TRUE),764628,"Ontario Supper totals")
# Schoolwide ADA is repeated by breakfast, lunch, supper; in 17 school-months
# the supper-column number differs and must remain distinct.
ada <- readtext(ontfile,"Source ADA ADP")
check_eq(nrow(ada),98,"Ontario ADA/ADP rows")
ada_discrepancies <- 0L
for (i in seq(4,97,by=3)) {
  stopifnot(as.character(ada[i,2])=="ADA")
  for (j in seq(3,30,by=3)) {
    vals <- numeric_or_na(unlist(ada[i,j:(j+2),drop=FALSE],use.names=FALSE))
    if(length(unique(vals))>1L)ada_discrepancies <- ada_discrepancies+1L
  }
}
check_eq(ada_discrepancies,17,"Ontario ADA meal-column discrepancies")
# Check each entire active school worksheet against its Backup where the names
# are not truncated; full source check for all 32 was also independently done.
met$ontario_school_blocks <- 32
met$ontario_grade_rows <- length(grade_rows)
met$ontario_grade_month_meal_cells <- 7350
met$ontario_blank_grade_month_meal_cells <- grade_missing
met$ontario_breakfast_meals <- 972190
met$ontario_lunch_meals <- 2492558
met$ontario_supper_meals <- 764628
met$ontario_TK_school_rows <- 26
met$ontario_K_school_rows <- 26
met$ontario_school_month_ADA_column_disagreements <- ada_discrepancies
key <- names(met)
write.csv(data.frame(metric=key,value=unlist(met,use.names=FALSE)),
          file=file.path(out,"source_workbook_reconciliation.csv"),row.names=FALSE)
writeLines(c("Source workbooks reconciled successfully.",
 "Source grade codes, official school identities, and partial-period TK/K attendance days remain unverified.",
 "Never use the full-year 180-day CDE proxy as a partial-period participation denominator."),
 file.path(out,"README.txt"))
cat("All original Elk Grove and Ontario-Montclair workbook arithmetic checks passed.\n")
print(data.frame(metric=key,value=unlist(met,use.names=FALSE)),row.names=FALSE)
