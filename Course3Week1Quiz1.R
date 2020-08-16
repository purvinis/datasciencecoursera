#Q1 and Q2
#The dataset is about housing
#How many properties are worth $1,000,000 or more?  (VAL)
#Consider the variable FES in the code book. Which of the "tidy data" principles
#does this variable violate? represent marital status and employment together in one variable
#should be split

setwd("D:/Rwork/datasciencecoursera")
library(dplyr)  #already installed, just need to load
install.packages("data.table",dependencies = TRUE)
library(data.table)

q1url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

#Check for and create directory
if (!file.exists("data")){
  dir.create("data")
}

download.file(q1url, destfile = "./data/q1data.csv")
dateQ1Downloaded <- date()
dateQ1Downloaded  #"Sat Aug 15 13:19:24 2020"

housingData <-read.table("./data/q1data.csv",sep = ',',header = TRUE)
print(head(housingData))

housingValues <- select(housingData,VAL) %>% filter(VAL ==24)
ans1 <-nrow(housingValues)
print(paste(ans1,"number of houses over 1M"))

print(select(housingData,FES))

#-----------------------------------------------------------------
#Q3Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
#Read rows 18-23 and columns 7-15 into R and assign the result 
#to a variable called:dat
#What is the value of sum(dat$Zip*dat$Ext,na.rm=T)

Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_261')
install.packages('rJava')
library(rJava)
install.packages('xlsx')
library(xlsx)
q3url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx " 
download.file(q3url, destfile = "./data/q3data.xlsx",mode='wb')
dat <-read.xlsx("./data/q3data.xlsx",sheetIndex = 1 , rowIndex = 18:23,colIndex = 7:15)
ans3 <-sum(dat$Zip*dat$Ext,na.rm=T)
print(paste(ans3,"sum"))
#---------------------------------------------------------------
#Q4 Read the XML data on Baltimore restaurants from here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
#How many restaurants have zipcode 21231? 

install.packages("XML")
library(XML)
q4url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
#had to remove the s in https for this to work
BaltiDoc <- xmlTreeParse(q4url,useInternal = TRUE)
rootNode <- xmlRoot(BaltiDoc)
names(rootNode)
print(rootNode[[1]])
print(rootNode[[1]][[1]])
print(xmlSize(rootNode[[1]][[1]]))
listOfZips <-xpathSApply(rootNode,"//zipcode",xmlValue)
ans4 <- distinct(data.frame(listOfZips)) #number of distinct zipcodes (oops) =32
finalans4 <- sum(listOfZips == "21231")
print(paste(finalans4," restaurants in zip"))

#alternate
#sum(xpathSApply(rootNode,"//zipcode",xmlValue)=="21231)
#--------------------------------------------------------------


q5url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(q5url, destfile = "./data/q5data.csv")
DT <-fread( file = ,"./data/q5data.csv")
system.time(DT[,mean(pwgtp15,by=SEX)]) #uses dt features because you don't have to use $
#system.time(DT[DT$SEX==1,]$pwgtp15);mean(DT[DT$SEX==2,]$pwgtp15)#2 parts, slow
#system.time(tapply(DT$pwgtp15,DT$SEX,mean))# uses tappy
#system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])#bad code
#system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))#uses sapply and is fastest
#system.time(mean(DT$pwgtp15,by=DT$SEX))
