# library(flatxml)
# library(tidyverse)
# library(janitor)
# library(zeallot)
#
# # Import and Parse _____________________________________________________________
# # pcs_tbl_xsd <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables.xsd"
# # pcs_tbl_xml <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024.xml"
# #
# # pcs_tbl <- fxml_importXMLFlat(pcs_tbl_xml)
# #
# # qs::qsave(pcs_tbl, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024")
#
# # pcs_tbl <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024")
#
# # Data Cleaning ________________________________________________________________
# # pcs_tbl <- pcs_tbl |>
# #   tibble() |>
# #   clean_names() |>
# #   filter(!is.na(value)) |>
# #   filter(elem != "version") |>
# #   filter(level2 != "title") |>
# #   mutate(rowid = row_number(), .before = 1) |>
# #   mutate(level1 = NULL) |>
# #   unite('levels', level2:level5,
# #         na.rm = TRUE,
# #         remove = TRUE)
# pcs_tbl
#
# pcs_tbl_clean <- pcs_tbl |>
#   mutate(elem = case_match(
#     value,
#     "Section" ~ "section",
#     "Qualifier" ~ "qualifier",
#     "Approach" ~ "approach",
#     "Body Part" ~ "part",
#     "Device" ~ "device",
#     "Body System" ~ "system",
#     "Operation" ~ "operation",
#     "Body System / Region" ~ "system",
#     "Device / Substance / Technology" ~ "device",
#     "Substance" ~ "substance",
#     "Type" ~ "type",
#     "Contrast" ~ "contrast",
#     "Isotope" ~ "isotope",
#     "Modality Qualifier" ~ "qualifier",
#     "Treatment Site" ~ "site",
#     "Equipment" ~ "equipment",
#     "Type Qualifier" ~ "qualifier",
#     "Radionuclide" ~ "radionuclide",
#     "Function / Device" ~ "device",
#     "Modality" ~ "modality",
#     "Body Region" ~ "part",
#     "Method" ~ "method",
#     "Duration" ~ "duration",
#     "Function" ~ "function",
#     "Section Qualifier" ~ "qualifier",
#     .default = elem)) |>
#   mutate(elem = case_match(
#     attr,
#     "code" ~ "code",
#     "pos" ~ "position",
#     "values" ~ "count",
#     .default = elem)) |>
#   select(rowid, elem, value) |>
#   pivot_wider(names_from = elem, values_from = value) |>
#   mutate(count = lead(count),
#          section = lead(section, 2),
#          label = lead(label, 3),
#          code = lead(code, 4),
#          definition = lead(definition, 5)) |>
#   select(rowid,
#          position,
#          count,
#          element = section,
#          code,
#          label,
#          definition) |>
#   mutate(element = case_match(
#     position,
#     "1" ~ "Section",
#     "2" ~ "System",
#     "3" ~ "Operation",
#     "4" ~ "Part",
#     "5" ~ "Approach",
#     "6" ~ "Device",
#     "7" ~ "Qualifier"),
#     .after = position) |>
#   filter(!is.na(label)) |>
#   fill(position) |>
#   fill(element)
#
# pcs_tbl_clean
#
# # Sections ___________________________________________________________
# section_ivs <- pcs_tbl_clean |>
#   filter(element == "Section") |>
#   select(rowid, position, count, element, code, label) |>
#   group_by(code, label) |>
#   summarise(start = min(rowid),
#             end = max(rowid)) |>
#   ungroup() |>
#   mutate(section = row_number())
#
# sections <- left_join(pcs_tbl_clean, section_ivs) |>
#   fill(section) |>
#   select(rowid,
#          count,
#          element,
#          position,
#          section,
#          code,
#          label,
#          definition)
#
# # Tables ______________________________________________________________
# table_ids <- sections |>
#   filter(position == "3") |>
#   mutate(table = consecutive_id(code),
#          .before = position) |>
#   select(rowid,
#          table,
#          position,
#          code,
#          label)
#
# tables <- left_join(sections, table_ids) |>
#   group_by(section) |>
#   fill(table) |>
#   ungroup() |>
#   mutate(position = as.integer(position),
#          count = as.integer(count)) |>
#   select(rowid,
#          position,
#          count,
#          element,
#          section,
#          table,
#          code,
#          label,
#          definition)
# tables
#
# # Units ______________________________________________________________
# unit_ivs <- tables |>
#   filter(position == 4) |>
#   select(rowid, count, element, position, section, table, code, label) |>
#     mutate(start = rowid,
#            end = lead(start) - 1,
#            end = case_when(
#              start == max(start) ~ {
#                slice_tail(tables) |>
#                  pull(rowid)
#              },
#              .default = end),
#            unit = row_number())
#
# units <- left_join(tables, unit_ivs) |>
#   group_by(table) |>
#   fill(unit) |>
#   ungroup() |>
#   select(rowid,
#          count,
#          element,
#          position,
#          section,
#          table,
#          unit,
#          code,
#          label,
#          definition)
# units
#
# # Table Lookup ______________________________________________________________
# table_lookup <- units |>
#   filter(position %in% c(1:3)) |>
#   mutate(count = NULL,
#          position = NULL,
#          unit = NULL) |>
#   pivot_wider(names_from = element,
#               values_from = c(code,
#                               label,
#                               definition)) |>
#   janitor::remove_empty(which = c("rows", "cols")) |>
#   mutate(
#     code_System = lead(code_System, 1),
#     code_Operation = lead(code_Operation, 2),
#     label_System = lead(label_System, 1),
#     label_Operation = lead(label_Operation, 2),
#     definition_Operation = lead(definition_Operation, 2),
#     table = lead(table, 2)) |>
#   filter(!is.na(code_Section)) |>
#   rename(definition = definition_Operation,
#          sec_id = section,
#          tbl_id = table,
#          section = label_Section,
#          system = label_System,
#          operation = label_Operation) |>
#   unite('tbl_code', code_Section:code_Operation, na.rm = TRUE, sep = "") |>
#   mutate(rowid = NULL)
#
# table_lookup
# # Groups ______________________________________________________________
# tbl_groupby <- units |>
#   group_by(section, table)
#
# group_size(tbl_groupby)
# n_groups(tbl_groupby)
# group_keys(tbl_groupby)
#
# head(group_split(tbl_groupby))
#
# tbl_groups[[150]] |> print(n = Inf)
