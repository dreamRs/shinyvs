library(shiny)
library(shinyvs)

ui <- fluidPage(
  tags$h2("Virtual Select (choices format)"),
  
  virtualSelectInput(
    inputId = "sel1",
    label = "Simple vector:",
    choices = month.name
  ),
  verbatimTextOutput("res1"),
  
  virtualSelectInput(
    inputId = "sel2",
    label = "Named vector:",
    choices = setNames(month.abb, month.name)
  ),
  verbatimTextOutput("res2"),
  
  virtualSelectInput(
    inputId = "sel3",
    label = "Named list:",
    choices = setNames(as.list(month.abb), month.name)
  ),
  verbatimTextOutput("res3"),
  
  virtualSelectInput(
    inputId = "sel4",
    label = "With groups:",
    choices = list(
      Winter = month.name[1:3],
      Spring = month.name[4:6],
      Summer = month.name[7:9],
      Fall = month.name[10:12]
    )
  ),
  verbatimTextOutput("res4"),
  
  virtualSelectInput(
    inputId = "sel5",
    label = "Already formated list:",
    choices = list(
      list(label = "January", value = "jan"),
      list(label = "February", value = "feb")
    )
  ),
  verbatimTextOutput("res5")
)

server <- function(input, output, session) {
  output$res1 <- renderPrint(input$sel1)
  output$res2 <- renderPrint(input$sel2)
  output$res3 <- renderPrint(input$sel3)
  output$res4 <- renderPrint(input$sel4)
  output$res5 <- renderPrint(input$sel5)
}

if (interactive())
  shinyApp(ui, server)
