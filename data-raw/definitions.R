## code to prepare `definitions` dataset goes here

# library(flatxml)
library(tidyverse)
library(janitor)
library(zeallot)

# Import and Parse _____________________________________________________________
# pcs_def_xsd <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definitions.xsd"
# pcs_def_xml <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definitions_2024.xml"
# pcs_def <- fxml_importXMLFlat(pcs_def_xml)
# qs::qsave(pcs_def, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definition_2024")

pcs_def <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definition_2024")

pcs_def <- pcs_def |>
  dplyr::tibble() |>
  janitor::clean_names() |>
  dplyr::filter(!is.na(value)) |>
  dplyr::filter(elem != "version") |>
  dplyr::filter(level2 != "title",
                level2 != "deviceAggregation") |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1) |>
  dplyr::mutate(level1 = NULL)

pcs_def <- pcs_def |>
  tidyr::unite('name', c(elem, attr, level2:level5),
               na.rm = TRUE,
               remove = TRUE) |>
  dplyr::mutate(name = dplyr::case_match(
    name,
    "section_code_section" ~ "section_code",
    "title_section_title" ~ "section_label",
    "axis_pos_section_axis" ~ "axis",
    "title_section_axis_title" ~ "name",
    "title_section_axis_terms_title" ~ "label",
    "definition_section_axis_terms_definition" ~ "definition",
    "explanation_section_axis_terms_explanation" ~ "explanation",
    "includes_section_axis_terms_includes" ~ "includes"),
    elemid = NULL)

