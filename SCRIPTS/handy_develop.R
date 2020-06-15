#=========================================================================
#handy scripts to be ran during development 
#do not expect any organization or documentation in this file
#=========================================================================

setwd("C:/Users/worc/Documents/CTC/eramonth_proj/eramonth")
devtools::document()
devtools::build()
path.install <- "C:/Users/worc/Documents/CTC/eramonth_proj/eramonth_0.0.0.9000.tar.gz"

system(paste0("Rcmd.exe INSTALL --preclean --no-multiarch --with-keep.source ", path.install))



url.use <- "https://gitlab.com/catarinawor/eramonth.git" # working
remotes::install_git(url = url.use)
library(tidyverse)
library(eramonth)


fmap.use.idi  <- read.csv("../DATA/Ck_CFile2ERA_Match.csv",stringsAsFactors = FALSE) %>%
                  left_join(read.csv("../DATA/Ck_Fishery_Matches_cat.csv", stringsAsFactors = FALSE), by="ERANO") %>%
                  select(CFILENO,IDI_Group) %>%
                  arrange(IDI_Group)
length(unique(fmap.use.idi$IDI_Group))

if(sum(is.na(fmap.use.idi$IDI_Group))>0){warning("Some missing matches between CFILENO and IDI grouping")}
#str(fmap.use.idi)
write.csv(fmap.use.idi,"../DATA/fmap_use_IDI.csv",row.names = FALSE)
#summary(fmap.use.idi)
pathdb.use <- "C:/Users/worc/Documents/CTC/ERA/2020/CASClient_2020_BE.mdb"

monthly.idi <- calcMonthly(fmap = fmap.use.idi,
                        pathdb = pathdb.use, # either give pathdb OR cas!!!!
                        tracing = FALSE,
                        infill = TRUE)

cmz.path <- "C:/Users/worc/Documents/CTC/ERA/2020/mortality_distribution_table/MDT_CADdetail/mdtresult/catchDistribution_CMZ.csv"
cmz <- read.csv(cmz.path, stringsAsFactors =FALSE)


moncyer <- calmmoncyer(monthly.idi=monthly.idi, cmzpath=cmz.path)
write.csv(moncyer,"../DATA/moncyer.csv",row.names = FALSE)



names(monthly.idi)
unique(monthly.idi$Fishery_Group)

length(names(cmz)[4:ncol(cmz)])
length(unique(monthly.idi$Fishery_Group))


cbind(
sort(names(monthly.idi)),
sort(unique(monthly.idi$Fishery_Group)))

excludedfis<- names(cmz)[4:ncol(cmz)][is.na(match(names(cmz)[4:ncol(cmz)],unique(monthly.idi$Fishery_Group) ))]

fmap.use.idi[fmap.use.idi$IDI_Group %in%excludedfis,]


names(cmz)[4:ncol(cmz)]

unique(tt)[match(unique(tt),names(cmz)[4:ncol(cmz)])]

length(names(cmz)[4:ncol(cmz)])
length(unique(monthly.idi$Fishery_Group))

length(unique(tt))


fishmatch2<-cbind(
    unique(monthly.idi$Fishery_Group)[match( names(cmz)[4:ncol(cmz)],unique(monthly.idi$Fishery_Group) )], 
    names(cmz)[4:ncol(cmz)])

fishmatch<-cbind(
  names(cmz)[4:ncol(cmz)][match(unique(monthly.idi$Fishery_Group), names(cmz)[4:ncol(cmz)]  )],
  unique(monthly.idi$Fishery_Group))

fishmatch[,2][is.na(fishmatch[,1])]

fishmatch2[,2][is.na(fishmatch2[,1])]


dim(moncyer)
head(moncyer)

#====================================
caddf <- readcasdbsplit(pathdb.use)

dim(casdf)
dim(caddf2)

summary(caddf)
sort(unique(casdf$CFileFishery_Id))

caddf[caddf$Total_Expanded<0,]

monthly.idi[monthly.idi$monthtotal<0,]


head(monthly.idi)
?merge
write.csv(monthly.idi,file = "../data/avgCYERmon.csv", row.names=FALSE)
plotMonthly(monthly.df = monthly.idi,stk="ATN",fgroup = "ISBM_CBC_Term_N",type="basic")
plotMonthly(monthly.df = monthly.idi,stk="ATN",fgroup = "ISBM_CBC_Term_N",type="box")


cmz <- read.csv("C:/Users/worc/Documents/CTC/ERA/2020/mortality_distribution_table/MDT_CADdetail/mdtresult/catchDistribution_CMZ.csv",
	stringsAsFactors =FALSE)
head(cmz)


a <- reshape(cmz, direction = "long", varying=list(4:ncol(cmz)),timevar = "fisheries", v.names = "value")
a$fisheries_name <- colnames(cmz)[4:ncol(cmz)][a$fisheries]

a <- a[a$CatchYear>2008,]
a <- a[a$MortType == "TM",]


summary(a[a$fisheries_name == "TERM_SthUS_All",])
head(a)



aa<- dplyr::left_join(monthly.idi, a, by=c("Stock" = "stock",
                                           "Recovery_Year" = "CatchYear", 
	                                      "Fishery_Group" = "fisheries_name"))

aa$moncyer <- aa$monprop * aa$value 


summary(aa)
unique(aa$Stock)
unique(a$stock)

cbind(sort(unique(monthly.idi$Fishery_Group)),
	sort(unique(fmap.use.idi$IDI_Group)),
	sort(unique(a$fisheries_name)))

head(aa[aa$Stock=="ATN",])


#=======================================
#old code

casstk <- unique(casdf$Stock)  

	unique(casdf$CFileFishery_Name)

match(fmap$nameCMZ,names(cmz[,4:ncol(cmz)]))


casdf$nameCMZ <- fmap$nameCMZ[match(casdf$CFileFishery_Id, fmap$CFILENO)]

dbstk <- casdf[casdf$Stock=="ATN",]
summary(dbstk)

monthlycwt <- aggregate(dbstk$Total_Expanded, list(Stock=dbstk$Stock, Stock_Name=dbstk$Stock_Name, Recovery_Year=dbstk$Recovery_Year,  Recovery_Month=dbstk$Recovery_Month), sum)
yearlycwt <- aggregate(dbstk$Total_Expanded, list(Stock=dbstk$Stock,Stock_Name= dbstk$Stock_Name,  Recovery_Year=dbstk$Recovery_Year), sum)

monthlycwt$yeartotal <- yearlycwt$x[match(monthlycwt$Recovery_Year,yearlycwt$Recovery_Year )]

#these proportions need to be multiplied by the annual mortality. 
monthlycwt$monprop <- monthlycwt$x/monthlycwt$yeartotal 



rmarkdown::render('plotCYER.Rmd', encoding = 'UTF-8')
rmarkdown::render('plotCYER_allyears.Rmd', encoding = 'UTF-8')



#



#
#
#
#

#
#
#
#
#================================
#mapping cmz investigation


unique(cmz$stock)


harcmz <- cmz[cmz$stock=="HAR",]


names(harcmz)