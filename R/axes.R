#' ICD-10-PCS Axes by Section
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#' @return [tibble()]
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
                         code = c("0", rep(NA, 6)),
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
                         code = c("1", rep(NA, 6)),
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
                         code = c("2", rep(NA, 6)),
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
                         code = c("3", rep(NA, 6)),
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
                         code = c("4", rep(NA, 6)),
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
                         code = c("5", rep(NA, 6)),
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
                         code = c("6", rep(NA, 6)),
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
                         code = c("7", rep(NA, 6)),
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
                         code = c("8", rep(NA, 6)),
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
                         code = c("9", rep(NA, 6)),
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
                         code = c("B", rep(NA, 6)),
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
                         code = c("C", rep(NA, 6)),
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
                         code = c("D", rep(NA, 6)),
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
                         code = c("F", rep(NA, 6)),
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
                         code = c("G", rep(NA, 6)),
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
                         code = c("H", rep(NA, 6)),
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
                         code = c("X", rep(NA, 6)),
                         label = c("New Technology",
                                   rep(NA, 6))))
  }
}
