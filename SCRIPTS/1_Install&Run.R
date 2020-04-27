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

# generate the fisheries mapping from the input files

fmap.use  <- read.csv("DATA/Ck_CFile2ERA_Match.csv",stringsAsFactors = FALSE) %>%
                  left_join(read.csv("DATA/Ck_Fishery_Matches.csv", stringsAsFactors = FALSE), by="ERANO") %>%
                  select(CFILENO,IDI_Group) %>%
                  arrange(IDI_Group)

# check for missing matches
if(sum(is.na(fmap.use$IDI_Group))>0){warning("Some missing matches between CFILENO and IDI grouping")}

str(fmap.use)

write.csv(fmap.use,"TEMP/fmap_use.csv",row.names = FALSE)






#pathcmz.use  <- "DATA/catchDistribution_CMZ.csv"

#CTC Users: can get info straight from the CAS database 
pathdb.use <- "C:/Users/worc/Documents/CTC/ream/devs/testtxt/CASClient_2019_BE.mdb"

# External Users: need to get a CAS csv file generated 
# via readcasdbsplit(pathdb) by a CTC member
cas.use <-read.csv("DATA/casdf.csv",stringsAsFactors = FALSE)






source("TEMP/FUNCTION_calcMonthly_TEMP.R")

test <- calcMonthlyTEMP(fmap = fmap.use,
                        pathdb = NULL, # either give pathdb OR cas
                        cas =   cas.use,
                        tracing = FALSE,
                        infill = TRUE)

head(test)
write.csv(test,"TEMP/test.csv",row.names = FALSE)


sort(unique(test$Recovery_Year))





