# library(tidyverse)
# library(janitor)
# library(zeallot)
#

# pcs <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_tbl2") |> select(-definition)
#
#
# sec_sys <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_sec_sys")
# sec_sys_op <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\pcs_sec_sys_op")
#
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
#
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
#   fill(sec_pos,
#        sys_pos,
#        op_pos,
#        sec_code,
#        sys_code,
#        op_code,
#        sec_lbl,
#        sys_lbl,
#        op_lbl)
# x = "2W0UX0Z"
# pcs_lookup <- function(x) {
#
#   xs <- unlist(strsplit(x, ""), use.names = FALSE)
#
#   search <- sec_sys_op |>
#     filter(sec_code == xs[1]) |>
#     filter(sys_code == xs[2]) |>
#     filter(op_code == xs[3])
#
#   rmin <- min(search$rowid)
#   rmax <- max(search$rowid)
#
#   pcs2 <- pcs |>
#     filter(between(rowid, rmin, rmax))
#
#   tbl <- search |>
#     mutate(rowid = NULL) |>
#     distinct()
#
#   table <- tibble(
#     position = c(tbl$sec_pos, tbl$sys_pos, tbl$op_pos),
#     title = c("Section", "Body System", "Root Operation"),
#     code = c(tbl$sec_code, tbl$sys_code, tbl$op_code),
#     label = c(tbl$sec_lbl, tbl$sys_lbl, tbl$op_lbl))
#
#   b4 <- pcs2 |>
#     filter(code == xs[3], axis_pos == "4" & axis_code == xs[4]) |>
#     mutate(rowid = NULL) |>
#     distinct()
#
#   body <- tibble(
#     position = b4$axis_pos,
#     title = b4$axis_title,
#     code = b4$axis_code,
#     label = b4$axis_label)
#
#   a5 <- pcs2 |>
#     filter(code == xs[3],
#            axis_pos == "5" &  axis_code == xs[5]) |>
#     mutate(rowid = NULL) |>
#     distinct()
#
#   approach <- tibble(
#     position = a5$axis_pos,
#     title = a5$axis_title,
#     code = a5$axis_code,
#     label = a5$axis_label)
#
#   d6 <- pcs2 |>
#     filter(code == xs[3],
#            axis_pos == "6" &  axis_code == xs[6]) |>
#     mutate(rowid = NULL) |>
#     distinct()
#
#   device <- tibble(
#     position = d6$axis_pos,
#     title = d6$axis_title,
#     code = d6$axis_code,
#     label = d6$axis_label)
#
#   q7 <- pcs2 |>
#     filter(code == xs[3],
#            axis_pos == "7" &  axis_code == xs[7]) |>
#     mutate(rowid = NULL) |>
#     distinct()
#
#   qualifier <- tibble(
#     position = q7$axis_pos,
#     title = q7$axis_title,
#     code = q7$axis_code,
#     label = q7$axis_label)
#
#   cli::cli_blockquote("PCS Code: {.val {x}}")
#
#   vctrs::vec_rbind(
#     table,
#     body,
#     approach,
#     device,
#     qualifier
#   )
#
#   # list(
#   #   table = table,
#   #   body = body,
#   #   approach = approach,
#   #   device = device,
#   #   qualifier = qualifier
#   # )
# }
#
# pcs_lookup("2W0UX0Z")
# pcs_lookup("2W20X4Z")
# pcs_lookup("2W10X7Z")
# pcs_lookup("2W10X6Z")
# pcs_lookup("2W1HX7Z")
#
# pcs_lookup("0G9000Z")
# pcs_lookup("0016070")
#
