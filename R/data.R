#' Extract patient condition data from the Eunomia database
#'
#' @description
#' This function will query the Eunomia database and return data regarding patient
#' conditions data.
#'
#' @param dbConnection A database connection created by DatabaseConnector::connect.
#'
#' @importFrom DatabaseConnector querySql
#' @importFrom dplyr mutate rename
#' @importFrom lubridate days origin
#'
#' @return
#' A data frame listing patient conditions.
#'
#' @export
extractPatients <- function(dbConnection) {
  if (is.null(dbConnection) || suppressWarnings(is.na(dbConnection)) || class(dbConnection) != "DatabaseConnectorDbiConnection") {
    stop("Please provide a database connection as input")
  }

  DatabaseConnector::querySql(connection = dbConnection,
                              sql = "SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONCEPT_NAME, CONDITION_START_DATE, CONDITION_END_DATE
                                     FROM CONDITION_OCCURRENCE
                                     LEFT JOIN CONCEPT ON CONDITION_OCCURRENCE.CONDITION_CONCEPT_ID = CONCEPT.CONCEPT_ID",
                              snakeCaseToCamelCase = TRUE)  %>%
    dplyr::rename(conditionName = conceptName) %>%
    dplyr::mutate(conditionEndDate = as.Date(ifelse(is.na(conditionEndDate), conditionStartDate + lubridate::days(30), conditionEndDate), lubridate::origin))
}
