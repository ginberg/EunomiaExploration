library(lubridate)

connectionDetails <- Eunomia::getEunomiaConnectionDetails()
dbConnection <- DatabaseConnector::connect(connectionDetails)
df <- head(extractPatients(dbConnection))
DatabaseConnector::disconnect(dbConnection)

test_that("createPlotData years", {
  df[1, "conditionEndDate"] <- df[1, "conditionEndDate"] %m+% years(3)
  df[5, "conditionEndDate"] <- df[5, "conditionEndDate"] %m+% years(2)
  data <- createPlotData(df)

  expect_equal(ncol(data), 3)
  expect_equal(colnames(data), c("conditionName", "time", "numberOfPatients"))
  expect_equal(nrow(data), 6 + 3 + 2)
  times <- data$time
  expect_equal(interval(times[1], times[2]) %/% years(1), 1)
  expect_equal(interval(times[1], times[3]) %/% years(1), 2)
})

test_that("createPlotData month", {
  df[2, "conditionEndDate"] <- df[2, "conditionEndDate"] %m+% months(2)
  df[6, "conditionEndDate"] <- df[6, "conditionEndDate"] %m+% months(3)
  data <- createPlotData(df, byMonth = TRUE)

  expect_equal(ncol(data), 3)
  expect_equal(colnames(data), c("conditionName", "time", "numberOfPatients"))
  expect_equal(nrow(data), 13 + 2 + 3)
  times <- data$time
  expect_equal(interval(times[2], times[3]) %/% months(1), 1)
  expect_equal(interval(times[2], times[4]) %/% months(1), 2)
})
