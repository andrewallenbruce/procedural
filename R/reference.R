#' ICD-10-PCS Sections
#'
#' @param x ICD-10-PCS section value, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#'
#' @template returns-default
#'
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

  sec <- get_pin("sections")

  sec <- fuimus::search_in(sec, sec$value, toupper(as.character(x)))

  return(sec)
}

#' ICD-10-PCS Body Systems
#'
#' @param x ICD-10-PCS body systems character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 114 systems.
#'
#' @template returns-default
#'
#' @examples
#' systems()
#'
#' systems("0")
#'
#' systems("2")
#'
#' systems("X")
#'
#' @noRd
systems <- function(x = NULL) {

  sys <- get_pin("systems")

  sys <- fuimus::search_in(sys, sys$section, toupper(as.character(x)))

  return(sys)
}

#' ICD-10-PCS Approaches
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
#' @noRd
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

    if (is.numeric(x)) x <- as.character(x)

    if (grepl("[[:lower:]]*", x)) x <- toupper(x)

    x <- rlang::arg_match(x, c(0, 3, 4, 7, 8, "F", "X"))

    app <- vctrs::vec_slice(app, app$value == x)
  }
  return(app)
}

#' @noRd
pcs_matrix <- function(x) {

  axis   <- c(1:7)
  value  <- c(0:9, LETTERS[c(1:8, 10:14, 16:26)])

  m <- matrix(data = 0L,
              nrow = length(axis),
              ncol = length(value),
              dimnames = list(axis, value))

  x <- lk(x)
  y <- 1L

  m[1, x[1]] <- y
  m[2, x[2]] <- y
  m[3, x[3]] <- y
  m[4, x[4]] <- y
  m[5, x[5]] <- y
  m[6, x[6]] <- y
  m[7, x[7]] <- y

  return(m)
  # x <- pcs_matrix("0G9000Z")
  # drawr::draw_matrix(x, highlight_area = x == 1, show_indices = "none")
}

#' @noRd
lk <- function(x) {

  x <- splitter(toupper(x))

  values <- 1:34

  names(values) <- c(0:9, LETTERS[c(1:8, 10:14, 16:26)])

  unname(values[x])

}

#' @noRd
.axisnames <- function(x) {

  if (is.numeric(x)) x <- as.character(x)

  if (grepl("[[:lower:]]*", x)) {x <- toupper(x)}

  x <- rlang::arg_match(x, c(0:9, LETTERS[c(2:4, 6:8, 24)]))

  if (nchar(x) > 1L) x <- splitter(x)[1]

  switch(x,
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
#' @param x ICD-10-PCS section character, an alphanumeric code of length 1.
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' axes("0")
#'
#' axes("2")
#'
#' axes("X")
#'
#' @noRd
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
