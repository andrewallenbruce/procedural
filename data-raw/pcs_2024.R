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
  select(-level1)

# A tibble: 5 × 2
#   attr       n
#   <chr>  <int>
# 1 code   32685
# 2 codes   2586
# 3 pos    13059
# 4 values 13059
# 5 NA     63144

# A tibble: 6 × 2
#   elem           n
#   <chr>      <int>
# 1 axis       39177
# 2 definition   849
# 3 label      65370
# 4 pcsRow      5172
# 5 pcsTable     905
# 6 title      13060

# A tibble: 14 × 2
#    columns                             n
#    <chr>                           <int>
#  1 code_pcsTable_axis_label         2715
#  2 code_pcsTable_pcsRow_axis_label 29970
#  3 codes_pcsTable_pcsRow            2586
#  4 pcsTable                          904
#  5 pcsTable_axis_definition          849
#  6 pcsTable_axis_label              2715
#  7 pcsTable_axis_title              2715
#  8 pcsTable_pcsRow                  2586
#  9 pcsTable_pcsRow_axis_label      29970
# 10 pcsTable_pcsRow_axis_title      10344
# 11 pos_pcsTable_axis                2715
# 12 pos_pcsTable_pcsRow_axis        10344
# 13 values_pcsTable_axis             2715
# 14 values_pcsTable_pcsRow_axis     10344

pcs_tbl <- pcs_tbl[4:nrow(pcs_tbl), ] |>
  unite('columns', c(attr, level2:level5), na.rm = TRUE, remove = TRUE) |>
  mutate(value = case_match(elem, "pcsRow" ~ "ROW", "pcsTable" ~ "TABLE", .default = value)) |>
  filter(!is.na(value))

pcs_tbl <- pcs_tbl |>
  mutate(columns = case_match(columns,
                              "code_pcsTable_axis_label" ~ "table_axis_code",
                              "code_pcsTable_pcsRow_axis_label" ~ "row_axis_code",
                              "codes_pcsTable_pcsRow" ~ "row",
                              "pcsTable" ~ "table",
                              "pcsTable_axis_definition" ~ "table_axis_definition",
                              "pcsTable_axis_label" ~ "table_axis_label",
                              "pcsTable_axis_title" ~ "table_axis_title",
                              "pcsTable_pcsRow" ~ "row",
                              "pcsTable_pcsRow_axis_label" ~ "row_axis_label",
                              "pcsTable_pcsRow_axis_title" ~ "row_axis_title",
                              "pos_pcsTable_axis" ~ "table_pos",
                              "pos_pcsTable_pcsRow_axis" ~ "row_pos",
                              "values_pcsTable_axis" ~ "values",
                              "values_pcsTable_pcsRow_axis" ~ "values",
                              .default = columns)) |>
  filter(columns != "values") |>
  mutate(rowid = row_number(), .before = 1)

pcs_tbl <- pcs_tbl |>
  rowwise() |>
  mutate(desc = tolower(value),
         desc = str_replace_all(desc, " ", "-")) |>
  ungroup() |>
  unite('cols', c(columns, desc), na.rm = TRUE, remove = TRUE)


pcsTables <- pcs_tbl |>
  filter(cols == "table_pos_1") |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {dplyr::slice_tail(pcs_tbl) |> dplyr::pull(rowid)}, .default = end)) |>
  select(rowid, start, end)

pcs_tbl <- left_join(pcs_tbl, pcsTables) |>
  fill(start, end) |>
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
  #select(row_m_1, rowid, row_p_1, row_p_2) |>
  pivot_longer(cols = contains("row"),
               names_to = "col",
               values_to = "rowid") |>
  select(rowid, start, end) |>
  arrange(rowid)

## Section
Section <- pcs_tbl |>
  filter(rowid %in% section_rowids$rowid) |>
  left_join(section_rowids)

Section_2 <- Section |>
  select(-elem, -elemid) |>
  pivot_wider(names_from = cols, values_from = value) |>
  clean_names()

sec0 <- Section_2 |>
  mutate(table_axis_title_section = lead(table_axis_title_section),
         table_axis_label_medical_and_surgical = lead(table_axis_label_medical_and_surgical, 2),
         table_axis_code_0 = lead(table_axis_code_0, 3)) |>
  select(rowid:table_axis_code_0) |>
  rename(axis_pos = table_pos_1,
         axis_name = table_axis_title_section,
         axis_label = table_axis_label_medical_and_surgical,
         axis_code = table_axis_code_0) |>
  filter(!is.na(axis_pos))

sec1 <- Section_2 |>
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

left_join(Section, secs) |>
  group_by()

pcs_tbl <- left_join(pcs_tbl, sec0) |>
  group_by(end) |>
  mutate(section = consecutive_id(start)) |>
  ungroup() |> print(n = 150)

## Body Part
pcsRows_4 <- pcs_tbl |>
  filter(columns == "row_pos") |>
  filter(value == "4") |>
  mutate(start = rowid,
         end = dplyr::lead(start) - 1,
         end = dplyr::case_when(start == max(start) ~ {dplyr::slice_tail(pcs_tbl) |> dplyr::pull(rowid)}, .default = end)) |>
  select(rowid, start, end)


pcs_tbl <- left_join(pcs_tbl, pcsRows_4) |>
  group_by(table) |>
  fill(start, end) |>
  mutate(body_part = consecutive_id(start),
         start = NULL,
         end = NULL) |>
  ungroup()

##### FIX
pcs_tbl <- pcs_tbl |> ungroup()


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





pcs_tbl |>
  pivot_wider(names_from = columns, values_from = value) |>
  mutate(
     pcsTable_axis_title = lead(pcsTable_axis_title, 2),
     pcsTable_axis_label = lead(pcsTable_axis_label, 3),
     code_pcsTable_axis_label = lead(code_pcsTable_axis_label, 4),
     pcsTable_axis_definition = lead(pcsTable_axis_definition, 5),
     pos_pcsTable_pcsRow_axis = lead(pos_pcsTable_pcsRow_axis, 9),
     pcsTable_pcsRow_axis_title = lead(pcsTable_pcsRow_axis_title, 11),
     pcsTable_pcsRow_axis_label = lead(pcsTable_pcsRow_axis_label, 12),
     code_pcsTable_pcsRow_axis_label = lead(code_pcsTable_pcsRow_axis_label, 13)) |>
   select(
     pos = pos_pcsTable_axis,
     code = code_pcsTable_axis_label,
     title = pcsTable_axis_title,
     label = pcsTable_axis_label,
     definition = pcsTable_axis_definition,
     axis_pos = pos_pcsTable_pcsRow_axis,
     axis_title = pcsTable_pcsRow_axis_title,
     axis_code = code_pcsTable_pcsRow_axis_label,
     axis_label = pcsTable_pcsRow_axis_label) |>
   unite('check', c(code, axis_code), na.rm = TRUE, sep = "", remove = FALSE) |>
   mutate(check = na_if(check, "")) |>
   filter(!is.na(check)) |>
   select(-check) |>
   fill(pos, code, title, label) |>
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
