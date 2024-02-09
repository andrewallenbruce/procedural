library(tidyverse)
library(janitor)
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

# Import and Parse _____________________________________________________________
# pcs_def_xsd <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definitions.xsd"
# pcs_def_xml <- "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definitions_2024.xml"
# pcs_def <- fxml_importXMLFlat(pcs_def_xml)
# qs::qsave(pcs_def, "D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definition_2024")

def <- pins::pin_read(mount_board(), "source_definitions") |>
  slice(4:4800) |>
  filter(level2 != "deviceAggregation") |>
  select(-level1, -level2) |>
  mutate(rowid = row_number(), .before = 1) |>
  unite('level', level3:level5, na.rm = TRUE, remove = TRUE) |>
  mutate(level = na_if(level, ""))

# Section Code / Name
sec_idx <- def |>
  filter(elem == "section", attr == "code") |>
  pivot_wider(names_from = attr,
              values_from = value) |>
  select(rowid, section_code = code)

secname_idx <- def |>
  filter(level == "title") |>
  pivot_wider(names_from = elem,
              values_from = value) |>
  select(rowid, section_title = title)

# Axis Position / Name
pos_idx <- def |>
  filter(attr == "pos") |>
  pivot_wider(names_from = attr,
              values_from = value) |>
  select(rowid, pos)

axis_idx <- def |>
  filter(elem == "axis") |>
  pivot_wider(names_from = elem,
              values_from = value) |>
  fill(axis, .direction = "updown") |>
  select(rowid, axis)

posname_idx <- def |>
  filter(level == "axis_title") |>
  pivot_wider(names_from = level,
              values_from = value) |>
  select(rowid, axis_title)


def <- left_join(def, sec_idx) |>
  left_join(secname_idx) |>
  left_join(axis_idx) |>
  left_join(posname_idx) |>
  fill(section_code, section_title) |>
  fill(axis, axis_title) |>
  filter(elem != "section") |>
  filter(is.na(attr)) |>
  select(-attr) |>
  filter(!is.na(value))

term_idx <- def |>
  filter(level == "axis_terms_title") |>
  mutate(term = value) |>
  select(rowid, term)

def <- left_join(def, term_idx)

lr_idx <- def |>
  mutate(r = str_detect(term, ", Right"),
         l = str_detect(term, ", Left"),
         b = str_detect(term, ", Bilateral"),
         lrb = case_when(r == TRUE ~ TRUE, .default = NA),
         lrb = case_when(l == TRUE ~ TRUE, .default = lrb),
         lrb = case_when(b == TRUE ~ TRUE, .default = lrb)) |>
  select(-r, -l, -b) |>
  filter(lrb %in% TRUE) |>
  mutate(lrb = term,
         term = str_remove(term, ", Right"),
         term = str_remove(term, ", Left"),
         term = str_remove(term, ", Bilateral")) |>
  select(rowid, term, lrb)

lr_idx[7, 2]$term <- "Adrenal Gland"
lr_idx[31, 2]$term <- "Carotid Body"
lr_idx[130, 2]$term <- "Kidney"
lr_idx[262, 2]$term <- "Ureter"

lr_nest <- lr_idx |>
  select(term, lrb) |>
  nest(.by = c(term), .key = "lrb")

lr_idx <- lr_idx |>
  select(rowid, term) |>
  left_join(lr_nest)

lr_idx |> print(n = 300)

names(lr_idx) <- c("rowid", "term2", "lrb")

def <- left_join(def, lr_idx) |>
  mutate(term2 = case_when(is.na(term2) ~ term, .default = term2)) |>
  select(-elemid, -term, -level) |>
  rename(term = term2) |>
  fill(term) |>
  group_by(term) |>
  fill(lrb) |>
  ungroup() |>
  filter(elem != "title") |>
  unnest(lrb, keep_empty = TRUE) |>
  mutate(term = case_when(!is.na(lrb) ~ lrb, .default = term)) |>
  select(section = section_code,
         section_title,
         axis,
         axis_title,
         term,
         # lrb,
         type = elem,
         description = value)

includes <- def |>
  filter(type == "includes") |>
  select(section,
         #section_title,
         axis,
         name = axis_title,
         label = term,
         includes = description)

definitions <- def |>
  filter(type != "includes") |>
  select(section,
         #section_title,
         axis,
         name = axis_title,
         label = term,
         type,
         description) |>
  pivot_wider(names_from = type,
              values_from = description)

#-------------------------------------
select <- pins::pin_read(mount_board(), "tables_rows")

axis3 <- select |>
  select(
    section = code_1,
    name = name_3,
    value = code_3,
    label = label_3) |>
  distinct()


def_axis_3 <- left_join(definitions(axis = "3"), axis3) |>
  select(section, axis, value, name, label, definition, explanation)

axis4 <- select |>
  filter(code_1 == "G") |>
  select(
    section = code_1,
    name = name_4,
    value = code_4,
    label = label_4) |>
  distinct()


def_axis_4 <- left_join(definitions(axis = "4"), axis4) |>
  select(section, axis, value, name, label, definition, explanation)


sects <- definitions(axis = "5") |>
  distinct(section) |>
  pull(section)

axis5 <- select |>
  filter(code_1 %in% sects) |>
  select(section = code_1, rows) |>
  unnest(rows) |>
  filter(axis == "5") |>
  select(
    section,
    name,
    value = code,
    label) |>
  distinct()


def_axis_5 <- left_join(definitions(axis = "5"), axis5) |>
  select(section, axis, value, name, label, definition, explanation)


definitions <- vctrs::vec_rbind(def_axis_3, def_axis_4, def_axis_5) |>
  select(section, axis, name, value, label, definition, explanation)
