#' ICD-10-PCS Sections
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#' @return a [dplyr::tibble()]
#' @examples
#' sections()
#'
#' sections("0")
#'
#' sections("2")
#'
#' sections("X")
#'
#' @export
sections <- function(x = NULL) {

  sec <- dplyr::tibble(
    axis = 1L,
    name = "Section",
    value = c(0:9, LETTERS[2:4], LETTERS[6:8], LETTERS[24]),
    label = c("Medical and Surgical",
              "Obstetrics",
              "Placement",
              "Administration",
              "Measurement and Monitoring",
              "Extracorporeal or Systemic Assistance and Performance",
              "Extracorporeal or Systemic Therapies",
              "Osteopathic",
              "Other Procedures",
              "Chiropractic",
              "Imaging",
              "Nuclear Medicine",
              "Radiation Therapy",
              "Physical Rehabilitation and Diagnostic Audiology",
              "Mental Health",
              "Substance Abuse Treatment",
              "New Technology"))

  if (!is.null(x)) {
    if (is.numeric(x)) x <- as.character(x)
    if (grepl("[[:lower:]]*", x)) {x <- toupper(x)}
    x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))
    if (nchar(x) > 1L) x <- splitter(x)[1]
    sec <- vctrs::vec_slice(sec, sec$value == x)
  }
  return(sec)
}

#' ICD-10-PCS Body Systems
#' @param x ICD-10-PCS body systems character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 114 systems.
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' systems()
#'
#' systems("0")
#'
#' systems("2")
#'
#' systems("X")
#'
#' @export
systems <- function(x = NULL) {

  # Medical and Surgical
  msg <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c(paste0(rep(0, 10), c(0:9, LETTERS[c(2:4, 6:8, 10:14, 16:25)]))),
    label = c("Central Nervous System and Cranial Nerves",
              "Peripheral Nervous System",
              "Heart and Great Vessels",
              "Upper Arteries",
              "Lower Arteries",
              "Upper Veins",
              "Lower Veins",
              "Lymphatic and Hemic Systems",
              "Eye",
              "Ear, Nose, Sinus",
              "Respiratory System",
              "Mouth and Throat",
              "Gastrointestinal System",
              "Hepatobiliary System and Pancreas",
              "Endocrine System",
              "Skin and Breast",
              "Subcutaneous Tissue and Fascia",
              "Muscles",
              "Tendons",
              "Bursae and Ligaments",
              "Head and Facial Bones",
              "Upper Bones",
              "Lower Bones",
              "Upper Joints",
              "Lower Joints",
              "Urinary System",
              "Female Reproductive System",
              "Male Reproductive System",
              "Anatomical Regions, General",
              "Anatomical Regions, Upper Extremities",
              "Anatomical Regions, Lower Extremities"))

  # Obstetrics
  obs <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = "10",
    label = "Pregnancy")

  # Placement
  plc <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c("2W", "2Y"),
    label = c("Anatomical Regions", "Anatomical Orifices"))

  # Administration
  adm <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c("30", "3C", "3E"),
    label = c("Circulatory", "Indwelling Device", "Physiological Systems and Anatomical Regions"))

  # Measurement and Monitoring
  mam <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c("4A", "4B"),
    label = c("Physiological Systems", "Physiological Devices"))

  # Extracorporeal or Systemic Assistance and Performance
  xpr <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = "5A",
    label = "Physiological Systems")

  # Extracorporeal or Systemic Therapies
  xth <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = "6A",
    label = "Physiological Systems")

  # Osteopathic
  ost <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = "7W",
    label = "Anatomical Regions")

  # Other Procedures
  otp <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c("8C", "8E"),
    label = c("Indwelling Device", "Physiological Systems and Anatomical Regions"))

  # Chiropractic
  chi <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = "9W",
    label = "Anatomical Regions")

  # Imaging
  img <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c(paste0(rep("B", 23), c(0, 2:5, 7:9,
                                    LETTERS[c(2, 4, 6:8, 12, 14, 16:18, 20:23, 25)]))),
    label = c("Central Nervous System",
              "Heart",
              "Upper Arteries",
              "Lower Arteries",
              "Veins",
              "Lymphatic System",
              "Eye",
              "Ear, Nose, Mouth and Throat",
              "Respiratory System",
              "Gastrointestinal System",
              "Hepatobiliary System and Pancreas",
              "Endocrine System",
              "Skin, Subcutaneous Tissue and Breast",
              "Connective Tissue",
              "Skull and Facial Bones",
              "Non-Axial Upper Bones",
              "Non-Axial Lower Bones",
              "Axial Skeleton, Except Skull and Facial Bones",
              "Urinary System",
              "Female Reproductive System",
              "Male Reproductive System",
              "Anatomical Regions",
              "Fetus and Obstetrical"))

  # Nuclear Medicine
  nuc <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c(paste0(rep("C", 15), c(0, 2, 5, 7:9,
                                    LETTERS[c(2, 4, 6:8, 16, 20, 22:23)]))),
    label = c("Central Nervous System",
              "Heart",
              "Veins",
              "Lymphatic and Hematologic System",
              "Eye",
              "Ear, Nose, Mouth and Throat",
              "Respiratory System",
              "Gastrointestinal System",
              "Hepatobiliary System and Pancreas",
              "Endocrine System",
              "Skin, Subcutaneous Tissue and Breast",
              "Musculoskeletal System",
              "Urinary System",
              "Male Reproductive System",
              "Anatomical Regions"))

  # Radiation Therapy
  rad <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c(paste0(rep("D", 15), c(0, 7:9,
                                    LETTERS[c(2, 4, 6:8, 13, 16, 20:23)]))),
    label = c("Central and Peripheral Nervous System",
              "Lymphatic and Hematologic System",
              "Eye",
              "Ear, Nose, Mouth and Throat",
              "Respiratory System",
              "Gastrointestinal System",
              "Hepatobiliary System and Pancreas",
              "Endocrine System",
              "Skin",
              "Breast",
              "Musculoskeletal System",
              "Urinary System",
              "Female Reproductive System",
              "Male Reproductive System",
              "Anatomical Regions"))

  # Physical Rehabilitation and Diagnostic Audiology
  phy <- dplyr::tibble(
    axis = 2L,
    name = "Section Qualifier",
    value = c("F0", "F1"),
    label = c("Rehabilitation", "Diagnostic Audiology"))

  # Mental Health
  men <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = "GZ",
    label = "None")

  # Substance Abuse Treatment
  sub <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = "HZ",
    label = "None")

  # New Technology
  new <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    value = c(paste0(rep("X", 12), c(0, 2,
                                    # D, F, H, K, N, R, T, W, X, Y
                                    LETTERS[c(4, 6, 8, 11, 14, 18, 20, 23:25)]))),
    label = c("Nervous System",
              "Cardiovascular System",
              "Gastrointestinal System",
              "Hepatobiliary System and Pancreas",
              "Skin, Subcutaneous Tissue, Fascia and Breast",
              "Muscles, Tendons, Bursae and Ligaments",
              "Bones",
              "Joints",
              "Urinary System",
              "Anatomical Regions",
              "Physiological Systems",
              "Extracorporeal"))

  sys <- vctrs::vec_rbind(msg, obs, plc, adm, mam, xpr,
                          xth, ost, otp, chi, img, nuc,
                          rad, phy, men, sub, new)

  if (!is.null(x)) {

    if (is.numeric(x)) x <- as.character(x)

    if (grepl("[[:lower:]]*", x)) {x <- toupper(x)}

    if (nchar(x) == 1L) {

      x <- splitter(x)[1]

      x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))

      sys <- sys |>
        dplyr::rowwise() |>
        dplyr::mutate(sec = splitter(code)[1]) |>
        dplyr::ungroup()

      sys <- vctrs::vec_slice(sys, sys$sec == x)

    }

    if (nchar(x) > 1L) {

      x <- collapser(splitter(x)[1:2])

      sys <- vctrs::vec_slice(sys, sys$value == x)

    }
  }
  return(sys)
}

