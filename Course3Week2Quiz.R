#Q1
#Register an application with the Github API here 
#https://github.com/settings/applications. Access the API to get information
#on your instructors repositories 
#(hint: this is the url you want 
#"https://api.github.com/users/jtleek/repos"). 
#Use this data to find the time that the datasharing repo was created. 
#What time was it created?
#This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). You may also need to run the code in the base R package and not R studio.

#Sadly and happily, I found quiz answers here:
# from https://rpubs.com/ninjazzle/DS-JHU-3-2-Q2
#"2013-11-07T13:25:07Z"

library(httr)
oauth_endpoints("github")

#Register an application at https://github.com/settings/applications
myapp <- oauth_app("github",
                   key = "75ffc4989df8001de43a",
                   secret = "389877827ca7031f4586a37206816ec5152088dc")
#Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

#use api
req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
output <- content(req)

#Find “datasharing”
datashare <- which(sapply(output, FUN=function(X) "datasharing" %in% X))
datashare

#Find the time that the datasharing repo was created.
list(output[[15]]$name, output[[15]]$created_at)

#"created_at": "2013-11-07T13:25:07Z", #I found just by looking at raw

#---------------------------------------------------------------------

#Q2
#The sqldf package allows for execution of SQL commands on R data frames. 
#We will use the sqldf package to practice the queries we might send 
#with the dbSendQuery command in RMySQL.
#Download the American Community Survey data and load it into an 
#R object called acs

q2url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
#Which of the following commands will select only the data for the 
#probability weights pwgtp1 with ages less than 50?

#0. Install Rtools40  YOu must download an exe file and run it
# rtools40 is only needed build R packages with C/C++/Fortran code from source
# execute library(devtools)  (to check?)
#1. Install MySQL - 
#2, Restart R andd execute install.packages('RMySQL',type='source') at the R prompt.
#  execute library(RMySQL)
# install.packages("sqldf")
# library(sqldf)

download.file(q2url, destfile = "./data/acs.csv")
acs <- read.table("./data/acs.csv",sep = ',',header = TRUE)
#x1 <- sqldf("select pwgtp1 from acs")
x2 <- sqldf("select pwgtp1 from acs where AGEP < 50")  #answer
#x3 <- sqldf("select * from acs")  
#x4 <- sqldf("select * from acs where AGEP < 50")

  
#Q3-------------------------------------------------------------
#  Using the same data frame you created in the previous problem, what is
#the equivalent function to unique(acs$AGEP)

head(unique(acs$AGEP))
head(sqldf("select distinct AGEP from acs"))  #answer
#head(sqldf("select distinct pwgtp1 from acs"))

#Q4---------------------------------------------------------------
#How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
# http://biostat.jhsph.edu/~jleek/contact.html
#(Hint: the nchar() function in R may be helpful)

htmlUrl <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(htmlUrl)
close(htmlUrl)

head(htmlCode)
ans4html <-c(nchar(htmlCode[10]), nchar(htmlCode[20]), 
             nchar(htmlCode[30]), nchar(htmlCode[100]))d

#ans is [1] 45 31  7 25

#Q5------------------------------------------------------
#Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
#https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
#Original source of the data:
#http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
#(Hint: this is a fixed width file format), so read.fwf()

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
SST <- read.fwf(fileUrl, skip=4, widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))
head(SST)
sum(SST[,4])   #should be 32426.7
