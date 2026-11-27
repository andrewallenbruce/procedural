#' PCS Axes of Classification
#'
#' @param code alphanumeric code; default is `NULL`
#' @returns tibble
#' @examples
#' section()
#'
#' system()
#'
#' table()
#'
#' @export
table <- function(code = NULL) {
  x <- procedural::pcs_tables
  ss_(x, x[["pos"]] %iin% 0:3)
}

#' @export
#' @rdname table
section <- function(code = NULL) {
  x <- procedural::pcs_tables
  ss_(x, x[["pos"]] %==% 1L) |>
    funique_(cols = c("pos", "title", "code", "label"))
}

#' @export
#' @rdname table
system <- function(code = NULL) {
  x <- procedural::pcs_tables
  ss_(x, x[["pos"]] %iin% 1:2) |>
    funique_(cols = c("pos", "title", "code", "label"))
}