#-------------------------------------------

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(definitions,
                         name = "definitions",
                         description = "ICD-10-PCS 2024 Definitions",
                         type = "qs")

board |> pins::pin_write(includes,
                         name = "includes",
                         description = "ICD-10-PCS 2024 Includes",
                         type = "qs")

board |> pins::write_board_manifest()

#--------------------------------------- Trying to join code values
def_list <- def |> split(def$section)

# Obstetrics
obs_op <- pcs("10")$select
obs_ap <- vctrs::vec_rbind(pcs("10S2")$select, pcs("10S0")$select[2, ])
def_list$`1` <- left_join(def_list$`1`, bind_rows(obs_op, obs_ap)) |>
  select(section:axis_name, value, label, elements)

# Placement
plc_op <- pcs("2W")$select
plc_ap <- pcs("2W00")$select
plc <- vctrs::vec_rbind(plc_op, plc_ap) |> select(axis, value, label)
def_list$`2` <- left_join(def_list$`2`, plc) |>
  select(section:axis_name, value, label, elements)

# Administration
adm_op <- vctrs::vec_rbind(pcs("30")$select, pcs("3E")$select) |>
  select(axis, value, label)

adm_ap <- pins::pin_read(mount_board(), "tables_rows") |>
  filter(code_1 == "3") |>
  select(rows) |>
  unnest(rows) |>
  distinct() |>
  filter(axis == "5") |>
  select(axis, value = code, label)

adm_sb <- pins::pin_read(mount_board(), "tables_rows") |>
  filter(code_1 == "3") |>
  select(rows) |>
  unnest(rows) |>
  distinct() |>
  filter(axis == "6") |>
  select(axis, value = code, label)

adm <- vctrs::vec_rbind(adm_op, adm_ap, adm_sb)



left_join(def_list$`3`, adm) |>
  select(section:axis_name, value, label, elements) |>
  filter(is.na(value)) |>
  unnest(elements, names_sep = ".") |>
  print(n = 300)



def_list$`3` |> print(n = 300)





# axis 3 Operations
tb_rw <- pins::pin_read(mount_board(), "tables_rows")

def_3 <- left_join(def |> filter(axis == "3"),
          tb_rw |> select(code_1, label_1, name_3, label_3, code = code_3),
          by = join_by("section" == "code_1",
                       "section_title" == "label_1",
                       "axis_title" == "name_3",
                       "term" == "label_3")) |>
  distinct()

# axis 4 Body Part
def_4 <- left_join(def |> filter(axis == "4"),
          tb_rw |> select(code_1, label_1, name_4, label_4, code = code_4),
          by = join_by("section" == "code_1",
                       "section_title" == "label_1",
                       "axis_title" == "name_4",
                       "term" == "label_4")) |>
  distinct()

# axis 5 Approach
def_5 <- left_join(def |> filter(axis == "5"),
          tb_rw |>
            select(code_1, label_1, rows) |>
            unnest(cols = c(rows)) |>
            mutate(axis = as.integer(axis)) |>
            filter(axis == "5"),
                   by = join_by("section" == "code_1",
                                "section_title" == "label_1",
                                "axis_title" == "name",
                                "term" == "label",
                                axis)) |>
  distinct()

# axis 6 Device
def |>
  filter(axis == "6") |>
  print(n = 300)

tb_rw |>
  select(code_1,
         label_1,
         label_3,
         rows) |>
  unnest(cols = c(rows)) |>
  mutate(axis = as.integer(axis)) |>
  filter(axis == "6") |>
  print(n = 300)


device_idx <- devices |>
  distinct(system) |>
  pull(system)

device_sec_sys <- tb_rw |>
  select(sec_code = code_1,
         section = label_1,
         sys_code = code_2,
         system = label_2,
         op_code = code_3,
         operation = label_3,
         rows) |>
  filter(system %in% device_idx) |>
  unnest(rows) |>
  filter(axis == "6") |>
  distinct() |>
  select(sec_code:operation, value = code, label)

dss <- device_sec_sys |>
  select(-op_code, -operation)

devices2 <- left_join(devices, dss, relationship = "many-to-many") |>
  left_join(device_sec_sys) |>
  select(section,
         sec_code,
         system,
         sys_code,
         operation,
         op_code,
         device,
         parent,
         label,
         value) |>
  mutate(label = if_else(!str_equal(parent, label), NA, label)) |>
  filter(!is.na(label)) |>
  select(-label) |>
  select(section = sec_code,
         system = sys_code,
         operation = op_code,
         device = value,
         device_name = parent,
         includes = device) |>
  distinct() |>
  mutate(operation = if_else(is.na(operation), "All applicable", operation))

devices2 |>
  print(n = 500)

def_6 <- left_join(def |>
                     filter(axis == "6"),
                   tb_rw |>
                     select(code_1, label_1, rows) |>
                     unnest(cols = c(rows)) |>
                     mutate(axis = as.integer(axis)) |>
                     filter(axis == "6"),
                   by = join_by("section" == "code_1",
                                "section_title" == "label_1",
                                "axis_title" == "name",
                                "term" == "label",
                                axis)) |>
  distinct()

def <- bind_rows(def_3, def_4, def_5, def_6) |>
  select(code = section,
         section = section_title,
         axis,
         axis_name = axis_title,
         axis_code = code,
         label = term,
         elements)

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(def,
                         name = "definitions",
                         description = "ICD-10-PCS 2024 Definitions",
                         type = "qs")

board |> pins::pin_write(devices2,
                         name = "devices",
                         description = "ICD-10-PCS 2024 Devices",
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
