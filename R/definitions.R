#' ICD-10-PCS Definitions
#' @param section PCS section character.
#' @param axis PCS axis position.
#' @param text PCS axis label.
#' @return a [dplyr::tibble()]
#' @examples
#' definitions(section = "0", axis = "3", text = "Drainage")
#'
#' definitions(section = "0", axis = "5")
#'
#' definitions(section = "B", text = "Fluoroscopy")
#'
#' @export
definitions <- function(section = NULL,
                        axis = NULL,
                        text = NULL) {

  def <- pins::pin_read(mount_board(), "definitions")

  if (!is.null(section)) {
    if (is.numeric(section))  section <- as.character(section)
    if (grepl("[[:lower:]]*", section)) section <- toupper(section)
    section <- rlang::arg_match(section, c(0:9, "B", "C", "F", "G", "H", "X"))
    def <- vctrs::vec_slice(def, def$section == section)
    }

  if (!is.null(axis)) {
    if (is.numeric(axis)) axis <- as.character(axis)
    axis <- rlang::arg_match(axis, c("3", "4", "5"))
    def <- vctrs::vec_slice(def, def$axis == axis)
  }

  # if (!is.null(text)) {def <- dplyr::filter(def, grepl(text, label, ignore.case = TRUE))}
  if (!is.null(text)) def <- srchcol(def, 'label', text)

  return(def)
}

#' ICD-10-PCS Includes
#' @param section PCS section character.
#' @param axis PCS axis position.
#' @param name PCS axis name.
#' @param text PCS axis label.
#' @return a [dplyr::tibble()]
#' @examples
#' includes(section = "0", axis = "3")
#' @export
includes <- function(section = NULL,
                     axis = NULL,
                     name = NULL,
                     text = NULL) {

  includes <- pins::pin_read(mount_board(), "includes")

  if (!is.null(section)) {
    if (is.numeric(section))  section <- as.character(section)
    if (grepl("[[:lower:]]*", section)) section <- toupper(section)

    section <- rlang::arg_match(section, c(0, 3, "F", "G", "X"))

    includes <- vctrs::vec_slice(includes, includes$section == section)
  }

  if (!is.null(axis)) {
    if (is.numeric(axis)) axis <- as.character(axis)
    axis <- rlang::arg_match(axis, c("3", "4", "5", "6"))
    includes <- vctrs::vec_slice(includes, includes$axis == axis)
  }

  if (!is.null(name)) {includes <- dplyr::filter(includes, name == name)}

  if (!is.null(text)) {
    includes <- dplyr::filter(includes, grepl(text, label, ignore.case = TRUE))
  }
  return(includes)
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

#' ICD-10-PCS Devices
#' @param system Column to search
#' @param device description
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' devices()
#' @export
devices <- function(system = NULL,
                    device = NULL) {

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

#' Return a range of ICD-10-PCS codes.
#' @param start 7-character string representing an ICD-10-PCS code.
#' @param end 7-character string representing an ICD-10-PCS code.
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' code_range("0G9000Z", "0G9100Z")
#'
#' code_range("0G9000Z", "10D20ZZ")
#'
#' @export
code_range <- function(start, end) {

  start <- checks(start)
  end <- checks(end)

  if (nchar(start) < 7L) cli::cli_abort("{.var start} must be 7 characters long.")
  if (nchar(end) < 7L) cli::cli_abort("{.var end} must be 7 characters long.")

  base <- pins::pin_read(mount_board(), "tables_order")[c('order', 'code', 'table', 'row')]

  o_start <- dplyr::filter(base, code == start) |> dplyr::pull(order)
  o_end <- dplyr::filter(base, code == end) |> dplyr::pull(order)

  if (o_start > o_end) {
    cli::cli_abort(c(
      "{.val {start}} comes after {.val {end}}",
      "x" = "{.val {o_start}} > {.val {o_end}}."))}
  dplyr::filter(base, dplyr::between(order, o_start, o_end))
}

#' ICD-10-PCS Code Order
#' @param code 1 to 7-character string.
#'    If `NULL` (default), returns all 78,603 codes.
#' @param text Search code descriptions
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' order(code = "00X")
#'
#' order(text = "Olfactory")
#'
#' @export
order <- function(code = NULL, text = NULL) {

  tbl <- pins::pin_read(mount_board(), "tables_order") |>
    dplyr::select(order, code, description = description_code)

  if (!is.null(code)) tbl <- srchcol(tbl, 'code', checks(code)[['input']], TRUE)
  if (!is.null(text)) tbl <- srchcol(tbl, 'description', text)

  return(tbl)
}
