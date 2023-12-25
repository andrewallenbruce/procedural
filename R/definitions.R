# library(flatxml)
# library(tidyverse)
# library(janitor)
# library(zeallot)
# library(datawizard)
#
# tbl[23107:23129,]
#
# wiz_rotate <- tbl[23107:23129,] |>
#   select(title, label, code, axis_title, axis_label, axis_code) |>
#   datawizard::data_rotate() |>
#   tibble()
#
# names(wiz_rotate) <- unname(unlist(wiz_rotate[1, ], use.names = FALSE))
#
# wiz_rotate[2:nrow(wiz_rotate),]
#
#   pivot_wider(names_from = title, values_from = c(pos, code, label), names_sep = ".", values_fn = list) |>
#   print(n = 200)
#
# tbl |>
#   mutate(rowid = row_number(), .before = 1) |>
#   select(-definition) |>
#   filter(label == "Placement")
#   pivot_wider(names_from = title, values_from = c(code, pos, label, definition), names_sep = ".", values_fn = list) |>
#   clean_names() |>
#   unnest(code_section)
#
# # Import and Parse _____________________________________________________________
# # pcs_def_xsd <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definitions.xsd"
# # pcs_def_xml <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definitions_2024.xml"
# # pcs_def <- fxml_importXMLFlat(pcs_def_xml)
# # qs::qsave(pcs_def, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definition_2024")
# pcs_def <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definition_2024")
#
# pcs_def <- pcs_def |>
#   tibble() |>
#   clean_names() |>
#   filter(!is.na(value)) |>
#   filter(elem != "version") |>
#   filter(level2 != "title",
#          level2 != "deviceAggregation") |>
#   mutate(rowid = row_number(), .before = 1) |>
#   mutate(level1 = NULL)
#
# pcs_def |>
#   print(n = 200)
#   unite('sections', c(attr, level2:level4), na.rm = TRUE, remove = FALSE) |>
#   mutate(sections = dplyr::na_if(sections, c("section_axis_terms"))) |>
#   unite('columns', c(attr, level3:level5), na.rm = TRUE, remove = TRUE) |>
#   mutate(level2 = NULL,
#          elem = NULL,
#          elemid = NULL) |>
#   pivot_wider(names_from = columns, values_from = value) |>
#   mutate(
#     title = lead(title),
#     pos = lead(pos_axis, 2),
#     axis = lead(axis_title, 3),
#     terms = lead(axis_terms_title, 4),
#     definition = lead(axis_terms_definition, 5),
#     explanation = lead(axis_terms_explanation, 6),
#     includes = lead(axis_terms_includes, 7)) |>
#   select(rowid,
#          code,
#          title,
#          pos,
#          axis,
#          terms,
#          includes,
#          definition,
#          explanation) |>
#   fill(code, title, pos, axis)
#
#
# op <- base[1:118,] |>
#   filter(!is.na(terms))
#
# op
#
# pt <- base[123:nrow(base),] |>
#   mutate(includes = lag(includes))
#
# pt[2:nrow(pt),] |> print(n = 200)
#
# pt[2:]
#
# base |> print(n = 200)
# base[base$code == "0",] |> print(n = 200)
#
# # Data Cleaning ________________________________________________________________
# def_sec <- pcs_def |>
#   tibble() |>
#   clean_names() |>
#   filter(!is.na(value)) |>
#   filter(elem != "version") |>
#   filter(level2 != "title",
#          level2 != "deviceAggregation") |>
#   mutate(rowid = row_number(), .before = 1) |>
#   mutate(level1 = NULL,
#          attr = NULL) |>
#   unite('levels', level2:level5, na.rm = TRUE, remove = TRUE) |>
#   pivot_wider(names_from = levels, values_from = value)
#
# # Sections Intervals ___________________________________________________________
# sections <- def_sec |>
#   filter(levels == "section") |>
#   select(rowid, elem, elemid, value, levels) |>
#   mutate(start = rowid,
#          end = lead(start) - 1,
#          end = case_when(
#            start == max(start) ~ {
#              slice_tail(def_sec) |>
#                pull(rowid)
#            },
#            .default = end))
#
# def_ivs <- left_join(def_sec, sections,
#                      by = join_by(rowid, elem, elemid, value, levels)) |>
#   fill(c(start, end))
#
# # [0] Medical & Surgical _______________________________________________________
# filter(sections, value == "0") |> select(start, end) %->% c(start, end)
# md <- list(start = start, end = end)
#
# md_base <- def_ivs |> filter(start == md$start, end == md$end)
#
# ## Section ----------
# md_section <- md_base |>
#   filter(levels %in% c("section", "section_title")) |>
#   pivot_wider(names_from = 'levels', values_from = 'value') |>
#   fill(c(section, section_title), .direction = "downup") |>
#   select(section.code = section,
#          section.name = section_title,
#          start,
#          end) |>
#   slice(1)
#
# ## Axis ----------
# md_axis <- md_base |>
#   filter(elem == "axis") |>
#   mutate(start_axis = rowid,
#          end_axis = lead(start_axis) - 1,
#          end_axis = case_when(
#            start_axis == max(start_axis) ~ {
#              slice_tail(md_base) |>
#                pull(rowid)
#            },
#            .default = end_axis))
#
# md_axis_3 <- md_base |>
#   filter(between(rowid, md_axis$start_axis[1], md_axis$end_axis[1])) |>
#   pivot_wider(names_from = levels, values_from = value) |>
#   mutate(
#     section_axis_title = lead(section_axis_title, 1),
#     section_axis_terms_title = lead(section_axis_terms_title, 2),
#     section_axis_terms_definition = lead(section_axis_terms_definition, 3),
#     section_axis_terms_explanation = lead(section_axis_terms_explanation, 4),
#     section_axis_terms_includes = lead(section_axis_terms_includes, 5)) |>
#   filter(!is.na(section_axis_terms_title)) |>
#   rename(axis = section_axis,
#          name = section_axis_title,
#          term = section_axis_terms_title,
#          definition = section_axis_terms_definition,
#          explanation = section_axis_terms_explanation,
#          includes = section_axis_terms_includes) |>
#   fill(c(axis, name)) |>
#   select(-elem)
#
# md_axis_5 <- md_base |>
#   filter(between(rowid, md_axis$start_axis[2], md_axis$end_axis[2])) |>
#   pivot_wider(names_from = levels, values_from = value) |>
#   mutate(
#     section_axis_title = lead(section_axis_title, 1),
#     section_axis_terms_title = lead(section_axis_terms_title, 2),
#     section_axis_terms_includes = lead(section_axis_terms_includes, 4)) |>
#   filter(!is.na(section_axis_terms_title)) |>
#   rename(axis = section_axis,
#          name = section_axis_title,
#          term = section_axis_terms_title,
#          includes = section_axis_terms_includes) |>
#   fill(c(axis, name)) |> print(n = Inf)
#
# md_axes <- bind_rows(md_axis_3, md_axis_5) |>
#   select(axis.code = axis,
#          axis.name = name,
#          axis.term = term,
#          axis.definition = definition,
#          axis.explanation = explanation,
#          start,
#          end)
#
# med_surg <- md_section |>
#   left_join(md_axes)
#
# # [1] Obstetrics _______________________________________________________________
# filter(sections, value == "1") |> select(start, end) %->% c(start, end)
#
# ob <- list(start = start, end = end)
#
# ob_base <- def_ivs |> filter(start == ob$start, end == ob$end)
#
# ## Section ----------
# ob_section <- ob_base |>
#   filter(levels %in% c("section", "section_title")) |>
#   pivot_wider(names_from = 'levels', values_from = 'value') |>
#   fill(c(section, section_title), .direction = "downup") |>
#   select(section.code = section,
#          section.name = section_title,
#          start,
#          end) |>
#   slice(1)
#
# ## Axis ----------
# ob_axis <- ob_base |>
#   filter(elem == "axis") |>
#   mutate(start_axis = rowid,
#          end_axis = lead(start_axis) - 1,
#          end_axis = case_when(
#            start_axis == max(start_axis) ~ {
#              slice_tail(ob_base) |>
#              pull(rowid)
#              },
#            .default = end_axis))
#
# ob_axis_3 <- ob_base |>
#   filter(between(rowid, ob_axis$start_axis[1], ob_axis$end_axis[1])) |>
#   pivot_wider(names_from = levels, values_from = value) |>
#   mutate(
#     section_axis_title = lead(section_axis_title, 1),
#     section_axis_terms_title = lead(section_axis_terms_title, 2),
#     section_axis_terms_definition = lead(section_axis_terms_definition, 3),
#     section_axis_terms_explanation = lead(section_axis_terms_explanation, 4)) |>
#   filter(!is.na(section_axis_terms_title)) |>
#   rename(axis = section_axis,
#          name = section_axis_title,
#          term = section_axis_terms_title,
#          definition = section_axis_terms_definition,
#          explanation = section_axis_terms_explanation) |>
#   fill(c(axis, name))
#
# ob_axis_5 <- ob_base |>
#   filter(between(rowid, ob_axis$start_axis[2], ob_axis$end_axis[2])) |>
#   pivot_wider(names_from = levels, values_from = value) |>
#   mutate(
#     section_axis_title = lead(section_axis_title, 1),
#     section_axis_terms_title = lead(section_axis_terms_title, 2),
#     section_axis_terms_definition = lead(section_axis_terms_definition, 3)) |>
#   filter(!is.na(section_axis_terms_title)) |>
#   rename(axis = section_axis,
#          name = section_axis_title,
#          term = section_axis_terms_title,
#          definition = section_axis_terms_definition) |>
#   fill(c(axis, name))
#
# ob_axes <- bind_rows(ob_axis_3, ob_axis_5) |>
#   select(axis.code = axis,
#          axis.name = name,
#          axis.term = term,
#          axis.definition = definition,
#          axis.explanation = explanation,
#          start,
#          end)
#
# obstetrics <- ob_section |>
#   left_join(ob_axes)
#
#
# # [2] Obstetrics _______________________________________________________________
# filter(sections, value == "2") |> select(start, end) %->% c(start, end)
#
# plc <- list(start = start, end = end)
#
# plc_base <- def_ivs |> filter(start == plc$start, end == plc$end)
#
# ## Section ----------
# plc_section <- plc_base |>
#   filter(levels %in% c("section", "section_title")) |>
#   pivot_wider(names_from = 'levels', values_from = 'value') |>
#   fill(c(section, section_title), .direction = "downup") |>
#   select(section.code = section,
#          section.name = section_title,
#          start,
#          end) |>
#   slice(1)
#
# ## Axis ----------
# plc_axis <- plc_base |>
#   filter(elem == "axis") |>
#   mutate(start_axis = rowid,
#          end_axis = lead(start_axis) - 1,
#          end_axis = case_when(
#            start_axis == max(start_axis) ~ {
#              slice_tail(plc_base) |>
#                pull(rowid)
#            },
#            .default = end_axis))
#
# plc_axis_3 <- plc_base |>
#   filter(between(rowid, plc_axis$start_axis[1], plc_axis$end_axis[1])) |>
#   pivot_wider(names_from = levels, values_from = value) |>
#   mutate(
#     section_axis_title = lead(section_axis_title, 1),
#     section_axis_terms_title = lead(section_axis_terms_title, 2),
#     section_axis_terms_definition = lead(section_axis_terms_definition, 3)) |>
#   filter(!is.na(section_axis_terms_title)) |>
#   rename(axis = section_axis,
#          name = section_axis_title,
#          term = section_axis_terms_title,
#          definition = section_axis_terms_definition) |>
#   fill(c(axis, name))
#
# plc_axis_5 <- plc_base |>
#   filter(between(rowid, plc_axis$start_axis[2], plc_axis$end_axis[2])) |>
#   pivot_wider(names_from = levels, values_from = value) |>
#   mutate(
#     section_axis_title = lead(section_axis_title, 1),
#     section_axis_terms_title = lead(section_axis_terms_title, 2),
#     section_axis_terms_definition = lead(section_axis_terms_definition, 3)) |>
#   filter(!is.na(section_axis_terms_title)) |>
#   rename(axis = section_axis,
#          name = section_axis_title,
#          term = section_axis_terms_title,
#          definition = section_axis_terms_definition) |>
#   fill(c(axis, name))
#
# plc_axes <- bind_rows(plc_axis_3, plc_axis_5) |>
#   select(axis.code = axis,
#          axis.name = name,
#          axis.term = term,
#          axis.definition = definition,
#          start,
#          end)
#
# placement <- plc_section |>
#   left_join(plc_axes)
