#' Creates a trend plot.
#'
#' @description
#' Creates a bar chart showing the number of patients over time, faceted by condition.
#'
#' @param data a dataset returned from EunomiaExploration::extractPatients
#' @param byMonth Boolean indicating if the time scale is by month or per year (default)
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom plotly ggplotly
#'
#' @return
#' A bar plot showing the number of patiens over time, faceted by condition.
#'
#' @examples
#' connectionDetails <- Eunomia::getEunomiaConnectionDetails()
#'
#' dbConnection <- DatabaseConnector::connect(connectionDetails)
#' df <- extractPatients(dbConnection)
#' DatabaseConnector::disconnect(dbConnection)
#' plotTrend(df)
#'
#' @export
plotTrend <- function(data, byMonth = FALSE) {
  data <- createPlotData(data = data, byMonth = byMonth)
  conditions <- unique(data$conditionName)
  conditions_length <- length(conditions)

  plot <- ggplot(data, aes(x = time, y = numberOfPatients)) +
    geom_bar(stat="identity")

  if (conditions_length == 1) {
    plot <- plot +
      theme(axis.text.x = element_text(angle = 45),
            plot.title = element_text(hjust = 0.5)) +
      ggtitle(paste("Number of patients over time for condition:", conditions))
  } else {
    plot <- plot +
      theme(axis.text.x = element_text(angle = 45, size = 6),
            plot.title = element_text(hjust = 0.5),
            strip.text = element_text(size = 6)) +
      ggtitle("Number of patients over time for all condition") +
      facet_wrap(~conditionName)
  }
  plotly::ggplotly(plot)
}


#' Creates the plot data.
#'
#' @description
#' Creates the data for the plotTrend function.
#'
#' @param data a dataset returned from EunomiaExploration::extractPatients
#' @param byMonth Boolean indicating if the time scale is by month or per year (default)
#'
#' @importFrom dplyr mutate select group_by summarise
#' @importFrom lubridate floor_date interval years add_with_rollback
#'
#' @return
#' A data frame with the plot data.
#'
#' @examples
#' connectionDetails <- Eunomia::getEunomiaConnectionDetails()
#' dbConnection <- DatabaseConnector::connect(connectionDetails)
#' df <- extractPatients(dbConnection)
#' disconnect(dbConnection)
#' createPlotData(df)
#'
createPlotData <- function(data, byMonth = FALSE) {
  if (byMonth) {
    data <- data  %>%
      mutate(time = lubridate::floor_date(conditionStartDate, unit = "month")) %>%
      mutate(endTime = lubridate::floor_date(conditionEndDate, unit = "month")) %>%
      distinct(personId, conditionName, time, .keep_all = TRUE) %>%
      mutate(nTimes = as.numeric(1 + lubridate::interval(time, endTime) %/% months(1))) %>%
      select(-endTime)
  } else {
    data <- data  %>%
      mutate(time = lubridate::floor_date(conditionStartDate, unit = "year")) %>%
      mutate(endTime = lubridate::floor_date(conditionEndDate, unit = "year")) %>%
      distinct(personId, conditionName, time, .keep_all = TRUE) %>%
      mutate(nTimes = as.numeric(1 + lubridate::interval(time, endTime) %/% lubridate::years(1))) %>%
      select(-endTime)
  }

  dfSingle <- data %>% filter(nTimes == 1) %>% select(-nTimes)
  dfMulti  <-  data %>% filter(nTimes > 1)
  nTimes   <- dfMulti$nTimes
  plusTime <- unlist(lapply(nTimes, function(x) seq(0, x - 1)))
  dfMulti  <- as.data.frame(lapply(dfMulti %>% select(-nTimes), rep, nTimes))

  if (nrow(dfMulti) > 0) {
    if (byMonth) {
      dfMulti <- dfMulti %>% mutate(time = time %>% lubridate::add_with_rollback(months(plusTime)))
    } else {
      dfMulti <- dfMulti %>% mutate(time = time %>% lubridate::add_with_rollback(lubridate::years(plusTime)))
    }
  }

  rbind(dfSingle, dfMulti) %>%
    group_by(conditionName, time) %>%
    summarise(numberOfPatients = n(), .groups = "drop")
}
