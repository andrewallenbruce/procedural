#' ICD-10-PCS Rows
#'
#' @param x 3 to 4-character string representing an ICD-10-PCS row within a
#'   table. If `NULL` (default), returns all ~ 29k rows.
#'
#' @template returns-default
#'
#' @examplesIf FALSE
#' rows("00X")
#'
#' rows("00XF")
#'
#' @autoglobal
#'
#' @export
rows <- function(x = NULL) {
  # tbl <- get_pin("pcs_tbl3")
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
  # if (!is.null(x)) {
  #   x <- checks(x)
  #
  #   if (nchar(x) == 3L) {
  #     tbl <- dplyr::filter(tbl, table == x)
  #   }
  #   if (nchar(x) > 3L) {
  #     tbl <- dplyr::filter(tbl, row == substr(x, 1, 4))
  #   }
  # }
  # return(tbl)
}

#' ICD-10-PCS Devices
#'
#' @param system PCS system character.
#' @param operation PCS operation character.
#' @param device PCS device character.
#' @param col column to search: "device_name" (default), "section", "system", "operation", "device", "includes"
#' @param search string to search for in `col`
#' @returns tibble
#' @examplesIf FALSE
#' device()
#' @export
device <- function(
  system = NULL,
  operation = NULL,
  device = NULL,
  col = c(
    "device_name",
    "section",
    "system",
    "operation",
    "device",
    "includes"
  ),
  search = NULL
) {
  # if (!is.null(system)) {
  #   system <- rlang::arg_match0(
  #     system,
  #     c(2:6, 8:9, "B", "C", "D", "J", "P", "Q", "R", "S", "U")
  #   )
  #   dev <- vctrs::vec_slice(dev, dev$system == system)
  # }
  #
  # if (!is.null(operation)) {
  #   operation <- rlang::arg_match0(
  #     operation,
  #     c("All applicable", "H", "R", "S", "V")
  #   )
  #   dev <- vctrs::vec_slice(dev, dev$operation == operation)
  # }
  #
  # if (!is.null(device)) {
  #   device <- as.character(device)
  #   device <- rlang::arg_match0(device, c(2, 4:7, "D", "J", "M", "P", "S"))
  #   dev <- vctrs::vec_slice(dev, dev$device == device)
  # }
  #
  # if (!is.null(search)) {
  #   dev <- fuimus::srchcol(dev, col = col, search = search)
  # }
  # return(.add_class(dev))
}
