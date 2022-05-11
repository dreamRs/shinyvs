# shinyvs

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/dreamRs/shinyvs/workflows/R-CMD-check/badge.svg)](https://github.com/dreamRs/shinyvs/actions)
<!-- badges: end -->

Virtual Select widget for [shiny](https://shiny.rstudio.com/) applications built for performance. Powered by [virtual-select](https://github.com/sa-si-dev/virtual-select).


:rotating_light: :rotating_light: :rotating_light: This widget is now available in package [shinyWidgets](https://github.com/dreamRs/shinyWidgets) (>= 0.7.0 on CRAN) :rotating_light: :rotating_light: :rotating_light: 


## Installation

You can install the development version of shinyvs from [GitHub](https://github.com/dreamRs/shinyvs) with:

``` r
# install.packages("remotes")
remotes::install_github("dreamRs/shinyvs")
```


## Example

Minimal example with 97310 choices from [babynames](https://github.com/hadley/babynames) package:

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


## Development

This package use [{packer}](https://github.com/JohnCoene/packer) to manage JavaScript assets, see packer's [documentation](https://packer.john-coene.com/#/) for more.

Install nodes modules with:

```r
packer::npm_install()
```

Modify `srcjs/inputs/virtual-select.js`, then run:

```r
packer::bundle()
```

Re-install R package and try `virtualSelectInput()` function.
