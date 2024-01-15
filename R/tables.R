#' ICD-10-PCS Tables
#' @param x 1 to 3-character string representing an ICD-10-PCS table.
#'    If `NULL` (default), returns all 895 tables.
#' @return a [dplyr::tibble()]
#' @examples
#' tables("0")
#'
#' tables("00")
#'
#' tables("00X")
#'
#' @export
tables <- function(x = NULL) {

  table <- pins::pin_read(mount_board(), "pcs_by_table_v2")

  # table <- pins::pin_read(mount_board(), "pcs_by_table") |>
  #   tidyr::nest(codes = c(code, label)) |>
  #   tidyr::separate_wider_position(table, c(section = 1, system = 1, operation = 1), cols_remove = FALSE) |>
  #   tidyr::unite('system', section:system, remove = FALSE, sep = "") |>
  #   dplyr::select(section, system, table, description, codes)

  if (!is.null(x)) {
    x <- checks(x)
    if (nchar(x) > 3L)  {x <- collapser(splitter(x)[1:3])}
    if (nchar(x) == 1L) {table <- vctrs::vec_slice(table, table$section == x)}
    if (nchar(x) == 2L) {table <- vctrs::vec_slice(table, table$system == x)}
    if (nchar(x) == 3L) {table <- vctrs::vec_slice(table, table$table == x)}
  }

  table <- dplyr::mutate(table, n_codes = purrr::map_dbl(codes, nrow))

  return(table)
}

#' ICD-10-PCS Rows
#' @param x 3 to 4-character string representing an ICD-10-PCS row within a table.
#'    If `NULL` (default), returns all ~ 29k rows.
#' @return [tibble()]
#' @examplesIf interactive()
#' rows("00X")
#'
#' rows("00XF")
#'
#' @export
rows <- function(x = NULL) {

  tbl <- pins::pin_read(mount_board(), "pcs_tbl3")
  # tbl <- pins::pin_read(mount_board(), "pcs_tbl2") |>
  #   tidyr::unnest(rows) |>
  #   dplyr::select(table = code_table,
  #                 axis = row_pos,
  #                 title = row_name,
  #                 code = row_code,
  #                 label = row_label,
  #                 rowid = row_id)
  #
  # row_idx <- tbl |>
  #   dplyr::filter(axis == "4") |>
  #   tidyr::unite("row",
  #                table,
  #                code,
  #                sep = "",
  #                remove = FALSE,
  #                na.rm = TRUE) |>
  #   dplyr::mutate(row_title = title,
  #                 row_label = label)
  #
  # tbl <- dplyr::left_join(tbl,
  #                         row_idx,
  #     by = dplyr::join_by(table, axis, title, code, label, rowid)) |>
  #   tidyr::fill(row, row_title, row_label)
  #
  # row_axes <- tbl |>
  #   dplyr::filter(axis != "4") |>
  #   dplyr::select(rowid,
  #                 axis,
  #                 title,
  #                 code,
  #                 label) |>
  #   tidyr::nest(.by = rowid, .key = "axes")
  #
  # tbl <- tbl |>
  #   dplyr::left_join(row_axes, by = "rowid") |>
  #   tidyr::unite("description",
  #                row_title,
  #                row_label,
  #                sep = ", ",
  #                remove = TRUE,
  #                na.rm = TRUE) |>
  #   dplyr::select(table, row, description, rowid, axes) |>
  #   dplyr::rowwise() |>
  #   dplyr::mutate(axes = rlang::list2("row_{row}.{rowid}" := axes)) |>
  #   dplyr::ungroup() |>
  #   dplyr::distinct()

  if (!is.null(x)) {
    x <- checks(x)
    if (nchar(x) == 3L) tbl <- dplyr::filter(tbl, table == x)
    if (nchar(x) > 3L) tbl <- dplyr::filter(tbl, row == substr(x, 1, 4))
  }
  return(tbl)
}
