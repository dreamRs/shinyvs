
#' @importFrom htmltools htmlDependency
html_dependency_virtualselect <- function() {
  htmlDependency(
    name = "virtual-select",
    version = "1.0.24",
    src = c(file = system.file("packer", package = "shinyvs")),
    script = "virtual-select.js"
  )
}


#' Prepare choices for [virtualSelectInput()]
#'
#' @param .data An object of type [data.frame()].
#' @param label Variable to use as labels (displayed to user).
#' @param value Variable to use as values (retrieved server-side).
#' @param group_by Variable identifying groups to use option group feature.
#' @param description Optional variable allowing to show a text under the labels.
#' @param alias Optional variable containing text to use with search feature.
#'
#' @return A `list` to use as `choices` argument of [virtualSelectInput()].
#' @export
#'
#' @importFrom rlang enexprs eval_tidy is_null
#'
#' @example examples/prepare-choices.R
prepare_choices <- function(.data,
                            label,
                            value,
                            group_by = NULL,
                            description = NULL,
                            alias = NULL) {
  args <- lapply(
    X = enexprs(
      label = label,
      value = value,
      group_by = group_by,
      description = description,
      alias = alias
    ),
    FUN = eval_tidy,
    data = as.data.frame(.data)
  )
  args <- dropNulls(args)
  if (!is_null(args$group_by)) {
    type <- "transpose_group"
    groups <- args$group_by
    args$group_by <- NULL
    args <- lapply(
      X = unique(groups),
      FUN = function(group) {
        list(
          label = group,
          options = lapply(args, `[`, groups == group)
        )
      }
    )
  } else {
    type <- "transpose"
  }
  structure(list(choices = args, type = type), class = c("list", "vs_choices"))
}



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
#' @param optionsCount No.of options to show on viewport.
#' @param ... Other arguments passed to JavaScript method, see
#'  [virtual-select documentation](https://sa-si-dev.github.io/virtual-select/#/properties) for a full list of options.
#' @param html Allow usage of HTML in choices.
#' @param inline Display inline with label or not.
#'
#' @return A `shiny.tag` object that can be used in a UI definition.
#' @export
#'
#' @importFrom htmltools tags css validateCssUnit HTML
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
                               optionsCount = 10,
                               ...,
                               html = FALSE,
                               inline = FALSE,
                               width = NULL) {
  selected <- restoreInput(id = inputId, default = selected)
  data <- list(
    options = process_choices(choices),
    config = list(
      multiple = multiple,
      search = search,
      selectedValue = selected,
      hideClearButton = hideClearButton,
      showSelectedOptionsFirst = showSelectedOptionsFirst,
      showValueAsTags = showValueAsTags,
      optionsCount = optionsCount,
      ...
    )
  )
  data <- toJSON(data, auto_unbox = TRUE, json_verbatim = TRUE)
  if (isTRUE(html))
    data <- HTML(data)
  tags$div(
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
        width = "100%",
        maxWidth = "none",
        display = if (!inline) "block"
      ),
      tags$script(
        type = "application/json",
        `data-for` = inputId,
        data
      )
    ),
    html_dependency_virtualselect()
  )
}



#' Update virtual select from server
#'
#' @inheritParams virtualSelectInput
#' @inheritParams shiny::updateSelectInput
#'
#' @return No value.
#' @export
#'
#' @importFrom shiny getDefaultReactiveDomain
#' @importFrom htmltools doRenderTags
#'
#' @example examples/update.R
updateVirtualSelect <- function(inputId,
                                label = NULL,
                                choices = NULL,
                                selected = NULL,
                                session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(label))
    label <- doRenderTags(label)
  if (!is.null(choices))
    choices <- process_choices(choices)
  message <- dropNulls(list(
    label = label,
    options = choices,
    value = selected
  ))
  session$sendInputMessage(inputId, message)
}



