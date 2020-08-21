library(dplyr)

#Q1-------------------------
#The American Community Survey distributes downloadable data about United States 
#communities. Download the 2006 microdata survey about housing for the state 
#of Idaho using download.file() from here:
c3w4Url <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
#and load the data into R. The code book, describing the variable names is here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#Apply strsplit() to split all the names of the data frame on the characters
#"wgtp". What is the value of the 123 element of the resulting list?

download.file(c3w4Url,destfile = "./data/acs.csv")
acsIdaho <- read.table("./data/acs.csv",sep = ',',header = TRUE)
head(acsIdaho)
acsnames <- names(acsIdaho)  #list of the names
splitNames <- strsplit(acsnames,"wgtp")
print(head(splitNames))
print(splitNames[123])  #[1] ""   "15"

#Q2------------------------------------------------
#Load the Gross Domestic Product data for the 190 ranked countries in this data set:
c3w4q2Url <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
#Remove the commas from the GDP numbers in millions of dollars and
#average them. What is the average?

download.file(c3w4q2Url,"./data/GDPdata.csv")
gdbstart <-read.csv("./data/GDPdata.csv",na.strings = c("", "NA")) #treat empty as NA
gdb <- gdbstart %>% filter(!is.na(as.numeric(Gross.domestic.product.2012))) #get 190 ranked
        #This makes a warnings about introducing NAs, but it works

gdb$X.3 <-gsub(",","",gdb$X.3)

ans <- mean(as.numeric(gdb$X.3))
print(ans)  #377652.4

#Q3--------------------------------------------------------------------
#In the data set from Question 2 what is a regular expression that would allow
#you to count the number of countries whose name begins with "United"? 
#Assume that the variable with the country names in it is named countryNames (X.2). 
#How many countries begin with United? 

grep("^United",gdbstart$X.2,value = TRUE)
#[1] "United States"        "United Kingdom"       "United Arab Emirates"

#Q4------------------------------------------------------------------
#Load the Gross Domestic Product data for the 190 ranked countries in this data set:
 # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv (done in Q2)
#Load the educational data from this data set:
educUrl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
#Match the data based on the country shortcode. Of the countries for which the 
#end of the fiscal year is available, how many end in June?

download.file(educUrl,"./data/eduData.csv")
edustart <-read.csv("./data/eduData.csv",na.strings = c("", "NA"))

names(gdbstart)[1] <-"CountryCode"
oneset <-inner_join(gdbstart,edustart,by = "CountryCode")  #one dataset by CountryCode

#The Special.Notes columns has fiscal year info
#If this info is avail, it is in the form: "Fiscal year end: March 31; reporting...."
#Search this column using grep

print(length(grep("^Fiscal year end: June",oneset$Special.Notes,value = TRUE)))
print(length(grep("June",oneset$Special.Notes,value = TRUE)))
