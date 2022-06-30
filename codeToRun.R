# Script that calls some package functions
library(EunomiaExploration)

connectionDetails <- getEunomiaConnectionDetails()
dbConnection <- connect(connectionDetails)

df <- EunomiaExploration::extractPatients(dbConnection)
EunomiaExploration::plotTrend(df, byMonth = FALSE)
EunomiaExploration::plotTrend(df, byMonth = TRUE)

d <- df %>%
  mutate(Time = as.numeric(format(ConditionStartDate, "%Y"))) %>%
  mutate(EndTime = as.numeric(format(ConditionEndDate, "%Y"))) %>%
  dplyr::distinct(PersonId, ConditionName, Time, .keep_all= TRUE) %>%
  select(ConditionName, Time, EndTime)
head(d)

# EunomiaExploration::plotTrend(df, byMonth = FALSE)
# EunomiaExploration::plotTrend(df, byMonth = TRUE)

#EunomiaExploration::createShinyApp()

# Creates a bar plot with the number of patients per year (default) or month for each condition in "data".
# if (byMonth) {
#   data <- df  %>%
#     mutate(Time = as.numeric(format(ConditionStartDate, "%B %Y"))) %>%
#     group_by(ConditionName, Time) %>%
#     summarise(NumberOfPatients = n())
# } else {
#   data <- df  %>%
#     mutate(Time = as.numeric(format(ConditionStartDate, "%Y"))) %>%
#     group_by(ConditionName, Time) %>%
#     summarise(NumberOfPatients = n())
# }
#
# plotTrend <- function(data, byMonth = FALSE) {
#   ggplot(data, aes(x = Time, y = NumberOfPatients)) +
#     geom_bar(stat="identity") +
#     facet_wrap(~ConditionName) +
#     theme(axis.text.x = element_text(angle = 45, size = 10),
#           plot.title = element_text(hjust = 0.5)) +
#     ggtitle("Number of Patients over time for all conditions.")
# }
#
# plotTrend(data, byMonth)
#
#
#
# plotTrendId <- function(data, conditionId, byMonth = FALSE) {
#   ggplot(data, aes(x = Time, y = NumberOfPatients)) +
#     geom_bar(stat="identity") +
#     theme(axis.text.x = element_text(angle = 45, size = 10),
#           plot.title = element_text(hjust = 0.5))
# }
#
# conditionIds <- unique(data$ConditionConceptId)
# plist <- mclapply(conditionIds, FUN=function(conditionId) {
#   plotTrendId(data, conditionId)
# })
# print(do.call(grid.arrange, plist))
#

EunomiaExploration::createShinyApp()
