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

  if (nchar(x) <= 2L) tbl <- NULL
  if (nchar(x) == 1L) bsys <- NULL
  if (nchar(x) != 7L) x <- NULL

  results <- purrr::compact(
    list(code = x,
         split = xs,
         section = xs[1],
         system = bsys,
         table = tbl))

  return(results)
}
