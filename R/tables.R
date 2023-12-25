# # library(flatxml)
# # library(tictoc)
# library(tidyverse)
# library(janitor)
# library(zeallot)
#
# `%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L
# # Import and Parse _____________________________________________________________
# # pcs_tbl_xsd <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables.xsd"
# # pcs_tbl_xml <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024.xml"
# # tic()
# # pcs_tbl <- fxml_importXMLFlat(pcs_tbl_xml)
# # toc()
#
# # 4630.2 sec elapsed 1 hour 17 min
# # qs::qsave(pcs_tbl, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024")
#
# pcs_tbl <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024")
#
# head(pcs_tbl, 25)
#
# # Data Cleaning ________________________________________________________________
# pcs_tbl <- pcs_tbl |>
#   tibble() |>
#   clean_names() |>
#   filter(elem %nin% c("version", "ICD10PCS.tabular")) |>
#   select(-level1)
#
# tbl <- pcs_tbl[4:nrow(pcs_tbl), ] |>
#   mutate(rowid = row_number(), .before = 1) |>
#   unite('columns', c(attr, level2:level5), na.rm = TRUE, remove = TRUE) |>
#   pivot_wider(names_from = columns, values_from = value) |>
#   mutate(
#     pcsTable_axis_title = lead(pcsTable_axis_title, 2),
#     pcsTable_axis_label = lead(pcsTable_axis_label, 3),
#     code_pcsTable_axis_label = lead(code_pcsTable_axis_label, 4),
#     pcsTable_axis_definition = lead(pcsTable_axis_definition, 5),
#     pos_pcsTable_pcsRow_axis = lead(pos_pcsTable_pcsRow_axis, 9),
#     pcsTable_pcsRow_axis_title = lead(pcsTable_pcsRow_axis_title, 11),
#     pcsTable_pcsRow_axis_label = lead(pcsTable_pcsRow_axis_label, 12),
#     code_pcsTable_pcsRow_axis_label = lead(code_pcsTable_pcsRow_axis_label, 13)) |>
#   select(
#     pos = pos_pcsTable_axis,
#     code = code_pcsTable_axis_label,
#     title = pcsTable_axis_title,
#     label = pcsTable_axis_label,
#     definition = pcsTable_axis_definition,
#     axis_pos = pos_pcsTable_pcsRow_axis,
#     axis_title = pcsTable_pcsRow_axis_title,
#     axis_code = code_pcsTable_pcsRow_axis_label,
#     axis_label = pcsTable_pcsRow_axis_label) |>
#   unite('check', c(code, axis_code), na.rm = TRUE, sep = "", remove = FALSE) |>
#   mutate(check = na_if(check, "")) |>
#   filter(!is.na(check)) |>
#   select(-check) |>
#   fill(pos, code, title, label) |>
#   group_by(label) |>
#   fill(definition) |>
#   ungroup() |>
#   group_by(definition) |>
#   fill(axis_pos, axis_title, axis_code) |>
#   ungroup()
#
# tbl |>
#   mutate(rowid = row_number()) |>
#   filter(label == "Placement") |>
#   print(n = 200)
#
# ## Obstetrics ---------------------------------------------------------
# obstetrics <- tbl[22953:23129, ] |>
#   mutate(definition = NULL) |>
#   select(title,
#          pos,
#          code,
#          label,
#          axis_title,
#          axis_pos,
#          axis_code,
#          axis_label) |>
#   mutate(rowid = row_number())
#
# obstetrics <- obstetrics |>
#   pivot_wider(names_from = title,
#               values_from = c(pos, code, label),
#               names_glue = "{title}_{.value}") |>
#   janitor::clean_names() |>
#   select(
#     sec_pos = section_pos,
#     sec_code = section_code,
#     sec_label = section_label,
#     sys_pos = body_system_pos,
#     sys_code = body_system_code,
#     sys_label = body_system_label,
#     op_pos = operation_pos,
#     op_code = operation_code,
#     op_label = operation_label,
#     axis_title,
#     axis_pos,
#     axis_code,
#     axis_label) |>
#   mutate(
#     sys_pos = lead(sys_pos),
#     sys_code = lead(sys_code),
#     sys_label = lead(sys_label),
#     op_pos = lead(op_pos, 2),
#     op_code = lead(op_code, 2),
#     op_label = lead(op_label, 2),
#     axis_title = lead(axis_title, 2),
#     axis_pos = lead(axis_pos, 2),
#     axis_code = lead(axis_code, 2),
#     axis_label = lead(axis_label, 2)) |>
#   filter(!is.na(axis_label))
#
# part <- obstetrics |>
#   pivot_wider(names_from = axis_title,
#               values_from = c(axis_pos, axis_code, axis_label),
#               names_glue = "{axis_title}_{.value}") |>
#   janitor::clean_names() |>
#   select(starts_with("sec_"),
#          starts_with("sys_"),
#          starts_with("op_"),
#          starts_with("body_part"),
#          starts_with("approach_"),
#          starts_with("device_"),
#          starts_with("qualifier")) |>
#   unnest(body_part_axis_pos, keep_empty = TRUE) |>
#   unnest(body_part_axis_code, keep_empty = TRUE) |>
#   unnest(body_part_axis_label, keep_empty = TRUE) |>
#   rename(part_pos = body_part_axis_pos,
#          part_code = body_part_axis_code,
#          part_label = body_part_axis_label)
#
# part |>
#   unnest(approach_axis_pos, keep_empty = TRUE) |>
#   unnest(approach_axis_code, keep_empty = TRUE) |>
#   unnest(approach_axis_label, keep_empty = TRUE) |>
#   rename(app_pos = approach_axis_pos,
#          app_code = approach_axis_code,
#          app_label = approach_axis_label) |>
#   unnest(device_axis_pos, keep_empty = TRUE) |>
#   unnest(device_axis_code, keep_empty = TRUE) |>
#   unnest(device_axis_label, keep_empty = TRUE) |>
#   rename(dev_pos = device_axis_pos,
#          dev_code = device_axis_code,
#          dev_label = device_axis_label) |>
#   unnest(qualifier_axis_pos, keep_empty = TRUE) |>
#   unnest(qualifier_axis_code, keep_empty = TRUE) |>
#   unnest(qualifier_axis_label, keep_empty = TRUE) |>
#   rename(qua_pos = qualifier_axis_pos,
#          qua_code = qualifier_axis_code,
#          qua_label = qualifier_axis_label)
#
#
#
#
#
#
#
#
#
#
#
# obstetrics |>
#   group_by(title) |>
#   mutate(iv = ivs::iv_diff(c(rowid, Inf)))
#
# obs_sections <- obstetrics |>
#   filter(title == "Section") |>
#   mutate(start = rowid,
#          end = lead(start) - 1,
#          end = case_when(start == max(start) ~ {
#            slice_tail(obstetrics) |> pull(rowid)}, .default = end),
#          sec_iv = ivs::iv(start, end),
#          start = NULL,
#          end = NULL)
#
# obs_sections |> filter()
#
# obs_systems <- obstetrics |>
#   filter(title == "Body System") |>
#   mutate(start = rowid,
#          end = lead(start) - 1,
#          end = case_when(start == max(start) ~ {
#            slice_tail(obstetrics) |> pull(rowid)}, .default = end),
#          sys_iv = ivs::iv(start, end),
#          start = NULL,
#          end = NULL)
#
#
# obs <- left_join(obstetrics, obs_sections) |>
#   left_join(obs_systems) |>
#   fill(sec_iv, sys_iv)
#
# pcs <- "10S07ZZ"
# pcs <- unlist(strsplit(pcs, ""), use.names = FALSE)
#
# obs |>
#   ivs::iv_between("1", sec_iv)
#   #filter(sec_iv == ) |>
#   filter(between(rowid, 2, 8))
#
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
# sections
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
