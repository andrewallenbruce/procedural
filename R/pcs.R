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
  if (nchar(x) == 1L) return(xs)

  xs <- .system(xs)
  if (nchar(x) == 2L) return(xs)

  xs <- .operation(xs)
  if (nchar(x) == 3L) return(xs)

  xs <- .part(xs)
  if (nchar(x) == 4L) return(xs)

  xs <- .approach(xs)
  if (nchar(x) == 5L) return(xs)

  xs <- .device(xs)
  if (nchar(x) == 6L) return(xs)

  xs <- .qualifier(xs)
  if (nchar(x) == 7L) {

    xs$input <- NULL

    xs$split <- NULL

    id <- intersect(xs$part$rowid,
                    xs$approach$rowid) |>
      intersect(xs$device$rowid) |>
      intersect(xs$qualifier$rowid)

    head <- vctrs::vec_rbind(xs$section,
                     xs$system,
                     xs$operation)

    tail <- vctrs::vec_rbind(xs$part,
                             xs$approach,
                             xs$device,
                             xs$qualifier) |>
      dplyr::filter(rowid %in% id) |>
      dplyr::select(-row, -rowid)

    xs <- vctrs::vec_rbind(head, tail)

  }
  return(xs)
}

#' @noRd
checks <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {

  if (!nzchar(x)) {cli::cli_abort(
    "x" = "{.strong x} cannot be an {.emph empty} string.",
    call = call)}

  if (is.numeric(x)) x <- as.character(x)

  if (grepl("[[:lower:]]*", x)) x <- toupper(x)

  if (grepl("[^[0-9A-HJ-NP-Z]]*", x)) {cli::cli_abort(c(
    "x" = "{.strong {.val {x}}} contains {.emph non-valid} characters."),
    call = call)}

  if (nchar(x) > 7L) {cli::cli_abort(c(
    "A valid {.strong PCS} code is {.emph {.strong 7} characters long}.",
    "x" = "{.strong {.val {x}}} is {.strong {.val {nchar(x)}}} characters long."),
    call = call)}

  return(list(input = x, split = splitter(x)))
}

.section <- function(x = NULL) {

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::mutate(system = paste0(code_1, code_2),
                  .before = name_3)

  #----- Updated NESTED Section PIN
  section <- set |>
    dplyr::select(name = name_1,
                  value = code_1,
                  label = label_1) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "1", .before = 1)

  # If you haven't named a section, return all sections.
  if (is.null(x)) return(section)

  # If you've named a section, return it and the system choices.
  x <- checks(x)

  x$section <- dplyr::filter(section, value == x$split[1])

  return(x)
}

.system <- function(x) {

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::mutate(system = paste0(code_1, code_2),
                  .before = name_3)

  #----- Updated NESTED System PIN
  system <- set |>
    dplyr::select(section = code_1,
                  system,
                  name = name_2,
                  value = code_2,
                  label = label_2) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "2", .before = 3) |>
    dplyr::group_by(section) |>
    tidyr::nest(.key = "system") |>
    dplyr::ungroup()

  # Filter to that section's systems.
  system <- dplyr::filter(system, section == x$split[1]) |>
    tidyr::unnest(system) |>
    dplyr::select(-section, -system)

  # If you haven't named a system, return all of that section's systems.
  if (nchar(x$input) == 2L) {
    x$system <- system
    return(x)
  }

  # If you've name a System, filter to it.
  x$system <- dplyr::filter(system, value == x$split[2])

  return(x)
}

.operation <- function(x) {

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::mutate(system = paste0(code_1, code_2),
                  .before = name_3)

  #----- Updated NESTED Operation PIN
  operation <- set |>
    dplyr::select(system = code_2,
                  # table,
                  name = name_3,
                  value = code_3,
                  label = label_3) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "3", .before = 3) |>
    dplyr::group_by(system) |>
    tidyr::nest(.key = "operation") |>
    dplyr::ungroup()

  # Filter to that system's operations.
  operation <- dplyr::filter(operation, system == x$split[2]) |>
    tidyr::unnest(operation) |>
    dplyr::select(-system)

  # If you haven't named an operation, return all of that system's operations.
  if (nchar(x$input) == 3L) {
    x$operation <- operation
    return(x)
  }

  # If you've name an Operation, filter to it.
  x$operation <- dplyr::filter(operation, value == x$split[3])

  return(x)
}

