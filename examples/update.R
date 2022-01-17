library(shiny)
library(shinyvs)

ui <- fluidPage(
  tags$h2("Virtual Select (update)"),
  
  virtualSelectInput(
    inputId = "sel1",
    label = "Update label:",
    choices = month.name
  ),
  verbatimTextOutput("res1"),
  textInput("label_text", label = "With text:"),
  textInput("label_html", label = "With HTML:"),
  
  
  virtualSelectInput(
    inputId = "sel2",
    label = "Update value:",
    choices = month.name
  ),
  verbatimTextOutput("res2"),
  radioButtons("selected", "Selected value:", month.name, inline = TRUE)
  
)

server <- function(input, output, session) {
  output$res1 <- renderPrint(input$sel1)
  observe({
    req(input$label_text)
    updateVirtualSelect(inputId = "sel1", label = input$label_text)
  })
  observe({
    req(input$label_html)
    updateVirtualSelect(inputId = "sel1", label = tags$span(input$label_html, style = "color: red;"))
  })
  
  output$res2 <- renderPrint(input$sel2)
  observe({
    updateVirtualSelect(inputId = "sel2", selected = input$selected)
  })
}

if (interactive())
  shinyApp(ui, server)
