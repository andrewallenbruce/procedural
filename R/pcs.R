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
  if (is.null(x)) return(invisible(xs))

  xs <- .system(xs)
  if (nchar(x) == 1L) return(invisible(xs))

  xs <- .operation(xs)
  if (nchar(x) == 2L) return(invisible(xs))

  xs <- .part(xs)
  if (nchar(x) == 3L) return(invisible(xs))

  xs <- .approach(xs)
  if (nchar(x) == 4L) return(invisible(xs))

  xs <- .device(xs)
  if (nchar(x) == 5L) return(invisible(xs))

  xs <- .qualifier(xs)
  if (nchar(x) == 6L) return(invisible(xs))

  xs <- .finisher(xs)

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
  if (is.na(x$input)) {
  x$select <- as.data.frame(sections())
  return(.cli(x))
  }

  # Return selected section
  if (!is.na(x$input)) {
    x$head <- sections(substr(x$input, 1, 1))
    return(x)
    }
}

.cli <- function(x) {

  cl <- glue::glue_data(.x = x$select, "[{value}] {label}")

  if (x$select$name[[1]] == "Section") {

    cli::cli_h2("No Code Selected")
    cli::cli_h2("Select A {.val {rlang::sym(x$select$name[[1]])}}")
    cli::cli_li(cl)
    cli::cli_end()
    return(invisible(NULL))

    } else {

      hd <- glue::glue_data(.x = x$head, "[{value}] {name}: {label}")
      cli::cli_h2("Selected: {.val {rlang::sym(x$input)}}")
      cli::cli_ol(hd)

      cli::cli_h2("Select {.val {rlang::sym(x$select$name[[1]])}}")
      cli::cli_li(cl)
      cli::cli_end()

      return(invisible(NULL))
    }
}

.system <- function(x) { #2

  # Filter to section
  system <- systems(substr(x$input, 1, 1))[c("axis", "name", "value", "label")]

  # Return all systems
  if (nchar(x$input) == 1L) {
    x$select <- as.data.frame(system)
    return(.cli(x))
  }

  # Return selected system
  if (nchar(x$input) > 1L) {
    x$head <- vctrs::vec_rbind(x$head,
              dplyr::filter(system, value == substr(x$input, 2, 2)))
    return(x)
  }
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
  if (nchar(x$input) == 2L) {
    x$select <- as.data.frame(operation)
    return(.cli(x))
  }

  # Return selected operation
  if (nchar(x$input) > 2L) {

    # Head = First 4 axes, Tail = Last 3 axes
    x$head <- vctrs::vec_rbind(x$head, dplyr::filter(operation, value == substr(x$input, 3, 3)))

    # Filtered pin to pass on
    x$select <- dplyr::filter(select, table == substr(x$input, 1, 3)) |> dplyr::select(name_4:rows)

    return(x)
  }
}

# Construct Tail / Row ---------------------
.part <- function(x) { #4

  # Create part object
  part <- x$select |>
    dplyr::mutate(axis = "4") |>
    dplyr::select(axis, name = name_4, value = code_4, label = label_4) |>
    dplyr::distinct()

  # Return all parts
  if (nchar(x$input) == 3L) {
    x$select <- as.data.frame(part)
    return(.cli(x))
  }

  # Return selected part
  if (nchar(x$input) > 3L) {

    x$head <- vctrs::vec_rbind(x$head, dplyr::filter(part, value == substr(x$input, 4, 4)))

    x$select <- dplyr::filter(x$select, row == substr(x$input, 1, 4)) |>
      dplyr::select(rowid:rows) |>
      tidyr::unnest(rows) |>
      dplyr::distinct() |>
      dplyr::rename(value = code)

    return(x)
    }
}

# Row IDs begin ---------------------
.approach <- function(x) { #5

  x$select <- as.data.frame(x$select) |> split(x$select$axis)

  # Return all approaches
  if (nchar(x$input) == 4L) {
    x$select <- unique(x$select$`5`[c("axis", "name", "value", "label")])
    return(.cli(x))
  }

  # Return selected approach
  if (nchar(x$input) > 4L) {
    x <- purrr::list_flatten(x)

    x$select_5 <- dplyr::filter(x$select_5, value == substr(x$input, 5, 5))
    x$id <- unique(x$select_5$rowid)
    x$head <- vctrs::vec_rbind(x$head, unique(x$select_5[c("axis", "name", "value", "label")]))

    x$select_6 <- dplyr::filter(x$select_6, rowid %in% x$id)
    x$select_7 <- dplyr::filter(x$select_7, rowid %in% x$id)

  return(x)
  }
}

.device <- function(x) { #6

  # Return all devices
  if (nchar(x$input) == 5L) {
    x$select <- unique(x$select_6[c("axis", "name", "value", "label")])
    return(.cli(x))
  }

  # Return selected device
  if (nchar(x$input) > 5L) {

    x$select_6 <- dplyr::filter(x$select_6, value == substr(x$input, 6, 6))
    x$id <- intersect(x$id, x$select_6$rowid)
    x$head <- vctrs::vec_rbind(x$head, unique(x$select_6[c("axis", "name", "value", "label")]))

    x$select_5 <- dplyr::filter(x$select_5, rowid %in% x$id)
    x$select_7 <- dplyr::filter(x$select_7, rowid %in% x$id)

  }
  return(x)
}

.qualifier <- function(x) { #7

  # Return all devices
  if (nchar(x$input) == 6L) {
    x$select <- unique(x$select_7[c("axis", "name", "value", "label")])
    return(.cli(x))
  }

  if (nchar(x$input) > 6L) {

    x$select_7 <- dplyr::filter(x$select_7, value == substr(x$input, 7, 7))
    x$id <- intersect(x$id, x$select_7$rowid)
    x$head <- vctrs::vec_rbind(x$head, unique(x$select_7[c("axis", "name", "value", "label")]))

    x$select_5 <- dplyr::filter(x$select_5, rowid %in% x$id)
    x$select_6 <- dplyr::filter(x$select_6, rowid %in% x$id)

  }
  return(x)
}

.finisher <- function(x) {
  if (length(x$id) == 1L) {
    x <- list(
      description = order(code = x$input)$description,
      code = x$head)
    }
  return(x)
}
