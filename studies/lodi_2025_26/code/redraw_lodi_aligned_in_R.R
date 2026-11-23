#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(ggplot2))
args <- commandArgs(trailingOnly=TRUE)
input <- if(length(args)>=1) args[[1]] else "studies/lodi_2025_26/outputs/lodi_31_school_grade_meal_census_for_R.csv"
out <- if(length(args)>=2) args[[2]] else "lodi_r_rendered_figures"
dir.create(out, recursive=TRUE, showWarnings=FALSE)
d <- read.csv(input, colClasses=c(cds="character",school="character"), check.names=FALSE)
grades <- c("K","1","2","3","4","5")
stopifnot(nrow(d)==31L,!anyDuplicated(d$cds),all(nchar(d$cds)==14))
stopifnot(all(unlist(lapply(c("breakfast","lunch","enroll"), function(x) paste0(x,"_",grades)))%in%names(d)))
long <- do.call(rbind,lapply(grades,function(g) data.frame(
 school=d$school,cds=d$cds,grade=g,
 breakfast=d[[paste0("breakfast_",g)]],
 lunch=d[[paste0("lunch_",g)]],
 enrolled=d[[paste0("enroll_",g)]]
)))
stopifnot(nrow(long)==186L,all(long$enrolled>0),!anyNA(long))
stopifnot(sum(long$breakfast[long$grade=="K"])==70667,
          sum(long$lunch[long$grade=="K"])==203639)
stopifnot(all(sapply(c("2","3","4","5"),function(g)sum(long$enrolled[long$grade==g]))==c(1885,1972,2025,2003)))
long$breakfast_rate <- 100*long$breakfast/(long$enrolled*180)
long$lunch_rate <- 100*long$lunch/(long$enrolled*180)
long$combined_rate <- (long$breakfast+long$lunch)/(long$enrolled*180)
long$grade <- factor(long$grade,levels=grades)
schools <- sort(unique(long$school))
long$school <- factor(long$school,levels=rev(schools))
# Angela's exact Ventura grade palette, preserved across figures.
ventura <- c(K="#C62828",`1`="#42A5F5",`2`="#26A69A",`3`="#66BB6A",`4`="#00897B",`5`="#00569B")
grade_labels <- c(K="Kindergarten",`1`="Grade 1",`2`="Grade 2",`3`="Grade 3",`4`="Grade 4",`5`="Grade 5")
lab <- function(z) {
 z<-sub(" Elementary School$","",z)
 z<-sub(" Elementary$","",z)
 z<-sub("^George Lincoln Mosher","G. Lincoln Mosher",z)
 z<-sub("^George Washington","G. Washington",z)
 z<-sub("^Ellerth E. Larson","E. E. Larson",z)
 z<-sub("^Clyde W. Needham","C. W. Needham",z)
 sub("^Lois E. Borchardt","L. E. Borchardt",z)
}
render <- function(metric,axis,title,file,limit,ticks) {
 older <- long[long$grade!="K",,drop=FALSE]
 kinder <- long[long$grade=="K",,drop=FALSE]
 p <- ggplot(long,aes(x=.data[[metric]],y=school,color=grade))+
   geom_hline(yintercept=seq_along(schools),color="#E1E7E9",linewidth=.25)+
   geom_point(data=older,size=2.8,alpha=.78,position="identity")+
   geom_point(data=kinder,size=3.8,alpha=.97,position="identity")+
   scale_color_manual(values=ventura,breaks=grades,labels=grade_labels,drop=FALSE)+
   scale_y_discrete(labels=lab,drop=FALSE)+
   scale_x_continuous(limits=c(0,limit),breaks=ticks,expand=expansion(mult=c(.008,.02)))+
   labs(x=axis,y=NULL,color=NULL,
        caption=paste0(title,"\nEach dot shows one grade at one school; all six grades share one horizontal row.\n",
        "Rates use reported meals / (2025–26 CDE Census enrollment × 180 assumed days).\n",
        "These are not observed attendance rates or shares of distinct students. Preschool is excluded."))+
   guides(color=guide_legend(nrow=1,override.aes=list(size=3.6,alpha=1)))+
   theme_minimal(base_size=11)+theme(
    panel.grid.major.y=element_blank(),panel.grid.minor=element_blank(),
    panel.grid.major.x=element_line(color="#E8EDEF",linewidth=.35),
    axis.text.y=element_text(size=8.9,color="#354249"),
    axis.text.x=element_text(size=9.5,color="#46555E"),
    axis.title.x=element_text(size=11,color="#354249",margin=margin(t=8)),
    legend.position="top",legend.justification="center",
    legend.text=element_text(size=10),
    plot.caption.position="plot",
    plot.caption=element_text(hjust=0,color="#37434A",size=8.9,lineheight=1.25,margin=margin(t=15)),
    plot.margin=margin(t=8,r=18,b=10,l=10))
 ggsave(file.path(out,paste0(file,".png")),p,width=13.4,height=10.5,units="in",dpi=240,bg="white")
 ggsave(file.path(out,paste0(file,".pdf")),p,width=13.4,height=10.5,units="in",bg="white")
 cat("CREATED",file,"\n")
}
render("breakfast_rate","Breakfasts per 100 assumed enrollment-days",
 "Figure 1. Lodi Unified: breakfast by school and grade (2025–26)","01_breakfast_R",100,seq(0,100,20))
render("lunch_rate","Lunches per 100 assumed enrollment-days",
 "Figure 2. Lodi Unified: lunch by school and grade (2025–26)","02_lunch_R",100,seq(0,100,20))
render("combined_rate","Breakfasts and lunches per assumed enrollment-day",
 "Figure 3. Lodi Unified: breakfast and lunch combined (2025–26)","03_combined_R",2,seq(0,2,.5))
cat("CHECKS PASSED:",length(schools),"schools;",nrow(long),"school-grade comparisons\n")
