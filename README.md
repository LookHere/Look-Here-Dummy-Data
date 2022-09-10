# Look-Here-Dummy-Data
Procedurally generating dummy data for Human Resources analytics


When running HR analysis sometimes it's very useful to have a dummy dataset (fake data that looks real).  Much of our work is confidential so showing live data publically is a problem.  At the same point, the more we can publically discuss our analytical methods, the better they become.  Also having an unbiased dataset is useful in verifying that our analyitics are working correctly before we put real data into them.

There are a few places to find dummy data online, [like here](https://www.aihr.com/blog/hr-data-sets-people-analytics/), but idealy we would use something that perfectly matched our internal data structure and had similar demographics to our actual populations.

This project aims to solve all of those issues, in an easier method than trying to implement this in excel.  This method uses one text file that identifies two factors about each type of demographic:
1) what the possible options are (for race may be listed as "American Indian/Alaskan Native (not Hispanic or Latino)", "Asian (not Hispanic or Latino)", etc.) 
2) the percentage of each option in the final dataset ( 1.3%, 5.9%, etc.)

The system will use the text file to generate a spreadsheet with as many fake employees as requested, all with randomized demographic information but in (about) the percentages requested for each demographic category.

HR data is challenging to work with since people are complex.  Many of the groupings we use have the majority of the population in a few categories, and other categories with very few people in them.  By creating a balanced dataset with appropriate percentages, it becomes much easiser to check how our analytics and graphs will respond to real-world groupings.

I developed this in R since the program is free and easy to work in.  I am specifically using common functions and small, iterative steps so the code is as easy to understand for people new to R.  I'm also not using any libraries so it's easier to drop into part of a larger coding project (also so that it doesn't break when a library is updated).

## Roadmap

- [X] Create a space to experiment with this idea (this github)
- [X] Implement this as a proof of concept in excel
- [X] Develop a method in R for creating categorical (gender, race, etc.) dummy data based on randomization 
- [X] Have the system accept variable numbers of categories
- [X] Have the system create realistic dates (hire, term, etc.)
- [ ] Implement the creation random names (possibly related to gender?)
- [ ] Develop compensation data, related to level
- [ ] Generate job titles, related to level
- [ ] Create a better way to enter start and term variables (possibly asking for average turnover)
