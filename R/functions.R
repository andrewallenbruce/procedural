# library(tidyverse)
# library(janitor)
# library(zeallot)

# ------------------------------------------------------------------------------
# pcs_tbl <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024")
#
# pcs_tbl <- pcs_tbl |>
#   tibble() |>
#   clean_names() |>
#   filter(elem %nin% c("version", "ICD10PCS.tabular")) |>
#   select(-level1)
#
# pcs_tbl <- pcs_tbl[4:nrow(pcs_tbl), ] |>
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
#   ungroup() |>
#   mutate(rowid = row_number())
# pcs_tbl2 <- pcs_tbl
# qs::qsave(pcs_tbl2, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_tbl2")
# qs::qsave(sec_sys, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_sec_sys")

# sec_sys <- pcs_tbl |>
#   filter(title == "Section" | title == "Body System") |>
#   select(pos, code, title, label, rowid) |>
#   pivot_wider(names_from = title,
#               values_from = c(label, pos, code),
#               names_glue = "{title}_{.value}") |>
#   janitor::clean_names() |>
#   select(rowid,
#          sec_pos = section_pos,
#          sys_pos = body_system_pos,
#          sec_code = section_code,
#          sys_code = body_system_code,
#          sec_lbl = section_label,
#          sys_lbl = body_system_label) |>
#   mutate(sys_lbl = lead(sys_lbl),
#          sys_pos = lead(sys_pos),
#          sys_code = lead(sys_code)) |>
#   filter(!is.na(sys_lbl)) |>
#   mutate(start = rowid,
#        end = lead(start) - 1,
#        end = case_when(start == max(start) ~ {
#          slice_tail(pcs_tbl) |> pull(rowid)}, .default = end))

# qs::qsave(sec_sys_op, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_sec_sys_op")

# sec_sys_op <- pcs_tbl |>
#   filter(title == "Section" | title == "Body System" | title == "Operation") |>
#   select(pos, code, title, label, rowid) |>
#   pivot_wider(names_from = title,
#               values_from = c(label, pos, code),
#               names_glue = "{title}_{.value}") |>
#   janitor::clean_names() |>
#   select(rowid,
#          sec_pos = section_pos,
#          sys_pos = body_system_pos,
#          op_pos = operation_pos,
#          sec_code = section_code,
#          sys_code = body_system_code,
#          op_code = operation_code,
#          sec_lbl = section_label,
#          sys_lbl = body_system_label,
#          op_lbl = operation_label) |>
#   mutate(sys_lbl = lead(sys_lbl),
#          sys_pos = lead(sys_pos),
#          sys_code = lead(sys_code),
#          op_lbl = lead(op_lbl, 2),
#          op_pos = lead(op_pos, 2),
#          op_code = lead(op_code, 2)) |>
#   filter(!is.na(op_lbl)) |> print(n = 200) |>
#   fill(sec_pos, sys_pos, sec_code, sys_code, sec_lbl, sys_lbl)



# sec_sys <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_sec_sys")
# sec_sys_op <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_sec_sys_op")
#
#
# sec_sys |>
#   filter(sec_lbl == "Obstetrics")
#
# search <- sec_sys_op |>
#   filter(sec_code == "1") |>
#   filter(sys_code == "0") |>
#   filter(op_code == "Q")
#
# rmin <- min(search$rowid)
# rmax <- max(search$rowid)
#
# options_10Q <- pcs_tbl |>
#   filter(between(rowid, rmin, rmax)) |>
#   mutate(definition = NULL) |>
#   filter(title == "Operation" & code == "Q") |>
#   select(-c(pos, code, title, label, rowid))
#
# table_10Q <- sec_sys_op |>
#   mutate(rowid = NULL) |>
#   filter(sec_code == "1") |>
#   filter(sys_code == "0") |>
#   filter(op_code == "Q") |>
#   distinct()
#
# vctrs::vec_cbind(
#   table_10Q, options_10Q
# )