.part <- function(x) {

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::mutate(system = paste0(code_1, code_2),
                  .before = name_3)

  #----- Updated NESTED Body Part PIN
  part <- set |>
    dplyr::select(operation = code_3,
                  row,
                  rowid,
                  name = name_4,
                  value = code_4,
                  label = label_4) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "4", .before = 4) |>
    dplyr::group_by(operation) |>
    tidyr::nest(.key = "part") |>
    dplyr::ungroup()

  # Filter to that operation's body parts.
  part <- dplyr::filter(part, operation == x$split[3]) |>
    tidyr::unnest(part) |>
    dplyr::select(-operation)

  # If you haven't named a body part, return all of that operation's body parts.
  if (nchar(x$input) == 3L) {
    x$part <- part
    return(x)
  }

  # If you've name a Body Part, filter to it.
  x$part <- dplyr::filter(part, row == substr(x$input, 1, 4))

  return(x)
}

.approach <- function(x) {

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::mutate(system = paste0(code_1, code_2),
                  .before = name_3)

  #------ Updated ROW pin
  ROWBASE <- set |>
    dplyr::select(part = code_4,
                  row,
                  rowid,
                  rows) |>
    tidyr::unnest(rows) |>
    dplyr::rename(value = code)

  #----- Updated NESTED Approach PIN
  approach <- ROWBASE |>
    dplyr::filter(axis == "5") |>
    dplyr::distinct() |>
    dplyr::group_by(part, row, rowid) |>
    tidyr::nest(.key = "approach") |>
    dplyr::ungroup()

  # Filter to that body part's approaches.
  approach <- dplyr::filter(approach, row == substr(x$input, 1, 4)) |>
    tidyr::unnest(approach) |>
    dplyr::select(-part)

  # If you haven't named an approach, return all of that body part's approaches.
  if (nchar(x$input) == 4L) {
    x$approach <- approach
    return(x)
  }

  # If you've name an Approach, filter to it.
  x$approach <- dplyr::filter(approach, value == x$split[5])

  return(x)
}

.device <- function(x) {

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::mutate(system = paste0(code_1, code_2),
                  .before = name_3)

  #------ Updated ROW pin
  ROWBASE <- set |>
    dplyr::select(part = code_4,
                  row,
                  rowid,
                  rows) |>
    tidyr::unnest(rows) |>
    dplyr::rename(value = code)

  #----- Updated NESTED Device PIN
  device <- ROWBASE |>
    dplyr::select(-part) |>
    dplyr::filter(axis == "6") |>
    dplyr::distinct() |>
    dplyr::group_by(row, rowid) |>
    tidyr::nest(.key = "device") |>
    dplyr::ungroup()

  # Filter to that approach's devices.
  device <- dplyr::filter(device, row == substr(x$input, 1, 4)) |>
    tidyr::unnest(device)

  # If you haven't named a device, return all of that approach's devices.
  if (nchar(x$input) == 5L) {
    x$device <- device
    return(x)
  }

  # If you've name a Device, filter to it.
  x$device <- dplyr::filter(device, value == x$split[6])

  return(x)
}

.qualifier <- function(x) {

  #------ Updated BASE pin
  set <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::mutate(system = paste0(code_1, code_2),
                  .before = name_3)

  #------ Updated ROW pin
  ROWBASE <- set |>
    dplyr::select(part = code_4,
                  row,
                  rowid,
                  rows) |>
    tidyr::unnest(rows) |>
    dplyr::rename(value = code)

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

  # If you haven't named a qualifier, return all of that device's qualifiers.
  if (nchar(x$input) == 6L) {
    x$qualifier <- qualifier
    return(x)
  }

  # If you've name a Qualifier, filter to it.
  x$qualifier <- dplyr::filter(qualifier, value == x$split[7])

  return(x)
}

#' @noRd
pcs_matrix <- function() {

  axis   <- c(1:7)
  value  <- c(0:9, LETTERS[c(1:8, 10:14, 16:26)])

  matrix(data = NA,
         nrow = length(axis),
         ncol = length(value),
         dimnames = list(axis, value))
}
