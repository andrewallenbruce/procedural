library(flatxml)
library(tictoc)
library(tidyverse)
library(janitor)
library(zeallot)

`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L
# Import and Parse _____________________________________________________________
# pcs_tbl_xsd <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables.xsd"
# pcs_tbl_xml <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024.xml"
# tic()
# pcs_tbl <- fxml_importXMLFlat(pcs_tbl_xml)
# toc()
# 4630.2 sec elapsed 1 hour 17 min
# qs::qsave(pcs_tbl, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024")

pcs_tbl <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024")

head(pcs_tbl, 25)

# Data Cleaning ________________________________________________________________
pcs_tbl <- pcs_tbl |>
  tibble() |>
  clean_names() |>
  filter(elem %nin% c("version", "ICD10PCS.tabular")) |>
  select(-level1)

tbl <- pcs_tbl[4:nrow(pcs_tbl), ] |>
  mutate(rowid = row_number(), .before = 1) |>
  unite('columns', c(attr, level2:level5), na.rm = TRUE, remove = TRUE) |>
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
  ungroup()

tbl |>
  print(n = 200)

# Sections ___________________________________________________________
section_ivs <- pcs_tbl_clean |>
  filter(element == "Section") |>
  select(rowid, position, count, element, code, label) |>
  group_by(code, label) |>
  summarise(start = min(rowid),
            end = max(rowid)) |>
  ungroup() |>
  mutate(section = row_number())

sections <- left_join(pcs_tbl_clean, section_ivs) |>
  fill(section) |>
  select(rowid,
         count,
         element,
         position,
         section,
         code,
         label,
         definition)
sections

# Tables ______________________________________________________________
table_ids <- sections |>
  filter(position == "3") |>
  mutate(table = consecutive_id(code),
         .before = position) |>
  select(rowid,
         table,
         position,
         code,
         label)

tables <- left_join(sections, table_ids) |>
  group_by(section) |>
  fill(table) |>
  ungroup() |>
  mutate(position = as.integer(position),
         count = as.integer(count)) |>
  select(rowid,
         position,
         count,
         element,
         section,
         table,
         code,
         label,
         definition)
tables

# Units ______________________________________________________________
unit_ivs <- tables |>
  filter(position == 4) |>
  select(rowid, count, element, position, section, table, code, label) |>
  mutate(start = rowid,
         end = lead(start) - 1,
         end = case_when(
           start == max(start) ~ {
             slice_tail(tables) |>
               pull(rowid)
           },
           .default = end),
         unit = row_number())

units <- left_join(tables, unit_ivs) |>
  group_by(table) |>
  fill(unit) |>
  ungroup() |>
  select(rowid,
         count,
         element,
         position,
         section,
         table,
         unit,
         code,
         label,
         definition)
units

# Table Lookup ______________________________________________________________
table_lookup <- units |>
  filter(position %in% c(1:3)) |>
  mutate(count = NULL,
         position = NULL,
         unit = NULL) |>
  pivot_wider(names_from = element,
              values_from = c(code,
                              label,
                              definition)) |>
  janitor::remove_empty(which = c("rows", "cols")) |>
  mutate(
    code_System = lead(code_System, 1),
    code_Operation = lead(code_Operation, 2),
    label_System = lead(label_System, 1),
    label_Operation = lead(label_Operation, 2),
    definition_Operation = lead(definition_Operation, 2),
    table = lead(table, 2)) |>
  filter(!is.na(code_Section)) |>
  rename(definition = definition_Operation,
         sec_id = section,
         tbl_id = table,
         section = label_Section,
         system = label_System,
         operation = label_Operation) |>
  unite('tbl_code', code_Section:code_Operation, na.rm = TRUE, sep = "") |>
  mutate(rowid = NULL)

table_lookup
# Groups ______________________________________________________________
tbl_groupby <- units |>
  group_by(section, table)

group_size(tbl_groupby)
n_groups(tbl_groupby)
group_keys(tbl_groupby)

head(group_split(tbl_groupby))

tbl_groups[[150]] |> print(n = Inf)



usethis::use_data(pcs_2024, overwrite = TRUE)


## code to prepare dataset goes here
nucc <- provider::download_nucc_csv()

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(nucc,
                         name = "taxonomy_codes",
                         description = "NUCC Health Care Provider Taxonomy code set",
                         type = "qs")

board |> pins::write_board_manifest()
