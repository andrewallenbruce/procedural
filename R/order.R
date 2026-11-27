#' PCS Code Order/Range
#'
#' @param x description
#' @param start,end `<chr>` Full 7-character ICD-10-PCS code.
#' @returns a [tibble::tibble] containing the results
#' @examples
#' order()
#'
#' @export
order <- function(x) {
  procedural::pcs_order
}

#' @examples
#' range("0G9000Z", "0G9100Z")
#' range("0G9000Z", "10D20ZZ")
#' range("0G9000Z", "0G9000Z")
#' try(range("0G9100Z", "0G9000Z"))
#'
#' @rdname order
#' @export
range <- function(start, end) {
  check_string(start, allow_empty = FALSE)
  check_string(end, allow_empty = FALSE)

  if (any_(nchar(c(start, end)) < 7L)) {
    cli::cli_abort("Both {.pkg start} and {.pkg end} must be 7 characters.")
  }

  x <- procedural::pcs_order
  o <- name_(c(start, end), c("start", "end"))
  i <- match_(o, x[["code"]])

  if (anyNA(i)) {
    args <- names(o[cheapr::which_na(i)])
    cli::cli_abort("{.pkg {args}} returned no results.")
  }

  if (diff(i) < 0L) {
    cli::cli_abort(
      c(
        "x" = "{.pkg {start}} {.emph (#{i[1]})} comes after {.pkg {end}} {.emph (#{i[2]})}",
        "i" = "Did you mean {.code p_range(start = {.val {end}}, end = {.val {start}})} ?"
      )
    )
  }

  ss_(x, cheapr::seq_(i[1L], i[2L]))
}
