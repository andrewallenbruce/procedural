#' ICD-10-PCS Tables
#' @param x 1 to 3-character string representing an ICD-10-PCS table.
#'    If `NULL` (default), returns all 895 tables.
#' @return [tibble()]
#' @examplesIf interactive()
#' tables()
#' tables("0")
#' tables("00")
#' tables("00X")
#' @export
tables <- function(x = NULL) {

  table <- pins::pin_read(mount_board(), "pcs_by_table") |>
    tidyr::nest(codes = c(code, label)) |>
    tidyr::separate_wider_position(table, c(section = 1, system = 1, operation = 1), cols_remove = FALSE) |>
    tidyr::unite('system', section:system, remove = FALSE, sep = "") |>
    dplyr::select(section, system, table, description, codes)

  if (!is.null(x)) {
    if (is.numeric(x)) x <- as.character(x)
    if (grepl("[[:lower:]]*", x)) {x <- toupper(x)}
    if (nchar(x) == 1L) {table <- vctrs::vec_slice(table, table$section == x)}
    if (nchar(x) == 2L) {table <- vctrs::vec_slice(table, table$system == x)}
    if (nchar(x) == 3L) {table <- vctrs::vec_slice(table, table$table == x)}
  }
  return(table)
}
