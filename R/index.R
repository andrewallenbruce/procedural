#' ICD-10-PCS Index
#'
#' @param col column to search: "term" (default), "index", "type", "value",
#'   "code"
#' @param search string to search for in `col`
#' @returns tibble
#' @examplesIf FALSE
#' index(search = "Abdominohysterectomy")
#' index(search = "Attain Ability")
#' index(search = "radi*")
#' @export
index <- function(
  search = NULL,
  col = c("term", "index", "verb", "value", "code")
) {
  # ind <- get_pin("index_v2") |>
  # tidyr::unite("term", term, subterm, sep = ", ", na.rm = TRUE) |>
  # dplyr::mutate(id = dplyr::row_number(), .before = 1) |>
  # dplyr::rename(index = letter, type = verb) |>
  # dplyr::select(-c(letter, term_id))
  # col <- match.arg(col)
  #
  # if (!is.null(search)) {
  #   ind <- fuimus::srchcol(ind, col = col, search = search)
  # }
  # return(.add_class(ind))
}
