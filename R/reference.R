#' ICD-10-PCS Sections
#'
#' @param x ICD-10-PCS section value, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#' @returns tibble
#' @examplesIf FALSE
#' sections()
#' sections("0")
#' sections("2")
#' sections("X")
#' @export
sections <- function(x = NULL) {
  if (!is.null(x)) {
    x <- toupper(as.character(x))
  }
}

#' ICD-10-PCS Body Systems
#'
#' @param x ICD-10-PCS body systems character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 114 systems.
#' @returns tibble
#' @examplesIf FALSE
#' systems()
#' systems("0")
#' systems("2")
#' systems("X")
#' @export
systems <- function(x = NULL) {
  if (!is.null(x)) {
    x <- toupper(as.character(x))
  }
}
