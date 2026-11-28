#!/usr/bin/env Rscript
# Ventura Unified 2025–26: final 1000×600 exports using the Lodi report renderer's
# colors, grid, legend, point size, axis tick frequency, and minimal theme.
# Source for rates: Angela's saved Ventura_analysis_copy.RData.
suppressPackageStartupMessages(library(ggplot2))
args <- commandArgs(trailingOnly=TRUE)
team <- if (length(args) >= 1L) args[[1]] else "team"
out <- if (length(args) >= 2L) args[[2]] else "output/ventura_1000x600"
dir.create(out, showWarnings=FALSE, recursive=TRUE)
source_file <- file.path(team,"Ventura Unified","cleaned data","Ventura_analysis_copy.RData")
stopifnot(file.exists(source_file))
env <- new.env(parent=globalenv())
load(source_file,envir=env)
stopifnot(exists("ventura_analysis",envir=env))
d <- get("ventura_analysis",envir=env)
grades <- c("TK","K","1","2","3","4","5")
stopifnot(all(c("school_name","grade","Breakfast","Lunch","attendance")%in%names(d)))
d <- d[as.character(d$grade)%in%grades,,drop=FALSE]
d$grade <- as.character(d$grade)
d$school_name <- as.character(d$school_name)
stopifnot(nrow(d)==124L,length(unique(d$school_name))==18L,
          !anyDuplicated(d[c("school_name","grade")]))
# Match Angela's actual chart denominator and window: grade attendance x 178 days.
d$breakfast_rate <- 100*as.numeric(d$Breakfast)/(as.numeric(d$attendance)*178)
d$lunch_rate <- 100*as.numeric(d$Lunch)/(as.numeric(d$attendance)*178)
d$combined_rate <- (as.numeric(d$Breakfast)+as.numeric(d$Lunch))/
                    (as.numeric(d$attendance)*178)
# Reuse final Lodi report's EXACT K + grades 1–5 palette;
# TK is the extra Ventura series and gets a lighter rose.
palette <- c(TK="#F2A0A3",K="#DC5C60",
             "1"="#12334D","2"="#2671B4","3"="#4D9CDB",
             "4"="#9FCCED","5"="#CDE5F6")
schools <- sort(unique(d$school_name))
d$grade <- factor(d$grade,levels=grades)
older <- d[d$grade%in%c("1","2","3","4","5"),,drop=FALSE]
early <- d[d$grade%in%c("TK","K"),,drop=FALSE]
make_figure <- function(field,axis,upper,breaks,file) {
  plot <- ggplot(d,aes(x=.data[[field]],y=school_name,colour=grade)) +
    geom_point(data=older,size=3) +
    geom_point(data=early,size=3) +
    scale_x_continuous(breaks=breaks,limits=c(0,upper)) +
    scale_y_discrete(limits=rev(schools)) +
    scale_colour_manual(values=palette,breaks=grades,drop=FALSE) +
    labs(x=axis,y="School",colour="Grade") +
    theme_minimal()
  # Same validation as Lodi final renderer: each nonmissing rate is plotted.
  build <- ggplot_build(plot)$data
  drawn <- c(build[[1]]$x,build[[2]]$x)
  original <- d[[field]]
  stopifnot(length(drawn)==length(original),
            sum(is.na(drawn))==sum(is.na(original)),
            isTRUE(all.equal(sort(drawn[is.finite(drawn)]),
                             sort(original[is.finite(original)]),
                             tolerance=1e-12)))
  ggsave(file.path(out,paste0(file,".pdf")),plot,device=grDevices::pdf,
         width=10,height=6,bg="white",title="")
  ggsave(file.path(out,paste0(file,".png")),plot,device="png",
         width=10,height=6,units="in",dpi=100,bg="white")
  cat("Generated",file,"from",sum(is.finite(original)),"valid school/grade rates\n")
}
make_figure("breakfast_rate","Breakfasts per 100 estimated days of student attendance",
  100,seq(0,100,10),"01_Ventura_Breakfast")
make_figure("lunch_rate","Lunches per 100 estimated days of student attendance",
  100,seq(0,100,10),"02_Ventura_Lunch")
make_figure("combined_rate","Breakfasts plus lunches per estimated day of student attendance",
  2,seq(0,2,.1),"03_Ventura_Combined_Meals")
write.csv(d[,c("school_name","grade","Breakfast","Lunch","attendance",
              "breakfast_rate","lunch_rate","combined_rate")],
  file.path(out,"Ventura_TK-5_Plot_Values.csv"),row.names=FALSE)
writeLines(c(
 "Ventura Unified 2025–26 | R-generated figures, 1000 × 600 pixels.",
 "Template: studies/lodi_2025_26/code/render_lodi_figures.R at main branch.",
 "Rates: Ventura team's original saved Ventura_analysis_copy.RData.",
 "No added titles, captions or footnotes inside PNG files.",
 "The plotting style matches Lodi final: theme_minimal() (both grids), grade point size 3,",
 "School/Grade legend at ggplot defaults, same x-axis 10-unit/.1-unit grid spacing, and grade alignment.",
 "Grade colors: TK #F2A0A3 (new pale rose), K #DC5C60;",
 "1 #12334D; 2 #2671B4; 3 #4D9CDB; 4 #9FCCED; 5 #CDE5F6.",
 "The original Ventura charts include TK, unlike Lodi.",
 "Each point represents a school-grade meal count divided by (reported grade attendance × 178),",
 "not a share of distinct children. Missing meal counts are not silently set to zero.",
 "Render method: R ggsave() at 10×6 inches, 100 DPI, produces exactly 1000×600 PNG."
 ),file.path(out,"README.txt"))
cat("R:",R.version.string,"ggplot2:",as.character(packageVersion("ggplot2")),"\n")
