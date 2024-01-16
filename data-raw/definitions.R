library(tidyverse)
library(janitor)
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

# Import and Parse _____________________________________________________________
# pcs_def_xsd <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definitions.xsd"
# pcs_def_xml <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definitions_2024.xml"
# pcs_def <- fxml_importXMLFlat(pcs_def_xml)
# qs::qsave(pcs_def, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definition_2024")

def <- pins::pin_read(mount_board(), "source_definitions") |>
  #slice(4:nrow(def)) |>
  select(-level1) |>
  mutate(rowid = row_number(), .before = 1)


devices <- def |>
  filter(level2 == "deviceAggregation")

sec_na_idx <- def |>
  filter(elem == "section", is.na(value)) |>
  pull(rowid)

ax_na_idx <- def |>
  filter(elem == "axis", is.na(value)) |>
  pull(rowid)

term_na_idx <- def |>
  filter(elem == "terms", is.na(value)) |>
  pull(rowid)

def <- def |>
  filter(rowid %nin% sec_na_idx) |>
  filter(rowid %nin% ax_na_idx) |>
  filter(rowid %nin% term_na_idx) |>
  filter(level2 != "deviceAggregation") |>
  select(-level2)

section_idx <- def |>
  filter(elem == "section") |>
  mutate(section = value) |>
  select(rowid, section)


def <- left_join(def, section_idx) |>
  fill(section) |>
  filter(elem != "section") |>
  filter(!is.na(section))

section_name_idx <- def |>
  filter(level3 == "title") |>
  mutate(section_name = value) |>
  select(rowid, section_name)

def <- left_join(def, section_name_idx) |>
  fill(section_name) |>
  filter(level3 != "title")

axis_idx <- def |>
  filter(elem == "axis") |>
  mutate(axis = value) |>
  select(rowid, axis)

def <- left_join(def, axis_idx) |>
  group_by(section) |>
  fill(axis) |>
  ungroup() |>
  filter(elem != "axis")

axis_name_idx <- def |>
  filter(level3 == "axis", level4 == "title") |>
  mutate(axis_name = value) |>
  select(rowid, axis_name)

def <- left_join(def, axis_name_idx) |>
  group_by(section) |>
  fill(axis_name) |>
  ungroup() |>
  #filter(!is.na(level5)) |>
  select(rowid,
         elem,
         elemid,
         value,
         section,
         axis,
         section_name,
         axis_name)


term_idx <- def |>
  filter(elem == "title") |>
  mutate(term = value) |>
  select(rowid, term)

def <- left_join(def, term_idx) |>
  fill(term) |>
  filter(elem != "title") |>
  select( #rowid,
         section,
         section_name,
         axis,
         axis_name,
         term,
         type = elem,
         # elemid,
         value)

def_nest <- def |>
  tidyr::nest(.by = c(section,
                      section_name,
                      axis,
                      axis_name,
                      term),
              .key = "items") |>
  print(n = 100)

def_nest |>
  count(section, section_name, axis)

def_nest |> filter(section == "0", axis == "4")

# axis 3 Operations
left_join(def_nest |> filter(axis == "3"),
          pins::pin_read(board, "tables_rows") |>
            select(code_1,
                   label_1,
                   name_3,
                   label_3,
                   code = code_3),
          by = join_by("section" == "code_1",
                       "section_name" == "label_1",
                       "axis_name" == "name_3",
                       "term" == "label_3")) |>
  distinct()

# axis 4 Body Part
left_join(def_nest |> filter(axis == "4"),
          pins::pin_read(board, "tables_rows") |>
            select(code_1,
                   label_1,
                   name_4,
                   label_4,
                   code = code_4),
          by = join_by("section" == "code_1",
                       "section_name" == "label_1",
                       "axis_name" == "name_4",
                       "term" == "label_4")) |>
  distinct()


pins::pin_read(board, "tables_rows") |>
  filter(code_1 == "1") |>
  count(label_3)


## ---------------------
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

