# SCRIPT TO INSTALL & RUN THE ERAMONTH PACKAGE FUNCTIONS


# ------------------------------------------------------
# INSTALL & LOAD PACKAGES

library(devtools)

library(remotes)
        
if(TRUE){
#url.use <- "https://gitlab.com/SOLV-Code/eramonth.git"  # -> not working?
url.use <- "https://gitlab.com/catarinawor/eramonth.git" # working
remotes::install_git(url = url.use)
}

library(eramonth)
library(tidyverse)





# ------------------------------------------------------
# INPUTS

# generate the fisheries mapping from the input files (Specific for the IDI project)

fmap.use.idi  <- read.csv("DATA/Ck_CFile2ERA_Match.csv",stringsAsFactors = FALSE) %>%
                  left_join(read.csv("DATA/Ck_Fishery_Matches.csv", stringsAsFactors = FALSE), by="ERANO") %>%
                  select(CFILENO,IDI_Group) %>%
                  arrange(IDI_Group)

# check for missing matches
if(sum(is.na(fmap.use.idi$IDI_Group))>0){warning("Some missing matches between CFILENO and IDI grouping")}
str(fmap.use.idi)
write.csv(fmap.use.idi,"DATA/fmap_use_IDI.csv",row.names = FALSE)

#CTC Users: can get info straight from the CAS database 
pathdb.use <- "C:/Users/worc/Documents/CTC/ream/devs/testtxt/CASClient_2019_BE.mdb"

# External Users: need to get a CAS csv file generated via readcasdbsplit(pathdb) by a CTC member
cas.in <-read.csv("DATA/casdf.csv",stringsAsFactors = FALSE)

# run all stocks and fishery groupings
monthly.idi <- calcMonthly(fmap = fmap.use.idi,
                        pathdb = NULL, # either give pathdb OR cas!!!!
                        cas =   cas.in,
                        tracing = FALSE,
                        infill = TRUE)

head(monthly.idi)
write.csv(monthly.idi,"OUTPUT/1_MonthlySplit_IDI_Group.csv",row.names = FALSE)

sort(unique(monthly.idi$Recovery_Year))


# test the plots
plotMonthly(monthly.df = monthly.idi,stk="ATN",fgroup = "ISBM_CBC_Term_N",type="basic")
plotMonthly(monthly.df = monthly.idi,stk="ATN",fgroup = "ISBM_CBC_Term_N",type="box")


# run all the plots
stk.list <- sort(unique(monthly.idi$Stock))
fgroup.list <- sort(unique(monthly.idi$Fishery_Group))


for(stk in stk.list){
print(stk)
pdf(paste0("OUTPUT/MonthlySplit_",stk,".pdf"),onefile = TRUE,height=8.5, width=11)  
par(mfrow=c(2,3))
for(fgroup in fgroup.list){

#print(fgroup)
  
plot.do <- dim(monthly.idi %>% dplyr::filter(Stock == stk,Fishery_Group == fgroup))[1] >0
if(plot.do){plotMonthly(monthly.df = monthly.idi,stk=stk,fgroup = fgroup,type="box")}
}    

dev.off()  
}






