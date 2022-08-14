## Enter the number of employees you'd like it to generate
Headcount <- 20000

## Generate Employee ID Numbers for everyone
## It's best practice to start headcounts at a large number so there is never a leading zero
EmployeeID <- seq(from = 10000000, to = 10000000 + Headcount -1)

## Creating an dataframe at the start with just the employee ID numbers.  
## Everything will be moved into this as it's built.  
## This will make it easier to see the data at any point.
LHDD <- data.frame(EmployeeID)

## Import categories CS; header = TRUE puts the first row as the column names
Categories <- read.csv("D:/CompensationScience/LookHereDummyData/categories.csv", header = TRUE)


## Creating Gender
## Male/Female ratio is 51.9%/48.1% https://en.wikipedia.org/wiki/Human_sex_ratio
## Non-binary percentage in young adults is 3% https://www.pewresearch.org/fact-tank/2022/06/07/about-5-of-young-adults-in-the-u-s-say-their-gender-is-different-from-their-sex-assigned-at-birth/
## For more information on gender terms, see https://transequality.org/issues/resources/frequently-asked-questions-about-transgender-people

## Create a data frame based on the ratios in the Categories document
GenderLookup <- data.frame(GenderCategories = Categories$GenderCategories, GenderRatio = Categories$GenderRatio)
## Remove the blank rows
GenderLookup <- GenderLookup[complete.cases(GenderLookup),]
## Change the ratios from text to numbers
GenderLookup$GenderRatio <- as.numeric(GenderLookup$GenderRatio)
## Creates a running total to compare to the randomizer
GenderLookup$GenderRunning <- cumsum(GenderLookup$GenderRatio)
str(GenderLookup)
## Creates a random variable for each employee that their gender will decide their gender
LHDD$GenderRand <- runif(Headcount, min=0, max=1)
