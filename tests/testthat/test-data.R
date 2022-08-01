
test_that("extractPatients", {

  connectionDetails <- Eunomia::getEunomiaConnectionDetails()
  dbConnection <- DatabaseConnector::connect(connectionDetails)
  df <- extractPatients(dbConnection)
  DatabaseConnector::disconnect(dbConnection)

  expect_equal(ncol(df), 5)
  expect_equal(nrow(df), 65332)
  expect_equal(colnames(df), c("personId", "conditionConceptId", "conditionName", "conditionStartDate", "conditionEndDate"))
})

test_that("extractPatients invalid input", {
  error_message <- "Please provide a database connection as input"

  tryCatch({
    extractPatients(NULL)
  },
  error = function(e) {
    expect_equal(e$message, error_message)
  })

  tryCatch({
    extractPatients(NA)
  },
  error = function(e) {
    expect_equal(e$message, error_message)
  })

})
