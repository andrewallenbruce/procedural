#' ICD-10-PCS Body Systems
#' @param x ICD-10-PCS body systems character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 114 systems.
#' @return a [dplyr::tibble()]
#' @examples
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
    code = c(paste0(rep(0, 10), c(0:9, LETTERS[c(2:4, 6:8, 10:14, 16:25)]))),
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
    code = "10",
    label = "Pregnancy")

  # Placement
  plc <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = c("2W", "2Y"),
    label = c("Anatomical Regions", "Anatomical Orifices"))

  # Administration
  adm <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = c("30", "3C", "3E"),
    label = c("Circulatory", "Indwelling Device", "Physiological Systems and Anatomical Regions"))

  # Measurement and Monitoring
  mam <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = c("4A", "4B"),
    label = c("Physiological Systems", "Physiological Devices"))

  # Extracorporeal or Systemic Assistance and Performance
  xpr <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = "5A",
    label = "Physiological Systems")

  # Extracorporeal or Systemic Therapies
  xth <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = "6A",
    label = "Physiological Systems")

  # Osteopathic
  ost <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = "7W",
    label = "Anatomical Regions")

  # Other Procedures
  otp <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = c("8C", "8E"),
    label = c("Indwelling Device", "Physiological Systems and Anatomical Regions"))

  # Chiropractic
  chi <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = "9W",
    label = "Anatomical Regions")

  # Imaging
  img <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = c(paste0(rep("B", 23), c(0, 2:5, 7:9,
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
    code = c(paste0(rep("C", 15), c(0, 2, 5, 7:9,
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
    code = c(paste0(rep("D", 15), c(0, 7:9,
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
    code = c("F0", "F1"),
    label = c("Rehabilitation", "Diagnostic Audiology"))

  # Mental Health
  men <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = "GZ",
    label = "None")

  # Substance Abuse Treatment
  sub <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = "HZ",
    label = "None")

  # New Technology
  new <- dplyr::tibble(
    axis = 2L,
    name = "Body System",
    code = c(paste0(rep("X", 12), c(0, 2,
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

      sys <- vctrs::vec_slice(sys, sys$code == x)

      }
  }
  return(sys)
}
