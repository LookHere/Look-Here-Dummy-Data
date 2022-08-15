## Please enter the number of employees you'd like it to generate, the earliest start date, and how many years of data you'd like (anyone with a term date after today is considered active).
Headcount <- 200
EarliestStartDate <- "2018-01-01"
YearsOfData <- 5

## Generates Employee ID Numbers for everyone
## It's best practice to start headcounts at a large number so there is never a leading zero
EmployeeID <- seq(from = 10000000, to = 10000000 + Headcount -1)

## Creates a dataframe with just the employee ID numbers.  
## Everything will be moved into this as it's built.  
## This will make it easier to see the data at any point.
LHDD <- data.frame(EmployeeID)

## Import categories.csv so it knows what demographics you wantt; header = TRUE puts the first row as the column names
Categories <- read.csv("D:/CompensationScience/LookHereDummyData/categories.csv", header = TRUE)


################# CREATING DATE RECORDS #################

## Creates a start date by starting with the EarliestStartDate and adding a random number to that between zero and (YearsOfData * 365.25 days in a year).
LHDD$StartDate <- as.Date(runif(Headcount, min=0, max=YearsOfData*365.25), origin=EarliestStartDate)

## Creates an end date by adding a number between zero and YearsOfData to the Start Date
LHDD$EndDate <- as.Date(runif(Headcount, min=0, max=YearsOfData*365.25), origin=LHDD$StartDate)
## If the end date is after today, blank it out (since the employee would still be active)


for(i in 1:nrow(LHDD)) {
  if (LHDD$EndDate[i ]>Sys.Date()) {
    LHDD$EndDate[i ] <- NA
  }
}


################# CREATING GENDER RECORDS #################
## Male/Female ratio is 51.9%/48.1% https://en.wikipedia.org/wiki/Human_sex_ratio
## Non-binary percentage in young adults is 3% https://www.pewresearch.org/fact-tank/2022/06/07/about-5-of-young-adults-in-the-u-s-say-their-gender-is-different-from-their-sex-assigned-at-birth/
## For more information on gender terms, see https://transequality.org/issues/resources/frequently-asked-questions-about-transgender-people

## Create a data frame based on the ratios in the categories.csv document
GenderLookup <- data.frame(GenderCategories = Categories$GenderCategories, GenderRatio = Categories$GenderRatio)
## Remove the blank rows
GenderLookup <- GenderLookup[complete.cases(GenderLookup),]
## Change the ratios from text to numbers
GenderLookup$GenderRatio <- as.numeric(GenderLookup$GenderRatio)
## If the ratios don't add up to 100%, this makes them add up to 100%
GenderLookup$GenderRatio<- GenderLookup$GenderRatio/sum(GenderLookup$GenderRatio)
## Creates a running total to compare to the randomizer
GenderLookup$GenderRunning <- cumsum(GenderLookup$GenderRatio)
## Creates a random variable for each employee that will decide their gender
LHDD$GenderRand <- runif(Headcount, min=0, max=1)

## Defaults all records to the first demographic
LHDD$Gender<-GenderLookup[1,1]
## Runs a "for loop" the same number of times as there are types of demographic categories listed, starting with the second cattegory (since the first is already the category for every row)
for (val in 2:nrow(GenderLookup))
  {
  ## Checks to see if the Random is greater than the Running Total of one record earlier; if it is overwrite that with the current demographic
  LHDD$Gender <- ifelse(LHDD$GenderRand>GenderLookup[val-1,3], GenderLookup[val,1],LHDD$Gender)
  }
## Deletes the randomizer since we are done using it
LHDD <- subset(LHDD, select = - c(GenderRand))  


################# CREATING Race RECORDS #################
## 

## Create a data frame based on the ratios in the categories.csv document
RaceLookup <- data.frame(RaceCategories = Categories$RaceCategories, RaceRatio = Categories$RaceRatio)
## Remove the blank rows
RaceLookup <- RaceLookup[complete.cases(RaceLookup),]
## Change the ratios from text to numbers
RaceLookup$RaceRatio <- as.numeric(RaceLookup$RaceRatio)
## If the ratios don't add up to 100%, this makes them add up to 100%
RaceLookup$RaceRatio<- RaceLookup$RaceRatio/sum(RaceLookup$RaceRatio)
## Creates a running total to compare to the randomizer
RaceLookup$RaceRunning <- cumsum(RaceLookup$RaceRatio)
## Creates a random variable for each employee that will decide their Race
LHDD$RaceRand <- runif(Headcount, min=0, max=1)

## Defaults all records to the first demographic
LHDD$Race<-RaceLookup[1,1]
## Runs a "for loop" the same number of times as there are types of demographic categories listed, starting with the second cattegory (since the first is already the category for every row)
for (val in 2:nrow(RaceLookup))
{
  ## Checks to see if the Random is greater than the Running Total of one record earlier; if it is overwrite that with the current demographic
  LHDD$Race <- ifelse(LHDD$RaceRand>RaceLookup[val-1,3], RaceLookup[val,1],LHDD$Race)
}
## Deletes the randomizer since we are done using it
LHDD <- subset(LHDD, select = - c(RaceRand))  


################# CREATING Department RECORDS #################
## 

## Create a data frame based on the ratios in the categories.csv document
DepartmentLookup <- data.frame(DepartmentCategories = Categories$DepartmentCategories, DepartmentRatio = Categories$DepartmentRatio)
## Remove the blank rows
DepartmentLookup <- DepartmentLookup[complete.cases(DepartmentLookup),]
## Change the ratios from text to numbers
DepartmentLookup$DepartmentRatio <- as.numeric(DepartmentLookup$DepartmentRatio)
## If the ratios don't add up to 100%, this makes them add up to 100%
DepartmentLookup$DepartmentRatio<- DepartmentLookup$DepartmentRatio/sum(DepartmentLookup$DepartmentRatio)
## Creates a running total to compare to the randomizer
DepartmentLookup$DepartmentRunning <- cumsum(DepartmentLookup$DepartmentRatio)
## Creates a random variable for each employee that will decide their Department
LHDD$DepartmentRand <- runif(Headcount, min=0, max=1)

## Defaults all records to the first demographic
LHDD$Department<-DepartmentLookup[1,1]
## Runs a "for loop" the same number of times as there are types of demographic categories listed, starting with the second cattegory (since the first is already the category for every row)
for (val in 2:nrow(DepartmentLookup))
{
  ## Checks to see if the Random is greater than the Running Total of one record earlier; if it is overwrite that with the current demographic
  LHDD$Department <- ifelse(LHDD$DepartmentRand>DepartmentLookup[val-1,3], DepartmentLookup[val,1],LHDD$Department)
}
## Deletes the randomizer since we are done using it
LHDD <- subset(LHDD, select = - c(DepartmentRand))  


################# EXPORT TO CSV #################

write.csv(LHDD,"D:/CompensationScience/LookHereDummyData/Example.csv", row.names = TRUE)


