#' ICD-10-PCS Definitions
#' @param section PCS section character.
#' @return a [dplyr::tibble()]
#' @examples
#' definitions(section = "2")
#'
#' definitions(section = "4")
#'
#' @export
definitions <- function(section = NULL) {

  def <- pins::pin_read(mount_board(), "pcs_definitions_v2")

  if (!is.null(section)) {
    if (is.numeric(section)) section <- as.character(section)
    if (grepl("[[:lower:]]*", section)) {section <- toupper(section)}
    def <- vctrs::vec_slice(def, def$code == section)
    def <- janitor::remove_empty(def, which = "cols")
  }
  return(def)
}
