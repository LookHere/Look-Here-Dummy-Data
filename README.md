# Look-Here-Dummy-Data
<i>Procedurally generating synthetic data for Human Resources analytics</i>

When running HR analysis, sometimes it's very useful to use a dummy dataset (fake data that looks real).  Much of our work is highly confidential so showing live data publicly isn't possible.  That siloing becomes a problem since the more we can publicly discuss our analytical methods, the better they become.  Additionally, having an unbiased data set is useful in verifying that our analytics are working correctly (unbiased data would look different then biased, real data).

There are a few places to find dummy data online, [like here](https://www.aihr.com/blog/hr-data-sets-people-analytics/), but ideally we would use something that perfectly matched our internal data structure and had similar demographics to our actual populations.  The Look Here Dummy Data project allows you to generate fake employees that use the same structure (field names, demographic percentages, etc.) of your live data.

Although its possible to [generate dummy data in excel](https://github.com/LookHere/Look-Here-Dummy-Data/tree/main/Files/ExcelProofOfConcept), this project aims to be quicker and more flexible.  It can create multiple populations of any headcount size, making it easy to test the validity of analytical methods on different scenarios.  It is also unbiased (which is challenging to create in excel) so every demographic is entirely unrelated to any other field (unless it should be), but the overall amounts are related to the percentages you decided.  This eliminates some of problematic, unexpected results that manually created dummy data often generates.  

This method lets you alter a single [text file](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/Categories.csv) that identifies two factors about each type of demographic:
1) the available options for that demographic (for "race" options may be listed as "American Indian/Alaskan Native (not Hispanic or Latino)", "Asian (not Hispanic or Latino)", etc.) 
2) the percentage of people in the final headcount that should have each option (1.3%, 5.9%, etc.)

First names are generated to correspond to the gender.  Location is generated based on the name.  (Location could be used for office location or birth location).

The system will also generate compensation amount based on the employee level (entry level, manager, director, etc.).  The compensation amounts are randomly pulled from a bell curve around the compensation target related to each level (and then rounded).  The final results will show most employees near their target, with fewer employees having more extreme compensations.

<kbd><img src="https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/Images/SampleCategories.png" width=100% height=100%></kbd>

The system will use the text file to generate a spreadsheet with as many fake employees as requested, all with randomized demographic information.  The total employees with each demographic will be (about) the percentages entered in the text file.  In benchmark tests it can generating [20,000 employees](https://github.com/LookHere/Look-Here-Dummy-Data/tree/main/Files/SampleOutput) in 8 seconds into a CSV file that's 2.6 MB. 

<kbd><img src="https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/Images/SampleOutput.png" width=100% height=100%></kbd>

HR data is challenging to work with since people are complex.  Many of the demographics we record have the majority of the population in a few categories, and other categories with very few people in them.  By creating a balanced dataset with appropriate percentages, it becomes much easier to see how our analytics and dashboards will respond to real-world groupings.

# How To Run This (Beginner User) 
This project was designed so a non-technical person could create an unlimited number of fake workers, all customized to their specific categories (and the percentage of employees in each category).  With only a beginner level of knowledge in R this should be very easy.  

I developed this in R since the program is free and easy to work in.  I am specifically using common functions and small, iterative steps so the code is as easy to understand for people new to R.  I'm also not using any libraries so it is easy to drop this code into part of a larger project (also so that it doesn't break when a library is updated).

