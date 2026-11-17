#' ICD-10-PCS Includes
#'
#' @param section PCS section:
#'    * `"0"` (Medical and Surgical),
#'    * `"3"` (Administration)
#'    * `"F"` (Physical Rehabilitation and Diagnostic Audiology)
#'    * `"G"` (Mental Health)
#'    * `"X"` (New Technology)
#' @param axis PCS axis:
#'    * `"3"`
#'      * Operation (0:9, X)
#'      * Type (B, C, F, G, H)
#'    * `"4"`
#'      * Qualifier (G)
#'    * `"5"`
#'      * Approach (0:4, 7:9, X)
#'      * Type Qualifier (F)
#' @param col column to search: `"name"`, `"label"` (default), `"includes"`
#' @param search string to search for in `col`
#' @returns tibble
#' @examplesIf FALSE
#' includes(section = "0", axis = "3")
#' @export
includes <- function(
  section = NULL,
  axis = NULL,
  col = c("label", "name", "includes"),
  search = NULL
) {
  # col <- match.arg(col)
  #
  # if (!is.null(section)) {
  #   section <- toupper(as.character(section))
  #   section <- rlang::arg_match0(section, c(0, 3, "F", "G", "X"))
  #   includes <- vctrs::vec_slice(includes, includes$section == section)
  # }
  #
  # if (!is.null(axis)) {
  #   axis <- as.character(axis)
  #   axis <- rlang::arg_match0(axis, c("3", "4", "5"))
  #   includes <- vctrs::vec_slice(includes, includes$axis == axis)
  # }
  #
  # if (!is.null(search)) {
  #   includes <- fuimus::srchcol(includes, col = col, search = search)
  # }
  # return(.add_class(includes))
}
