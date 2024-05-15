#' @noRd
.def_op <- function(x) {

  op <- definitions(
    section = substr(x$input, 1, 1),
    axis = "3",
    search = substr(x$input, 3, 3)
    ) |>
    dplyr::mutate(
      definition = dplyr::if_else(
        !is.na(explanation),
        paste0(definition, ". ", explanation, "."),
        definition)
      ) |>
    dplyr::mutate(
      display = glue::glue('{label}: <small>{definition}.</small>')
      ) |>
    dplyr::select(label, display) |>
    unlist()

  names(op)[2] <- op[['label']]

  op[2]
}

#' @noRd
.inc_part <- function(x, y) {

  search <- paste0("(",
                   paste0(
                     unique(y$label_4),
                          collapse = "|"),
                   ")")

  inc <- includes(
    section = substr(x$input, 1, 1),
    axis = "4",
    search = search
    ) |>
    dplyr::mutate(
      includes = stringr::str_to_title(includes)
      ) |>
    dplyr::select(label, includes) |>
    dplyr::distinct() |>
    dplyr::group_by(label) |>
    tidyr::nest(.key = "includes") |>
    dplyr::mutate(includes = purrr::map_chr(
      includes,
      ~paste(.x$includes,
             collapse = "<br>"))) |>
    dplyr::ungroup()

  y |>
    dplyr::rename(code = code_4,
                  label = label_4) |>
    dplyr::left_join(inc,
                     by = dplyr::join_by(label)) |>
    dplyr::select(code, includes) |>
    dplyr::filter(!is.na(includes)) |>
    tibble::deframe()
}

#' @noRd
.def_ap <- function(x, y) {

  search <- paste0("(",
                   paste0(unique(y),
                          collapse = "|"), ")")

  definitions(section = substr(x$input, 1, 1),
              axis = "5",
              search = search) |>
    dplyr::select(label, definition) |>
    tibble::deframe()
}

#' @noRd
.vc_ln <- function(x, y) {

  len_vec <- x |> purrr::map_int(dplyr::n_distinct)

  rep(NA, max(len_vec) - unname(len_vec[y]))
}

#' @noRd
tables <- function(x) {

  x <- checks(x)

  pg <- get_pin("tables_rows") |>
    dplyr::filter(table == substr(x$input, 1, 3))

  # Top of gt table
  top <- pg |>
    dplyr::select(name_1:label_2, name_3:label_3) |>
    dplyr::distinct() |>
    tidyr::pivot_longer(cols = dplyr::everything(),
                        names_to = "name",
                        values_to = "vals") |>
    tidyr::separate(name, into = c("name", "axis"), sep = "_") |>
    tidyr::pivot_wider(names_from = "name", values_from = "vals") |>
    dplyr::mutate(label = dplyr::if_else(label %in% names(.def_op(x)),
                                         .def_op(x)[label], label)) |>
    dplyr::mutate(display = glue::glue("<b>{code}</b>  {label}<br>")) |>
    dplyr::select(-axis)

  top <- tibble::add_row(
    top,
    display = "<b>ICD-10-PCS 2024  &empty;</b><hr>",
    .before = 1
    )

  # Bottom of gt table
  bottom <- dplyr::select(pg, name_4:rows)

  bottom_inc <- .inc_part(x, bottom)

  # Pivot Rows Wider
  bottom_rows <- bottom |>
    dplyr::select(rowid:rows) |>
    dplyr::distinct() |>
    tidyr::unnest(cols = c(rows)) |>
    dplyr::distinct() |>
    tidyr::pivot_wider(names_from = axis,
                       names_glue = "{.value}_{axis}",
                       values_from = c(name, code, label),
                       values_fn = list) |>
    tidyr::unnest(cols = dplyr::ends_with("_5")) |>
    tidyr::unnest(cols = dplyr::ends_with("_6")) |>
    tidyr::unnest(cols = dplyr::ends_with("_7")) |>
    dplyr::select(rowid,
                  dplyr::ends_with("_5"),
                  dplyr::ends_with("_6"),
                  dplyr::ends_with("_7"))

  app_def <- .def_ap(x, bottom_rows$code_5)

  bottom_rows <- dplyr::left_join(
    bottom |>
      dplyr::select(-rows, -row),
    bottom_rows, by = dplyr::join_by(rowid),
    relationship = "many-to-many"
    ) |>
    dplyr::mutate(
      ax4 = glue::glue("**{code_4}** {label_4}"),
      ax5 = glue::glue("**{code_5}** {label_5}"),
      ax6 = glue::glue("**{code_6}** {label_6}"),
      ax7 = glue::glue("**{code_7}** {label_7}")) |>
    dplyr::select(rowid,
                  dplyr::starts_with("name_"),
                  dplyr::starts_with("ax"))

  bottom_col_names <- bottom_rows |>
    dplyr::select(dplyr::starts_with("name_")) |>
    dplyr::distinct() |>
    t() |>
    as.vector()

  bottom_rows |>
    dplyr::select(!dplyr::starts_with("name_")) |>
    dplyr::group_by(rowid) |>
    dplyr::distinct() |>
    dplyr::group_split(.keep = FALSE)

}