If you have no knowledge of R, [this video](https://www.youtube.com/watch?v=_V8eKsto3Ug) shows you how to download the software and all of the basics needed to integrate R into your toolbox.

To set-up the program you’ll need to:
- Download this project’s [r code](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/LookHereDummyData.R) to run the project yourself.  
-  Create the Categories.CSV file to customize the categories and percentages to look like your company.  The easiest way to do that is to alter [this template](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/Categories.csv).
- To generate names, the system will psudo-randomly look up a name from [this file](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/NameDatabase.csv).  

It's easiest if you download all 3 files (<i>LookHereDummyData.R</i>, <i>Categories.CSV</i>, and <i>NameDatabase.CSV</i>) and move them into one folder.  Then go into the R code and identify that folder as the “working directory”.  That will let the code know where to find the files.  

After running the program the OutputLookHereDummyData.CSV headcount file is generated in the same working directly.  You can open that with excel. 

# Nuts and Bolts (Advanced User)
This code is designed to be integrated into larger projects, so you can easily generate dummy data as needed.  As such, it doesn’t need any libraries.  Each demographic section is modular and doesn’t rely on any other section (the employee ID section is always needed since it creates the dataframe).

Here is a brief explanation of how each section works.  More details are in the comments with the code.  If you’d like to built out another module of this an integrate it into this project, let me know!

## Employee ID 
This sections decides the overall structure of the headcount being generated.  It sets up the total headcount, the earliest start date, and how many years of data should be generated.  

This section pulls in the <i>Categories.CSV</i> file to pull in the demographic choices from the user.  It also creates the dataframe that all other sections hang their demographic data on.  

## Dates
The dates section generates two dates, the StartDate (hire date) and EndDate (termination date).

The StartDate is a random number between the EarliestStartDate and (the YearsOfData * 365.25 days).

The EndDate is a random number between the StartDate and (the YearsOfData * 365.25 days).

Anyone with an EndDate after “today” will have their EndDate removed and are considered active.

## Gender
The gender categories from the <i>Categories.CSV</i> file are brought in.  

Each ratio is divided by the sum of all ratios.  This just ensures that the new sum of all ratios add up to 100%.  

Then each ratio is stacked on top of the one before it, so the maximum of the previous ratio is the start of the next one.  This is known as a running total.

A random number between 0% and 100% is created for each record.  

If the random number is between the minimum and maximum of the first ratio, then the employee receives that demographic.  If it’s between the minimum and maximum of the second ratio, then the employee receives that ratio.  This continues for as many categories are entered.  The number of categories can be changed by the user in the <i>categories.csv</i> file.

## Race and Department
Both the Race and Department sections work similarly to the Gender section.

## Job Level and Compensation

The Job Level is created in a similar way to the Gender section.  

The Job Level also brings in a target compensation amount.  If you’re trying to mirror live data, use the average pay for employees at that level.

The target compensation amount is modified by a formula that picks a random point on a bell curve around the origonal target compensation.  That means that most compensations amounts will be close to the target (average) and fewer compensation amounts will be outlines.  This should somewhat mirror actual compensation distributions in a healthy incentive plan.

After the compensation amount for each employee is decided, it is rounded to the nearest thousand.  

## Name and Location
If the gender module has been run, the name will be based off of the gender.  If the gender module has not been run, then the name will be picked randomly.  

To select a name based on gender: 
- The system takes the <i>NameDatabase.CSV</i> and sorts it by gender.
- The row number for the first and last record of the “Male” and “Female” records is identified.
- A random modifier is generated for each person (between zero and one).
- The modifier determines which row between the first and last row of the “Male” or “Female” records is picked.

For non-binary employees, the name is selected from all male, female, and non-gendered names in the database.

The location is selected based on the where that name is common used.

The database of names was pulled from random websites, so some areas are heavily over and under represented.  I haven't been able to find databases of African names by country, so are currently grouped into a continent.  The name formatting and original script has not been reviewed for consistency or accuracy.  The names were found on these websites: [France](https://www.insee.fr/fr/statistiques/2540004), [Finland and Sweden](https://dvv.fi/en/most-popular-children-s-names), [New Zealand](https://catalogue.data.govt.nz/dataset/most-popular-male-and-female-first-names/resource/bcf26297-13c4-4c0d-b2e5-6ef73665783a), [China](https://www.chinahighlights.com/travelguide/guidebook/chinese-names.htm), [Africa](https://www.names.org/lists/by-origin/african/), [Japan](https://www.momjunction.com/baby-names/japanese/page/6/), [Hindi names](https://www.momjunction.com/baby-names/hindi/), and  [other](https://en.wiktionary.org/wiki/Appendix:Most_popular_given_names_by_country).

## Export to CSV
The last section will take the final file and export it to a .csv file on the users computer where it can be opened with excel.  

# Roadmap

- [X] Create a space to experiment with this idea (this github)
- [X] Implement this as a proof of concept in [excel](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/ExcelProofOfConcept.ods)
- [X] Develop a method in R for creating categorical (gender, race, etc.) dummy data based on randomization 
- [X] Have the system accept variable numbers of categories
- [X] Have the system create realistic dates (hire, term, etc.)
- [X] Develop compensation data, related to level
- [X] Pull random names, related to gender and location
- [ ] Build out location so the user can decide percentages of each location
- [ ] Generate job titles, related to level
- [ ] Generate benefit and dependent information
- [ ] Generate paroll data
- [ ] Generate a table of actions (hire, term, promotion, transfer, etc.)
- [ ] Time keeping data (hours worked, time off, etc.)
- [ ] Generate canidate data for a recruiting funnel
- [ ] Create a better way to enter start and termination variables (possibly asking for average turnover)
- [ ] Create a way to take the unbiased dummy data and make it biased, to test if analytics and dashboards can identify the bias
- [ ] Develop this into a package so it's easier to run
- [ ] Develop this into a shiny page so it doesn't have to be run in R
