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
pcs <- function(x = NULL) {

  xs <- .section(x)
  if (is.null(x)) return(xs)

  xs <- .system(xs)
  if (nchar(x) == 1L) return(xs)

  xs <- .operation(xs)
  if (nchar(x) == 2L) return(xs)

  xs <- .part(xs)
  if (nchar(x) == 3L) return(xs)

  xs <- .approach(xs)
  if (nchar(x) == 4L) return(xs)

  xs <- .device(xs)
  if (nchar(x) == 5L) return(xs)

  xs <- .qualifier(xs)

  return(xs)
}

#' @noRd
checks <- function(x = NULL,
                   arg = rlang::caller_arg(x),
                   call = rlang::caller_env()) {

  # No section == return NA.
  if (is.null(x)) return(list(input = NA_character_))

  if (is.numeric(x)) x <- as.character(x)

  if (grepl("[[:lower:]]*", x)) x <- toupper(x)

  # if (grepl("[^[0-9A-HJ-NP-Z]]*", x)) {cli::cli_abort(c(
  #   "x" = "{.strong {.val {x}}} contains {.emph invalid} PCS values."),
  #   call = call)}

  if (nchar(x) > 7L) {cli::cli_abort(c(
    "A valid {.strong PCS} code is {.emph {.strong 7} characters long}.",
    "x" = "{.strong {.val {x}}} is {.strong {.val {nchar(x)}}} characters long."),
    call = call)}

  return(list(input = x))
}

.section <- function(x) { #1

  x <- checks(x)

  # Return all sections
  if (is.na(x$input)) x$select <- as.data.frame(sections())

  # Return selected section
  if (!is.na(x$input)) x$head <- sections(substr(x$input, 1, 1))

  return(x)
}

.system <- function(x) { #2

  # Filter to section
  system <- systems(substr(x$input, 1, 1))[c("axis", "name", "value", "label")]

  # Return all systems
  if (nchar(x$input) == 1L) x$select <- as.data.frame(system)

  # Return selected system
  if (nchar(x$input) > 1L) x$head <- vctrs::vec_rbind(x$head, dplyr::filter(system, value == substr(x$input, 2, 2)))

  return(x)
}

.operation <- function(x) { #3

  # Filter to system
  select <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::filter(system == substr(x$input, 1, 2)) |>
    dplyr::select(code_2, name_3:rows)

  # Create operation object
  operation <- select |>
    dplyr::mutate(axis = "3") |>
    dplyr::select(axis, name = name_3, value = code_3, label = label_3) |>
    dplyr::distinct()

  # Return all operations
  if (nchar(x$input) == 2L) x$select <- as.data.frame(operation)

  # Return selected operation
  if (nchar(x$input) > 2L) {

    # Head = First 4 axes, Tail = Last 3 axes
    x$head <- vctrs::vec_rbind(x$head, dplyr::filter(operation, value == substr(x$input, 3, 3)))

    # Filtered pin to pass on
    x$select <- dplyr::filter(select, table == substr(x$input, 1, 3)) |> dplyr::select(name_4:rows)
  }
  return(x)
}

# Construct Tail / Row ---------------------
.part <- function(x) { #4

  # Create part object
  part <- x$select |>
    dplyr::mutate(axis = "4") |>
    dplyr::select(axis, name = name_4, value = code_4, label = label_4) |>
    dplyr::distinct()

  # Return all parts
  if (nchar(x$input) == 3L) x$select <- as.data.frame(part)

  # Return selected part
  if (nchar(x$input) > 3L) {

    x$head <- vctrs::vec_rbind(x$head, dplyr::filter(part, value == substr(x$input, 4, 4)))

    x$select <- dplyr::filter(x$select, row == substr(x$input, 1, 4)) |>
      dplyr::select(rowid:rows) |>
      tidyr::unnest(rows) |>
      dplyr::distinct() |>
      dplyr::rename(value = code)
    }
  return(x)
}

.approach <- function(x) { #5

  axis <- as.data.frame(x$select) |> split(x$select$axis)
  x$select <- NULL

  # Return all approaches
  if (nchar(x$input) == 4L) x$select <- axis$`5`

  # Return selected approach
  if (nchar(x$input) > 4L) {

    axis$`5` <- dplyr::filter(axis$`5`, value == substr(x$input, 5, 5))
    x$id <- unique(axis$`5`$rowid)

    x$tail <- axis$`5`
    x$select <- list(`6` = axis$`6`, `7` = axis$`7`)
    x <- purrr::list_flatten(x)
  }
  return(x)
}

.device <- function(x) { #6

  # Return selected device
  if (nchar(x$input) > 5L) {

    x$select_6 <- dplyr::filter(x$select_6, value == substr(x$input, 6, 6))
    x$id <- intersect(x$id, x$select_6$rowid)
    x$tail <- vctrs::vec_rbind(x$tail, x$select_6)
    x$select_6 <- NULL
  }
  return(x)
}

.qualifier <- function(x) { #7

  if (nchar(x$input) > 6L) {

    x$select_7 <- dplyr::filter(x$select_7, value == substr(x$input, 7, 7))
    x$id <- intersect(x$id, x$select_7$rowid)

    x$tail <- vctrs::vec_rbind(x$tail, x$select_7)
    x$select_7 <- NULL
  }
  return(x)
}
