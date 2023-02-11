################# EMPLOYEE ID - PREPARING SPACE FOR THE LOOK HERE DUMMY DATA #################
## This is version 10 of the "look here dummy data" generator own project.  For the most updated code and to understand the context go here: https://github.com/LookHere/Look-Here-Dummy-Data
## This project is developed to be very easy for beginner users to run and integrate into projects.  As such, it does not require any libraries, each demographic is modular (doesn't rely on any other demographic), and the code is very basic with very heavy commenting. 

## Please enter the number of employees you'd like it to generate, the earliest start date, and how many years of data you'd like (anyone with a term date after today is considered active and the term date is removed).
Headcount <- 2000
EarliestStartDate <- "2018-01-01"
YearsOfData <- 5

## Set the working directory.  This is where you'll put the categories.csv (which determains the demographics you want) and will be where the output file is created.
setwd("C:/CompensationScience/LookHereDummyData")

## This code uploads the csv file "categories.csv" where you enter the demographics you want.  You can download a template for this file here: (https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/Categories.csv) and save that as a csv file in the working directory.
## Header = TRUE identifies the first row as the column names
Categories <- read.csv("Categories.csv", header = TRUE)

## This code pulls in the list of names
NameDatabase <- read.csv("NameDatabase.csv", header = TRUE)

## Generates Employee ID Numbers for everyone
## For Employee IDs (sometimes known as EmplID) it's best practice to start headcounts at a very large number like 10,000,000 so there is never a leading zero.  Don't make the ID numbers related to anything (ex. all contractors start with a 9 and all full time workers start with a 1) because that breaks when someone transfers.
EmployeeID <- seq(from = 10000000, to = 10000000 + Headcount -1)

## Creates a dataframe with just the employee ID numbers.  
## Everything will be moved into this as it's built.  
LHDD <- data.frame(EmployeeID)


################# DATES - CREATING DATE RECORDS #################

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

## Identifies if what was entered by the users is a female or male . This is useful later when we connect names to them.
## Everyone is considered non-binary unless specifically identified as female or male.

# Lists of words that refer to females
WomanWords <- c('female',  'woman',  'lady',  'girl',  'madam',  'gentlewoman',  'madame',  'dame',  'gal',  'maiden',  'grua',  'emakume',  'жанчына',  
                'žena',  'жена',  'dona',  'donna',  'žena',  'žena',  'kvinde',  'vrouw',  'naine',  'nainen',  'femme',  'frou',  'muller',  'Frau',  'γυναίκα',  
                'gynaíka',  'nő',  'Kona',  'bean',  'donna',  'sieviete',  'moteris',  'Fra',  'жена',  'mara',  'kvinne',  'kobieta',  'mulher',  'femeie',  
                'женщина',  'zhenshchina',  'boireannach',  'жена',  'zhena',  'žena',  'ženska',  'mujer',  'kvinna',  'хатын-кыз',  'zhinka',  'Жінка',  'fenyw',  
                'פרוי',  'կին',  'qadın',  'নারী',  '女人',  'nǚrén',  'ქალი',  'સ્ત્રી',  'महिला',  'poj niam',  '女性',  'ಮಹಿಳೆ',  'әйел',  'ស្ត្រី',  'yeoja',
                '여자',  'аял',  'ແມ່ຍິງ',  'സ്ത്രീ',  'स्त्री',  'эмэгтэй',  'မိန်းမ',  'महिला',  'ମହିଳା',  'ښځه',  '.ਰਤ',  'عورت',  'කාන්තාවක්',  'зан',  'பெண்',  
                'మహిళ',  'หญิง',  'kadın',  'aýal',  'عورت',  'ئايال',  'ayol',  'đàn bà',  'امرأة' ,'אִשָׁה', 'jin', 'زن', 'vrou', 'ሴት', 'mkazi', 'mace', 'nwaanyị'
                , 'umugore', 'mosali', 'mukadzi', 'naag', 'mwanamke', 'umfazi', 'obinrin', 'owesifazane', 'babaye', 'babae', 'wahine', 'wanita', 'wédok', 'vehivavy',
                'wanita', 'wahine', 'fafine', 'awéwé', 'virino', 'fanm', 'femina', 'imra ah')

