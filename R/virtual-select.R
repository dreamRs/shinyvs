
#' Virtual Select Input
#'
#' @param inputId
#' @param label
#' @param choices
#' @param selected
#' @param multiple
#' @param width
#'
#' @return
#' @export
#'
#' @importFrom htmltools tags tagList css validateCssUnit htmlDependency
#' @importFrom shiny restoreInput
#' @importFrom jsonlite toJSON
#'
#' @examples
virtualSelectInput <- function(inputId,
                               label,
                               choices,
                               selected = NULL,
                               multiple = FALSE,
                               search = FALSE,
                               width = NULL) {
  selected <- restoreInput(id = inputId, default = selected)
  config <- list(
    options = choices,
    multiple = multiple,
    search = search
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
        display = "block"
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
