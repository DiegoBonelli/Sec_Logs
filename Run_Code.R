######################################################
######################################################
#  R Code to retrieve SEC log files per months
#   
# Author: Diego Bonelli
# Date: 20/06/2021
# Notes: 
#
#
######################################################
######################################################

###########################################################################################################
### This file executes all functions necessary to download, and save all SEC log files                                
###########################################################################################################

# clear
rm(list = ls())

# misc
options(width = 135) # set console width
memory.limit(size=1e+13) # set limit

# load packages
library(data.table)
library(stringr)
library(pbapply)
library(plyr)
library(parallel)

# source functions
source("C:/Users/s14343/OneDrive - Norges Handelshøyskole/Skrivebord/SEC Log Files/functions.R")

# set directory
setwd("C:/Users/s14343/OneDrive - Norges Handelshøyskole/Skrivebord/SEC Log Files")

# set locations to save the csv or RData files
csv <- 'csv'
RData <- 'RData'

# create all folders if they do not exist
unlink(raw_filings_folder, recursive = TRUE)
if(!dir.exists(csv)) dir.create(csv)
if(!dir.exists(RData)) dir.create(RData)

# Get list
# List=GetList()

# Download all files each months 
DownloadAllMonthly(out_csv = csv,format = "csv",cl=1,out_RData=RData)

