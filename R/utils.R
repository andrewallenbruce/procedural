#' @export
print.procedural <- function(x, ...) {
  withr::with_options(
    list(
      pillar.bold = TRUE,
      pillar.subtle_num = TRUE,
      pillar.print_min = 20
    ),
    NextMethod()
  )
  invisible(x)
}

#' @noRd
.add_class <- function(data) {
  data <- tibble::as_tibble(data)

  class(data) <- unique(c("procedural", class(data)))

  data
}

#' @noRd
ss_ <- function(.data, row, col) {
  collapse::ss(x = .data, i = row, j = col, check = FALSE)
}

#' @noRd
any_ <- function(x) {
  collapse::anyv(x = x, value = TRUE)
}

#' @noRd
match_ <- function(x, tbl, ...) {
  collapse::fmatch(x = x, table = tbl, ...)
}

#' @noRd
un_ <- function(x) {
  unlist(x, use.names = FALSE)
}
