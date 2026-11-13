#' Validate Section Values
#'
#' The 17 valid PCS Section values are "B-D", "F-H", "X", and "0-9".
#'
#' @param x `<chr>` string
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#' @examples
#' x <- c("0", "3", "K")
#'
#' is_section_value(x)
#'
#' x[which(is_section_value(x))]
#'
#' try(is_section_value("XX"))
#'
#' @family PCS validators
#' @export
is_section_value <- function(x) {
  check_nchar(x, 1)
  grepl("^[BCDFGHX0-9]$", x, perl = TRUE)
}

#' Validate System Values
#'
#' The 34 valid PCS System values are "A-H", "J-N", "P-Z", and "0-9".
#'
#' @param x `<chr>` string
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#' @examples
#' x <- c(LETTERS, 0:9)
#'
#' is_system_value(x)
#'
#' x[which(is_system_value(x))]
#'
#' try(is_system_value("XX"))
#'
#' @family PCS validators
#' @export
is_system_value <- function(x) {
  check_nchar(x, 1)
  grepl("^[A-HJ-NP-Z0-9]$", x, perl = TRUE)
}
