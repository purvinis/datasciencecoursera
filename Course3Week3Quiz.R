library(dplyr)
library(tidyr)

#Q1
#The American Community Survey distributes downloadable data about United States 
#communities. Download the 2006 microdata survey about housing for the state of
#Idaho using download.file() from here:
c3w3q1Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
#and load the data into R. The code book, describing the variable names is here:
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#Create a logical vector that identifies the households on greater than 10 acres 
#who sold more than $10,000 worth of agriculture products. Assign that logical 
#vector to the variable agricultureLogical. Apply the which() function like 
#this to identify the rows of the data frame where the logical vector is TRUE.
#which(agricultureLogical)
#What are the first 3 values that result?

download.file(c3w3q1Url,destfile = "./data/acsIdaho.csv")
acsIdaho <- read.table("./data/acsIdaho.csv",sep = ',',header = TRUE)
head(acsIdaho)
#ACR - acreage, ==3 for > 10 acres
#AGS - agricultural sales  == 6 for >$10000 of ag sales
acsIdaho <- select(acsIdaho,ACR,AGS)
ans1 <-acsIdaho[which(acsIdaho$ACR ==3 & acsIdaho$AGS ==6),]
print(head(ans1))   # 125, 238, 262

#Q2-------------------------------------------------------------
#Using the jpeg package read in the following picture of your instructor into R
c3w3q2Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
#Use the parameter native=TRUE. What are the 30th and 80th quantiles 
#of the resulting data? (some Linux systems may produce an answer 638 
#different for the 30th quantile)

install.packages("jpeg")
library(jpeg)
