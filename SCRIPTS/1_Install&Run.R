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

fmap.use <- read.csv("DATA/fisheriesmap.csv")
pathcmz.use  <- "DATA/catchDistribution_CMZ.csv"


#CTC Users: can get info straight from the CAS database 
pathdb.use <- "C:/Users/worc/Documents/CTC/ream/devs/testtxt/CASClient_2019_BE.mdb"

# External Users: need to get a CAS csv file generated 
# via readcasdbsplit(pathdb) by a CTC member
cas.use <-read.csv("DATA/casdf.csv")




} # end calcMonthly()


test <- calcMonthly(stk = "ATN", fmap = fmap.use,
                        pathdb = NULL, # either give pathdb OR cas
                        cas =   cas.use, 
                        pathcmz = pathcmz.use,
                        tracing = FALSE)

write.csv(test,"TEMP/test.csv")








