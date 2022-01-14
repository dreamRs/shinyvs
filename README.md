# shinyvs

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Virtual Select widget for [shiny](https://shiny.rstudio.com/) applications built for performance. Powered by [virtual-select](https://github.com/sa-si-dev/virtual-select).


## Installation

You can install the development version of shinyvs from [GitHub](https://github.com/dreamRs/shinyvs) with:

``` r
# install.packages("devtools")
devtools::install_github("dreamRs/shinyvs")
```


## Example

Minimal example with 97310 from [babynames](https://github.com/hadley/babynames) package:

``` r
library(shiny)
library(shinyvs)

ui <- fluidPage(
  tags$h2("Virtual Select example"),
  
  virtualSelectInput(
    inputId = "single",
    label = "Single select (with 97310 choices) :",
    choices = sort(unique(babynames::babynames$name)),
    search = TRUE
  ),
  verbatimTextOutput("res_single")
)

server <- function(input, output, session) {
  output$res_single <- renderPrint(input$single)
}

shinyApp(ui, server)
```