# List of words that refer to males
ManWords <- c('male', 'man','guy','gentleman', 'dude', 'lad', 'fella', 'gent', 'njeri', 'gizon', 'чалавек', 'čovjek', 'мъж', 'home', 'omu', 'čovjek', 
              'muž', 'mand', 'man', 'mees', 'mies', 'homme', 'man', 'home', 'Mann', 'ándras', 'άνδρας', 'Férfi', 'Maður', 'fear', 'uomo', 'vīrietis', 'vyras', 
              'Mann', 'човек', 'bniedem', 'Mann', 'człowiek', 'homem', 'om', 'человек', 'chelovek', 'dhuine', 'chovek', 'човек', 'muž', 'Moški', 'hombre', 'man', 
              'кеше', 'מענטש', 'insan', 'মানুষ', 'rén', '人', 'კაცი', 'માણસ', 'आदमी', 'txiv neej', 'おとこ', 'ವ್ಯಕ್ತಿ', 'адам', 'បុរសម្នាក់', '남자', 'namja', 
              'адам', 'ຜູ້ຊາຍ', 'മനുഷ്യൻ', 'मनुष्य', 'хүн', 'လူကို', 'मानिस', 'ମଣିଷ', 'سړی', 'ਆਦਮੀ', 'ماڻهو', 'මිනිසා', 'одам', 'ஆண்', 'మనిషి', 'ชาย', 'adam', 'ada
             m', 'آدمی', 'man', 'kishi', 'Đàn ông', 'رجل', 'rajul', 'איש', 'مرد', 'man', 'ሰው', 'mwamuna', 'mutumin', 'nwoke', 'umuntu', 'monna', 'murume', 'nin', '
             mtu', 'umntu', 'ọkunrin', 'indoda', 'lalaki', 'lalaki', 'kāne', 'manusia', 'wong', 'olona', 'lelaki', 'tangata', 'tamaloa', 'lalaki', 'viro', 'nonm', 'homine')

# Create female and male data frames, with one column being "woman" and one "man", respective 
WomanDF <- data.frame(WomanWords,"woman")
ManDF <- data.frame(ManWords,"man")

# Rename the columns
names(WomanDF) <- c("GenderClean", "GenderStandard")
names(ManDF) <- c("GenderClean", "GenderStandard")

# Combine the two data frames
GenderWords <- rbind(WomanDF, ManDF)

# Look up each user entered gender and find the Standard equivalent

# Creates a column that's a lower case version of what the user entered (since our lookup table is lower case)
GenderLookup$GenderClean <- tolower(GenderLookup$GenderCategories) 
# Lookup the Standard equivalent gender based on what the user entered
GenderLookup <- merge(GenderWords, GenderLookup, by="GenderClean", all.y = TRUE)
# For anyone who isn't female or male, they are nonbinary
GenderLookup$GenderStandard[is.na(GenderLookup$GenderStandard)] <- "nonbinary"

# Delete the old files that are no longer needed
rm(WomanWords, ManWords, WomanDF, ManDF, GenderWords)
GenderLookup <- subset(GenderLookup, select = - c(GenderClean))  
# Reorder the columns
GenderLookup <- GenderLookup[ , c(2, 3, 4, 1)] 
# Reorder the rows
GenderLookup <- GenderLookup[order(GenderLookup$GenderRunning), ]

### Creates an Standard Gender for everyone

## Defaults all records to the first demographic
LHDD$GenderStandard<-GenderLookup[1,4]
## Runs a "for loop" the same number of times as there are types of demographic categories listed, starting with the second category (since the first is already the category for every row)
for (val in 2:nrow(GenderLookup))
{
  ## Checks to see if the Random is greater than the Running Total of one record earlier; if it is overwrite that with the current demographic
  LHDD$GenderStandard <- ifelse(LHDD$GenderRand>GenderLookup[val-1,3], GenderLookup[val,4],LHDD$GenderStandard)
}

### Creates a gender for everyone based on the user's terms

## Defaults all records to the first demographic
LHDD$Gender<-GenderLookup[1,1]
## Runs a "for loop" the same number of times as there are types of demographic categories listed, starting with the second category (since the first is already the category for every row)
for (val in 2:nrow(GenderLookup))
{
  ## Checks to see if the Random is greater than the Running Total of one record earlier; if it is overwrite that with the current demographic
  LHDD$Gender <- ifelse(LHDD$GenderRand>GenderLookup[val-1,3], GenderLookup[val,1],LHDD$Gender)
}


## Deletes the randomizer since we are done using it
LHDD <- subset(LHDD, select = - c(GenderRand))  


################# CREATING RACE RECORDS #################
## The racial categorization is based on the United States Department of Labor's Equal Employment Opportunity breakdown https://www.dol.gov/agencies/ofccp/faqs/EEO-Tab-FAQs#Q5

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


################# CREATING DEPARTMENT RECORDS #################
## Departments and Divisions are unique to each organization.  This is a basic example to make understanding easier.

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



################# CREATING JOB LEVELS AND COMPENSATION #################
## Job levels are common in organizations differentiating the hierarchy.  The compensation generated is based on a bell curve around the target pay.

## Create a data frame based on the ratios in the categories.csv document
JobLevelLookup <- data.frame(JobLevel = Categories$JobLevel, JobLevelRatio = Categories$JobLevelRatio)
## Remove the blank rows
JobLevelLookup <- JobLevelLookup[complete.cases(JobLevelLookup),]
## Change the ratios from text to numbers
JobLevelLookup$JobLevelRatio <- as.numeric(JobLevelLookup$JobLevelRatio)
## If the ratios don't add up to 100%, this makes them add up to 100%
JobLevelLookup$JobLevelRatio<- JobLevelLookup$JobLevelRatio/sum(JobLevelLookup$JobLevelRatio)
## Creates a running total to compare to the randomizer
JobLevelLookup$JobLevelRunning <- cumsum(JobLevelLookup$JobLevelRatio)
## Creates a random variable for each employee that will decide their Department
LHDD$JobLevelRand <- runif(Headcount, min=0, max=1)

## Defaults all records to the first demographic
LHDD$JobLevel<-JobLevelLookup[1,1]
## Runs a "for loop" the same number of times as there are types of demographic categories listed, starting with the second cattegory (since the first is already the category for every row)
for (val in 2:nrow(JobLevelLookup))
{
  ## Checks to see if the Random is greater than the Running Total of one record earlier; if it is overwrite that with the current demographic
  LHDD$JobLevel <- ifelse(LHDD$JobLevelRand>JobLevelLookup[val-1,3], JobLevelLookup[val,1],LHDD$JobLevel)
}
## Deletes the randomizer since we are done using it
LHDD <- subset(LHDD, select = - c(JobLevelRand))  

## Create a lookup between JobLevel and JobLevelCompTarget
CompTargetLookup <- subset(Categories, select = c(JobLevel, JobLevelCompTarget))

## Brings in the JobLevelCompTarget
LHDD <- merge(LHDD, CompTargetLookup,   'JobLevel')

## Reorders the columns (moving JobLevel to the end) and rows (sorting by EmployeeID)
LHDD <- LHDD[ , c( 2:ncol(LHDD),1)]
LHDD <- LHDD[order(LHDD$"EmployeeID"),]


## For every row, increase or decrease the compensation target by a random amount and then round to the nearest thousand
## rnorm creates 1 random number around 0 with a standard deviation of 0.1
for(i in 1:nrow(LHDD)) {
  LHDD$JobLevelCompTarget[i] <- LHDD$JobLevelCompTarget[i] + LHDD$JobLevelCompTarget[i] * rnorm(1, 0, 0.1)
  LHDD$JobLevelCompTarget[i]<- round(LHDD$JobLevelCompTarget[i], digits = -3)
}

################# NAME AND LOCATION #################
## This code creates a name and location for each employee.  The name and location are connected, but this is (purposely) not correlated to race.
## The list of names and countries is just what was easily found on the internet. It is in no way balanced so some countries are over represented.  
## As with some live data, the format of the names is inconsistent between locations. Also some locations have names in the origonal character script.


## Creates a random variable for each employee that will decide their Name
LHDD$NameRand <- runif(Headcount, min=0, max=1)

## If there is no "Male" and "Female" gender already created, it defaults everyone to NonBinary so the names will be pulled randomly without regard to gender

##########################~~~~~~~~~~~~~ Change gender to GenderStandard   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if ('Gender' %in% names(LHDD) && any(LHDD$Gender=="Male") && any(LHDD$Gender=="Female")) {
    LHDD$TempGender <- LHDD$Gender
  } else {
    LHDD$TempGender <- "NonBinary"
  }

