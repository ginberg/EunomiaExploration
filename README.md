# R programmer for Health Data Science

Welcome to the second round of the recruitment process for R programmer for Health Data Science

## Exercise

We would like you to complete a short take-home exercise to help us evaluate the R skills needed for the position.

The exercise involves the following:

Create an R package that contains a https://github.com/OHDSI/Eunomia database and has the following functions:

1. extractPatients

This function should take a database connection as input, and extract information on condition, start and end date of the condition from the condition occurence table in the database. The function should be able to do this for different sql dialects. It should return a data.frame object containing these three columns.

2. plotTrend(data,byMonth) 

Takes as input the output from the extractPatients function, and should provide a calendar month and year plotting option. Creates a bar plot with the number of patients per year (default) or month for each condition in "data".

3. createShinyApp 

Simple shiny app should have a pulldown menu to select the condition and a checkbox for by month. The app should then plot the frequency of the selected condition by the selected time varyiance (Year or Month)

Creating the Shiny App will create extra points.

We would like you to make an R package that does this and provides unit testing functionality using (https://testthat.r-lib.org/)

in the submitted package there sould be a file named codeToRun.R in this file should be 4 calls to the functions, 1 extractPatients, 1 plotTrend by year, 1 plotTrend by month, and one createShinyApp

This should run.

## Evaluation
You will be evaluated on the critera below. 

### Completeness and correctness: up to 5 points:

- All three tasks are completed and return correct results. 4 pts
- Two tasks are completed and return correct results. 3 pts
- At least two tasks are completed There may be bugs or errors in the calculations, but works end to end. 2 pts
- At least one task is completed, possibly with errors but works end to end. 1 pt
- Anything else. 0 pts

### Code style and conventions: up to 4 points:

- Code is logically organized and clearly commented. Style follows the HADES style guideline https://ohdsi.github.io/Hades/codeStyle.html. Code is fully documented specifying inputs, outputs and with a clear description of what the functions do. There are at least some tests or assertions and exception handling (if necessary). 4 pts
- Code is logically organized and clearly commented.  Style follows the HADES style guideline https://ohdsi.github.io/Hades/codeStyle.html. Code is fully documented specifying inputs, outputs and with a clear description of what the functions do. 3 pts
- Code is logically organized, but documentation is inconsistent or confusing. 2 pts
- Code is disorganized and hard to follow. Inconsistent and arbitrary style. 1 pt
- Anything else. 0 pts

## Submitting a solution
Please add all code into this repository.

