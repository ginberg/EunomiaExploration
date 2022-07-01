connectionDetails <- getEunomiaConnectionDetails()
dbConnection <- connect(connectionDetails)
df <- head(extractPatients(dbConnection))
disconnect(dbConnection)

test_that("createPlotData years", {
  df[1, "ConditionEndDate"] <- df[1, "ConditionEndDate"] %m+% years(3)
  df[5, "ConditionEndDate"] <- df[5, "ConditionEndDate"] %m+% years(2)
  data <- createPlotData(df)

  expect_equal(ncol(data), 3)
  expect_equal(colnames(data), c("ConditionName", "Time", "NumberOfPatients"))
  expect_equal(nrow(data), 6 + 3 + 2)
  times <- data$Time
  expect_equal(interval(times[1],times[2]) %/% years(1), 1)
  expect_equal(interval(times[1],times[3]) %/% years(1), 2)
})

test_that("createPlotData month", {
  df[2, "ConditionEndDate"] <- df[2, "ConditionEndDate"] %m+% months(2)
  df[6, "ConditionEndDate"] <- df[6, "ConditionEndDate"] %m+% months(3)
  data <- createPlotData(df, byMonth = TRUE)

  expect_equal(ncol(data), 3)
  expect_equal(colnames(data), c("ConditionName", "Time", "NumberOfPatients"))
  expect_equal(nrow(data), 13 + 2 + 3)
  times <- data$Time
  expect_equal(interval(times[2],times[3]) %/% months(1), 1)
  expect_equal(interval(times[2],times[4]) %/% months(1), 2)
})
