#' ICD-10-PCS Approaches
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#'
#' @template returns-default
#'
#' @examples
#'
#' approaches()
#'
#' approaches("0")
#'
#' approaches("X")
#'
#' @autoglobal
#'
#' @export
approaches <- function(x = NULL) {

  app <- data.frame(
    axis = 5L,
    name = "Approach",
    value = c(0, 3, 4, 7, 8, "F", "X"),
    label = c('Open',
              'Percutaneous',
              'Percutaneous Endoscopic',
              'Via Natural or Artificial Opening',
              'Via Natural or Artificial Opening Endoscopic',
              'Via Natural or Artificial Opening With Percutaneous Endoscopic Assistance',
              'External'))

  if (!is.null(x)) {

    x <- stringfish::sf_touppertoupper(as.character(x))

    x <- rlang::arg_match0(x, c(0, 3, 4, 7, 8, "F", "X"))

    app <- fuimus::search_in_if(app, app$value, x)

  }
  return(app)
}

#' @noRd
.axisnames <- function(x) {

  if (is.numeric(x)) x <- as.character(x)

  if (stringfish::sf_grepl("[[:lower:]]*", x)) x <- stringfish::sf_toupper(x)

  x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))

  if (nchar(x) > 1L) x <- fuimus::splitter(x)[1]

  switch(
    x,
    "0" = c("Section", "Body System", "Operation", "Body Part", "Approach", "Device", "Qualifier"),
    "1" = c("Section", "Body System", "Operation", "Body Part", "Approach", "Device", "Qualifier"),
    "2" = c("Section", "Body System", "Operation", "Body Part", "Approach", "Device", "Qualifier"),
    "3" = c("Section", "Body System", "Operation", "Body System / Region", "Approach", "Substance", "Qualifier"),
    "4" = c("Section", "Body System", "Operation", "Body System / Region", "Approach", "Function / Device", "Qualifier"),
    "5" = c("Section", "Body System", "Operation", "Body System", "Duration", "Function", "Qualifier"),
    "6" = c("Section", "Body System", "Operation", "Body System", "Duration", "Qualifier", "Qualifier"),
    "7" = c("Section", "Body System", "Operation", "Body Region", "Approach", "Method", "Qualifier"),
    "8" = c("Section", "Body System", "Operation", "Body Region", "Approach", "Method", "Qualifier"),
    "9" = c("Section", "Body System", "Operation", "Body Region", "Approach", "Method", "Qualifier"),
    "B" = c("Section", "Body System", "Root Type", "Body Part", "Contrast", "Qualifier", "Qualifier"),
    "C" = c("Section", "Body System", "Root Type", "Body Part", "Radionuclide", "Qualifier", "Qualifier"),
    "D" = c("Section", "Body System", "Modality", "Treatment Site", "Modality Qualifier", "Isotope", "Qualifier"),
    "F" = c("Section", "Section Qualifier", "Root Type", "Body System / Region", "Type Qualifier", "Equipment", "Qualifier"),
    "G" = c("Section", "Body System", "Root Type", "Qualifier", "Qualifier", "Qualifier", "Qualifier"),
    "H" = c("Section", "Body System", "Root Type", "Qualifier", "Qualifier", "Qualifier", "Qualifier"),
    "X" = c("Section", "Body System", "Operation", "Body Part", "Approach", "Device / Substance / Technology", "Qualifier"))
}


#' ICD-10-PCS Axes by Section
#'
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#'
#' @template returns-default
#'
#' @examplesIf interactive()
#' axes("0")
#'
#' axes("X")
#'
#' @autoglobal
#'
#' @noRd
axes <- function(x) {

  x <- toupper(as.character(x))

  x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))

  if (nchar(x) > 1L) {
    x <- fuimus::splitter(x)[1]
  }

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
