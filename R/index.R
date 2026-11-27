#' Search the PCS Alphabetic Index
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
#' @param letter `<chr>` letter/chapter to filter to; A - Z, including 3
#' @param term `<chr>` term to search for
#' @returns a [tibble::tibble] containing the results
#' @examples
#' index(term = "Abdominohysterectomy")
#' index(term = "Attain Ability")
#' index(term = "arthr*")
#' index(letter = "3")
#' @export
index <- function(letter = NULL, term = NULL) {
  check_string(letter, allow_empty = FALSE, allow_null = TRUE)
  check_string(term, allow_empty = FALSE, allow_null = TRUE)

  x <- procedural::pcs_index

  if (!is.null(letter)) {
    letter <- rlang::arg_match(letter, collapse::funique(x[["letter"]]))
    x <- ss_(x, x[["letter"]] %iin% letter)
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
