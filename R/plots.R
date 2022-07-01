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
  data <- createPlotData(data, byMonth)
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


#' Creates the plot data.
#'
#' @description
#' Creates the data for the plotTrend function.
#'
#' @param data a dataset returned from EunomiaExploration::extractPatients
#' @param byMonth Boolean indicating if the time scale is by month or per year (default)
#'
#' @import dplyr
#'
#' @return
#' A data frame with the plot data.
#'
#' @examples
#' connectionDetails <- getEunomiaConnectionDetails()
#'
#' dbConnection <- connect(connectionDetails)
#' df <- extractPatients(dbConnection)
#' disconnect(dbConnection)
#' createPlotData(df)
#'
createPlotData <- function(data, byMonth = FALSE) {
  if (byMonth) {
    data <- data  %>%
      mutate(Time = floor_date(ConditionStartDate, unit = "month")) %>%
      mutate(EndTime = floor_date(ConditionEndDate, unit = "month")) %>%
      distinct(PersonId, ConditionName, Time, .keep_all = TRUE) %>%
      mutate(Ntimes = as.numeric(1 + interval(Time, EndTime) %/% months(1))) %>%
      select(-EndTime)
  } else {
    data <- data  %>%
      mutate(Time = floor_date(ConditionStartDate, unit = "year")) %>%
      mutate(EndTime = floor_date(ConditionEndDate, unit = "year")) %>%
      distinct(PersonId, ConditionName, Time, .keep_all = TRUE) %>%
      mutate(Ntimes = as.numeric(1 + interval(Time, EndTime) %/% years(1))) %>%
      select(-EndTime)
  }

  df_single <- data %>% filter(Ntimes == 1) %>% select(-Ntimes)
  df_multi  <-  data %>% filter(Ntimes > 1)
  ntimes    <- df_multi$Ntimes
  plusTime  <- unlist(lapply(ntimes, function(x) seq(0,x-1)))
  df_multi  <- as.data.frame(lapply(df_multi %>% select(-Ntimes), rep, ntimes))

  if (byMonth) {
    df_multi <- df_multi %>% mutate(Time = Time %m+% months(plusTime))
  } else {
    df_multi <- df_multi %>% mutate(Time = Time %m+% years(plusTime))
  }

  rbind(df_single, df_multi) %>%
    group_by(ConditionName, Time) %>%
    summarise(NumberOfPatients = n(), .groups = "drop")
}
