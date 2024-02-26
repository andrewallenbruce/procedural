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

.cli <- function(x) {

  cl <- glue::glue_data(.x = x$possible, "{value} >=> {label}")

  if (x$possible$name[[1]] == "Section") {

    cli::cli_h2("No Code Selected")
    cli::cli_h2("Select {.val {rlang::sym(x$possible$name[[1]])}}")
    cli::cli_li(cl)
    cli::cli_end()
    return(invisible(NULL))

  } else {

    hd <- glue::glue_data(.x = x$head, "[{value}] {name}: {label}")
    cli::cli_h2("Selected: {.val {rlang::sym(x$input)}}")
    cli::cli_ol(hd)

    cli::cli_h2("Select {.val {rlang::sym(x$possible$name[[1]])}}")
    cli::cli_li(cl)
    cli::cli_end()

    return(invisible(NULL))
  }
}

.clierr <- function(x,
                    n,
                    arg = rlang::caller_arg(x),
                    call = rlang::caller_env()) {

  put <- substr(x$input, n, n)

  if (!put %in% delister(x$possible["value"])) {

    cli::cli_abort(
      paste("{.strong {.val {rlang::sym(put)}}} is an invalid",
       "{.val {rlang::sym(x$possible$name[[1]])}} value."),
      call = call)

    }
}

.section <- function(x) { #1

  x <- checks(x)
  x$possible <- as.data.frame(sections())

  # Return all sections
  if (is.na(x$input)) {.cli(x); return(invisible(x))}

  # Return selected section
  if (!is.na(x$input)) {

    .clierr(x, 1)

    x$head <- sections(substr(x$input, 1, 1))
    return(x)

    }
  }

.system <- function(x) { #2

  # Filter to section
  system <- systems(substr(x$input, 1, 1))[c("axis", "name", "value", "label")]
  x$possible <- as.data.frame(system)

  # Return all systems
  if (nchar(x$input) == 1L) {.cli(x); return(invisible(x))}

  # Return selected system
  if (nchar(x$input) > 1L) {

    .clierr(x, 2)

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

  x$possible <- as.data.frame(operation)

  # Return all operations
  if (nchar(x$input) == 2L) {.cli(x); return(invisible(x))}

  # Return selected operation
  if (nchar(x$input) > 2L) {

    .clierr(x, 3)

    x$definitions <- definitions(section = substr(x$input, 1, 1),
                                 axis = "3",
                                 col = "value",
                                 search = substr(x$input, 3, 3))

    # Head = First 4 axes, Tail = Last 3 axes
    x$head <- vctrs::vec_rbind(x$head,
              dplyr::filter(operation, value == substr(x$input, 3, 3)))

    # Filtered pin to pass on
    x$select <- dplyr::filter(select, table == substr(x$input, 1, 3)) |>
      dplyr::select(name_4:rows)

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

  x$possible <- as.data.frame(part)

  # Return all parts
  if (nchar(x$input) == 3L) {.cli(x); return(invisible(x))}

  # Return selected part
  if (nchar(x$input) > 3L) {

    .clierr(x, 4)


    x$head <- vctrs::vec_rbind(x$head,
              dplyr::filter(part, value == substr(x$input, 4, 4)))

    if (substr(x$input, 1, 1) %in% c(0, 3, "F", "G", "X")) {

      x$includes <- includes(section = substr(x$input, 1, 1),
                             axis = "4",
                             col = "label",
                             search = delister(x$head[4, 4]))
    } else {

      x$includes <- NA
    }

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
  x$possible <- unique(x$select$`5`[c("axis", "name", "value", "label")])

  # Return all approaches
  if (nchar(x$input) == 4L)  {.cli(x); return(invisible(x))}

  # Return selected approach
  if (nchar(x$input) > 4L) {

    .clierr(x, 5)

    if (substr(x$input, 1, 1) %in% c(0:4, 7:9, "F", "X")) {

      x$definitions <- vctrs::vec_rbind(x$definitions,
                       definitions(section = substr(x$input, 1, 1),
                                   axis = "5",
                                   col = "value",
                                   search = substr(x$input, 5, 5)))
    }

    x <- purrr::list_flatten(x)
    x$select_5 <- dplyr::filter(x$select_5,
                                value == substr(x$input, 5, 5))
    x$id <- unique(x$select_5$rowid)

    x$head <- vctrs::vec_rbind(x$head,
              unique(x$select_5[c("axis", "name", "value", "label")]))

    x$select_6 <- dplyr::filter(x$select_6, rowid %in% x$id)
    x$select_7 <- dplyr::filter(x$select_7, rowid %in% x$id)
    return(x)
  }
}

.device <- function(x) { #6

  x$possible <- unique(x$select_6[c("axis", "name", "value", "label")])

  # Return all devices
  if (nchar(x$input) == 5L) {.cli(x); return(invisible(x))}

  # Return selected device
  if (nchar(x$input) > 5L) {

    .clierr(x, 6)

    x$select_6 <- dplyr::filter(x$select_6,
                  value == substr(x$input, 6, 6))

    x$id <- intersect(x$id, x$select_6$rowid)

    x$head <- vctrs::vec_rbind(x$head,
              unique(x$select_6[c("axis", "name", "value", "label")]))

    # x$select_6 <- NULL
    x$select_5 <- dplyr::filter(x$select_5, rowid %in% x$id)
    x$select_7 <- dplyr::filter(x$select_7, rowid %in% x$id)

    if (substr(x$input, 1, 1) %in% c(0, 3, "X")) {

      x$includes <- vctrs::vec_rbind(x$includes,
                    includes(section = substr(x$input, 1, 1),
                             axis = "6",
                             col = "label",
                             search = delister(x$head[6, 4])))
    }
  }
  return(x)
}

.qualifier <- function(x) { #7

  x$possible <- unique(x$select_7[c("axis", "name", "value", "label")])

  # Return all devices
  if (nchar(x$input) == 6L) {.cli(x); return(invisible(x))}

  if (nchar(x$input) > 6L) {

    .clierr(x, 7)

    x$select_7 <- dplyr::filter(x$select_7, value == substr(x$input, 7, 7))
    x$id <- intersect(x$id, x$select_7$rowid)
    x$head <- vctrs::vec_rbind(x$head,
              unique(x$select_7[c("axis", "name", "value", "label")]))

    x$select_5 <- dplyr::filter(x$select_5, rowid %in% x$id)
    x$select_6 <- dplyr::filter(x$select_6, rowid %in% x$id)

  }
  return(x)
}

.finisher <- function(x) {

  if (length(x$id) == 1L) {

    x <- list(
      code = x$input,
      description = procedural::order(search = x$input)$description_code,
      axes = x$head,
      definitions = x$definitions |>
        dplyr::mutate(definition = dplyr::if_else(!is.na(explanation),
        paste0(definition, ". ", explanation, "."), definition), explanation = NULL),
      includes = x$includes |>
        tidyr::nest(includes = "includes") |>
        dplyr::mutate(includes = purrr::map_chr(
          includes, ~paste(.x$includes, collapse = ", ")))
      )
  }
  return(x)
}
