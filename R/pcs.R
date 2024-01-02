#' Look up ICD-10-PCS Codes or Tables
#' @param x an alphanumeric character vector, can be 3 to 7 characters long.
#' @return [tibble()]
#' @examples
#' pcs("0G9")
#'
#' pcs("0G90")
#'
#' pcs("0G900")
#'
#' pcs("0G9000")
#'
#' pcs("0G9000Z")
#'
#' @export
pcs <- function(x) {

  # checks _______________________

  if (nchar(x) < 3L || nchar(x) > 7L) {cli::cli_abort(
    "{.fn pcs} only accepts a {.cls {class(x)}} vector 3-7 chars long.")}

  if (grepl("[[:lower:]]*", x)) x <- toupper(x)
  xs <- splitter(x)

  # boards _______________________

  pre_table <- pins::pin_read(mount_board(), "pre_table")

  post_table <- pins::pin_read(mount_board(), "post_table") |>
    dplyr::mutate(row = as.character(row)) |>
    tidyr::fill(axis_pos, axis_title, row)

  # search _______________________

  pre_table <- vctrs::vec_slice(pre_table, pre_table$code_1 == xs[1])
  pre_table <- vctrs::vec_slice(pre_table, pre_table$code_2 == xs[2])
  pre_table <- vctrs::vec_slice(pre_table, pre_table$code_3 == xs[3])
  post_table <- vctrs::vec_slice(post_table, post_table$table == pre_table$table)

  # table _______________________
  pre_table <- dplyr::distinct(pre_table)

  tbl <- dplyr::tibble(
    axis = c("1", "2", "3"),
    name = c(pre_table$title_1, pre_table$title_2, pre_table$title_3),
    code = c(pre_table$code_1, pre_table$code_2, pre_table$code_3),
    label = c(pre_table$label_1, pre_table$label_2, pre_table$label_3))

  # axis 4 _______________________

  x4 <- vctrs::vec_slice(post_table, post_table$axis_pos == "4")
  x4 <- vctrs::vec_slice(x4, x4$axis_code == xs[4])
  x4 <- dplyr::distinct(x4)

  x4 <- dplyr::tibble(
    axis = x4$axis_pos,
    name = x4$axis_title,
    code = x4$axis_code,
    label = x4$axis_label)

  # axis 5 _______________________

  x5 <- vctrs::vec_slice(post_table, post_table$axis_pos == "5")
  x5 <- vctrs::vec_slice(x5, x5$axis_code == xs[5])
  x5 <- dplyr::distinct(x5)

  x5 <- dplyr::tibble(
    axis = x5$axis_pos,
    name = x5$axis_title,
    code = x5$axis_code,
    label = x5$axis_label)

  # axis 6 _______________________

  x6 <- vctrs::vec_slice(post_table, post_table$axis_pos == "6")
  x6 <- vctrs::vec_slice(x6, x6$axis_code == xs[6])
  x6 <- dplyr::distinct(x6)

  x6 <- dplyr::tibble(
    axis = x6$axis_pos,
    name = x6$axis_title,
    code = x6$axis_code,
    label = x6$axis_label)

  # axis 7 _______________________

  x7 <- vctrs::vec_slice(post_table, post_table$axis_pos == "7")
  x7 <- vctrs::vec_slice(x7, x7$axis_code == xs[7])
  x7 <- dplyr::distinct(x7)

  x7 <- dplyr::tibble(
    axis = x7$axis_pos,
    name = x7$axis_title,
    code = x7$axis_code,
    label = x7$axis_label)

  vctrs::vec_rbind(tbl, x4, x5, x6, x7) |>
    dplyr::distinct() |>
    janitor::remove_empty("rows")
}

#' @noRd
prep <- function(x,
                 arg = rlang::caller_arg(x),
                 call = rlang::caller_env()) {

  if (!nzchar(x)) {cli::cli_abort("x" = "{.strong x} cannot be an {.emph empty} string.", call = call)}

  if (nchar(x) > 7L) {cli::cli_abort(c(
      "A valid {.strong PCS} code is {.emph {.strong 7} characters long}.",
      "x" = "{.strong {.val {x}}} is {.strong {.val {nchar(x)}}} characters long."),
      call = call)}

  if (grepl("[^[0-9A-HJ-NP-Z]]*", x)) {cli::cli_abort(c(
      "x" = "{.strong {.val {x}}} contains {.emph non-valid} characters."), call = call)}

  if (is.numeric(x)) x <- as.character(x)

  # If any chars are lowercase, capitalize
  if (grepl("[[:lower:]]*", x)) x <- toupper(x)

  xs <- splitter(x)

  bsys <- collapser(xs[1:2])

  tbl <- collapser(xs[1:3])

  rw <- collapser(xs[1:4])

  if (nchar(x) <= 2L) {
    tbl <- NULL
    rw <- NULL
  }

  if (nchar(x) == 3L) rw <- NULL
  if (nchar(x) == 1L) bsys <- NULL
  if (nchar(x) != 7L) x <- NULL

  results <- purrr::compact(
    list(split = xs,
         section = xs[1],
         system = bsys,
         table = tbl,
         row = rw,
         code = x))

  return(results)
}

