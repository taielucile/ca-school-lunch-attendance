#!/usr/bin/env Rscript
# Lodi 2025–26: kindergarten–grade 5, absence-adjusted comparisons.
# Official CDE school Census enrollment (2025–26), grouped absenteeism (2025–26),
# original Lodi grade-specific meal workbook. Internal research figures.
suppressPackageStartupMessages(library(ggplot2))
args <- commandArgs(trailingOnly=TRUE)
meal_path <- if(length(args)>=1) args[[1]] else "studies/lodi_2025_26/outputs/lodi_31_school_grade_meal_census_for_R.csv"
absence_path <- if(length(args)>=2) args[[2]] else "studies/lodi_2025_26/outputs/lodi_31_school_absence_group_inputs_2025_26.csv"
out <- if(length(args)>=3) args[[3]] else "lodi_r_rendered_figures"
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
stopifnot(max(long$breakfast_rate)<100,max(long$lunch_rate)<100,max(long$combined_rate)<2)
write.csv(long,file.path(out,"lodi_186_school_grade_absence_adjusted_rates.csv"),row.names=FALSE)

# EXACT grade palette from Angela's Ventura analysis (no transparency or blending).
ventura <- c(K="#C62828",`1`="#42A5F5",`2`="#26A69A",
             `3`="#66BB6A",`4`="#00897B",`5`="#00569B")
grade_labels <- c(K="Kindergarten",`1`="Grade 1",`2`="Grade 2",
                  `3`="Grade 3",`4`="Grade 4",`5`="Grade 5")
schools <- sort(unique(long$school))
long$school <- factor(long$school,levels=rev(schools))
long$grade <- factor(long$grade,levels=grades)
short_name <- function(z) {
 z <- sub(" Elementary School$","",z)
 z <- sub(" Elementary$","",z)
 z <- sub("^George Lincoln Mosher","G. Lincoln Mosher",z)
 z <- sub("^George Washington","G. Washington",z)
 z <- sub("^Ellerth E. Larson","E. E. Larson",z)
 z <- sub("^Clyde W. Needham","C. W. Needham",z)
 sub("^Lois E. Borchardt","L. E. Borchardt",z)
}
create_figure <- function(metric,axis,fig_title,file,upper,breaks,extra="") {
 older <- long[long$grade!="K",,drop=FALSE]
 kinder <- long[long$grade=="K",,drop=FALSE]
 note <- paste0("Each point represents one grade at one school. ",
                 "Rates use reported meals divided by estimated attended student-days (Census enrollment × 180, minus an allocated share of grouped absences).\n",
                 "CDE groups absences as TK/K, grades 1–3, and grades 4–6. ",
                 "Attendance is modeled, not observed; the points are not percentages of distinct students.",
                 extra)
 p <- ggplot(long,aes(x=.data[[metric]],y=school,color=grade))+
   geom_hline(yintercept=seq_along(schools),color="#E5E9ED",linewidth=0.28)+
   geom_point(data=older,position="identity",size=3,alpha=1)+
   geom_point(data=kinder,position="identity",size=4,alpha=1)+
   scale_color_manual(values=ventura,breaks=grades,labels=grade_labels,drop=FALSE)+
   scale_y_discrete(labels=short_name,drop=FALSE)+
   scale_x_continuous(limits=c(0,upper),breaks=breaks,expand=expansion(mult=c(0.007,0.02)))+
   labs(x=axis,y=NULL,color=NULL,caption=paste0(fig_title,"\n",note))+
   guides(color=guide_legend(nrow=1,override.aes=list(size=3.6,alpha=1)))+
   theme_minimal(base_size=11)+
   theme(panel.grid.major.y=element_blank(),
         panel.grid.minor=element_blank(),
         panel.grid.major.x=element_line(color="#E9EDF0",linewidth=.35),
         axis.text.y=element_text(size=9.2,color="#263746"),
         axis.text.x=element_text(size=9.5,color="#435463"),
         axis.title.x=element_text(size=11,color="#263746",margin=margin(t=8)),
         legend.position="top",legend.text=element_text(size=10),
         plot.caption.position="plot",
         plot.caption=element_text(hjust=0,size=8.8,color="#35444B",lineheight=1.23,
                                   margin=margin(t=14)),
         plot.margin=margin(t=9,r=17,b=12,l=10))
 ggsave(file.path(out,paste0(file,".png")),p,width=13.5,height=10.4,units="in",dpi=240,bg="white")
 ggsave(file.path(out,paste0(file,".pdf")),p,width=13.5,height=10.4,units="in",bg="white")
 cat("CREATED ",file,"\n",sep="")
}
create_figure("breakfast_rate","Breakfasts per 100 modeled attended student-days",
              "Figure 1. Breakfast by school and grade — Lodi, 2025–26",
              "01_breakfast_absence_adjusted_R",100,seq(0,100,20))
create_figure("lunch_rate","Lunches per 100 modeled attended student-days",
              "Figure 2. Lunch by school and grade — Lodi, 2025–26",
              "02_lunch_absence_adjusted_R",100,seq(0,100,20))
create_figure("combined_rate","Breakfasts and lunches per modeled attended student-day",
              "Figure 3. Breakfast and lunch combined — Lodi, 2025–26",
              "03_combined_absence_adjusted_R",2,seq(0,2,.5),
              " A value of 1.0 represents one meal per estimated attendance day on average.")
cat("CHECKS PASSED: 31 schools; 186 grade rows; Kindergarten days ",
    format(round(sum(k$modeled_attended_student_days),3),nsmall=3),
    "; K breakfast ",round(sum(k$breakfast_meals)/sum(k$modeled_attended_student_days)*100,4),
    "; K lunch ",round(sum(k$lunch_meals)/sum(k$modeled_attended_student_days)*100,4),"\n",sep="")