sect <- pcs_def |>
  dplyr::filter(name == "section_code" | name == "section_label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::mutate(section_label = lead(section_label)) |>
  dplyr::filter(!is.na(section_label)) |>
  dplyr::mutate(start = rowid,
                end = dplyr::lead(start) - 1,
                end = dplyr::case_when(start == max(start) ~ {
                  dplyr::slice_tail(pcs_def) |>
                    dplyr::pull(rowid)},
                  .default = end))


pcs_def <- dplyr::left_join(pcs_def, sect) |>
  tidyr::fill(section_code, section_label, start, end) |>
  dplyr::rowwise() |>
  dplyr::mutate(section_range = list(range(start, end)),
                start = NULL,
                end = NULL) |>
  dplyr::ungroup()

ax <- pcs_def |>
  dplyr::filter(name == "axis" | name == "name") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::mutate(name = lead(name)) |>
  dplyr::filter(!is.na(name)) |>
  dplyr::mutate(start = rowid,
                end = dplyr::lead(start) - 1,
                end = dplyr::case_when(start == max(start) ~ {
                  dplyr::slice_tail(pcs_def) |>
                    dplyr::pull(rowid)},
                  .default = end)) |>
  dplyr::select(rowid, axis, axis_name = name, start, end)

pcs_def <- dplyr::left_join(pcs_def, ax) |>
  dplyr::group_by(section_label) |>
  tidyr::fill(axis, axis_name, start, end, .direction = "downup") |>
  dplyr::ungroup() |>
  dplyr::rowwise() |>
  dplyr::mutate(axis_range = list(range(start, end)),
                start = NULL,
                end = NULL) |>
  dplyr::ungroup()

pcs_def <- pcs_def |>
  dplyr::filter(name %nin% c("section_code", "section_label", "axis", "name")) |>
  dplyr::select(-c(section_range, axis_range, rowid)) |>
  dplyr::rename(code = section_code,
                section = section_label)

def <- split(pcs_def, pcs_def$section)

## ==========================================
## Medical and Surgical ---------------------
medical <- def$`Medical and Surgical`
medspl <- split(medical, medical$axis_name)

med_op <- medspl$Operation |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

mops_labels <- med_op |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

med_op <- dplyr::left_join(med_op, mops_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::select(code, section, axis, axis_name, label, definition, explanation, includes)

med_op <- dplyr::left_join(na.omit(med_op[c('label', 'definition')]),
                           na.omit(med_op[c('label', 'explanation')])) |>
  dplyr::left_join(na.omit(med_op[c('label', 'includes')])) |>
  dplyr::left_join(med_op[1, 1:5]) |>
  tidyr::fill(code, section, axis, axis_name) |>
  dplyr::select(code, section, axis, axis_name, label, definition, explanation, includes)

med_dev <- medspl$Device |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

mdv_labels <- med_dev |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

med_dev <- dplyr::left_join(med_dev, mdv_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::select(code, section, axis, axis_name, label, includes)

################# FIX THIS #################
med_bod <- medspl$`Body Part` |>
  dplyr::mutate(rowid = dplyr::row_number(),
                conid = dplyr::consecutive_id(name),
                .before = 1)

mbd_labels <- med_bod |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid,
                with = conid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

mbd_includes <- med_bod |>
  dplyr::filter(name == "includes") |>
  dplyr::mutate(start = rowid,
                with = conid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

med_bod <- dplyr::left_join(med_bod, mbd_labels) |>
  tidyr::fill(start, with, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::select(code, section, axis, axis_name, label, includes)
################# FIX THIS #################

med_app <- medspl$Approach |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

medical <- vctrs::vec_rbind(med_op,
                            med_dev,
                            #med_bod,
                            med_app)

## ==========================================
## Obstetrics -------------------------------
obstetrics <- def$Obstetrics |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

obs_labels <- obstetrics |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

obstetrics <- dplyr::left_join(obstetrics, obs_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::mutate(explanation = lead(explanation)) |>
  dplyr::filter(!is.na(definition)) |>
  dplyr::select(code, section, axis, axis_name, label, definition, explanation)

## ==========================================
## Placement --------------------------------
placement <- def$Placement |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Administration -------------------------
administration <- def$Administration |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

adm_labels <- administration |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

administration <- dplyr::left_join(administration, adm_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::select(code, section, axis, axis_name, label, definition, includes)

## ==========================================
## Measurement and Monitoring ---------------
measuremonitor <- def$`Measurement and Monitoring` |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Extracorporeal or Systemic Assistance and Performance
extra_perform <- def$`Extracorporeal or Systemic Assistance and Performance` |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Extracorporeal or Systemic Therapies -----
extra_therapy <- def$`Extracorporeal or Systemic Therapies` |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Osteopathic ------------------------------
osteopathic <- def$Osteopathic |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Other Procedures -------------------------
other <- def$`Other Procedures` |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Chiropractic -----------------------------
chiropractic <- def$Chiropractic |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Imaging ----------------------------------
imaging <- def$Imaging |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Nuclear Medicine -------------------------
nuclear <- def$`Nuclear Medicine` |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

## ==========================================
## Physical Rehabilitation and Diagnostic Audiology
phys_audio <- def$`Physical Rehabilitation and Diagnostic Audiology`
physpl <- split(phys_audio, phys_audio$axis_name)

phys_type <- physpl$Type |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

phys_qual <- physpl$`Type Qualifier` |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

phys_labels <- phys_qual |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

phys_qual <- dplyr::left_join(phys_qual, phys_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::select(code, section, axis, axis_name, label, definition, includes, explanation)

phys_qual <- vctrs::vec_cbind(phys_qual[1, 1:4],
                              phys_qual |>
                                dplyr::distinct(label, definition) |>
                                dplyr::filter(!is.na(definition)) |>
                                dplyr::left_join(phys_qual |>
                                                   dplyr::distinct(label, includes) |>
                                                   dplyr::filter(!is.na(includes))) |>
                                dplyr::left_join(phys_qual |>
                                                   dplyr::distinct(label, explanation) |>
                                                   dplyr::filter(!is.na(explanation))))

phys_audio <- vctrs::vec_rbind(phys_type, phys_qual)

## ==========================================
## Mental Health ----------------------------
mental <- def$`Mental Health` |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

ment_labels <- mental |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

mental <- dplyr::left_join(mental, ment_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::select(code, section, axis, axis_name, label, definition, includes, explanation)

mental <- vctrs::vec_cbind(
  mental[1, 1:4],
  mental |>
    dplyr::distinct(label, definition) |>
    dplyr::filter(!is.na(definition)) |>
    dplyr::left_join(
      mental |>
        dplyr::distinct(label, includes) |>
        dplyr::filter(!is.na(includes))) |>
    dplyr::left_join(
      mental |>
        dplyr::distinct(label, explanation) |>
        dplyr::filter(!is.na(explanation))))

## ==========================================
## Substance Abuse Treatment ----------------
substance <- def$`Substance Abuse Treatment` |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

subs_labels <- substance |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

substance <- dplyr::left_join(substance, subs_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::mutate(explanation = lead(explanation)) |>
  dplyr::filter(!is.na(definition)) |>
  dplyr::select(code, section, axis, axis_name, label, definition, explanation)

## ==========================================
## New Technology ---------------------------
newtech <- def$`New Technology`
techspl <- split(newtech, newtech$axis_name)

tech_op <- techspl$Operation |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

op_labels <- tech_op |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

tech_op <- dplyr::left_join(tech_op, op_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::select(code, section, axis, axis_name, label, definition, explanation, includes) |>
  dplyr::mutate(explanation = lead(explanation),
                includes = lead(includes, 2)) |>
  dplyr::filter(!is.na(definition))

tech_dev <- techspl$`Device / Substance / Technology` |>
  dplyr::mutate(rowid = dplyr::row_number(), .before = 1)

dev_labels <- tech_dev |>
  dplyr::filter(name == "label") |>
  dplyr::mutate(start = rowid) |>
  tidyr::pivot_wider(names_from = name, values_from = value)

tech_dev <- dplyr::left_join(tech_dev, dev_labels) |>
  tidyr::fill(start, label) |>
  dplyr::filter(name != "label") |>
  tidyr::pivot_wider(names_from = name, values_from = value) |>
  dplyr::select(code, section, axis, axis_name, label, includes)

tech_app <- techspl$Approach |>
  tidyr::pivot_wider(names_from = name, values_from = value, values_fn = list) |>
  tidyr::unnest(cols = c(label, definition))

newtech <- vctrs::vec_rbind(tech_op, tech_dev, tech_app)

####################################################################

definitions <- vctrs::vec_rbind(medical,
                 obstetrics,
                 placement,
                 administration,
                 measuremonitor,
                 extra_perform,
                 extra_therapy,
                 osteopathic,
                 other,
                 chiropractic,
                 imaging,
                 nuclear,
                 phys_audio,
                 mental,
                 substance,
                 newtech)


board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(definitions,
                         name = "pcs_definitions",
                         description = "ICD-10-PCS 2024 Definitions",
                         type = "qs")

board |> pins::write_board_manifest()
