# Look-Here-Dummy-Data
<i>Procedurally generating synthetic data for Human Resources analytics</i>

When running HR analysis, sometimes it's very useful to use a dummy dataset (fake data that looks real).  Much of our work is highly confidential so showing live data publicly isn't possible.  That siloing becomes a problem since the more we can publicly discuss our analytical methods, the better they become.  Additionally, having an unbiased data set is useful in verifying that our analytics are working correctly before we put real data into them.

There are a few places to find dummy data online, [like here](https://www.aihr.com/blog/hr-data-sets-people-analytics/), but ideally we would use something that perfectly matched our internal data structure and had similar demographics to our actual populations.

Although its possible to generate dummy data in excel, this project aims to be quicker and more flexible.  It can create multiple populations of any headcount, making it easy to test the validity of analytical methods on different scenarios.  It is also unbiased (which is challenging to create in excel) so every field is entirely unrelated to any other field, but the overall amounts are related to the percentages you decided.  This eliminates some of problematic, unexpected results that manually created dummy data often generates.  

This method lets you alter a [text file](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/Categories.csv) that identifies two factors about each type of demographic:
1) the available options for that demographic (for "race" options may be listed as "American Indian/Alaskan Native (not Hispanic or Latino)", "Asian (not Hispanic or Latino)", etc.) 
2) the percentage of the final data set that should have each option (1.3%, 5.9%, etc.)

<kbd><img src="https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/TextFileExample.png" width=100% height=100%></kbd>

The system will use the text file to generate a spreadsheet with as many fake employees as requested, all with randomized demographic information.  The total employees with each demographic will be (about) the percentages listed in the text file.  In benchmark tests it can generating [a file of 20,000 employees](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/OutputExample.csv) in 8.5 seconds into a CSV file that's 1.779 megabytes. 

<kbd><img src="https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/OutputExample.jpg" width=100% height=100%></kbd>

HR data is challenging to work with since people are complex.  Many of the groupings we use have the majority of the population in a few categories, and other categories with very few people in them.  By creating a balanced dataset with appropriate percentages, it becomes much easier to see how our analytics and graphs will respond to real-world groupings.

I developed this in R since the program is free and easy to work in.  I am specifically using common functions and small, iterative steps so the code is as easy to understand for people new to R.  I'm also not using any libraries so it is easy to drop this code into part of a larger project (also so that it doesn't break when a library is updated).

## Roadmap

- [X] Create a space to experiment with this idea (this github)
- [X] Implement this as a proof of concept in [excel](https://github.com/LookHere/Look-Here-Dummy-Data/blob/main/Files/ExcelProofOfConcept.ods)
- [X] Develop a method in R for creating categorical (gender, race, etc.) dummy data based on randomization 
- [X] Have the system accept variable numbers of categories
- [X] Have the system create realistic dates (hire, term, etc.)
- [X] Develop compensation data, related to level
- [ ] Creation random names (possibly related to gender)
- [ ] Generate job titles, related to level
- [ ] Generate benefit and dependent information
- [ ] Create a better way to enter start and termination variables (possibly asking for average turnover)
