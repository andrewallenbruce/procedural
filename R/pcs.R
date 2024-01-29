#' Look up ICD-10-PCS Codes or Tables
#' @param x an alphanumeric character vector, can be 3 to 7 characters long.
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' pcs("0G9")
#'
#' pcs("0G90")
#'
#' pcs("0G900")
#'
#' pcs("0G9000")
#'
#' pcs("0G9000Z")
#'
#' @export
pcs <- function(x) {

  xs <- .section(x)
  xs <- .system(xs)
  xs <- .operation(xs)
  xs <- .part(xs)
  xs <- .approach(xs)
  xs <- .device(xs)
  xs <- .qualifier(xs)

  return(xs)
}

#' @noRd
checks <- function(x = NULL,
                   arg = rlang::caller_arg(x),
                   call = rlang::caller_env()) {

  # No section == return all sections.
  if (is.null(x)) {
    return(list(input = NA_character_,
                select = sections()))
    }

  if (is.numeric(x)) x <- as.character(x)

  if (grepl("[[:lower:]]*", x)) x <- toupper(x)

  if (grepl("[^[0-9A-HJ-NP-Z]]*", x)) {cli::cli_abort(c(
    "x" = "{.strong {.val {x}}} contains {.emph non-valid} characters."),
    call = call)}

  if (nchar(x) > 7L) {cli::cli_abort(c(
    "A valid {.strong PCS} code is {.emph {.strong 7} characters long}.",
    "x" = "{.strong {.val {x}}} is {.strong {.val {nchar(x)}}} characters long."),
    call = call)}

  return(list(input = x))
}

# Construct Head / Table ---------------------
.section <- function(x) { #1

  x <- checks(x)

  # Return selected section.
  x$section <- sections(substr(x$input, 1, 1))

  return(x)
}

.system <- function(x) { #2

  # Filter to section.
  system <- systems(substr(x$input, 1, 1))

  system$section <- NULL

  # No system == return Section's systems.
  if (!is_system(x$input)) {
    x$select <- system
    return(x)
  }

  # Return selected system.
  if (is_system(x$input)) {
    x$system <- dplyr::filter(system, value == substr(x$input, 2, 2))
    }
  return(x)
}

.operation <- function(x) { #3

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows")

  # Filter to system.
  operation <- set |>
    dplyr::select(system = code_2,
                  name = name_3,
                  value = code_3,
                  label = label_3) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "3", .before = 2) |>
    dplyr::filter(system == substr(x$input, 2, 2)) |>
    dplyr::select(axis, name, value, label)

  # No operation == return System's operations.
  if (nchar(x$input) == 2L) {
    x$select <- operation
    return(x)
  }

  # Return selected operation.
  if (nchar(x$input) >= 3L) {

    x$head <- vctrs::vec_rbind(
      x$section,
      x$system,
      dplyr::filter(operation,
                    value == substr(x$input, 3, 3)))

    x$section <- x$system <- NULL
  }
  return(x)
}

# Construct Tail / Row ---------------------
.part <- function(x) { #4

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows")

  # Filter to operation.
  part <- set |>
    dplyr::select(operation = code_3,
                  row,
                  rowid,
                  name = name_4,
                  value = code_4,
                  label = label_4) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "4", .before = 4) |>
    dplyr::filter(operation == substr(x$input, 3, 3)) |>
    dplyr::select(-operation)

  # No body part == return Operation's body parts.
  if (nchar(x$input) == 3L) {
    x$select <- part
    return(x)
  }

  # Return selected body part.
  if (nchar(x$input) >= 4L) {
    x$part <- dplyr::filter(part, row == substr(x$input, 1, 4))
    }
  return(x)
}

.approach <- function(x) { #5

  ROWBASE <- pins::pin_read(mount_board(), "rowbase")

  # Filter to body part.
  approach <- ROWBASE |>
    dplyr::filter(axis == "5", row == substr(x$input, 1, 4)) |>
    dplyr::distinct() |>
    dplyr::select(-part)

  # No approach == return Body Part's approaches.
  if (nchar(x$input) == 4L) {
    x$select <- approach
    return(x)
  }

  # Return selected approach.
  if (nchar(x$input) >= 5L) {
    x$approach <- dplyr::filter(approach, value == substr(x$input, 5, 5))
  }
  return(x)
}

.device <- function(x) { #6

  ROWBASE <- pins::pin_read(mount_board(), "rowbase")

  # Filter to body part.
  device <- ROWBASE |>
    dplyr::filter(axis == "6", row == substr(x$input, 1, 4)) |>
    dplyr::distinct() |>
    dplyr::select(-part)

  # No device == return Approach's devices.
  if (nchar(x$input) == 5L) {
    x$select <- device
    return(x)
  }

  # Return selected device.
  if (nchar(x$input) >= 6L) {
    x$device <- dplyr::filter(device, value == substr(x$input, 6, 6))
  }
  return(x)
}

.qualifier <- function(x) { #7

  ROWBASE <- pins::pin_read(mount_board(), "rowbase")

  #----- Updated NESTED Qualifier PIN
  qualifier <- ROWBASE |>
    dplyr::select(-part) |>
    dplyr::filter(axis == "7") |>
    dplyr::distinct() |>
    dplyr::group_by(row, rowid) |>
    tidyr::nest(.key = "qualifier") |>
    dplyr::ungroup()

  # Filter to that device's qualifiers.
  qualifier <- dplyr::filter(qualifier, row == substr(x$input, 1, 4)) |>
    tidyr::unnest(qualifier)

  # If you haven't selected a qualifier, return all of that device's qualifiers.
  if (nchar(x$input) == 6L) {
    x$select <- qualifier
    return(x)
  }

  # If you've selected a qualifier, return it.
  if (nchar(x$input) == 7L) {

    x$qualifier <- dplyr::filter(qualifier, value == x$split[7])

    id <- intersect(x$part$rowid, x$approach$rowid) |>
      intersect(x$device$rowid) |>
      intersect(x$qualifier$rowid)

    if (vctrs::vec_is_empty(id)) {
      cli::cli_warn(
        "{.strong {.val {x$input}}} is an invalid ICD-10-PCS code.",
        call = rlang::caller_env())

      x$select <- qualifier
      return(x)
    }

    tail <- vctrs::vec_rbind(x$part,
                             x$approach,
                             x$device,
                             x$qualifier) |>
      dplyr::filter(rowid %in% id) |>
      dplyr::select(-row, -rowid)

    x <- vctrs::vec_rbind(x$head, tail)
  }
  return(x)
}