#' @noRd
pcs.old <- function(x) {

  # checks _______________________

  if (nchar(x) < 3L || nchar(x) > 7L) {cli::cli_abort(
    "{.fn pcs} only accepts a {.cls {class(x)}} vector 3-7 chars long.")}

  if (grepl("[[:lower:]]*", x)) x <- toupper(x)
  xs <- splitter(x)

  # boards _______________________

  tables <- pins::pin_read(mount_board(), "pcs_2024_tables")
  pcs_2024 <- pins::pin_read(mount_board(), "pcs_2024")

  # search _______________________

  tables <- vctrs::vec_slice(tables, tables$sec_code == xs[1])
  tables <- vctrs::vec_slice(tables, tables$sys_code == xs[2])
  tables <- vctrs::vec_slice(tables, tables$op_code == xs[3])
  pcs_2024 <- vctrs::vec_slice(pcs_2024, pcs_2024$rowid >= min(tables$rowid) & pcs_2024$rowid <= max(tables$rowid))

  # table _______________________

  tables$rowid <- NULL

  tables <- dplyr::distinct(tables)

  tables <- dplyr::tibble(
    axis = c(tables$sec_pos, tables$sys_pos, tables$op_pos),
    name = unlist(axes(xs[1])[1:3, 2], use.names = FALSE),
    code = c(tables$sec_code, tables$sys_code, tables$op_code),
    label = c(tables$sec_lbl, tables$sys_lbl, tables$op_lbl))

  # axis 4 _______________________

  ax4 <- vctrs::vec_slice(pcs_2024, pcs_2024$code == xs[3])
  ax4 <- vctrs::vec_slice(ax4, ax4$axis_pos == "4")
  ax4 <- vctrs::vec_slice(ax4, ax4$axis_code == xs[4])
  ax4 <- tidyr::drop_na(ax4)
  ax4$rowid <- NULL
  ax4 <- dplyr::distinct(ax4)

  ax4 <- dplyr::tibble(
    axis = ax4$axis_pos,
    name = ax4$axis_title,
    code = ax4$axis_code,
    label = ax4$axis_label)

  # axis 5 _______________________

  ax5 <- vctrs::vec_slice(pcs_2024, pcs_2024$code == xs[3])
  ax5 <- vctrs::vec_slice(ax5, ax5$axis_pos == "5")
  ax5 <- vctrs::vec_slice(ax5, ax5$axis_code == xs[5])
  ax5 <- tidyr::drop_na(ax5)
  ax5$rowid <- NULL
  ax5 <- dplyr::distinct(ax5)

  ax5 <- dplyr::tibble(
    axis = ax5$axis_pos,
    name = ax5$axis_title,
    code = ax5$axis_code,
    label = ax5$axis_label)

  # axis 6 _______________________

  ax6 <- vctrs::vec_slice(pcs_2024, pcs_2024$code == xs[3])
  ax6 <- vctrs::vec_slice(ax6, ax6$axis_pos == "6")
  ax6 <- vctrs::vec_slice(ax6, ax6$axis_code == xs[6])
  ax6 <- tidyr::drop_na(ax6)
  ax6$rowid <- NULL
  ax6 <- dplyr::distinct(ax6)

  ax6 <- dplyr::tibble(
    axis = ax6$axis_pos,
    name = ax6$axis_title,
    code = ax6$axis_code,
    label = ax6$axis_label)

  # axis 7 _______________________

  ax7 <- vctrs::vec_slice(pcs_2024, pcs_2024$code == xs[3])
  ax7 <- vctrs::vec_slice(ax7, ax7$axis_pos == "7")
  ax7 <- vctrs::vec_slice(ax7, ax7$axis_code == xs[7])
  ax7 <- tidyr::drop_na(ax7)
  ax7$rowid <- NULL
  ax7 <- dplyr::distinct(ax7)

  ax7 <- dplyr::tibble(
    axis = ax7$axis_pos,
    name = ax7$axis_title,
    code = ax7$axis_code,
    label = ax7$axis_label)

  vctrs::vec_rbind(tables, ax4, ax5, ax6, ax7)
}
