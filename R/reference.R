#' ICD-10-PCS Sections
#'
#' @param x ICD-10-PCS section value, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#' @returns tibble
#' @examples
#' section()
#' @export
section <- function(x = NULL) {
  if (!is.null(x)) {
    x <- toupper(as.character(x))
  }
  collapse::ss(
    procedural::pcs_tables,
    procedural::pcs_tables$pos %==% 1L,
    -1L
  ) |>
    cheapr::unique_()
}

#' ICD-10-PCS Body Systems
#'
#' @param x ICD-10-PCS body systems character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 114 systems.
#' @returns tibble
#' @examples
#' system()
#' @export
system <- function(x = NULL) {
  if (!is.null(x)) {
    x <- toupper(as.character(x))
  }
  collapse::ss(
    procedural::pcs_tables,
    procedural::pcs_tables$pos %iin% 1:2,
    -1L
  ) |>
    cheapr::unique_()
}
