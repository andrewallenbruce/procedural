#' ICD-10-PCS Axes
#'
#' @param x alphanumeric code; default is `NULL`
#' @returns tibble
#' @examples
#' section()
#'
#' @export
section <- function(x = NULL) {
  collapse::ss(
    procedural::pcs_tables,
    procedural::pcs_tables$pos %==% 1L
  ) |>
    collapse::funique(cols = c("pos", "title", "code", "label"))
}

#' @examples
#' system()
#'
#' @export
#' @rdname section
system <- function(x = NULL) {
  collapse::ss(
    procedural::pcs_tables,
    procedural::pcs_tables$pos %iin% 1:2
  ) |>
    collapse::funique(cols = c("pos", "title", "code", "label"))
}

#' @examples
#' table()
#'
#' @export
#' @rdname section
table <- function(x = NULL) {
  collapse::ss(
    procedural::pcs_tables,
    procedural::pcs_tables$pos %iin% 0:3
  )
}
