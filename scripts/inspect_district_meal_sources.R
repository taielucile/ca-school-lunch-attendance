#!/usr/bin/env Rscript
# Read-only source-structure audit of 2025-26 district meal workbooks.
# Does not compute participation rates or treat meal tallies as distinct children.
suppressPackageStartupMessages(library(readxl))
paths <- c(
  Chino = "team/Chino/July 2025 to March 2026 - Meals by School & Grade.xls",
  Davis = "team/Davis Joint Unified/raw data/Davis Joint Unified Meal cleaned_copy.xlsx"
)
dir.create("output/meal-source-audit", recursive=TRUE, showWarnings=FALSE)
outfile <- "output/meal-source-audit/source_structure.txt"
sink(outfile, split=TRUE)
for (d in names(paths)) {
  p <- paths[[d]]
  cat("\n======== DISTRICT:", d, "========\n", "File:", p, "\n")
  cat("Exists:", file.exists(p), "\n")
  stopifnot(file.exists(p))
  cat("SHA256:\n"); system2("sha256sum",shQuote(p),stdout=TRUE) |> writeLines()
  sheets <- excel_sheets(p)
  cat("Sheets:", paste(sheets,collapse=" | "), "\n")
  for (sh in sheets) {
    cat("\nSHEET:",sh,"\n")
    dat <- tryCatch(
      read_excel(p,sheet=sh,col_names=FALSE,col_types="text",.name_repair="minimal"),
      error=function(e) {cat("SHEET READ ERROR",conditionMessage(e),"\n");NULL})
    if(is.null(dat)) next
    cat("Dimensions:",nrow(dat),"rows x",ncol(dat),"columns\n")
    limit <- min(100L,nrow(dat))
    for (i in seq_len(min(15L,limit))) {
      row <- unlist(dat[i,],use.names=FALSE)
      ix <- which(!is.na(row)&nzchar(trimws(row)))
      if(length(ix)) cat("HEADER_ROW",i,paste(paste0(ix,":",substr(row[ix],1,72)),collapse=" | "),"\n")
    }
    # Unambiguously identify which grade tokens are actually in the source.
    dat <- as.data.frame(dat,stringsAsFactors=FALSE)
    search_cols <- seq_len(min(ncol(dat),min(22L,ncol(dat))))
    matches <- character()
    dates <- character()
    for (i in seq_len(nrow(dat))) {
      vals <- unlist(dat[i,search_cols,drop=FALSE],use.names=FALSE)
      vals <- vals[!is.na(vals)]
      if(!length(vals))next
      rowtext <- paste(vals,collapse=" | ")
      if(grepl("(^|[^A-Za-z])(TK|Kindergarten|Kinder|Pre-?K|Preschool|Grade [1-9]|1st grade|first grade)([^A-Za-z]|$)",rowtext,ignore.case=TRUE,perl=TRUE)) {
        if(length(matches)<32) matches <- c(matches,paste0("ROW ",i,": ",substr(rowtext,1,310)))
      }
      if(grepl("2025|2026|July|August|September|October|November|December|January|February|March|April|May|June",rowtext,ignore.case=TRUE)) {
        if(length(dates)<18) dates <- c(dates,paste0("ROW ",i,": ",substr(rowtext,1,280)))
      }
    }
    cat("GRADE_RELEVANT_ROWS (first up to 32):\n",paste(matches,collapse="\n"),"\n",sep="")
    cat("DATE_RELEVANT_ROWS (first up to 18):\n",paste(dates,collapse="\n"),"\n",sep="")
    cat("GRADE_RELEVANT_ROWS_FOUND:",length(matches),"(capped at 32)\n")
  }
}
sink()
