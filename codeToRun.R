# Script that calls some package functions
library(EunomiaExploration)

connectionDetails <- Eunomia::getEunomiaConnectionDetails()
dbConnection <- DatabaseConnector::connect(connectionDetails)

# extractPatients
df <- EunomiaExploration::extractPatients(dbConnection)
DatabaseConnector::disconnect(dbConnection)

# plotTrend
EunomiaExploration::plotTrend(df, byMonth = FALSE)
EunomiaExploration::plotTrend(df, byMonth = TRUE)

# createShinyApp
EunomiaExploration::createShinyApp()