## Sort the name database by location and gender
NameDatabase <- NameDatabase[with(NameDatabase, order(Gender,Country)),]

## Find the first and last row number for the female, male, and non-binary populations
MinFemale <- min(which(NameDatabase$Gender == 'Female'))
MaxFemale <- max(which(NameDatabase$Gender == 'Female'))
DiffFemale <- MaxFemale - MinFemale 

MinMale <- min(which(NameDatabase$Gender == 'Male'))
MaxMale <- max(which(NameDatabase$Gender == 'Male'))
DiffMale <- MaxMale - MinMale

MinNonB <- min(MinFemale, MinMale)
MaxNonB <- max(MaxFemale, MaxMale)
DiffNonB <- MaxNonB - MinNonB

## Create a lookup table with the min and max for each category
NameLookup <- data.frame (Female = c(MinFemale, MaxFemale, DiffFemale),
                          Male = c(MinMale, MaxMale, DiffMale),
                          NonBinary = c(MinNonB, MaxNonB, DiffNonB)
                          )

## Look at the gender of each row, and return a name and location for that gender
for(i in 1:nrow(LHDD)) {
  ## Find the gender of the person on this row 
  RowGender <- LHDD$TempGender[i]
  ## Use the gender to find the min and max rows to use from the NameLookup
  NameMin <- NameLookup[1,RowGender]
  NameDiff <- NameLookup[3,RowGender]
  ## To find a random name over the range decided, multiply the random number by the difference between the max and min.  Then add it to the min and round down to the nearest integer.
  NameRow <- round((LHDD$NameRand[i] * NameDiff) +  NameMin, digits = 0)
  ## Use the NameRow to pull in the information from the right row of the NameDatabase
  LHDD$NameFirst[i] <- NameDatabase$Name[NameRow]
  LHDD$NameFirstOrigCharacter[i] <- NameDatabase$OrigCharacter[NameRow]
  LHDD$Location[i] <- NameDatabase$Country[NameRow]
}

## Deletes the randomizer and temp gender since we are done using them
LHDD <- subset(LHDD, select = - c(NameRand, TempGender)) 

################# EXPORT TO CSV #################

## This will export the final file into the working directory you set in the first step.  It will create a new file (or overwrite the current file) called "OutputLookHereDummyData.csv". 
write.csv(LHDD,"OutputLookHereDummyData.csv", row.names = TRUE)
