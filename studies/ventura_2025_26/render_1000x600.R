#!/usr/bin/env Rscript
# Re-export Angela's Ventura grade-by-school figures at exactly 1000 x 600.
# Based on team repository original (Ventura Unified/Ventura final analysis_copy.R).
suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})
args <- commandArgs(trailingOnly=TRUE)
team_dir <- if (length(args)>0) args[[1]] else "team"
out_dir <- if (length(args)>1) args[[2]] else "output/ventura_1000x600"
dir.create(out_dir, recursive=TRUE, showWarnings=FALSE)
rdata_path <- file.path(team_dir, "Ventura Unified", "cleaned data", "Ventura_analysis_copy.RData")
stopifnot(file.exists(rdata_path))
e <- new.env(parent=globalenv())
loaded <- load(rdata_path, envir=e)
cat("Original Ventura RData objects:",paste(loaded,collapse=", "), "\n")
for(n in loaded) {
 x <- get(n,envir=e)
 if(is.data.frame(x)) cat("  ", n,":",nrow(x),"rows; columns:",paste(names(x),collapse=", "), "\n")
}
# Prefer analyzed grade-level data from Angela's saved environment.
find_data <- function() {
 for(n in c("ventura_TK5","ventura_meals_per_person","ventura_analysis","plot_data")) {
  if(exists(n,envir=e)) {
   x <- get(n,envir=e)
   if(is.data.frame(x) && all(c("school_name","grade")%in%names(x)) &&
        (all(c("Breakfast","Lunch","attendance")%in%names(x)) ||
         all(c("breakfast_per_person_day","lunch_per_person_day","total_meals_per_person_day")%in%names(x)))) {
    cat("Selected saved analysis object:",n,"\n")
    return(x)
   }
  }
 }
 stop("Saved RData lacks a compatible Ventura grade-level object; see printed object schemas.")
}
df <- find_data() |> as.data.frame()
grades <- c("TK","K","1","2","3","4","5")
df$grade <- as.character(df$grade)
df <- df[df$grade %in% grades,,drop=FALSE]
df$school_name <- as.character(df$school_name)
if(all(c("Breakfast","Lunch","attendance")%in%names(df))) {
  # Recompute from original underlying values, following Angela's figure formula.
  df$breakfast_per_person_day <- as.numeric(df$Breakfast)/(as.numeric(df$attendance)*178)
  df$lunch_per_person_day <- as.numeric(df$Lunch)/(as.numeric(df$attendance)*178)
  df$total_meals_per_person_day <- (as.numeric(df$Breakfast)+as.numeric(df$Lunch))/(as.numeric(df$attendance)*178)
}
stopifnot(nrow(df)>70,!anyDuplicated(df[c("school_name","grade")]))
cat("Selected",nrow(df),"rows across",length(unique(df$school_name)),"schools.\n")
# Preserve original missing-data behavior: missing meal-type counts are not zero-filled
# for these three plots, unless Angela's saved data contained a numeric zero.
stopifnot(all(sapply(c("breakfast_per_person_day","lunch_per_person_day","total_meals_per_person_day"),function(z)any(is.finite(df[[z]])))))
df$grade <- factor(df$grade,levels=grades)
df$school_name <- factor(df$school_name,levels=sort(unique(df$school_name),decreasing=TRUE))
colors <- c(TK="#E57373",K="#C62828",`1`="#42A5F5",`2`="#26A69A",
            `3`="#66BB6A",`4`="#00897B",`5`="#00569B")
# Titles/notes are outside PNG (as with final Lodi figures).
design <- theme_minimal(base_size=9.2) + theme(
  legend.position="top", legend.direction="horizontal",
  legend.text=element_text(size=8.3),
  axis.text.y=element_text(size=8.0,colour="#303942"),
  axis.text.x=element_text(size=8.0,colour="#303942"),
  axis.title.x=element_text(size=8.7,margin=margin(t=5)),
  panel.grid.major.y=element_blank(),
  panel.grid.major.x=element_line(colour="#E4E9ED",linewidth=.25),
  panel.grid.minor=element_blank(),
  plot.margin=margin(5,11,8,6),
  legend.margin=margin(0,0,0,0),
  legend.box.margin=margin(0,0,0,0)
)
save_figure <- function(var,xlab,name,breaks,limits) {
 x <- df
 older <- x[x$grade%in%c("1","2","3","4","5"),,drop=FALSE]
 young <- x[x$grade%in%c("TK","K"),,drop=FALSE]
 g <- ggplot(x,aes(x=.data[[var]],y=school_name,colour=grade)) +
   geom_point(data=older,size=2.1,alpha=1,position="identity",na.rm=TRUE)+
   geom_point(data=young,size=2.35,alpha=1,position="identity",na.rm=TRUE)+
   scale_colour_manual(values=colors,breaks=grades,drop=FALSE) +
   scale_x_continuous(breaks=breaks,limits=limits) +
   labs(x=xlab,y=NULL,colour="Grade") + design +
   guides(colour=guide_legend(nrow=1,override.aes=list(size=2.65,alpha=1)))
 target <- file.path(out_dir,paste0(name,".png"))
 ggsave(target,plot=g,width=10,height=6,units="in",dpi=100,bg="white")
 # Figure also provided as scalable PDF with matching 5:3 aspect.
 ggsave(file.path(out_dir,paste0(name,".pdf")),plot=g,width=10,height=6,units="in",bg="white")
 cat("EXPORTED",target,"\n")
}
save_figure("breakfast_per_person_day","Breakfast meals per estimated attended day",
 "ventura_breakfast_1000x600",seq(0,1,.25),c(0,1))
save_figure("lunch_per_person_day","Lunch meals per estimated attended day",
 "ventura_lunch_1000x600",seq(0,1,.25),c(0,1))
save_figure("total_meals_per_person_day","Breakfasts + lunches per estimated attended day",
 "ventura_combined_1000x600",seq(0,2,.5),c(0,2))
write.csv(df[,c("school_name","grade","breakfast_per_person_day","lunch_per_person_day","total_meals_per_person_day")],
 file.path(out_dir,"ventura_plotted_rates.csv"),row.names=FALSE)
writeLines(c("Ventura 2025–26 – 1000 × 600 R-generated school-by-grade figures",
 "Source: team/ Ventura Unified/cleaned data/Ventura_analysis_copy.RData and original Ventura final analysis_copy.R",
 "Method: reported grade breakfast/lunch meals / (reported grade attendance × 178), as in Angela's original plots.",
 "Preschool excluded. Missing meal counts remain missing instead of being invented as zero.",
 "All plots: exact original Ventura colors; same y-axis school order and x scales as original; no title or caption inside PNG.",
 "Each point represents one grade at one school. These are meals relative to attendance estimates, not fractions of distinct students.",
 "Axes and legends remain inside figures. Figures are 1000×600; PDF equivalents are 10×6 inches."),
 file.path(out_dir,"README.txt"))
