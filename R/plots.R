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
#'
#' @return
#' A bar plot showing the number of patiens over time, faceted by condition.
#'
#' @examples
#' connectionDetails <- getEunomiaConnectionDetails()
#'
#' dbConnection <- connect(connectionDetails)
#' df <- extractPatients(dbConnection)
#' disconnect(dbConnection)
#' plotTrend(df)
#'
#' @export
plotTrend <- function(data, byMonth = FALSE) {
  if (byMonth) {
    data <- data  %>%
      mutate(Time = floor_date(ConditionStartDate, unit = "month")) %>%
      distinct(PersonId, ConditionName, Time, .keep_all = TRUE) %>%
      group_by(ConditionName, Time) %>%
      summarise(NumberOfPatients = n())
  } else {
    data <- data  %>%
      mutate(Time = floor_date(ConditionStartDate, unit = "year")) %>%
      distinct(PersonId, ConditionName, Time, .keep_all = TRUE) %>%
      group_by(ConditionName, Time) %>%
      summarise(NumberOfPatients = n())
  }

  conditions <- unique(data$ConditionName)
  conditions_length <- length(conditions)

  plot <- ggplot(data, aes(x = Time, y = NumberOfPatients)) +
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
      facet_wrap(~ConditionName)
  }
  ggplotly(plot)
}
