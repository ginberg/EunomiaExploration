#' Creates a shiny app.
#'
#' @description
#' Creates a shiny app to visualize condition data.
#'
#' @importFrom shiny shinyApp selectizeInput checkboxInput plotOutput
#' @importFrom shinydashboard dashboardPage dashboardHeader dashboardSidebar dashboardBody
#'
#' @return
#' A bar plot showing the number of patiens over time, faceted by condition.
#'
#' @examples
#' #createShinyApp()
#'
#' @export
createShinyApp <- function() {

  connectionDetails <- getEunomiaConnectionDetails()
  dbConnection <- connect(connectionDetails)
  df <- EunomiaExploration::extractPatients(dbConnection)
  conditions <- unique(sort(df$ConditionName))

  ui <- dashboardPage(
    dashboardHeader(title = "Eunomia exploration"),
    dashboardSidebar(selectizeInput("conditionId", "Condition", conditions),
                     checkboxInput("byMonth", "By month", value = FALSE)),
    dashboardBody(plotlyOutput("plot", height = "80vh")),
    title = "Eunomia exploration"
  )
  server <- function(input, output, session) {

    data <- reactive({
      df  %>%
        filter(ConditionName == input$conditionId)
    })

    output$plot <- renderPlotly({
      req(input$conditionId)
      EunomiaExploration::plotTrend(data(), input$byMonth)
    })
  }
  shinyApp(ui, server)
}
