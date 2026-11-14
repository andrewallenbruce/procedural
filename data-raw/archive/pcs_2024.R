library(janitor)
library(tidyverse)
library(qs)

`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

# pcs <- qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_tbl2") |>
#   select(-definition)

# sec_sys <- qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_sec_sys")
# sec_sys_op <- qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_sec_sys_op")

pcs_tbl <- qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024") |>
  tibble() |>
  clean_names() |>
  filter(elem %nin% c("version", "ICD10PCS.tabular")) |>
  select(-level1, -level2) |>
  slice(2:nrow(pcs_tbl)) |>
  mutate(rowid = row_number(), .before = 1)

pcsTable_ids <- pcs_tbl |>
  filter(elem == "pcsTable") |>
  janitor::remove_empty(which = c("rows", "cols")) |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {
           dplyr::slice_tail(pcs_tbl) |>
             dplyr::pull(rowid)},
           .default = end),
         table_id = row_number()) |>
  select(-start, -end, -elem)

pcsRow_ids <- pcs_tbl |>
  filter(elem == "pcsRow") |>
  filter(is.na(attr)) |>
  janitor::remove_empty(which = c("rows", "cols")) |>
  select(-level3) |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {
           dplyr::slice_tail(pcs_tbl) |>
             dplyr::pull(rowid)},
           .default = end),
         row_id = row_number()) |>
  select(-start, -end, -elem)

pcs_tbl <- left_join(pcs_tbl, pcsTable_ids) |>
  mutate(category = if_else(!is.na(table_id), "table", NA_character_)) |>
  left_join(pcsRow_ids) |>
  mutate(category = if_else(!is.na(row_id), "row", category)) |>
  fill(category) |>
  fill(table_id) |>
  mutate(elem = if_else(elem == "axis", NA_character_, elem),
         elem = if_else(elem == "title", NA_character_, elem),
         elem = if_else(elem == "label", NA_character_, elem),
         elem = if_else(elem == "definition", NA_character_, elem)) |>
  unite('columns', c(elem, attr, level3:level5), na.rm = TRUE, remove = TRUE) |>
  group_by(category) |>
  fill(row_id) |>
  ungroup()

pcs_tbl <- pcs_tbl |>
  filter(!is.na(value)) |>
  filter(columns %nin% c("values_axis",
                         "values_pcsRow_axis",
                         "pcsRow_codes_pcsRow")) |>
  mutate(columns = case_match(
    columns,
    c("axis_definition") ~ "definition",
    c("axis_label", "pcsRow_axis_label") ~ "label",
    c("axis_title", "pcsRow_axis_title") ~ "title",
    c("pos_axis", "pos_pcsRow_axis") ~ "axis",
    c("code_axis_label", "code_pcsRow_axis_label") ~ "code",
    .default = columns)) |>
  select(columns, value, category, table_id, row_id) |>
  mutate(id = row_number(), .before = 1)

pcs_tbl |> filter(columns == "label") |> print(n = 150)

defs <- pcs_tbl |>
  filter(columns == "definition") |>
  select(id, table_id, value) |>
  rename(definition = value)

tables <- pcs_tbl |>
  left_join(defs) |>
  mutate(definition = lead(definition, 2)) |>
  filter(columns != "definition") |>
  filter(category == "table") |>
  select(-category, -row_id) |>
  pivot_wider(names_from = columns, values_from = value) |>
  select(id,
         table_id,
         axis,
         title,
         label,
         code,
         definition) |>
  mutate(title = lead(title),
         label = lead(label, 2),
         definition = lead(definition, 2),
         code = lead(code, 3)) |>
  filter(!is.na(axis)) |>
  select(-id)

rows <- pcs_tbl |>
  filter(category == "row") |>
  select(-category) |>
  pivot_wider(names_from = columns, values_from = value) |>
  mutate(title = lead(title),
         label = lead(label, 2),
         code = lead(code, 3)) |>
  filter(!is.na(code)) |>
  fill(axis, title) |>
  select(-id)

pcs <- bind_rows(tables, rows) |>
  arrange(table_id) |>
  select(table_id, row_id, axis, code, title, label, definition)

pcs |>
  filter(axis == "1") |> count(label)
  group_by(axis, code, title, label) |>
  summarise(n = n(), .groups = "drop") |>
pcs |> filter(axis == "2", code == "0")
pcs |> filter(axis == "3") |> print(n = 150)


###################################
pcs_tbl <- pcs_tbl |>
  rowwise() |>
  mutate(desc = tolower(value),
         desc = str_replace_all(desc, " ", "-")) |>
  ungroup() |>
  unite('cols',
        c(columns, desc),
        na.rm = TRUE,
        remove = TRUE)

pcsTables <- pcs_tbl |>
  filter(cols == "table_pos_1") |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {
           dplyr::slice_tail(pcs_tbl) |>
             dplyr::pull(rowid)},
           .default = end)) |>
  select(rowid, start, end)

pcs_tbl <- left_join(pcs_tbl, pcsTables) |>
  fill(start,
       end) |>
  mutate(table = consecutive_id(start),
         start = NULL,
         end = NULL) |>
  filter(value != "TABLE") |>
  filter(value != "ROW") |>
  mutate(rowid = row_number(), .before = 1)

section_rowids <- pcs_tbl |>
  filter(value == "Section") |>
  select(rowid) |>
  rowwise() |>
  mutate(row_m_1 = rowid - 1,
         row_p_1 = rowid + 1,
         row_p_2 = rowid + 2,
         start = min(c_across(row_m_1:row_p_2)),
         end = max(c_across(row_m_1:row_p_2))) |>
  ungroup() |>
  pivot_longer(cols = contains("row"),
               names_to = "col",
               values_to = "rowid") |>
  select(rowid,
         start,
         end) |>
  arrange(rowid)

##----------------------- Sections
Section <- pcs_tbl |>
  filter(rowid %in% section_rowids$rowid) |>
  left_join(section_rowids) |>
  select(-elem, -elemid) |>
  pivot_wider(names_from = cols, values_from = value) |>
  clean_names()

sec0 <- Section |>
  mutate(table_axis_title_section = lead(table_axis_title_section),
         table_axis_label_medical_and_surgical = lead(table_axis_label_medical_and_surgical, 2),
         table_axis_code_0 = lead(table_axis_code_0, 3)) |>
  select(rowid:table_axis_code_0) |>
  rename(axis_pos = table_pos_1,
         axis_name = table_axis_title_section,
         axis_label = table_axis_label_medical_and_surgical,
         axis_code = table_axis_code_0) |>
  filter(!is.na(axis_pos))

sec1 <- Section |>
  select(rowid,
         table,
         start,
         end,
         table_pos_1,
         table_axis_title_section,
         table_axis_label_obstetrics,
         table_axis_code_1) |>
  mutate(table_axis_title_section = lead(table_axis_title_section),
         table_axis_label_obstetrics = lead(table_axis_label_obstetrics, 2),
         table_axis_code_1 = lead(table_axis_code_1, 3)) |>
  rename(axis_pos = table_pos_1,
         axis_name = table_axis_title_section,
         axis_label = table_axis_label_obstetrics,
         axis_code = table_axis_code_1) |>
  filter(!is.na(axis_label))

secs <- vctrs::vec_rbind(sec0, sec1)

pcs_tbl <- left_join(pcs_tbl, sec0) |>
  group_by(end) |>
  mutate(section = consecutive_id(start)) |>
  ungroup() |>
  print(n = 150)

## Body Part
pcsRows_4 <- pcs_tbl |>
  filter(columns == "row_pos") |>
  filter(value == "4") |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {
           dplyr::slice_tail(pcs_tbl) |>
             dplyr::pull(rowid)},
           .default = end)) |>
  select(rowid, start, end)


pcs_tbl <- left_join(pcs_tbl, pcsRows_4) |>
  group_by(table) |>
  fill(start, end) |>
  mutate(body_part = consecutive_id(start),
         start = NULL,
         end = NULL) |>
  ungroup()

## Approach
pcsRows_5 <- pcs_tbl |>
  filter(columns == "row_pos") |>
  filter(value == "5") |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {dplyr::slice_tail(pcs_tbl) |> dplyr::pull(rowid)}, .default = end)) |>
  select(rowid, start, end)

pcs_tbl <- left_join(pcs_tbl, pcsRows_5) |>
  group_by(table) |>
  fill(start, end) |>
  mutate(approach = consecutive_id(start),
         start = NULL,
         end = NULL) |>
  ungroup()

## Device
pcsRows_6 <- pcs_tbl |>
  filter(columns == "row_pos") |>
  filter(value == "6") |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {dplyr::slice_tail(pcs_tbl) |> dplyr::pull(rowid)}, .default = end)) |>
  select(rowid, start, end)

pcs_tbl <- left_join(pcs_tbl, pcsRows_6) |>
  group_by(table) |>
  fill(start, end) |>
  mutate(device = consecutive_id(start),
         start = NULL,
         end = NULL) |>
  ungroup()

## Qualifier
pcsRows_7 <- pcs_tbl |>
  filter(columns == "row_pos") |>
  filter(value == "7") |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {dplyr::slice_tail(pcs_tbl) |> dplyr::pull(rowid)}, .default = end)) |>
  select(rowid, start, end)

pcs_tbl <- left_join(pcs_tbl, pcsRows_7) |>
  group_by(table) |>
  fill(start, end) |>
  mutate(qualifier = consecutive_id(start),
         start = NULL,
         end = NULL) |>
  ungroup()



pcs_tbl |>
  filter(columns == "table_pos", value == "1")
  select(columns,
         value,
         table,
         body_part,
         approach,
         device,
         qualifier) |>
  # filter(columns == "table_pos" |
  #          columns == "table_axis_label" |
  #          columns == "table_axis_title" |
  #          columns == "table_axis_definition" |
  #          columns == "table_axis_code") |>
  # pivot_wider(names_from = columns, values_from = value) |>
  print(n = 150)


  group_by(label) |>
   fill(axis_title, axis_pos) |> print(n = 150)

   group_by(label) |>
   fill(definition) |>
   ungroup() |>
   group_by(definition) |>
   fill(axis_pos, axis_title, axis_code) |>
   ungroup() |>
   mutate(rowid = row_number())

 sec_sys_op <- pcs_tbl |>
   filter(title == "Section" | title == "Body System" | title == "Operation") |>
   select(pos, code, title, label, rowid) |>
   pivot_wider(names_from = title,
               values_from = c(label, pos, code),
               names_glue = "{title}_{.value}") |>
   janitor::clean_names() |>
   select(rowid,
          sec_pos = section_pos,
          sys_pos = body_system_pos,
          op_pos = operation_pos,
          sec_code = section_code,
          sys_code = body_system_code,
          op_code = operation_code,
          sec_lbl = section_label,
          sys_lbl = body_system_label,
          op_lbl = operation_label) |>
   mutate(sys_lbl = lead(sys_lbl),
          sys_pos = lead(sys_pos),
          sys_code = lead(sys_code),
          op_lbl = lead(op_lbl, 2),
          op_pos = lead(op_pos, 2),
          op_code = lead(op_code, 2)) |>
   fill(sec_pos,
        sys_pos,
        op_pos,
        sec_code,
        sys_code,
        op_code,
        sec_lbl,
        sys_lbl,
        op_lbl)


# usethis::use_data(pcs_2024, overwrite = TRUE)
# code to prepare dataset goes here
library(icd10us)

tables <- icd10pcs |>
  dplyr::filter(valid_billing_code == 0) |>
  dplyr::mutate(start = order_number,
                end = dplyr::lead(start) - 1,
                end = dplyr::case_when(start == max(start) ~ {
                  dplyr::slice_tail(icd10pcs) |>
                    dplyr::pull(order_number)},
                  .default = end)) |>
  dplyr::select(
    rowid = order_number,
    start,
    end,
    table = icd10pcs_code,
    description = icd10pcs_long_description)

pcs_by_table <- icd10pcs |>
  dplyr::select(
    rowid = order_number,
    code = icd10pcs_code,
    valid_billing_code,
    label = icd10pcs_long_description) |>
  dplyr::left_join(tables) |>
  tidyr::fill(table, description, start, end) |>
  dplyr::filter(valid_billing_code == 1) |>
  dplyr::select(code,
                label,
                table,
                description) |>
  dplyr::mutate(medsurg = stringr::str_detect(table, "^0"),
                description = dplyr::if_else(medsurg == TRUE,
                  paste0("Medical and Surgical, ", description), description),
                medsurg = NULL)

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(pcs_tbl,
                         name = "pcs_2024",
                         description = "ICD-10-PCS 2024 Code Set",
                         type = "qs")

board |> pins::pin_write(sec_sys_op,
                         name = "pcs_2024_tables",
                         description = "ICD-10-PCS 2024 Tables",
                         type = "qs")

board |> pins::pin_write(pcs_by_table,
                         name = "pcs_by_table",
                         description = "ICD-10-PCS 2024 Tables and Codes",
                         type = "qs")

board |> pins::write_board_manifest()
