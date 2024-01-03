#' ICD-10-PCS Sections
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#'
#' approaches()
#'
#' approaches("0")
#'
#' approaches("2")
#'
#' approaches("X")
#'
#' @export
approaches <- function(x = NULL) {

  app <- dplyr::tibble(
    axis = 5L,
    name = "Approach",
    code = c(0:9, LETTERS[2:4], LETTERS[6:8], LETTERS[24]),
    label = c('Open',
              'Open Approach',
              'External Approach',
              'Percutaneous',
              'Percutaneous Endoscopic Approach',
              'Percutaneous Approach',
              'Via Natural or Artificial Opening',
              'Via Natural or Artificial Opening Endoscopic',
              'Via Natural or Artificial Opening Endoscopic Approach',
              'Via Natural or Artificial Opening with Percutaneous Endoscopic Assistance'))

  if (!is.null(x)) {
    if (is.numeric(x)) x <- as.character(x)
    if (grepl("[[:lower:]]*", x)) {x <- toupper(x)}
    x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))
    if (nchar(x) > 1L) x <- splitter(x)[1]
    sec <- vctrs::vec_slice(sec, sec$code == x)
  }
  return(app)
}
