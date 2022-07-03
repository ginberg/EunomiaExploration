#' Creates a shiny app.
#'
#' @description
#' Creates a shiny app to visualize condition data.
#'
#' @importFrom Eunomia getEunomiaConnectionDetails
#' @importFrom DatabaseConnector connect disconnect
#' @importFrom shiny shinyApp selectizeInput checkboxInput plotOutput
#' @importFrom shinydashboard dashboardPage dashboardHeader dashboardSidebar dashboardBody
#' @importFrom plotly plotlyOutput renderPlotly
#'
#' @return
#' A bar plot showing the number of patiens over time, faceted by condition.
#'
#' @examples
#' createShinyApp()
#'
#' @export
createShinyApp <- function() {

  connectionDetails <- Eunomia::getEunomiaConnectionDetails()
  dbConnection <- DatabaseConnector::connect(connectionDetails)
  df <- EunomiaExploration::extractPatients(dbConnection)
  DatabaseConnector::disconnect(dbConnection)
  conditions <- unique(sort(df$conditionName))

  ui <- dashboardPage(
    dashboardHeader(title = "Eunomia exploration"),
    dashboardSidebar(selectizeInput("conditionId", "Condition", conditions),
                     checkboxInput("byMonth", "By month", value = FALSE)),
    dashboardBody(plotly::plotlyOutput("plot", height = "80vh")),
    title = "Eunomia exploration"
  )
  server <- function(input, output, session) {

    data <- reactive({
      df %>% filter(conditionName == input$conditionId)
    })

    output$plot <- plotly::renderPlotly({
      req(input$conditionId)
      EunomiaExploration::plotTrend(data(), input$byMonth)
    })
  }
  shinyApp(ui, server)
}
