#' @autoglobal
#' @noRd
is_system <- function(x,
                      arg = rlang::caller_arg(x),
                      call = rlang::caller_env()) {

  if (!substr(x, 1, 1) %in% c(0:9, LETTERS[c(2:4, 6:8, 24)])) {
    cli::cli_abort(c(
      "Invalid {.strong Section} value",
      "i" = "Valid values: {.val {rlang::syms(c('0-9', 'B-H', 'X'))}}."),
      call = call)}

  # if (substr(x, 2, 2) %nin% c(0:9, LETTERS[c(1:8, 10:14, 16:26)])) {
  #   cli::cli_abort(c(
  #     "Valid {.strong PCS System} axis values: {.emph {.strong 0-9, J-N or P-Z}}.",
  #     "x" = "{.strong {.val {x}}} value: {.strong {.val {substr(x, 2, 2)}}}."),
  #     call = call)}

  section <- substr(x, 1, 1)

  values <- list(
    '0' = c(0:9, "B", "C", "D", "F", "G", "H", "J", "K", "L", "M",
            "N", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y"),
    '1' = '0',
    '2' = c("W", "Y"),
    '3' = c(0, "C", "E"),
    '4' = c("A", "B"),
    '5' = "A",
    '6' = "A",
    '7' = "W",
    '8' = c("C", "E"),
    '9' = "W",
    'B' = c(0, 2:5, 7:9, "B", "D", "F", "G", "H", "L", "N", "P", "Q",
            "R", "T", "U", "V", "W", "Y"),
    'C' = c("0", "2", "5", 7:9, "B", "D", "F", "G", "H", "P", "T", "V", "W"),
    'D' = c("0", 7:9, "B", "D", "F", "G", "H", "M", "P", "T", "U", "V", "W"),
    'F' = c("0", "1"),
    'G' = "Z",
    'H' = "Z",
    'X' = c(2, "D", "F", "H", "K", "N", "R", "T", "V", "W", "X", "Y"))

  valid <- fuimus::delister(values[section])

  if (!substr(x, 2, 2) %in% valid) {
    cli::cli_abort(c(
      "Invalid {.strong Section {.val {rlang::sym(section)}}} System value",
      "i" = "{.strong {.val {length(valid)}}} valid value{?s}: {.val {rlang::syms(valid)}}."),
      call = call)
  }
  nchar(x) >= 2L
}

#' @autoglobal
#' @noRd
is_table <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {

  if (!substr(x, 1, 1) %in% c(0:9, LETTERS[c(2:4, 6:8, 24)])) {
    cli::cli_abort(c(
      "Valid {.strong PCS Section} axis values: {.emph {.strong 0-9, B-H or X}}.",
      "x" = "{.strong {.val {x}}} value: {.strong {.val {substr(x, 1, 1)}}}."),
      call = call)}

  if (!substr(x, 2, 2) %in% c(0:9, LETTERS[c(1:8, 10:14, 16:26)])) {
    cli::cli_abort(c(
      "Valid {.strong PCS System} axis values: {.emph {.strong 0-9, J-N or P-Z}}.",
      "x" = "{.strong {.val {x}}} value: {.strong {.val {substr(x, 2, 2)}}}."),
      call = call)}

  if (!substr(x, 3, 3) %in% c(0:9, LETTERS[c(1:8, 10:14, 16:25)])) {
    cli::cli_abort(c(
      "Valid {.strong PCS Operation} axis values: {.emph {.strong 0-9, J-N or P-Y}}.",
      "x" = "{.strong {.val {x}}} value: {.strong {.val {substr(x, 3, 3)}}}."),
      call = call)}

  x
}

#' @autoglobal
#' @noRd
is_row <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {

  if (!substr(x, 4, 4) %in% c(0:9, LETTERS[c(1:8, 10:14, 16:26)])) {
    cli::cli_abort(c(
      "Valid {.strong PCS Body Part / Region} axis values: {.emph {.strong 0-9, J-N or P-Z}}.",
      "x" = "{.strong {.val {x}}} value: {.strong {.val {substr(x, 4, 4)}}}."),
      call = call)}

  x
}

#' @autoglobal
#' @noRd
is_single_id <- function(x, y) {
  length(dplyr::intersect(x, y)) == 1L
}

