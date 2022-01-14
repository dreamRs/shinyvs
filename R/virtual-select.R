
#' @title Virtual Select Input
#'
#' @description A select dropdown widget made for performance,
#'  based on [virtual-select](https://github.com/sa-si-dev/virtual-select).
#'
#' @param choices List of choices
#' @inheritParams shiny::selectInput
#' @param search Enable search feature.
#' @param inline Display inline with label or not.
#'
#' @return A `shiny.tag.list` object that can be used in a UI definition.
#' @export
#'
#' @importFrom htmltools tags tagList css validateCssUnit htmlDependency
#' @importFrom shiny restoreInput
#' @importFrom jsonlite toJSON
#'
#' @example examples/default.R
virtualSelectInput <- function(inputId,
                               label,
                               choices,
                               selected = NULL,
                               multiple = FALSE,
                               search = FALSE,
                               inline = FALSE,
                               width = NULL) {
  selected <- restoreInput(id = inputId, default = selected)
  config <- list(
    options = choices,
    multiple = multiple,
    search = search,
    selectedValue = selected
  )
  vsTag <- tags$div(
    class = "form-group shiny-input-container",
    style = css(width = validateCssUnit(width)),
    tags$label(
      label,
      class = "control-label",
      class = if (is.null(label)) "shiny-label-null",
      id = paste0(inputId, "-label"),
      `for` = inputId
    ),
    tags$div(
      id = inputId,
      class = "virtual-select",
      style = css(
        width = validateCssUnit(width),
        maxWidth = validateCssUnit(width),
        display = if (!inline) "block"
      ),
      tags$script(
        type = "application/json",
        `data-for` = inputId,
        toJSON(config, auto_unbox = TRUE, json_verbatim = TRUE)
      )
    )
  )
  tagList(vsTag, htmlDependency(
    name = "virtual-select",
    version = "1.0.24",
    src = c(file = system.file("packer", package = "shinyvs")),
    script = "virtual-select.js"
  ))
}