definitions <- vctrs::vec_rbind(
                 medical,
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


## Root Operation Codes ##############
r0 <- vctrs::vec_c(
  "0" = "Alteration",
  "1" = "Bypass",
  "2" = "Change",
  "3" = "Control",
  "4" = "Creation",
  "5" = "Destruction",
  "6" = "Detachment",
  "7" = "Dilation",
  "8" = "Division",
  "9" = "Drainage",
  "B" = "Excision",
  "C" = "Extirpation",
  "D" = "Extraction",
  "F" = "Fragmentation",
  "G" = "Fusion",
  "H" = "Insertion",
  "J" = "Inspection",
  "K" = "Map",
  "L" = "Occlusion",
  "M" = "Reattachment",
  "N" = "Release",
  "P" = "Removal",
  "Q" = "Repair",
  "R" = "Replacement",
  "S" = "Reposition",
  "T" = "Resection",
  "U" = "Supplement",
  "V" = "Restriction",
  "W" = "Revision",
  "X" = "Transfer",
  "Y" = "Transplantation"
)


t0 <- dplyr::tibble(
  code = "0",
  section = "Medical and Surgical",
  axis = "3",
  axis_code = names(r0),
  label = r0
)

r1 <- vctrs::vec_c(
  "2" = "Change",
  "9" = "Drainage",
  "A" = "Abortion",
  "D" = "Extraction",
  "E" = "Delivery",
  "H" = "Insertion",
  "J" = "Inspection",
  "P" = "Removal",
  "Q" = "Repair",
  "S" = "Reposition",
  "T" = "Resection",
  "Y" = "Transplantation"
)

t1 <- dplyr::tibble(
  code = "1",
  section = "Obstetrics",
  axis = "3",
  axis_code = names(r1),
  label = r1
)

r2 <- vctrs::vec_c(
  "0" = "Change",
  "1" = "Compression",
  "2" = "Dressing",
  "3" = "Immobilization",
  "4" = "Packing",
  "5" = "Removal",
  "6" = "Traction"
)

t2 <- dplyr::tibble(
  code = "2",
  section = "Placement",
  axis = "3",
  axis_code = names(r2),
  label = r2
)

r3 <- vctrs::vec_c(
  "0" = "Introduction",
  "1" = "Irrigation",
  "2" = "Transfusion"
)

t3 <- dplyr::tibble(
  code = "3",
  section = "Administration",
  axis = "3",
  axis_code = names(r3),
  label = r3
)

r4 <- vctrs::vec_c(
  "0" = "Measurement",
  "1" = "Monitoring"
)

t4 <- dplyr::tibble(
  code = "4",
  section = "Measurement and Monitoring",
  axis = "3",
  axis_code = names(r4),
  label = r4
)

r5 <- vctrs::vec_c(
  "0" = "Assistance",
  "1" = "Performance",
  "2" = "Restoration"
)

t5 <- dplyr::tibble(
  code = "5",
  section = "Extracorporeal or Systemic Assistance and Performance",
  axis = "3",
  axis_code = names(r5),
  label = r5
)

r6 <- vctrs::vec_c(
  "0" = "Atmospheric Control",
  "1" = "Decompression",
  "2" = "Electromagnetic Therapy",
  "3" = "Hyperthermia",
  "4" = "Hypothermia",
  "5" = "Pheresis",
  "6" = "Phototherapy",
  "7" = "Ultrasound Therapy",
  "8" = "Ultraviolet Light Therapy",
  "9" = "Shockwave Therapy",
  "B" = "Perfusion"
)

t6 <- dplyr::tibble(
  code = "6",
  section = "Extracorporeal or Systemic Therapies",
  axis = "3",
  axis_code = names(r6),
  label = r6
)

t7 <- dplyr::tibble(
  code = "7",
  section = "Osteopathic",
  axis = "3",
  axis_code = "0",
  label = "Treatment"
)

t8 <- dplyr::tibble(
  code = "8",
  section = "Other Procedures",
  axis = "3",
  axis_code = "0",
  label = "Other Procedures"
)

t9 <- dplyr::tibble(
  code = "9",
  section = "Chiropractic",
  axis = "3",
  axis_code = "B",
  label = "Manipulation"
)

rB <- vctrs::vec_c(
  "0" = "Plain Radiography",
  "1" = "Fluoroscopy",
  "2" = "Computerized Tomography (CT Scan)",
  "3" = "Magnetic Resonance Imaging (MRI)",
  "4" = "Ultrasonography",
  "5" = "Other Imaging"
)

tB <- dplyr::tibble(
  code = "B",
  section = "Imaging",
  axis = "3",
  axis_code = names(rB),
  label = rB
)

rC <- vctrs::vec_c(
  "1" = "Planar Nuclear Medicine Imaging",
  "2" = "Tomographic (Tomo) Nuclear Medicine Imaging",
  "3" = "Positron Emission Tomographic (PET) Imaging",
  "4" = "Nonimaging Nuclear Medicine Uptake",
  "5" = "Nonimaging Nuclear Medicine Probe",
  "6" = "Nonimaging Nuclear Medicine Assay",
  "7" = "Systemic Nuclear Medicine Therapy",
)

tC <- dplyr::tibble(
  code = "C",
  section = "Nuclear Medicine",
  axis = "3",
  axis_code = names(rC),
  label = rC
)

rF <- vctrs::vec_c(
  "0" = "Speech Assessment",
  "1" = "Motor and/or Nerve Function Assessment",
  "2" = "Activities of Daily Living Assessment",
  "3" = "Hearing Assessment",
  "4" = "Hearing Aid Assessment",
  "5" = "Vestibular Assessment",
  "6" = "Speech Treatment",
  "7" = "Motor Treatment",
  "8" = "Activities of Daily Living Treatment",
  "9" = "Hearing Treatment",
  "B" = "Cochlear Implant Treatment",
  "C" = "Vestibular Treatment",
  "D" = "Device Fitting",
  "F" = "Caregiver Training"
)

tF <- dplyr::tibble(
  code = "F",
  section = "Physical Rehabilitation and Diagnostic Audiology",
  axis = "3",
  axis_code = names(rF),
  label = rF
)

rG <- vctrs::vec_c(
  "1" = "Psychological Tests",
  "2" = "Crisis Intervention",
  "3" = "Medication Management",
  "5" = "Individual Psychotherapy",
  "6" = "Counseling",
  "7" = "Family Psychotherapy",
  "B" = "Electroconvulsive Therapy",
  "C" = "Biofeedback",
  "F" = "Hypnosis",
  "G" = "Narcosynthesis",
  "H" = "Group Psychotherapy",
  "J" = "Light Therapy",
)

tG <- dplyr::tibble(
  code = "G",
  section = "Mental Health",
  axis = "3",
  axis_code = names(rG),
  label = rG
)

rH <- vctrs::vec_c(
  "2" = "Detoxification Services",
  "3" = "Individual Counseling",
  "4" = "Group Counseling",
  "5" = "Individual Psychotherapy",
  "6" = "Family Counseling",
  "8" = "Medication Management",
  "9" = "Pharmacotherapy"
)

tH <- dplyr::tibble(
  code = "H",
  section = "Substance Abuse Treatment",
  axis = "3",
  axis_code = names(rH),
  label = rH
)

rX <- length(vctrs::vec_c(
  "0" = "Introduction",
  "1" = "Transfusion",
  "2" = "Monitoring",
  "5" = "Destruction",
  "7" = "Dilation",
  "A" = "Assistance",
  "C" = "Extirpation",
  "E" = "Measurement",
  "G" = "Fusion",
  "H" = "Insertion",
  "J" = "Inspection",
  "K" = "Bypass",
  "P" = "Irrigation",
  "R" = "Replacement",
  "S" = "Reposition",
  "U" = "Supplement",
  "V" = "Restriction"
))

tX <- dplyr::tibble(
  code = "H",
  section = "New Technology",
  axis = "3",
  axis_code = names(rH),
  label = rH
)

root_ops <- vctrs::vec_rbind(t0, t1, t2, t3, t4, t5,
                             t6, t7, t8, t9, tB, tC,
                             tF, tG, tH, tX)

definitions <- dplyr::left_join(definitions(), root_ops) |>
  dplyr::select(code,
                section,
                axis,
                axis_name,
                axis_code,
                dplyr::everything())

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(definitions,
                         name = "pcs_definitions_v2",
                         description = "ICD-10-PCS 2024 Definitions",
                         type = "qs")

board |> pins::write_board_manifest()

## Approach Codes ##############
# Sections 0-4, 7-9, X
approach <- vctrs::vec_c(
  "Open" = "0",
  "Percutaneous" = "3",
  "Percutaneous Endoscopic" = "4",
  "Via Natural or Artificial Opening" = "7",
  "Via Natural or Artificial Opening Endoscopic" = "8",
  "Via Natural or Artificial Opening With Percutaneous Endoscopic Assistance" = "F",
  "External" = "X"
)

sections <- c("0", "1", "2", "3", "4", "7", "8", "9", "X")

definitions <- definitions() |>
  mutate(axis_code = case_when(
    axis == "5" & code %in% sections ~ approach[label], .default = axis_code))

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(definitions,
                         name = "pcs_definitions_v3",
                         description = "ICD-10-PCS 2024 Definitions",
                         type = "qs")

board |> pins::write_board_manifest()
