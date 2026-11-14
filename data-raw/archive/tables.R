tables() |>
  group_by(section) |>
  summarise(codes = sum(n_codes),
            prop = codes / 78220) |>
  rename(code = section) |>
  left_join(sections()[c('code', 'label')],
            by = join_by(code)) |>
  select(code, label, codes, prop) |>
  mutate(id = row_number(), .before = 1) |>
  gt(rowname_col = "id") |>
  fmt_percent(columns = prop, decimals = 1) |>
  fmt_number(columns = codes, decimals = 0) |>
  opt_table_font(font = google_font(name = "Rubik")) |>
  cols_align(align = "center", columns = code) |>
  cols_hide(c(codes, prop)) |>
  tab_style(style = list(cell_fill(color = "lightgray",
                                   alpha = 0.5),
                         cell_text(weight = "bold")),
            locations = cells_body(columns = code)) |>
  opt_all_caps() |>
  opt_align_table_header(align = "left") |>
  tab_header(title = md("**ICD-10-PCS 2024** Sections")) |>
  cols_nanoplot(columns = codes,
                plot_type = "bar",
                new_col_label = "# of Codes",
                options = nanoplot_options(
                  data_bar_fill_color = "#0B0B45",
                  data_bar_stroke_color = "#0B0B45",
                  interactive_data_values = FALSE)) |>
  tab_style(style = cell_borders(sides = c("left"),
                                 weight = "5px",
                                 color = "lightgray"),
            locations = cells_body(columns = nanoplots))
