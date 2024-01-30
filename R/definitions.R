#' ICD-10-PCS Definitions
#' @param section PCS section character.
#' @param axis PCS axis position.
#' @param label PCS axis label.
#' @return a [dplyr::tibble()]
#' @examples
#' definitions(section = "0",
#'             axis = "3",
#'             label = "Drainage")
#'
#' definitions(section = "0",
#'             axis = "3",
#'             label = "Drainage")$elements
#'
#' definitions(section = "0",
#'             axis = "4",
#'             label = "Abdominal Aorta")$elements
#'
#' definitions(section = "B",
#'             label = "Fluoroscopy")$elements
#'
#' @export
definitions <- function(section = NULL,
                        axis = NULL,
                        label = NULL) {

  def <- pins::pin_read(mount_board(), "definitions")

  if (!is.null(section)) {
    if (is.numeric(section))  section <- as.character(section)
    if (grepl("[[:lower:]]*", section)) section <- toupper(section)
    section <- rlang::arg_match(section, c(0:9, "B", "C", "F", "G", "H", "X"))
    def <- vctrs::vec_slice(def, def$section == section)
    }

  if (!is.null(axis)) {
    if (is.numeric(axis)) axis <- as.character(axis)
    axis <- rlang::arg_match(axis, c("3", "4", "5", "6"))
    def <- vctrs::vec_slice(def, def$axis == axis)
  }

  if (!is.null(label)) def <- vctrs::vec_slice(def, def$label == label)

  return(def)
}

#' ICD-10-PCS Index
#' @param search Search term
#' @param column Column to search
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' index(search = "Abdominohysterectomy")
#'
#' index(search = "Attain Ability")
#'
#' index(search = "radi*")
#'
#' @export
index <- function(search = NULL,
                  column = NULL) {

  ind <- pins::pin_read(mount_board(), "index_v2") |>
    tidyr::unite("term", term, subterm, sep = ", ", na.rm = TRUE) |>
    dplyr::mutate(id = dplyr::row_number(), .before = 1) |>
    dplyr::rename(index = letter,
                  type = verb) |>
    dplyr::select(-term_id)

  if (!is.null(search)) {
    if (is.null(column)) {column <- "term"}
    ind <- dplyr::filter(ind, stringi::stri_detect_regex(ind[[column]], paste0("(?i)", search)))
    }
  return(ind)
}

#' ICD-10-PCS Index
#' @param system Column to search
#' @param device description
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' devices()
#' @export
devices <- function(system = NULL, device = NULL) {

  dev <- pins::pin_read(mount_board(), "devices")

  if (!is.null(system)) {
    if (is.numeric(system)) system <- as.character(system)
    if (grepl("[[:lower:]]*", system)) section <- toupper(system)
    system <- rlang::arg_match(system, c(2:6, 8:9, "B", "C", "D", "J", "P", "Q", "R", "S", "U"))
    dev <- vctrs::vec_slice(dev, dev$system == system)
  }

  if (!is.null(device)) {
    if (is.numeric(device)) device <- as.character(device)
    device <- rlang::arg_match(device, c(2, 4:7, "D", "J", "M", "P", "S"))
    dev <- vctrs::vec_slice(dev, dev$device == device)
  }
  return(dev)
}


