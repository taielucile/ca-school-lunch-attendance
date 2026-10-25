# October 2026 TK/K stability audit. Base R only.
# Run from repository root AFTER Rscript RUN_ALL.R, with CDE stability TSV at
# data/raw/sr2425-v3.txt. Alternatively, reuse the pipeline's saved comparison
# CSV at output/tables/irvine_lodi_denominator_comparison_2024_25.csv.
raw_path <- "data/raw/sr2425-v3.txt"
comparison_path <- "output/tables/irvine_lodi_denominator_comparison_2024_25.csv"
if (!file.exists(raw_path) || !file.exists(comparison_path))
  stop("Need CDE stability TSV and generated 2024-25 comparison CSV; see docs/october_2026_stability_reproduction.md")
raw <- read.delim(raw_path, encoding="latin1", colClasses="character",
                  check.names=FALSE, quote="", na.strings=c("", "*"))
need <- c("Academic Year","Aggregate Level","Reporting Category","District Name",
          "County Code","District Code","School Code","Adjusted Cumulative Enrollment",
          "Stability Count","Stability Rate (percent)")
stopifnot(all(need %in% names(raw)))
keep <- raw[raw[["Academic Year"]]=="2024-25" &
  raw[["Aggregate Level"]]=="S" & raw[["Reporting Category"]]=="GRTKKN" &
  raw[["District Name"]] %in% c("Irvine Unified","Lodi Unified") &
  !(raw[["School Code"]] %in% c("0000000","0000001")), , drop=FALSE]
keep$cds_code <- paste0(keep[["County Code"]],keep[["District Code"]],keep[["School Code"]])
stopifnot(nrow(keep)==64L, !anyDuplicated(keep$cds_code),
          all(nchar(keep$cds_code)==14L))
s <- data.frame(cds_code=keep$cds_code,
  adjusted_cumulative_enrollment=as.numeric(keep[["Adjusted Cumulative Enrollment"]]),
  stable_enrollment=as.numeric(keep[["Stability Count"]]),
  stability_rate_pct=as.numeric(keep[["Stability Rate (percent)"]]))
stopifnot(!anyNA(s), all(s$adjusted_cumulative_enrollment>0),
          all(s$stable_enrollment>=0 & s$stable_enrollment<=s$adjusted_cumulative_enrollment),
          all(abs(100*s$stable_enrollment/s$adjusted_cumulative_enrollment-s$stability_rate_pct)<0.11))
p <- read.csv(comparison_path,colClasses=c(cds_code="character"),check.names=FALSE)
need_p <- c("cds_code","district_focus","tk_k_total_absence_days",
            "tk_k_eligible_cumulative_enrollment","B_vs_A_pct")
stopifnot(all(need_p %in% names(p)),nrow(p)==64L,!anyDuplicated(p$cds_code),
          setequal(p$cds_code,s$cds_code))
m <- merge(p,s,by="cds_code",sort=FALSE)
summary <- do.call(rbind,lapply(split(m,m$district_focus),function(g) {
  h <- g[is.finite(g$B_vs_A_pct) & !is.na(g$tk_k_total_absence_days) &
    !is.na(g$tk_k_eligible_cumulative_enrollment),,drop=FALSE]
  data.frame(district=g$district_focus[1],schools=nrow(g),usable=nrow(h),
    stable_count=sum(g$stable_enrollment),
    adjusted_cumulative_enrollment=sum(g$adjusted_cumulative_enrollment),
    weighted_stability_pct=100*sum(g$stable_enrollment)/sum(g$adjusted_cumulative_enrollment),
    pearson=cor(h$stability_rate_pct,h$B_vs_A_pct,method="pearson"),
    spearman=cor(h$stability_rate_pct,h$B_vs_A_pct,method="spearman"))
}))
for (d in c("Irvine Unified","Lodi Unified")) {
  x <- summary[summary$district==d,,drop=FALSE]
  if(d=="Irvine Unified") stopifnot(x$schools==30,x$usable==30,x$stable_count==3012,
    x$adjusted_cumulative_enrollment==3519,abs(x$pearson+0.798)<0.0015,
    abs(x$spearman+0.735)<0.0015)
  else stopifnot(x$schools==34,x$usable==33,x$stable_count==2450,
    x$adjusted_cumulative_enrollment==2957,abs(x$pearson+0.647)<0.0015,
    abs(x$spearman+0.664)<0.0015)
}
dir.create("output/tables",recursive=TRUE,showWarnings=FALSE)
write.csv(summary,"output/tables/october_2026_stability_summary.csv",row.names=FALSE)
write.csv(m,"output/tables/october_2026_stability_school_audit.csv",row.names=FALSE)
print(summary,row.names=FALSE)
cat("PASS: October 2026 stability source, join, and correlation checks\n")