#' ICD-10-PCS Axes by Section
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' axes("0")
#'
#' axes("2")
#'
#' axes("X")
#'
#' @export
axes <- function(x) {

  if (is.numeric(x)) x <- as.character(x)

  if (grepl("[[:lower:]]*", x)) {x <- toupper(x)}

  x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))

  if (nchar(x) > 1L) x <- splitter(x)[1]

  if (x == "0") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body Part",
                                  "Approach",
                                  "Device",
                                  "Qualifier"),
                         value = c("0", rep(NA, 6)),
                         label = c("Medical and Surgical",
                                   rep(NA, 6))))
  }

  if (x == "1") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body Part",
                                  "Approach",
                                  "Device",
                                  "Qualifier"),
                         value = c("1", rep(NA, 6)),
                         label = c("Obstetrics",
                                   rep(NA, 6))))
  }

  if (x == "2") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body Region",
                                  "Approach",
                                  "Device",
                                  "Qualifier"),
                         value = c("2", rep(NA, 6)),
                         label = c("Placement",
                                   rep(NA, 6))))
  }

  if (x == "3") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body System / Region",
                                  "Approach",
                                  "Substance",
                                  "Qualifier"),
                         value = c("3", rep(NA, 6)),
                         label = c("Administration",
                                   rep(NA, 6))))
  }

  if (x == "4") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body System / Region",
                                  "Approach",
                                  "Function / Device",
                                  "Qualifier"),
                         value = c("4", rep(NA, 6)),
                         label = c("Measurement and Monitoring",
                                   rep(NA, 6))))
  }

  if (x == "5") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body System",
                                  "Duration",
                                  "Function",
                                  "Qualifier"),
                         value = c("5", rep(NA, 6)),
                         label = c("Extracorporeal or Systemic Assistance and Performance",
                                   rep(NA, 6))))
  }

  if (x == "6") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body System",
                                  "Duration",
                                  "Qualifier",
                                  "Qualifier"),
                         value = c("6", rep(NA, 6)),
                         label = c("Extracorporeal or Systemic Therapies",
                                   rep(NA, 6))))
  }

  if (x == "7") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body Region",
                                  "Approach",
                                  "Method",
                                  "Qualifier"),
                         value = c("7", rep(NA, 6)),
                         label = c("Osteopathic",
                                   rep(NA, 6))))
  }

  if (x == "8") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body Region",
                                  "Approach",
                                  "Method",
                                  "Qualifier"),
                         value = c("8", rep(NA, 6)),
                         label = c("Other Procedures",
                                   rep(NA, 6))))
  }

  if (x == "9") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body Region",
                                  "Approach",
                                  "Method",
                                  "Qualifier"),
                         value = c("9", rep(NA, 6)),
                         label = c("Chiropractic",
                                   rep(NA, 6))))
  }

  if (x == "B") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Type",
                                  "Body Part",
                                  "Contrast",
                                  "Qualifier",
                                  "Qualifier"),
                         value = c("B", rep(NA, 6)),
                         label = c("Imaging",
                                   rep(NA, 6)))
    )
  }

  if (x == "C") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Type",
                                  "Body Part",
                                  "Radionuclide",
                                  "Qualifier",
                                  "Qualifier"),
                         value = c("C", rep(NA, 6)),
                         label = c("Nuclear Medicine",
                                   rep(NA, 6))))
  }

  if (x == "D") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Modality",
                                  "Treatment Site",
                                  "Modality Qualifier",
                                  "Isotope",
                                  "Qualifier"),
                         value = c("D", rep(NA, 6)),
                         label = c("Radiation Therapy",
                                   rep(NA, 6))))
  }

  if (x == "F") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Section Qualifier",
                                  "Root Type",
                                  "Body System / Region",
                                  "Type Qualifier",
                                  "Equipment",
                                  "Qualifier"),
                         value = c("F", rep(NA, 6)),
                         label = c("Physical Rehabilitation and Diagnostic Audiology",
                                   rep(NA, 6))))
  }

  if (x == "G") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Type",
                                  "Qualifier",
                                  "Qualifier",
                                  "Qualifier",
                                  "Qualifier"),
                         value = c("G", rep(NA, 6)),
                         label = c("Mental Health",
                                   rep(NA, 6))))
  }

  if (x == "H") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Type",
                                  "Qualifier",
                                  "Qualifier",
                                  "Qualifier",
                                  "Qualifier"),
                         value = c("H", rep(NA, 6)),
                         label = c("Substance Abuse Treatment",
                                   rep(NA, 6))))
  }

  if (x == "X") {
    return(dplyr::tibble(axis = c(1:7),
                         name = c("Section",
                                  "Body System",
                                  "Root Operation",
                                  "Body Part",
                                  "Approach",
                                  "Device / Substance / Technology",
                                  "Qualifier"),
                         value = c("X", rep(NA, 6)),
                         label = c("New Technology",
                                   rep(NA, 6))))
  }
}

#' ICD-10-PCS Sections
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#'
#' approaches()
#'
#' approaches("0")
#'
#' approaches("2")
#'
#' approaches("X")
#'
#' @export
approaches <- function(x = NULL) {

  app <- dplyr::tibble(
    axis = 5L,
    name = "Approach",
    value = c(0:9, LETTERS[2:4], LETTERS[6:8], LETTERS[24]),
    label = c('Open',
              'Open Approach',
              'External Approach',
              'Percutaneous',
              'Percutaneous Endoscopic Approach',
              'Percutaneous Approach',
              'Via Natural or Artificial Opening',
              'Via Natural or Artificial Opening Endoscopic',
              'Via Natural or Artificial Opening Endoscopic Approach',
              'Via Natural or Artificial Opening with Percutaneous Endoscopic Assistance'))

  if (!is.null(x)) {

    if (is.numeric(x)) x <- as.character(x)

    if (grepl("[[:lower:]]*", x)) {x <- toupper(x)}

    x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))

    if (nchar(x) > 1L) x <- splitter(x)[1]

    sec <- vctrs::vec_slice(sec, sec$value == x)
  }
  return(app)
}
