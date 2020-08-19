library(dplyr)
library(tidyr)
remove.packages ("tidyverse")
#library(tidyverse)

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
download.file(c3w3q2Url,destfile = "./data/jeff.jpg", mode = "wb") #'wb' is binary
jeff <- readJPEG("./data/jeff.jpg",native = TRUE)
str(jeff)
quantile(jeff,c(0.3,0.8)) #-15258512 -10575416 

#Q3
#Load the Gross Domestic Product data for the 190 ranked countries in this data set:
gdbUrl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
#Load the educational data from this data set:
educUrl <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
#Match the data based on the country shortcode. How many of the IDs match? 
#Sort the data frame in descending order by GDP rank (so United States is last). 
#What is the 13th country in the resulting data frame?
 #Original data sources:
 # http://data.worldbank.org/data-catalog/GDP-ranking-table
#http://data.worldbank.org/data-catalog/ed-stats

download.file(gdbUrl,"./data/GDPdata.csv")
download.file(educUrl,"./data/eduData.csv")
gdb <-read.csv("./data/GDPdata.csv")
edu <-read.csv("./data/eduData.csv")

head(gdb)  #X is the column factor for the country code
head(edu)  #CountryCode is the column factor

#
# https://rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
colnames(gdb)
colnames (edu)
#rename(gdb,X = "CountryCode")
names(gdb)[1] <-"CountryCode"
oneset <-inner_join(gdb,edu,by = "CountryCode")  #one dataset by CountryCode
oneset <- filter(oneset,!Gross.domestic.product.2012 %in% "")

oneset <- arrange(oneset,desc(as.numeric(Gross.domestic.product.2012)))

matches <-length(oneset[,1])  
#returns 189. THe rankings go to 190. 178 is repeated twice
print(oneset[13,1:4])
#13         KNA                         178  NA St. Kitts and Nevis


#Q4--------------------------------------------------------
# What is the average GDP ranking for the 
#"High income: OECD" and "High income: nonOECD" group?
# column is Income.Group

newset <- oneset %>% 
  select(CountryCode,Gross.domestic.product.2012,Income.Group) %>%
  spread(Income.Group,Gross.domestic.product.2012,fill = NA) %>%
  select(2:3)

meannonOECD <- mean(as.numeric(na.omit(newset[,1]))) #91.91304
meanOECD <-  mean(as.numeric(na.omit(newset[,2]))) #32.96667

#Q5-----------------------------------------------------
#Cut the GDP ranking into 5 separate quantile groups. 
#Make a table versus Income.Group. How many countries
#are Lower middle income but among the 38 nations with highest GDP?

income_sets <- oneset %>% 
  select(CountryCode,Gross.domestic.product.2012,Income.Group) %>%
  spread(Income.Group,Gross.domestic.product.2012,fill = NA) 

lowerset <-income_sets %>%
  select(CountryCode,`Lower middle income`)

dgpgroups <-quantile(as.numeric(oneset$Gross.domestic.product.2012),probs = seq(0,1,0.2))
  
highest38 <- oneset[(1:(190-dgpgroups[5])),1:2]
commoncountry <-inner_join(lowerset,highest38,by = "CountryCode")
completed <- na.omit(commoncountry)  #16

#answer is 5, but I"m not getting this
