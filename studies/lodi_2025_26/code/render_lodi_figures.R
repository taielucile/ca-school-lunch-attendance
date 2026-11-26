#!/usr/bin/env Rscript
# Lodi 2025–26: kindergarten–grade 5, absence-adjusted comparisons.
# Official CDE school Census enrollment (2025–26), grouped absenteeism (2025–26),
# original Lodi grade-specific meal workbook. Internal research figures.
suppressPackageStartupMessages(library(ggplot2))
args <- commandArgs(trailingOnly=TRUE)
meal_path <- if(length(args)>=1) args[[1]] else "inputs/lodi_31_school_grade_meal_census_for_R.csv"
absence_path <- if(length(args)>=2) args[[2]] else "inputs/lodi_31_school_absence_group_inputs_2025_26.csv"
out <- if(length(args)>=3) args[[3]] else "figures"
dir.create(out, recursive=TRUE, showWarnings=FALSE)

meals <- read.csv(meal_path,colClasses=c(cds="character",school="character"),check.names=FALSE)
abs <- read.csv(absence_path,colClasses=c(cds="character"),check.names=FALSE)
stopifnot(nrow(meals)==31L,nrow(abs)==31L,!anyDuplicated(meals$cds),!anyDuplicated(abs$cds))
stopifnot(setequal(meals$cds,abs$cds),all(nchar(meals$cds)==14L))
d <- merge(meals,abs,by="cds",sort=FALSE,all=TRUE)
stopifnot(nrow(d)==31L,!anyNA(d),all(d$enroll_6>=0),all(d$enroll_TK>=0))
grades <- c("K","1","2","3","4","5")
long <- do.call(rbind,lapply(grades,function(g){
  group <- if(g=="K") "GRTKKN" else if(g%in%c("1","2","3")) "GR13" else "GR46"
  group_enrollment <- if(group=="GRTKKN") d$enroll_TK+d$enroll_K else
                      if(group=="GR13") d$enroll_1+d$enroll_2+d$enroll_3 else
                      d$enroll_4+d$enroll_5+d$enroll_6
  n <- d[[paste0("enroll_",g)]]
  group_absent_days <- d[[paste0("absent_",group)]]
  modeled_attended_days <- n*180 - group_absent_days*(n/group_enrollment)
  data.frame(cds=d$cds,school=d$school,grade=g,
             census_enrollment=n,absence_group=group,
             group_census_enrollment=group_enrollment,
             reported_group_absence_days=group_absent_days,
             modeled_attended_student_days=modeled_attended_days,
             breakfast_meals=d[[paste0("breakfast_",g)]],
             lunch_meals=d[[paste0("lunch_",g)]])
}))
stopifnot(nrow(long)==186L,!anyNA(long),all(long$census_enrollment>0),
          all(long$modeled_attended_student_days>0))
k <- long[long$grade=="K",]
stopifnot(sum(k$breakfast_meals)==70667,sum(k$lunch_meals)==203639)
stopifnot(abs(sum(k$modeled_attended_student_days)-287174.337285)<0.001)
stopifnot(all(sapply(c("2","3","4","5"),function(g)sum(long$census_enrollment[long$grade==g]))==c(1885,1972,2025,2003)))
long$breakfast_rate <- 100*long$breakfast_meals/long$modeled_attended_student_days
long$lunch_rate <- 100*long$lunch_meals/long$modeled_attended_student_days
long$combined_rate <- (long$breakfast_meals+long$lunch_meals)/long$modeled_attended_student_days
stopifnot(!anyDuplicated(long[c("cds", "grade")]),
          all(table(long$cds, long$grade) == 1L))
rate_columns <- c("breakfast_rate", "lunch_rate", "combined_rate")
archived <- read.csv(file.path(dirname(meal_path), "lodi_186_school_grade_absence_adjusted_rates.csv"),
                     colClasses = c(cds = "character", grade = "character"))
keys <- c("cds", "grade")
checks <- merge(long[c(keys, rate_columns)], archived[c(keys, rate_columns)],
                by = keys, all = TRUE, suffixes = c("_new", "_archived"))
stopifnot(nrow(checks) == 186L, !anyNA(checks))
for (field in rate_columns) {
  stopifnot(all(abs(checks[[paste0(field, "_new")]] -
                    checks[[paste0(field, "_archived")]]) < 1e-10))
}
pooled <- aggregate(cbind(breakfast_meals, lunch_meals, modeled_attended_student_days) ~ grade,
                    data = long, FUN = sum)
pooled <- pooled[match(grades, pooled$grade), ]
stopifnot(all(round(100 * pooled$breakfast_meals / pooled$modeled_attended_student_days, 1) ==
              c(24.6, 28.9, 28.8, 29.6, 28.1, 25.9)),
          all(round(100 * pooled$lunch_meals / pooled$modeled_attended_student_days, 1) ==
              c(70.9, 74.0, 75.0, 78.8, 75.6, 75.3)))

# Angela's Ventura grade colors. Lodi has no verified TK meal series.
palette <- c(K = "#DC5C60", "1" = "#12334D", "2" = "#2671B4",
             "3" = "#4D9CDB", "4" = "#9FCCED", "5" = "#CDE5F6")
schools <- sort(unique(long$school))
long$grade <- factor(long$grade, levels = grades)
older <- long[long$grade != "K", ]
kindergarten <- long[long$grade == "K", ]

plot_meals <- function(field, axis, upper, breaks) {
  stopifnot(all(is.finite(long[[field]])), all(long[[field]] >= 0),
            max(long[[field]]) <= upper)
  plot <- ggplot(long, aes(x = .data[[field]], y = school, colour = grade)) +
    geom_point(data = older, size = 3) +
    geom_point(data = kindergarten, size = 3) +
    scale_x_continuous(breaks = breaks, limits = c(0, upper)) +
    scale_y_discrete(limits = rev(schools)) +
    scale_colour_manual(values = palette, breaks = grades, drop = FALSE) +
    labs(x = axis, y = "School", colour = "Grade") +
    theme_minimal()
  layers <- ggplot_build(plot)$data
  drawn_x <- c(layers[[1]]$x, layers[[2]]$x)
  stopifnot(length(drawn_x) == nrow(long), !anyNA(drawn_x),
            all(sort(drawn_x) == sort(long[[field]])))
  plot
}

plots <- list(
  "01_Lodi_Breakfast" = plot_meals("breakfast_rate",
      "Breakfasts per 100 estimated days of student attendance", 100, seq(0, 100, 10)),
  "02_Lodi_Lunch" = plot_meals("lunch_rate",
      "Lunches per 100 estimated days of student attendance", 100, seq(0, 100, 10)),
  "03_Lodi_Combined_Meals" = plot_meals("combined_rate",
      "Breakfasts plus lunches per estimated day of student attendance", 2, seq(0, 2, 0.1))
)
for (name in names(plots)) {
  ggsave(file.path(out, paste0(name, ".pdf")), plots[[name]], device = grDevices::pdf,
         width = 10, height = 6, bg = "white", title = "")
}
write.csv(long,
          file.path(out, "Lodi_K-5_Plot_Values.csv"), row.names = FALSE)
cat("Verified 558 plotted rates across 186 school-grade rows.\n")
cat(R.version.string, "\n")
cat("ggplot2 ", as.character(packageVersion("ggplot2")), "\n", sep = "")
