#' @noRd
ss_ <- function(.data, row, col) {
  collapse::ss(x = .data, i = row, j = col, check = FALSE)
}

#' @noRd
all_ <- function(x) {
  collapse::allv(x = x, value = TRUE)
}

#' @noRd
any_ <- function(x) {
  collapse::anyv(x = x, value = TRUE)
}

#' @noRd
whichv_ <- function(x, negate = FALSE) {
  collapse::whichv(x = x, value = TRUE, invert = negate)
}

#' @noRd
match_ <- function(x, tbl, ...) {
  collapse::fmatch(x = x, table = tbl, ...)
}

#' @noRd
nrow_ <- function(x) {
  collapse::fnrow(x)
}

#' @noRd
pull_ <- function(x, nm) {
  x[[nm]]
}

#' @noRd
un_ <- function(x) {
  unlist(x, use.names = FALSE)
}

#' @noRd
name_ <- function(x, names = x, ...) {
  rlang::set_names(x = x, nm = names, ...)
}

#' @noRd
is_single_id <- function(x, y) {
  length(vctrs::vec_set_intersect(x, y)) == 1L
}

#' @noRd
check_nchar <- function(
  x,
  n = 1,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_number_whole(n, min = 1)

  if (any_(nchar(x) != n)) {
    cli::cli_abort(
      "{.arg {arg}} must be {.val {n}} character{?s} long.",
      arg = arg,
      call = call
    )
  }
  toupper(x)
}
