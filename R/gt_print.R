#' Return ICD-10-PCS Code as a `gt` Table
#'
#' @param x an object of class `pcs`.
#'
#' @returns a gt table
#'
#' @examples
#' pcs("0G9000Z") |> gt_pcs()
#'
#' gt_pcs(pcs("0016070"))
#'
#' @autoglobal
#'
#' @export
gt_pcs <- function(x) {

  stopifnot("`x` must be a `pcs` object" = inherits(x, "pcs"))

  x$axes |>
    gt::gt(rowname_col = "axis") |>
    gt::cols_align(
      align = "center",
      columns = c(axis, value)
    ) |>
    gt::tab_style(style = list(
      gt::cell_fill(
        color = "lightgray",
        alpha = 0.5),
      gt::cell_text(weight = "bold")),
      locations = gt::cells_body(columns = value)
    ) |>
    gt::tab_header(
      subtitle = gt::html("<b><i>ICD-10-PCS 2024</i></b>"),
      title = gt::html(
        paste0("<b><u>",
               x$code,
               "</u></b> ",
               x$description)
      )
    ) |>
    gt::tab_footnote(
      footnote = gt::html(
        paste0(
          "<b>Definition:</b> ",
          x$definitions$definition[1])
      ),
      locations = gt::cells_body(
        columns = label,
        rows = 3)
    ) |>
    gt::tab_footnote(
      footnote = gt::html(
        paste0("<b>Definition:</b> ",
               x$definitions$definition[2])
      ),
      locations = gt::cells_body(
        columns = label,
        rows = 5)
    ) |>
    gt::opt_table_font(
      font = gt::google_font(name = "Rubik")
    ) |>
    gt::opt_all_caps() |>
    gt::opt_table_outline(style = "none") |>
    gt::tab_options(
      quarto.disable_processing = TRUE,
      table.width = gt::pct(100),
      heading.title.font.size = gt::px(18),
      heading.subtitle.font.size = gt::px(16),
      heading.align = "left",
      table.font.color = "#0B0B45",
      footnotes.font.size = gt::px(12),
      footnotes.marks = letters,
      column_labels.hidden = TRUE)
}

#' Return ICD-10-PCS Code as a `gt` Table
#'
#' @param x an object of class `pcs`.
#'
#' @returns description
#'
#' @examples
#' pcs("0G9000Z") |> gt_pcs2()
#'
#' gt_pcs2(pcs("0016070"))
#'
#' @autoglobal
#'
#' @export
gt_pcs2 <- function(x) {
  x$axes |>
    gt::gt(rowname_col = "axis") |>
    gt::opt_table_font(
      font = gt::google_font(name = "Rubik")
    ) |>
    gt::cols_align(
      align = "center",
      columns = c(axis, value)
    ) |>
    gt::tab_style(
      style = list(
        gt::cell_fill(
          color = "lightgray",
          alpha = 0.5),
        gt::cell_text(weight = "bold")
      ),
      locations = gt::cells_body(columns = value)
    ) |>
    gt::opt_all_caps() |>
    gt::opt_table_outline(style = "none") |>
    gt::tab_header(
      title = gt::html(
        paste0(
          "<b>",
          x$code,
          "</b>  ",
          x$description)
      ),
      subtitle = htmltools::tagList(
        htmltools::tags$div(
          style = htmltools::css(
            `text-align` = "right"),
          htmltools::tags$div(
            htmltools::tags$strong("ICD-10-PCS 2024")
          )
        )
      )
    ) |>
    gt::tab_options(
      quarto.disable_processing = TRUE,
      stub.background.color = "#0B0B35",
      stub.border.color = "white",
      stub_row_group.border.color = "#0B0B35",
      table.width = gt::pct(100),
      heading.title.font.size = gt::px(18),
      heading.subtitle.font.size = gt::px(16),
      heading.background.color = "white",
      heading.border.bottom.color = "#0B0B35",
      heading.align = "left",
      table.font.color = "#0B0B35",
      table.font.size = gt::px(14),
      table.border.bottom.color = "#0B0B35",
      footnotes.font.size = gt::px(12),
      column_labels.hidden = TRUE)
}

#' @autoglobal
#'
#' @noRd
vert_lab <- function(label) {
  paste0("<vertical-text>", label, "</vertical-text>")
}
