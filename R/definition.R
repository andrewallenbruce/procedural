#' PCS Code Addenda
#'
#' @param section `<chr>` PCS section
#' @param axis `<int>` PCS axis
#' @param term `<chr>` PCS term
#' @returns a [tibble::tibble] containing the results
#' @examples
#' definitions(term = "drain")
#' definitions(section = "0", axis = 5)
#' definitions(section = "B", term = "fluoro")
#'
#'
#' includes(term = "drain")
#' includes(section = "0", axis = 6, term = "^art")
#' includes(section = "3", term = "pro")
#'
#'
#' explanations(term = "drain")
#' explanations("X", 3, "destruction")
#'
#'
#' @export
definitions <- function(section = NULL, axis = NULL, term = NULL) {
  check_string(section, allow_empty = FALSE, allow_null = TRUE)
  check_number_whole(axis, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)

  x <- procedural::pcs_definitions

  if (!is.null(section)) {
    section <- rlang::arg_match(section, funique_(x[["section"]]))
    x <- ss_(x, x[["section"]] %iin% section)
  }

  if (!is.null(axis)) {
    axis <- as.character(axis)
    axis <- rlang::arg_match(axis, as.character(funique_(x[["axis"]])))
    x <- ss_(x, x[["axis"]] %iin% axis)
  }

  if (!is.null(term)) {
    i <- grep(term, x[["term"]], ignore.case = TRUE, perl = TRUE)
    if (!length(i)) {
      cli::cli_abort("{.pkg term} {.val {term}} returned 0 results")
    }
    x <- ss_(x, i)
  }
  return(x)
}

#' @export
#' @rdname definitions
includes <- function(section = NULL, axis = NULL, term = NULL) {
  check_string(section, allow_empty = FALSE, allow_null = TRUE)
  check_number_whole(axis, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)

  x <- procedural::pcs_includes

  if (!is.null(section)) {
    section <- rlang::arg_match(section, funique_(x[["section"]]))
    x <- ss_(x, x[["section"]] %iin% section)
  }

  if (!is.null(axis)) {
    axis <- as.character(axis)
    axis <- rlang::arg_match(axis, as.character(funique_(x[["axis"]])))
    x <- ss_(x, x[["axis"]] %iin% axis)
  }

  if (!is.null(term)) {
    i <- grep(term, x[["term"]], ignore.case = TRUE, perl = TRUE)
    if (!length(i)) {
      cli::cli_abort("{.pkg term} {.val {term}} returned 0 results")
    }
    x <- ss_(x, i)
  }
  return(x)
}

#' @export
#' @rdname definitions
explanations <- function(section = NULL, axis = NULL, term = NULL) {
  check_string(section, allow_empty = FALSE, allow_null = TRUE)
  check_number_whole(axis, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)

  x <- procedural::pcs_explanations

  if (!is.null(section)) {
    section <- rlang::arg_match(section, funique_(x[["section"]]))
    x <- ss_(x, x[["section"]] %iin% section)
  }

  if (!is.null(axis)) {
    axis <- as.character(axis)
    axis <- rlang::arg_match(axis, as.character(funique_(x[["axis"]])))
    x <- ss_(x, x[["axis"]] %iin% axis)
  }

  if (!is.null(term)) {
    i <- grep(term, x[["term"]], ignore.case = TRUE, perl = TRUE)
    if (!length(i)) {
      cli::cli_abort("{.pkg term} {.val {term}} returned 0 results")
    }
    x <- ss_(x, i)
  }
  return(x)
}
