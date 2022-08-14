# Look-Here-Dummy-Data
Procedurally generating dummy data for Human Resources analytics


When running HR analysis sometimes it's very useful to have a dummy dataset (fake data that looks real).  Much of our work is confidential so showing live data publically is a problem.  At the same point, the more we can publically discuss our analytical methods, the better they become.  Also having an unbiased dataset is useful in verifying that our analyitics are working correctly before we put real data into them.

There are a few places to find dummy data online, [like here](https://www.aihr.com/blog/hr-data-sets-people-analytics/), but idealy we would use something that perfectly matched our internal data structure and had similar demographics to our actual populations.

This project aims to solve all of those issues, in an easier method that trying to implement this in excel.  The basic idea is that there is one text file that identifies two things about each type of demographic
1) what the possible options are (for race may be listed as "American Indian/Alaskan Native (not Hispanic or Latino)", "Asian (not Hispanic or Latino)", etc.) 
2) the percentage of each option in the final dataset ( 1.3%, 5.9%, etc.)

From that the system will generate a spreadsheet with as many fake employees as you'd like, all with randomized demographic information but in (about) the percentages listed.

HR data is challenging to work with since people are complex.  Many of the groupings we use have the majority of the population in a few categories, and other categories with very few people in them.  By creating a blanced dataset with appropriate percentages, it becomes much easiser to check how our analytics and graphs will respond to real-world groupings.
