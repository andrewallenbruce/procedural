#' ICD-10-PCS Definitions
#' @param section PCS section character.
#' @param axis PCS axis position.
#' @param col column to search: "name", "value" (default), "label" "definition", "explanation"
#' @param search string to search for in `col`
#' @return a [dplyr::tibble()]
#' @examples
#' definitions(section = "0", axis = "3", col = "label", search = "Drainage")
#'
#' definitions(section = "0", axis = "5")
#'
#' definitions(section = "B", search = "Fluoroscopy")
#'
#' @export
definitions <- function(section = NULL,
                        axis = NULL,
                        col = c("value", "label", "name", "definition", "explanation"),
                        search = NULL) {

  def <- pins::pin_read(mount_board(), "definitions")

  col <- match.arg(col)

  if (!is.null(section)) {
    if (is.numeric(section))  section <- as.character(section)
    if (grepl("[[:lower:]]*", section)) section <- toupper(section)
    # section <- rlang::arg_match(section, c(0:9, "B", "C", "F", "G", "H", "X"))
    def <- vctrs::vec_slice(def, def$section == section)
    }

  if (!is.null(axis)) {
    if (is.numeric(axis)) axis <- as.character(axis)
    axis <- rlang::arg_match(axis, c("3", "4", "5"))
    def <- vctrs::vec_slice(def, def$axis == axis)
  }

  if (!is.null(search)) {
    def <- srchcol(def, col = col, search = search, ignore = TRUE)
    }
  return(def)
}

#' ICD-10-PCS Includes
#' @param section PCS section character.
#' @param axis PCS axis position.
#' @param col column to search: "name", "label" (default), "includes"
#' @param search string to search for in `col`
#' @return a [dplyr::tibble()]
#' @examples
#' includes(section = "0", axis = "3")
#' @export
includes <- function(section = NULL,
                     axis = NULL,
                     col = c("label", "name", "includes"),
                     search = NULL) {

  includes <- pins::pin_read(mount_board(), "includes")

  col <- match.arg(col)

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

  if (!is.null(search)) {
    includes <- srchcol(includes, col = col, search = search, ignore = TRUE)
    }
  return(includes)
}

#' ICD-10-PCS Index
#' @param col column to search: "term" (default), "index", "type", "value", "code"
#' @param search string to search for in `col`
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
                  col = c("term", "index", "type", "value", "code")) {

  ind <- pins::pin_read(mount_board(), "index_v2") |>
    tidyr::unite("term", term, subterm, sep = ", ", na.rm = TRUE) |>
    dplyr::mutate(id = dplyr::row_number(), .before = 1) |>
    dplyr::rename(index = letter,
                  type = verb) |>
    dplyr::select(-term_id)

  col <- match.arg(col)

  if (!is.null(search)) {

    ind <- srchcol(ind, col = col, search = search, ignore = TRUE)

  }
  return(ind)
}

#' ICD-10-PCS Order File
#' @param col column to search: "code" (default), "table", "row", "description_code", "description_table", "order"
#' @param search string to search for in `col`
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' order(search = "00X")
#'
#' order(search = "Olfactory", col = "description_code")
#'
#' @export
order <- function(search = NULL, col = c("code",
                                         "table",
                                         "row",
                                         "description_code",
                                         "description_table",
                                         "order")) {

  tbl <- pins::pin_read(mount_board(), "tables_order")

  col <- match.arg(col)

  if (!is.null(search)) {

    tbl <- srchcol(tbl, col = col, search = search, ignore = TRUE)

  }
  return(tbl)
}

#' Return a range of ICD-10-PCS codes.
#' @param start 7-character ICD-10-PCS code.
#' @param end 7-character ICD-10-PCS code.
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

#' ICD-10-PCS Devices
#' @param system PCS system character.
#' @param operation PCS operation character.
#' @param device PCS device character.
#' @param col column to search: "device_name" (default), "section", "system", "operation", "device", "includes"
#' @param search string to search for in `col`
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' devices()
#' @export
devices <- function(system = NULL,
                    operation = NULL,
                    device = NULL,
                    col = c("device_name", "section", "system", "operation", "device", "includes"),
                    search = NULL) {

  dev <- pins::pin_read(mount_board(), "devices")

  col <- match.arg(col)

  if (!is.null(system)) {
    system <- rlang::arg_match(system, c(2:6, 8:9, "B", "C", "D", "J", "P", "Q", "R", "S", "U"))
    dev <- vctrs::vec_slice(dev, dev$system == system)
  }

  if (!is.null(operation)) {
    operation <- rlang::arg_match(operation, c("All applicable", "H", "R", "S", "V"))
    dev <- vctrs::vec_slice(dev, dev$operation == operation)
  }

  if (!is.null(device)) {
    if (is.numeric(device)) device <- as.character(device)
    device <- rlang::arg_match(device, c(2, 4:7, "D", "J", "M", "P", "S"))
    dev <- vctrs::vec_slice(dev, dev$device == device)
  }

  if (!is.null(search)) {

    dev <- srchcol(dev, col = col, search = search, ignore = TRUE)

  }

  return(dev)
}
