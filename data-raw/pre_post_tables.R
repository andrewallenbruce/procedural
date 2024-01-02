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
  unite('columns', c(attr, level2:level5), na.rm = TRUE, remove = TRUE) |>
  #mutate(value = case_match(elem, "pcsRow" ~ "ROW", "pcsTable" ~ "TABLE", .default = value)) |>
  filter(!is.na(value))


pcs_tbl2 <- pcs_tbl2 |>
  pivot_wider(names_from = columns, values_from = value) |>
  mutate(
    pcsTable_axis_title = lead(pcsTable_axis_title, 1),
    pcsTable_axis_label = lead(pcsTable_axis_label, 2),
    code_pcsTable_axis_label = lead(code_pcsTable_axis_label, 2),
    #pcsTable_axis_definition = lead(pcsTable_axis_definition, 3),
    pos_pcsTable_pcsRow_axis = lead(pos_pcsTable_pcsRow_axis, 5),
    pcsTable_pcsRow_axis_title = lead(pcsTable_pcsRow_axis_title, 6),
    pcsTable_pcsRow_axis_label = lead(pcsTable_pcsRow_axis_label, 7),
    code_pcsTable_pcsRow_axis_label = lead(code_pcsTable_pcsRow_axis_label, 7)) |>
  select(
    pos = pos_pcsTable_axis,
    code = code_pcsTable_axis_label,
    title = pcsTable_axis_title,
    label = pcsTable_axis_label,
    # definition = pcsTable_axis_definition,
    axis_pos = pos_pcsTable_pcsRow_axis,
    axis_title = pcsTable_pcsRow_axis_title,
    axis_code = code_pcsTable_pcsRow_axis_label,
    axis_label = pcsTable_pcsRow_axis_label) |>
  unite('check', c(code, axis_code), na.rm = TRUE, sep = "", remove = FALSE) |>
  mutate(check = na_if(check, "")) |>
  filter(!is.na(check)) |>
  select(-check) |>
  mutate(rowid = row_number(), .before = 1)



table_key <- pcs_tbl2 |>
  select(rowid, pos, code, title, label) |>
  filter(pos %in% c("1", "2", "3")) |>
  pivot_wider(names_from = pos, values_from = c(code, title, label), names_glue = "{pos}_{.value}") |>
  clean_names() |>
  select(rowid, starts_with("x1"), starts_with("x2"), starts_with("x3")) |>
  mutate(x2_code = lead(x2_code),
         x2_title = lead(x2_title),
         x2_label = lead(x2_label),
         x3_code = lead(x3_code, 2),
         x3_title = lead(x3_title, 2),
         x3_label = lead(x3_label, 2)) |>
  unite('table_code', c(x1_code, x2_code, x3_code), na.rm = TRUE, sep = "", remove = FALSE) |>
  mutate(table_code = na_if(table_code, "")) |>
  fill(table_code)

table_key <- table_key |>
  group_by(table_code) |>
  mutate(start = min(rowid),
         end = max(rowid)) |>
  ungroup() |>
  filter(!is.na(x1_code))

pcs_tbl2 <- left_join(pcs_tbl2, table_key) |>
  select(axis_pos:end) |>
  remove_empty(c("rows")) |>
  select(
    code_1 = x1_code,
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
  remove_empty(c("rows"))

pcs_tbl2 <- pcs_tbl2 |> fill(table)

pre_table <- pcs_tbl2 |>
  select(code_1:table) |>
  filter(!is.na(code_1))

post_table <- pcs_tbl2 |>
  select(table:axis_label) |>
  mutate(row = if_else(axis_pos == "4", glue::glue("{table}{axis_code}"), NA_character_)) # 4 is the row position for body part

########________________________________________


board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(pre_table,
                         name = "pre_table",
                         description = "ICD-10-PCS 2024 Table Key",
                         type = "qs")

board |> pins::pin_write(post_table,
                         name = "post_table",
                         description = "ICD-10-PCS 2024 Table Rows",
                         type = "qs")

board |> pins::write_board_manifest()

