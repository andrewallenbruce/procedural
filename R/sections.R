#' ICD-10-PCS Sections
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#' @return a [dplyr::tibble()]
#' @examples
#' sections()
#'
#' sections("0")
#'
#' sections("2")
#'
#' sections("X")
#'
#' @export
sections <- function(x = NULL) {

  sec <- dplyr::tibble(
    axis = 1L,
    name = "Section",
    code = c(0:9, LETTERS[2:4], LETTERS[6:8], LETTERS[24]),
    label = c("Medical and Surgical",
              "Obstetrics",
              "Placement",
              "Administration",
              "Measurement and Monitoring",
              "Extracorporeal or Systemic Assistance and Performance",
              "Extracorporeal or Systemic Therapies",
              "Osteopathic",
              "Other Procedures",
              "Chiropractic",
              "Imaging",
              "Nuclear Medicine",
              "Radiation Therapy",
              "Physical Rehabilitation and Diagnostic Audiology",
              "Mental Health",
              "Substance Abuse Treatment",
              "New Technology"))

  if (!is.null(x)) {
    if (is.numeric(x)) x <- as.character(x)
    if (grepl("[[:lower:]]*", x)) {x <- toupper(x)}
    x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))
    if (nchar(x) > 1L) x <- splitter(x)[1]
    sec <- vctrs::vec_slice(sec, sec$code == x)
  }
  return(sec)
}
