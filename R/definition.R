#' ICD-10-PCS Definitions
#'
#' @param section `<chr>` PCS section; one of `0:9, B, C, F, G, H, X`
#' @param axis `<int>` PCS axis; one of `3, 4, 5, 6`
#'    * 3: Operation
#'    * 3: Type
#'    * 4: Body Part
#'    * 4: Qualifier
#'    * 5: Approach
#'    * 5: Type Qualifier
#'    * 6: Substance
#'    * 6: Device
#'    * 6: Device / Substance / Technology
#' @param term `<chr>` term to search for
#' @param complete `<lgl>`  Return complete entries; default is `TRUE`
#' @returns a [tibble::tibble] containing the results
#' @examples
#' try(definition(term = "drinnn"))
#' definition(term = "drain")
#' definition(section = "0", axis = 5)
#' definition(section = "B", term = "fluoro")
#' definition()
#' @export
definition <- function(
  section = NULL,
  axis = NULL,
  term = NULL,
  complete = TRUE
) {
  if (!is.null(section)) {
    x <- ss_(
      procedural::pcs_definitions,
      procedural::pcs_definitions[["section"]] %iin% section
    )
    if (!nrow(x)) {
      cli::cli_abort('{.pkg section = "{section}"} returned 0 rows')
    }
  } else {
    x <- procedural::pcs_definitions
  }

  if (!is.null(axis)) {
    x <- ss_(x, x[["axis"]] %iin% axis)
    if (!nrow(x)) {
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
    if (!nrow(x)) {
      cli::cli_abort('{.pkg term = "{term}"} returned 0 rows')
    }
    if (complete) {
      x <- ss_(
        procedural::pcs_definitions,
        procedural::pcs_definitions[["entry"]] %iin% collapse::funique(x$entry)
      )
    }
  }
  return(x)
}
