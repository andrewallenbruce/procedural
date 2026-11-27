#' @noRd
av_ <- function(.data, ..., where = "front") {
  collapse::av(x = .data, ..., pos = where)
}

#' @noRd
ss_ <- function(.data, row, col, safe = TRUE) {
  collapse::ss(x = .data, i = row, j = col, check = safe)
}

#' @noRd
fill_ <- function(.data, ...) {
  vctrs::vec_fill_missing(x = .data, ...)
}

#' @noRd
csum_ <- function(x, ...) {
  collapse::fcumsum(x = x, ...)
}

#' @noRd
rbind_ <- function(..., id = NULL, use_names = TRUE, fill_in = FALSE) {
  collapse::rowbind(..., idcol = id, use.names = use_names, fill = fill_in)
}

#' @noRd
rorderv_ <- function(x, columns = NULL, ...) {
  collapse::roworderv(X = x, cols = columns, ...)
}

#' @noRd
ifelse_ <- function(cond, if_true, if_false, if_na = NULL) {
  cheapr::if_else_(
    condition = cond,
    true = if_true,
    false = if_false,
    na = if_na
  )
}

#' @noRd
count_ <- function(x, ...) {
  cheapr::counts(x = x, ...)
}

#' @noRd
funique_ <- function(x, ...) {
  collapse::funique(x, ...)
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
