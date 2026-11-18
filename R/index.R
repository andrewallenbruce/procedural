#' ICD-10-PCS Index
#'
#' @param term `<chr>` term to search for
#' @returns a [tibble::tibble] containing the results
#' @examples
#' index()
#' # index(term = "Abdominohysterectomy")
#' # index(term = "Attain Ability")
#' # index(term = "radi*")
#' @export
index <- function(term = NULL) {
  procedural::pcs_index
}
