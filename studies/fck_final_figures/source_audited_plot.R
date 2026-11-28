#!/usr/bin/env Rscript
# Feed California Kinders: source-audited Ventura/Lodi report figures.
# Uses team Ventura saved RData, and audited Lodi school-by-grade rates.
# Colors are K/TK from Ventura's original source and grades 1-5 from
# the final Lodi production renderer, matching the requested pink/red/blues only.
suppressPackageStartupMessages(library(ggplot2))
args <- commandArgs(trailingOnly=TRUE)
team_root <- if(length(args)>=1L) args[[1]] else "team"
out <- if(length(args)>=2L) args[[2]] else "final_figures"
dir.create(out,showWarnings=FALSE,recursive=TRUE)

# SOURCE 1: team Ventura saved analysis, not extracted graphics or OCR.
env <- new.env(parent=globalenv())
load(file.path(team_root,"Ventura Unified","cleaned data","Ventura_analysis_copy.RData"),envir=env)
stopifnot(exists("ventura_analysis",envir=env))
v <- as.data.frame(get("ventura_analysis",envir=env))
grades_v <- c("TK","K","1","2","3","4","5")
v$grade <- as.character(v$grade)
v <- v[v$grade%in%grades_v,,drop=FALSE]
v$school <- as.character(v$school_name)
stopifnot(nrow(v)==124L,length(unique(v$school))==18L,
 !anyDuplicated(v[c("school","grade")]),
 all(is.finite(v$attendance)),all(v$attendance>0),
 all(is.finite(v$Lunch)))
missing <- v[is.na(v$Breakfast),c("school","grade","Breakfast","Lunch","attendance")]
print(missing)
stopifnot(nrow(missing)==6L,all(missing$school=="Homestead"),
 setequal(missing$grade,c("K","1","2","3","4","5")))
# The team's Ventura meal analysis_copy.R confirms Homestead has NO
# breakfast service. The source's purported Breakfast section is lunch.
# ONLY these six structural non-service values become 0 breakfast meals.
v$breakfast_original <- v$Breakfast
v$breakfast_structural_zero <- v$school=="Homestead" & is.na(v$Breakfast)
v$Breakfast[v$breakfast_structural_zero] <- 0
stopifnot(!anyNA(v$Breakfast),sum(v$breakfast_structural_zero)==6L)
v$breakfast_rate <- 100*as.numeric(v$Breakfast)/(as.numeric(v$attendance)*178)
v$lunch_rate <- 100*as.numeric(v$Lunch)/(as.numeric(v$attendance)*178)
v$combined_rate <- (as.numeric(v$Breakfast)+as.numeric(v$Lunch))/
                     (as.numeric(v$attendance)*178)
stopifnot(all(is.finite(v$breakfast_rate)),all(is.finite(v$lunch_rate)),
          all(is.finite(v$combined_rate)),all(v$breakfast_rate>=0),
          all(v$lunch_rate>=0),max(v$breakfast_rate)<=100,
          max(v$lunch_rate)<=100,
          isTRUE(all.equal(v$combined_rate,
             (v$breakfast_rate+v$lunch_rate)/100,tolerance=1e-12)))
write.csv(v[c("school","grade","Breakfast","Lunch","attendance",
              "breakfast_structural_zero","breakfast_rate","lunch_rate","combined_rate")],
 file.path(out,"ventura_school_grade_rates_audited.csv"),row.names=FALSE)
write.csv(missing,file.path(out,"ventura_six_original_missing_breakfast_rows.csv"),row.names=FALSE)

# SOURCE 2: full 186-row Lodi absence-adjusted grade comparisons on main.
lodi_path <- "studies/lodi_2025_26/outputs/lodi_186_school_grade_absence_adjusted_rates.csv"
l <- read.csv(lodi_path,colClasses=c(cds="character",grade="character"))
grades_l <- c("K","1","2","3","4","5")
stopifnot(nrow(l)==186L,length(unique(l$school))==31L,
 !anyDuplicated(l[c("cds","grade")]),setequal(unique(l$grade),grades_l),
 all(is.finite(l$modeled_attended_student_days)),all(l$modeled_attended_student_days>0),
 sum(l$breakfast_meals[l$grade=="K"])==70667L,
 sum(l$lunch_meals[l$grade=="K"])==203639L)
stopifnot(max(abs(l$breakfast_rate-
      100*l$breakfast_meals/l$modeled_attended_student_days))<1e-9,
 max(abs(l$lunch_rate-
      100*l$lunch_meals/l$modeled_attended_student_days))<1e-9,
 max(abs(l$combined_rate-
      (l$breakfast_meals+l$lunch_meals)/l$modeled_attended_student_days))<1e-9)
stopifnot(all(round(100*with(subset(l,grade=="K"),
      sum(breakfast_meals)/sum(modeled_attended_student_days)),1)==24.6),
 all(round(100*with(subset(l,grade=="K"),
      sum(lunch_meals)/sum(modeled_attended_student_days)),1)==70.9))
write.csv(l,file.path(out,"lodi_school_grade_rates_verified.csv"),row.names=FALSE)

# Exactly these hexes are documented in the cited team scripts.
palette <- c(TK="#E57373",K="#C62828",
 "1"="#12334D","2"="#2671B4","3"="#4D9CDB",
 "4"="#9FCCED","5"="#CDE5F6")
