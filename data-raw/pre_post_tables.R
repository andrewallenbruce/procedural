library(janitor)
library(tidyverse)
library(qs)

########________________________________________
pcs_tbl <- qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024") |>
  tibble() |>
  clean_names() |>
  filter(elem %nin% c("version", "ICD10PCS.tabular")) |>
  select(-level1)

pcs_tbl2 <- pcs_tbl[4:nrow(pcs_tbl), ] |>
  unite('columns',
        c(attr, level2:level5),
        na.rm = TRUE,
        remove = TRUE) |>
  filter(!is.na(value))

pcs_tbl2 <- pcs_tbl2 |>
  pivot_wider(names_from  = columns,
              values_from = value) |>
  mutate(pcsTable_axis_title             = lead(pcsTable_axis_title, 1),
         pcsTable_axis_label             = lead(pcsTable_axis_label, 2),
         code_pcsTable_axis_label        = lead(code_pcsTable_axis_label, 2),
         # pcsTable_axis_definition      = lead(pcsTable_axis_definition, 3),
         pos_pcsTable_pcsRow_axis        = lead(pos_pcsTable_pcsRow_axis, 5),
         pcsTable_pcsRow_axis_title      = lead(pcsTable_pcsRow_axis_title, 6),
         pcsTable_pcsRow_axis_label      = lead(pcsTable_pcsRow_axis_label, 7),
         code_pcsTable_pcsRow_axis_label = lead(code_pcsTable_pcsRow_axis_label, 7)) |>
  select(pos                             = pos_pcsTable_axis,
         code                            = code_pcsTable_axis_label,
         title                           = pcsTable_axis_title,
         label                           = pcsTable_axis_label,
         # definition                    = pcsTable_axis_definition,
         axis_pos                        = pos_pcsTable_pcsRow_axis,
         axis_title                      = pcsTable_pcsRow_axis_title,
         axis_code                       = code_pcsTable_pcsRow_axis_label,
         axis_label                      = pcsTable_pcsRow_axis_label) |>
  unite('check',
        c(code, axis_code),
        sep    = "",
        na.rm  = TRUE,
        remove = FALSE) |>
  mutate(check = na_if(check, "")) |>
  filter(!is.na(check)) |>
  select(-check) |>
  mutate(rowid = row_number(),
         .before = 1)

table_key <- pcs_tbl2 |>
  select(rowid,
         pos,
         code,
         title,
         label) |>
  filter(pos %in% c("1", "2", "3")) |>
  pivot_wider(names_from = pos,
              values_from = c(code, title, label),
              names_glue = "{pos}_{.value}") |>
  clean_names() |>
  select(rowid,
         starts_with("x1"),
         starts_with("x2"),
         starts_with("x3")) |>
  mutate(x2_code  = lead(x2_code),
         x2_title = lead(x2_title),
         x2_label = lead(x2_label),
         x3_code  = lead(x3_code, 2),
         x3_title = lead(x3_title, 2),
         x3_label = lead(x3_label, 2)) |>
  unite('table_code',
        c(x1_code, x2_code, x3_code),
        sep = "",
        na.rm = TRUE,
        remove = FALSE) |>
  mutate(table_code = na_if(table_code, "")) |>
  fill(table_code) |>
  group_by(table_code) |>
  mutate(start = min(rowid),
         end = max(rowid)) |>
  ungroup() |>
  filter(!is.na(x1_code))

pcs_tbl2 <- left_join(pcs_tbl2, table_key) |>
  select(axis_pos:end) |>
  remove_empty(c("rows")) |>
  select(code_1 = x1_code,
         title_1 = x1_title,
         label_1 = x1_label,
         code_2 = x2_code,
         title_2 = x2_title,
         label_2 = x2_label,
         code_3 = x3_code,
         title_3 = x3_title,
         label_3 = x3_label,
         table = table_code,
         axis_pos,
         axis_title,
         axis_code,
         axis_label) |>
  mutate(axis_pos = lead(axis_pos),
         axis_title = lead(axis_title),
         axis_code = lead(axis_code),
         axis_label = lead(axis_label)) |>
  remove_empty(c("rows")) |>
  fill(table)

idx_row <- pcs_tbl2 |>
  mutate(id = row_number(), .before = 1) |>
  filter(axis_pos == "4") |>
  # select(axis_pos) |>
  mutate(row = row_number())

pcs_tbl2 <- pcs_tbl2 |>
  mutate(id = row_number(), .before = 1) |>
  left_join(idx_row) |>
  fill(row, axis_title, axis_pos) |>
  fill(code_1:label_3) |>
  select(name_1 = title_1,
         code_1,
         label_1,
         name_2 = title_2,
         code_2,
         label_2,
         name_3 = title_3,
         code_3,
         label_3,
         code_table = table,
         row_id = row,
         row_pos = axis_pos,
         row_name = axis_title,
         row_code = axis_code,
         row_label = axis_label) |>
  nest(rows = contains("row_"))

########________________________________________
board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(pcs_tbl2,
                         name = "pcs_tbl2",
                         description = "ICD-10-PCS Tables & Rows",
                         type = "qs")

board |> pins::write_board_manifest()

########________________________________________
tbl <- pins::pin_read(mount_board(), "pcs_tbl2") |>
  tidyr::unnest(rows) |>
  dplyr::select(table = code_table,
                axis = row_pos,
                title = row_name,
                code = row_code,
                label = row_label,
                rowid = row_id)

row_idx <- tbl |>
  dplyr::filter(axis == "4") |>
  tidyr::unite("row",
               table,
               code,
               sep = "",
               remove = FALSE,
               na.rm = TRUE) |>
  dplyr::mutate(row_title = title,
                row_label = label)

tbl <- dplyr::left_join(tbl, row_idx,
       by = dplyr::join_by(table, axis, title, code, label, rowid)) |>
       tidyr::fill(row, row_title, row_label)

row_axes <- tbl |>
  dplyr::filter(axis != "4") |>
  dplyr::select(rowid,
                axis,
                title,
                code,
                label) |>
  tidyr::nest(.by = rowid, .key = "axes")

ttbl <- tbl |>
  dplyr::left_join(row_axes, by = "rowid") |>
  tidyr::unite("description",
               row_title,
               row_label,
               sep = ", ",
               remove = TRUE,
               na.rm = TRUE) |>
  dplyr::select(table, row, description, rowid, axes) |>
  dplyr::rowwise() |>
  dplyr::mutate(axes = rlang::list2("row_{rowid}.{row}" := axes)) |>
  dplyr::ungroup() |>
  dplyr::distinct()

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(ttbl,
                         name = "pcs_tbl3",
                         description = "ICD-10-PCS Tables & Rows",
                         type = "qs")

board |> pins::write_board_manifest()
