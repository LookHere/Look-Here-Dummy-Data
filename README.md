# Look-Here-Dummy-Data
<i>Procedurally generating synthetic data for Human Resources analytics</i>

When running HR analysis, sometimes it's very useful to use a dummy dataset (fake data that looks real).  Much of our work is highly confidential so showing live data publicly isn't possible.  That siloing becomes a problem since the more we can publicly discuss our analytical methods, the better they become.  Additionally, having an unbiased data set is useful in verifying that our analytics are working correctly before we put real data into them.

There are a few places to find dummy data online, [like here](https://www.aihr.com/blog/hr-data-sets-people-analytics/), but ideally we would use something that perfectly matched our internal data structure and had similar demographics to our actual populations.

Although its possible to generate dummy data in excel, this project aims to be quicker and more flexible.  It can create multiple populations of any headcount size, making it easy to test the validity of analytical methods on different scenarios.  It is also unbiased (which is challenging to create in excel) so every field is entirely unrelated to any other field, but the overall amounts are related to the percentages you decided.  This eliminates some of problematic, unexpected results that manually created dummy data often generates.  

This method lets you alter a single [text file](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/Categories.csv) that identifies two factors about each type of demographic:
1) the available options for that demographic (for "race" options may be listed as "American Indian/Alaskan Native (not Hispanic or Latino)", "Asian (not Hispanic or Latino)", etc.) 
2) the percentage of people in the final headcount that should have each option (1.3%, 5.9%, etc.)

The system will also generate compensation amount based on the employee level (entry level, manager, director, etc.).  The compensation amounts are randomly pulled from a bell curve around the compensation target related to each level (and then rounded).  The final results will show most employees near their target, with fewer employees having more extreme compensations.

<kbd><img src="https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/TextFileExample.png" width=100% height=100%></kbd>

The system will use the text file to generate a spreadsheet with as many fake employees as requested, all with randomized demographic information.  The total employees with each demographic will be (about) the percentages entered in the text file.  In benchmark tests it can generating [20,000 employees](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/OutputExample.csv) in 6.02 seconds into a CSV file that's 2.14 MB. 

<kbd><img src="https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/OutputExample.jpg" width=100% height=100%></kbd>

HR data is challenging to work with since people are complex.  Many of the demographics we record have the majority of the population in a few categories, and other categories with very few people in them.  By creating a balanced dataset with appropriate percentages, it becomes much easier to see how our analytics and dashboards will respond to real-world groupings.

# How To Run This (Beginner User) 
This project was designed so a non-technical person could create an unlimited number of fake workers, all customized to their specific categories (and the percentage of employees in each category).  With only a beginner level of knowledge in R this should be very easy.  

I developed this in R since the program is free and easy to work in.  I am specifically using common functions and small, iterative steps so the code is as easy to understand for people new to R.  I'm also not using any libraries so it is easy to drop this code into part of a larger project (also so that it doesn't break when a library is updated).

If you have no knowledge of R, [this video](https://www.youtube.com/watch?v=_V8eKsto3Ug) shows you how to download the software and all of the basics needed to integrate R into your toolbox.

You can download this project’s [r code](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/LookHereDummyData.R) to run the project yourself.  Once you do, just make sure you link it your downloaded copy of this [text file](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/Categories.csv). The text file is where you’ll identify the categories and percentages you’re customizing.  (You'll link to this file in the very first section of the r code.)  

You can download the final headcount file into another CSV file and then open that with excel. In the last section of the r code you’ll need to identify which folder you want to generate the headcount file in.

# Nuts and Bolts (Advanced User)
This code is designed to be integrated into larger projects, so you can easily generate dummy data as needed.  As such, it doesn’t need any libraries.  Each demographic section is modular and doesn’t rely on any other section (the employee ID section is needed since it creates the dataframe).

Here is a brief explanation of how each section works.  More details are in the comments with the code.  If you’d like to built out another part of this an integrate it into this project, let me know!

## Employee ID 
This sections decides the overall structure of the headcount being generated.  It sets up the total headcount, the earliest start date, and how many years of data should be generated.  

This section looks at the <i>categories.csv</i> file to pull in the demographic choices from the user.  It also creates the dataframe that all other sections hang their demographic data on.  

## Dates
The dates section generates two dates, the StartDate (hire date) and EndDate (termination date).

The StartDate is a random number between the EarliestStartDate and (the YearsOfData * 365.25 days).

The EndDate is a random number between the StartDate and (the YearsOfData * 365.25 days).

Anyone with an EndDate after “today” will have their EndDate removed and are considered active.

## Gender
The gender categories from the <i>categories.csv</i> file are brought in.  

Each ratio is divided by the sum of all ratios.  This just ensures that the sum of all ratios add up to 100%.  

Then each ratio is stacked on top of the one before it, so the maximum of the previous ratio is the start of the next one.  This is known as a running total.

A random number between 0% and 100% is created for each record.  

If the random number is between the minimum and maximum of the first ratio, then the employee gets that demographic.  If it’s between the minimum and maximum of the second ratio, then the employee gets that ratio.  This continues for as many categories are entered.  The number of categories can be changed by the user in the <i>categories.csv</i> file.

## Race and Department
Both the Race and Department sections work similarly to the Gender section.

## Job Level and Compensation

The Job Level is created in a similar way to the Gender section.  

The Job Level also brings in a target compensation amount.  If you’re trying to mirror live data, use the average pay for employees at that level.

The target compensation amount is altered by a formula that picks a random point on a bell curve around it.  That means that most compensations amounts will be close to the target (average) and fewer compensation amounts will be outlines.  This should somewhat mirror actual compensation distributions in a healthy incentive plan.

After the compensation amount for each employee is decided, it is rounded to the nearest thousand.  

## Export to CSV
The last section will take the final file and export it to a .csv file on the users computer where it can be opened with excel.  

# Roadmap

- [X] Create a space to experiment with this idea (this github)
- [X] Implement this as a proof of concept in [excel](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/ExcelProofOfConcept.ods)
- [X] Develop a method in R for creating categorical (gender, race, etc.) dummy data based on randomization 
- [X] Have the system accept variable numbers of categories
- [X] Have the system create realistic dates (hire, term, etc.)
- [X] Develop compensation data, related to level
- [ ] Creation random names, related to gender and location
- [ ] Generate job titles, related to level
- [ ] Generate benefit and dependent information
- [ ] Generate a table of actions (hire, term, promotion, transfer, etc.)
- [ ] Create a better way to enter start and termination variables (possibly asking for average turnover)
- [ ] Create a way to take the unbiased dummy data and make it biased, to test if analytics and dashboards can identify the bias
- [ ] Develop this into a package so it's easier to run
