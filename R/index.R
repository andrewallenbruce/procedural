#' ICD-10-PCS Index
#'
#' @param term `<chr>` term to search for
#' @returns a [tibble::tibble] containing the results
#' @examples
#' index("Abdominohysterectomy")
#' index("Attain Ability")
#' index("arthr*")
#' index()
#' @export
index <- function(term = NULL) {
  check_string(term, allow_empty = FALSE, allow_null = TRUE)
  if (!is.null(term)) {
    x <- ss_(
      procedural::pcs_index,
      grep(
        term,
        procedural::pcs_index[["term"]],
        ignore.case = TRUE,
        perl = TRUE
      )
    )
    if (!nrow_(x)) {
      cli::cli_abort('{.pkg term = "{term}"} returned 0 rows')
    }
  } else {
    x <- procedural::pcs_index
  }
  return(x)
}
