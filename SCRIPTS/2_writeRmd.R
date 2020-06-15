#==========================================
#Script to produce monthly CYER Rmd
#Author: Catarina Wor 
#Date May 2020
#==========================================

# directory where you want to save the Rmd
dash_dir <- "../Rmd/test.Rmd"

library(eramonth)
da <- read.csv("../data/moncyer.csv",stringsAsFactors=FALSE)
head(da)

moncyer<-"../data/moncyer.csv"

code <- paste0("da <- read.csv('",moncyer,"',stringsAsFactors=FALSE)\n",
	          "da <- da[ da$moncyer>0 & !is.na(da$moncyer) & 
               da$Fishery_Group != 'ESC_Home' &da$Fishery_Group != 'ESC_Stray_CA'
               & da$Fishery_Group != 'ESC_Stray_US',] \n")
 

write_dash_raster(fn= dash_dir,
	title="2009-2019 CYER by stock, fisheries and month",
	packs= c("eramonth","plotly","tidyverse"), 
	code= code) 


rmarkdown::render('../Rmd/plotCYER_allstocksgit push origin master
	.Rmd', encoding = 'UTF-8')



