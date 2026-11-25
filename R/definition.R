#' ICD-10-PCS Code Addenda
#'
#' @param section `<chr>` PCS section
#' @param axis `<int>` PCS axis
#' @param term `<chr>` PCS term
#' @returns a [tibble::tibble] containing the results
#' @examples
#' try(definitions(term = "drinnn"))
#' definitions(term = "drain")
#' definitions(section = "0", axis = 5)
#' definitions(section = "B", term = "fluoro")
#' definitions()
#'
#'
#' @export
definitions <- function(section = NULL, axis = NULL, term = NULL) {
  check_string(section, allow_empty = FALSE, allow_null = TRUE)
  check_number_whole(axis, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)

  x <- procedural::pcs_definitions

  if (!is.null(section)) {
    section <- rlang::arg_match(section, collapse::funique(x[["section"]]))
    x <- ss_(x, x[["section"]] %iin% section)
  }

  if (!is.null(axis)) {
    axis <- as.character(axis)
    axis <- rlang::arg_match(axis, as.character(collapse::funique(x[["axis"]])))
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

#' @examples
#' try(includes(section = "3", axis = 5))
#' includes(term = "drain")
#' includes(section = "0", axis = 6, term = "^art")
#' includes(section = "3", term = "pro")
#' includes()
#'
#'
#' @export
#' @rdname definitions
includes <- function(section = NULL, axis = NULL, term = NULL) {
  check_string(section, allow_empty = FALSE, allow_null = TRUE)
  check_number_whole(axis, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)

  x <- procedural::pcs_includes

  if (!is.null(section)) {
    section <- rlang::arg_match(section, collapse::funique(x[["section"]]))
    x <- ss_(x, x[["section"]] %iin% section)
  }

  if (!is.null(axis)) {
    axis <- as.character(axis)
    axis <- rlang::arg_match(axis, as.character(collapse::funique(x[["axis"]])))
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

#' @examples
#' try(explanations(section = "B"))
#' explanations(term = "drain")
#' explanations(section = "X", axis = 3, term = "destruction")
#' explanations()
#'
#'
#' @export
#' @rdname definitions
explanations <- function(section = NULL, axis = NULL, term = NULL) {
  check_string(section, allow_empty = FALSE, allow_null = TRUE)
  check_number_whole(axis, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)

  x <- procedural::pcs_explanations

  if (!is.null(section)) {
    section <- rlang::arg_match(section, collapse::funique(x[["section"]]))
    x <- ss_(x, x[["section"]] %iin% section)
  }

  if (!is.null(axis)) {
    axis <- as.character(axis)
    axis <- rlang::arg_match(axis, as.character(collapse::funique(x[["axis"]])))
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
