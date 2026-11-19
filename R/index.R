#' PCS Alphabetic Index
#'
#' The Alphabetic Index maps clinician-documented terminology to PCS tables and
#' codes.
#'
#' @details
#' Unlike the ICD-10-CM index, most entries do not end at a complete code.
#' Rather, they point to a PCS table or row (the first three or four
#' characters), and the coder completes the remaining characters inside that
#' table. Look up the term, follow it to the table, then build and verify the
#' full seven-character code on its code page.
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