# Consistent base style, same tick spacing, grids, legend and point geometry.
short_lodi <- function(s) {
 s <- sub(" Elementary School$","",s)
 s <- sub(" Elementary$","",s)
 s <- sub("^George Lincoln Mosher","G. Lincoln Mosher",s)
 s <- sub("^George Washington","G. Washington",s)
 s <- sub("^Ellerth E. Larson","E. E. Larson",s)
 s <- sub("^Clyde W. Needham","C. W. Needham",s)
 s <- sub("^Lois E. Borchardt","L. E. Borchardt",s)
 s <- sub("^Joe Serna Jr. Charter","Joe Serna Jr. Charter",s)
 s
}
plot_report <- function(df,district,grades,metric,xlabel,maxval,breaks,
                        filename,height,labels=NULL) {
 schools <- sort(unique(df$school))
 df$grade <- factor(df$grade,levels=grades)
 df$school <- factor(df$school,levels=rev(schools))
 older <- df[!as.character(df$grade)%in%c("TK","K"),,drop=FALSE]
 early <- df[as.character(df$grade)%in%c("TK","K"),,drop=FALSE]
 stopifnot(all(is.finite(df[[metric]])),min(df[[metric]])>=0,
           max(df[[metric]])<=maxval,nrow(df)==if(district=="Ventura")124L else 186L)
 p <- ggplot(df,aes(x=.data[[metric]],y=school,colour=grade)) +
   geom_point(data=older,size=2.8,alpha=1,position="identity")+
   geom_point(data=early,size=2.8,alpha=1,position="identity")+
   scale_x_continuous(limits=c(0,maxval),breaks=breaks)+
   scale_y_discrete(labels=if(is.null(labels)) waiver() else labels)+
   scale_colour_manual(values=palette,breaks=grades,drop=FALSE)+
   labs(x=xlabel,y="School",colour="Grade")+
   theme_minimal(base_size=10)+
   theme(
    panel.grid.major.x=element_line(colour="#DEDEDE",linewidth=.35),
    panel.grid.major.y=element_line(colour="#DEDEDE",linewidth=.35),
    panel.grid.minor=element_blank(),
    plot.margin=margin(6,8,8,8),
    axis.text.y=element_text(size=if(district=="Lodi")8.2 else 9.1,
                              colour="#17212B"),
    axis.text.x=element_text(size=9.2,colour="#17212B"),
    axis.title.x=element_text(size=10.2,colour="#101820"),
    axis.title.y=element_text(size=10.2,colour="#101820"),
    legend.position="right",
    legend.title=element_text(size=10,colour="#101820"),
    legend.text=element_text(size=9.2,colour="#17212B"))
 build <- ggplot_build(p)$data
 drawn <- c(build[[1]]$x,build[[2]]$x)
 stopifnot(length(drawn)==nrow(df),!anyNA(drawn),
           isTRUE(all.equal(sort(drawn),sort(df[[metric]]),tolerance=1e-10)))
 ggsave(file.path(out,paste0(filename,".png")),p,
        width=10,height=height,units="in",dpi=100,bg="white")
 ggsave(file.path(out,paste0(filename,".pdf")),p,
        width=10,height=height,units="in",bg="white")
 cat("OK",filename,"rows",length(drawn),"dims",1000,"x",height*100,"\n")
}
for(district in c("Ventura","Lodi")) {
 d <- if(district=="Ventura") v else l
 gs <- if(district=="Ventura") grades_v else grades_l
 height <- if(length(unique(d$school))<30) 5 else 6
 nm <- if(district=="Ventura") "ventura" else "lodi"
 lbl <- if(district=="Lodi") short_lodi else NULL
 plot_report(d,district,gs,"breakfast_rate",
   "Breakfasts per 100 estimated attended student-days",
   100,seq(0,100,10),paste0(nm,"_breakfast_",1000,"x",height*100),height,lbl)
 plot_report(d,district,gs,"lunch_rate",
   "Lunches per 100 estimated attended student-days",
   100,seq(0,100,10),paste0(nm,"_lunch_",1000,"x",height*100),height,lbl)
 plot_report(d,district,gs,"combined_rate",
   "Breakfasts plus lunches per estimated attended student-day",
   2,seq(0,2,.1),paste0(nm,"_combined_",1000,"x",height*100),height,lbl)
}
writeLines(c(
 "FINAL SOURCE-AUDITED FIGURES — November 27, 2026",
 "18 Ventura schools, 124 school-grade rows -> 1000x500",
 "31 Lodi schools, 186 school-grade rows -> 1000x600",
 "Source: whippedfruit/Feed-California-Kinders/Ventura Unified/cleaned data/Ventura_analysis_copy.RData",
 "Source: taielucile/ca-school-lunch-attendance/studies/lodi_2025_26/outputs/lodi_186_school_grade_absence_adjusted_rates.csv",
 "Palette: Original Ventura TK pink #E57373 and K red #C62828;",
 "         final Lodi production R script blue grades 1-5 #12334D #2671B4 #4D9CDB #9FCCED #CDE5F6.",
 "Note: Original Ventura final analysis_copy.R uses DIFFERENT teal/green codes for grades 2-4.",
 "      We use the final Lodi blue sequence in BOTH, by explicit user request.",
 "Ventura missing entries: all six are Homestead grades K-5; its source meal-analysis R",
 "  explicitly confirms breakfast is NOT served there. Zero means no breakfast service.",
 "  Thus all 124 Ventura breakfast and 124 combined grade points are now mathematically defined.",
 "  Do NOT interpret zeros as observed student participation rates.",
 "Ventura 178 days denominator follows Angela's original figure calculations.",
 "Lodi uses verified modeled grade attendance days; Preschool excluded.",
 "No figure title or footnote inside image. Rates are meal-day ratios, not shares of distinct students.",
 "Missing-value treatment is documented in ventura_school_grade_rates_audited.csv.",
 paste("R",R.version.string,"ggplot2",as.character(packageVersion("ggplot2")))
),file.path(out,"README.txt"))
