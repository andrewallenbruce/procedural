#' ICD-10-PCS Definitions
#'
#' @param section `<chr>` PCS section; one of `0:9, B, C, F, G, H, X`
#'    * Operation: `0:9, X`
#'    * Approach: `0:4, 7:9, X`
#'    * Type: `B, C, F, G, H`
#'    * Type Qualifier: `F`
#'    * Qualifier: `G`
#' @param axis `<int>` PCS axis; one of `3, 4, 5`
#'    * `3`: Operation (91) | Type (46)
#'    * `4`: Qualifier (15)
#'    * `5`: Approach (39) | Type Qualifier (129)
#' @param term `<chr>` term to search for
#' @returns a [tibble::tibble] containing the results
#' @examples
#' try(definition(term = "drinnn"))
#' definition(term = "drain")
#' definition(section = "0", axis = 5)
#' definition(section = "B", term = "fluoro")
#' definition()
#'
#' @export
definition <- function(section = NULL, axis = NULL, term = NULL) {
  check_string(section, allow_empty = FALSE, allow_null = TRUE)
  check_number_whole(axis, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)
  if (!is.null(section)) {
    x <- ss_(
      procedural::pcs_definitions,
      procedural::pcs_definitions[["section"]] %iin% section
    )
    if (!nrow_(x)) {
      cli::cli_abort('{.pkg section = "{section}"} returned 0 rows')
    }
  } else {
    x <- procedural::pcs_definitions
  }

  if (!is.null(axis)) {
    x <- ss_(x, x[["axis"]] %iin% axis)
    if (!nrow_(x)) {
      cli::cli_abort('{.pkg axis = "{axis}"} returned 0 rows')
    }
  }

  if (!is.null(term)) {
    x <- ss_(
      x,
      grep(
        term,
        x[["term"]],
        ignore.case = TRUE,
        perl = TRUE
      )
    )
    if (!nrow_(x)) {
      cli::cli_abort('{.pkg term = "{term}"} returned 0 rows')
    }
  }
  return(x)
}

#' @examples
#' try(includes(section = "B"))
#' includes(term = "drain")
#' includes(section = "0", axis = 6)
#' includes(section = "3", term = "pro")
#' includes()
#'
#' @export
#' @rdname definition
includes <- function(section = NULL, axis = NULL, term = NULL) {
  check_string(section, allow_empty = FALSE, allow_null = TRUE)
  check_number_whole(axis, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)
  if (!is.null(section)) {
    x <- ss_(
      procedural::pcs_includes,
      procedural::pcs_includes[["section"]] %iin% section
    )
    if (!nrow_(x)) {
      cli::cli_abort('{.pkg section = "{section}"} returned 0 rows')
    }
  } else {
    x <- procedural::pcs_includes
  }

  if (!is.null(axis)) {
    x <- ss_(x, x[["axis"]] %iin% axis)
    if (!nrow_(x)) {
      cli::cli_abort('{.pkg axis = "{axis}"} returned 0 rows')
    }
  }

  if (!is.null(term)) {
    x <- ss_(
      x,
      grep(
        term,
        x[["term"]],
        ignore.case = TRUE,
        perl = TRUE
      )
    )
    if (!nrow_(x)) {
      cli::cli_abort('{.pkg term = "{term}"} returned 0 rows')
    }
  }
  return(x)
}
