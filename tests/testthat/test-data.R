
test_that("extractPatients", {

  connectionDetails <- getEunomiaConnectionDetails()
  dbConnection <- connect(connectionDetails)
  df <- extractPatients(dbConnection)
  disconnect(dbConnection)

  expect_equal(ncol(df), 5)
  expect_equal(nrow(df), 65332)
  expect_equal(colnames(df), c("PersonId", "ConditionConceptId", "ConditionName", "ConditionStartDate", "ConditionEndDate"))
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

  tryCatch({
    extractPatients(mtcars)
  },
  error = function(e) {
    expect_equal(e$message, error_message)
  })

})