#' @noRd
.m_axis <- function(x) {

  len_vec <- x |> purrr::map_int(dplyr::n_distinct)

  x1 <- unique(x[names(len_vec[len_vec == max(len_vec)])])

  res <- tibble::add_column(
    x1,
    x2 = c(unlist(unique(x[names(len_vec[2])]),
                  use.names = FALSE), .vc_ln(x, names(len_vec)[2])),
    x3 = c(unlist(unique(x[names(len_vec[3])]),
                  use.names = FALSE), .vc_ln(x, names(len_vec)[3])),
    x4 = c(unlist(unique(x[names(len_vec[4])]),
                  use.names = FALSE), .vc_ln(x, names(len_vec)[4])))

  names(res) <- names(len_vec)

  res |>
    dplyr::mutate(.includes = bottom_inc[substr(ax4, 3, 3)],
                  .appdef = app_def[substr(ax5, 7, 100)],
                  .includes = dplyr::if_else(is.na(.includes), "", .includes),
                  .appdef = dplyr::if_else(is.na(.appdef), "", .appdef))
}

#' @noRd
.pcs_gt <- function(data) {

  clrs <- c("#0B0B45", "grey70")
  ftsz <- c("14px", "10px")
  ftwt <- c("normal", "bold")

  data |>
    gt::gt() |>
    gt::fmt_markdown() |>
    gt::sub_missing(missing_text = "") |>
    gt::opt_table_font(font = gt::google_font(name = "Rubik")) |>
    gt::opt_all_caps() |>
    gt::opt_row_striping() |>
    gt::tab_header(title = gt::html(top$display)) |>
    gt::cols_align(align = "left") |>
    gt::cols_label(
      ax4 = bottom_col_names[1],
      ax5 = bottom_col_names[2],
      ax6 = bottom_col_names[3],
      ax7 = bottom_col_names[4]) |>
    gtExtras::gt_merge_stack(ax4,
                             .includes,
                             small_cap = FALSE,
                             palette = clrs,
                             font_size = ftsz,
                             font_weight = ftwt) |>
    gtExtras::gt_merge_stack(ax5,
                             .appdef,
                             small_cap = FALSE,
                             palette = clrs,
                             font_size = ftsz,
                             font_weight = ftwt) |>
    gt::tab_options(
      table.width = gt::pct(55),
      table.font.color = clrs[1],
      table.font.size = gt::px(14),
      table_body.hlines.width = gt::px(0),
      table_body.vlines.style = "solid",
      table_body.vlines.width = gt::px(2),
      column_labels.font.size = gt::px(16),
      column_labels.background.color = "grey95",
      column_labels.vlines.width = gt::px(2),
      column_labels.vlines.style = "solid",
      heading.align = "left",
      heading.title.font.size = gt::px(18),
      heading.subtitle.font.size = gt::px(14),
      footnotes.font.size = gt::px(12))
}
