
#' @title Virtual Select Input
#'
#' @description A select dropdown widget made for performance,
#'  based on [virtual-select](https://github.com/sa-si-dev/virtual-select).
#'
#' @param choices List of choices, **warning** format is a little different than [shiny::selectInput()].
#' You can use:
#'  * `vector` use a simple vector for better performance.
#'  * `list` custom list allowing to use more options, must correspond to [virtual-select specifications](https://sa-si-dev.github.io/virtual-select/#/properties)
#' @inheritParams shiny::selectInput
#' @param search Enable search feature.
#' @param hideClearButton Hide clear value button.
#' @param showSelectedOptionsFirst Show selected options at the top of the dropbox.
#' @param showValueAsTags Show each selected values as tags with remove icon.
#' @param ... Other arguments passed to JavaScript method, see
#'  [virtual-select documentation](https://sa-si-dev.github.io/virtual-select/#/properties) for a full list of options.
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
                               hideClearButton = FALSE,
                               showSelectedOptionsFirst = FALSE,
                               showValueAsTags = FALSE,
                               ...,
                               inline = FALSE,
                               width = NULL) {
  selected <- restoreInput(id = inputId, default = selected)
  config <- list(
    options = choices,
    multiple = multiple,
    search = search,
    selectedValue = selected,
    hideClearButton = hideClearButton,
    showSelectedOptionsFirst = showSelectedOptionsFirst,
    showValueAsTags = showValueAsTags,
    ...
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
