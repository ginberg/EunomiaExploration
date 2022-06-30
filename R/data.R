#' Extract patient condition data from the Eunomia database
#'
#' @description
#' This function will query the Eunomia database and return data regarding patient
#' conditions data.
#'
#' @param dbConnection A database connection created by DatabaseConnector::connect.
#'
#' @importFrom dplyr rename
#' @importFrom DatabaseConnector querySql
#'
#' @return
#' A data frame listing patient conditions.
#'
#' @examples
#' connectionDetails <- getEunomiaConnectionDetails()
#'
#' dbConnection <- connect(connectionDetails)
#'
#' extractPatients(dbConnection)
#'
#' disconnect(dbConnection)
#'
#' @export
extractPatients <- function(dbConnection) {
  querySql(dbConnection, "SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONCEPT_NAME, CONDITION_START_DATE, CONDITION_END_DATE
                          FROM CONDITION_OCCURRENCE
                          LEFT JOIN CONCEPT ON CONDITION_OCCURRENCE.CONDITION_CONCEPT_ID = CONCEPT.CONCEPT_ID")  %>%
    rename(ConditionConceptId = CONDITION_CONCEPT_ID) %>%
    rename(ConditionStartDate = CONDITION_START_DATE) %>%
    rename(ConditionEndDate = CONDITION_END_DATE) %>%
    rename(PersonId = PERSON_ID) %>%
    rename(ConditionName = CONCEPT_NAME) %>%
    mutate(ConditionEndDate = as.Date(ifelse(is.na(ConditionEndDate), ConditionStartDate + days(30), ConditionEndDate), origin))
}
