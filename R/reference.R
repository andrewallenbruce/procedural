#' ICD-10-PCS Sections
#'
#' @param x ICD-10-PCS section value, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#'
#' @template returns-default
#'
#' @examples
#' sections()
#'
#' sections("0")
#'
#' sections("2")
#'
#' sections("X")
#'
#' @autoglobal
#'
#' @export
sections <- function(x = NULL) {
  sec <- get_pin("sections")

  if (!is.null(x)) {
    x <- toupper(as.character(x))
  }

  sec <- fuimus::search_in_if(sec, sec$value, x)

  return(sec)
}

#' ICD-10-PCS Body Systems
#'
#' @param x ICD-10-PCS body systems character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 114 systems.
#'
#' @template returns-default
#'
#' @examples
#' systems()
#'
#' systems("0")
#'
#' systems("2")
#'
#' systems("X")
#'
#' @autoglobal
#'
#' @export
systems <- function(x = NULL) {
  sys <- get_pin("systems")

  if (!is.null(x)) {
    x <- toupper(as.character(x))
  }

  sys <- fuimus::search_in_if(sys, sys$section, x)

  return(sys)
}
