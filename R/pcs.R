#' Look up ICD-10-PCS Codes or Tables
#'
#' @param x an alphanumeric character vector, can be 3 to 7 characters long.
#'
#' @template returns-default
#'
#' @examplesIf interactive()
#'
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
#' @autoglobal
#'
#' @export
pcs <- function(x = NULL) {

  xs <- .section(x)
  if (is.null(x)) return(invisible(xs))

  x_chars <- stringfish::sf_nchar(x)

  xs <- .system(xs)
  if (x_chars == 1L) return(invisible(xs))

  xs <- .operation(xs)
  if (x_chars == 2L) return(invisible(xs))

  xs <- .part(xs)
  if (x_chars == 3L) return(invisible(xs))

  xs <- .approach(xs)
  if (x_chars == 4L) return(invisible(xs))

  xs <- .device(xs)
  if (x_chars == 5L) return(invisible(xs))

  xs <- .qualifier(xs)
  if (x_chars == 6L) return(invisible(xs))

  xs <- .finisher(xs)

  return(xs)
}

.section <- function(x) { #1

  x <- checks(x)
  x$possible <- as.data.frame(sections())

  # Return all sections
  if (is.na(x$input)) {.cli(x); return(invisible(x))}

  # Return selected section
  if (!is.na(x$input)) {

    .clierr(x, 1)

    x$head <- sections(stringfish::sf_substr(x$input, 1, 1))

    return(x)
    }
  }

.system <- function(x) { #2

  # Filter to section
  system <- systems(
    stringfish::sf_substr(x$input, 1, 1)
    )[c("axis", "name", "value", "label")]

  x$possible <- as.data.frame(system)

  # Return all systems
  if (stringfish::sf_nchar(x$input) == 1L) {.cli(x); return(invisible(x))}

  # Return selected system
  if (stringfish::sf_nchar(x$input) > 1L) {

    .clierr(x, 2)

    x$head <- vctrs::vec_rbind(
      x$head,
      vctrs::vec_slice(
        system,
        system$value == stringfish::sf_substr(x$input, 2, 2)
        )
      )
    return(x)
  }
}

.operation <- function(x) { #3

  # Filter to system
  # TODO
  select <- get_pin("tables_rows") |>
    dplyr::filter(system == stringfish::sf_substr(x$input, 1, 2)) |>
    dplyr::select(code_2, name_3:rows)

  # Create operation object
  operation <- select |>
    dplyr::mutate(axis = "3") |>
    dplyr::select(axis,
                  name = name_3,
                  value = code_3,
                  label = label_3) |>
    dplyr::distinct()

  x$possible <- as.data.frame(operation)

  # Return all operations
  if (stringfish::sf_nchar(x$input) == 2L) {.cli(x); return(invisible(x))}

  # Return selected operation
  if (stringfish::sf_nchar(x$input) > 2L) {

    .clierr(x, 3)

    # Axis 3 Definition
    x$definitions <- switch(
      stringfish::sf_substr(x$input, 1, 1),
      'D' = dplyr::tibble(label = character(0),
                          definition = character(0)),
      definitions(section = stringfish::sf_substr(x$input, 1, 1),
                  axis = "3",
                  col = "value",
                  search = stringfish::sf_substr(x$input, 3, 3),
                  display = TRUE))

    # Head = First 4 axes, Tail = Last 3 axes
    x$head <- vctrs::vec_rbind(
      x$head,
      vctrs::vec_slice(
        operation,
        operation$value == stringfish::sf_substr(x$input, 3, 3)
        )
      )

    # Filtered pin to pass on
    x$select <- vctrs::vec_slice(
      select,
      select$table == stringfish::sf_substr(x$input, 1, 3)
      ) |>
      dplyr::select(name_4:rows)

    return(x)
  }
}

# Construct Tail / Row ---------------------
.part <- function(x) { #4

  # Create part object
  part <- x$select |>
    dplyr::mutate(axis = "4") |>
    dplyr::select(axis,
                  name = name_4,
                  value = code_4,
                  label = label_4) |>
    dplyr::distinct()

  x$possible <- as.data.frame(part)

  # Return all parts
  if (stringfish::sf_nchar(x$input) == 3L) {.cli(x); return(invisible(x))}

  # Return selected part
  if (stringfish::sf_nchar(x$input) > 3L) {

    .clierr(x, 4)

    x$head <- vctrs::vec_rbind(x$head,
              dplyr::filter(part,
              value == stringfish::sf_substr(x$input, 4, 4)))

    # Axis 4 Includes
    x$includes <- switch(
      stringfish::sf_substr(x$input, 1, 1),
      "0" = ,
      "3" = ,
      "F" = ,
      "G" = ,
      "X" = includes(section = stringfish::sf_substr(x$input, 1, 1),
                     axis = "4",
                     col = "label",
                     search = delister(x$head[4, 4])),
                     dplyr::tibble(section = character(0),
                                   axis = character(0),
                                   name = character(0),
                                   label = character(0),
                                   includes = character(0)))

    x$select <- dplyr::filter(
      x$select,
      row == stringfish::sf_substr(x$input, 1, 4)
      ) |>
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
  x$possible <- collapse::funique(x$select$`5`[c("axis", "name", "value", "label")])

  # Return all approaches
  if (nchar(x$input) == 4L)  {.cli(x); return(invisible(x))}

  # Return selected approach
  if (nchar(x$input) > 4L) {

    .clierr(x, 5)

    x <- purrr::list_flatten(x)

    x$select_5 <- dplyr::filter(
      x$select_5,
      value == stringfish::sf_substr(x$input, 5, 5))

    x$id <- unique(x$select_5$rowid)

    x$head <- vctrs::vec_rbind(
      x$head,
      unique(x$select_5[c("axis", "name", "value", "label")])
      )

    x$select_6 <- dplyr::filter(x$select_6, rowid %in% x$id)
    x$select_7 <- dplyr::filter(x$select_7, rowid %in% x$id)

    # Axis 5 Definition
    x$definitions <- switch(
      stringfish::sf_substr(x$input, 1, 1),
      "0" = ,
      "1" = ,
      "2" = ,
      "3" = ,
      "4" = ,
      "7" = ,
      "8" = ,
      "9" = ,
      "F" = ,
      "X" = vctrs::vec_rbind(
        x$definitions,
        definitions(
          section = stringfish::sf_substr(x$input, 1, 1),
          axis = "5",
          col = "value",
          search = stringfish::sf_substr(x$input, 5, 5),
          # col = "label",
          # search = delister(x$head[5, 4])
          display = TRUE)
        ),
      vctrs::vec_rbind(
        x$definitions,
        dplyr::tibble(label = character(0),
                      definition = character(0))))
    return(x)
  }
}

.device <- function(x) { #6

  x$possible <- unique(x$select_6[c("axis", "name", "value", "label")])

  # Return all devices
  if (stringfish::sf_nchar(x$input) == 5L) {.cli(x); return(invisible(x))}

  # Return selected device
  if (stringfish::sf_nchar(x$input) > 5L) {

    .clierr(x, 6)

    x$select_6 <- dplyr::filter(
      x$select_6,
      value == stringfish::sf_substr(x$input, 6, 6)
      )

    x$id <- intersect(x$id, x$select_6$rowid)

    x$head <- vctrs::vec_rbind(
      x$head,
      unique(x$select_6[c("axis", "name", "value", "label")])
      )

    x$select_5 <- dplyr::filter(x$select_5, rowid %in% x$id)
    x$select_7 <- dplyr::filter(x$select_7, rowid %in% x$id)

    # Axis 6 Includes
    x$includes <- switch(
      stringfish::sf_substr(x$input, 1, 1),
      "0" = ,
      "3" = ,
      "F" = ,
      "G" = ,
      "X" = vctrs::vec_rbind(
        x$includes,
        includes(section = stringfish::sf_substr(x$input, 1, 1),
                 axis = "4",
                 col = "label",
                 search = delister(x$head[6, 4]))
        ),
      vctrs::vec_rbind(
        x$includes,
      dplyr::tibble(section = character(0),
                    axis = character(0),
                    name = character(0),
                    label = character(0),
                    includes = character(0))))
  }
  return(x)
}

.qualifier <- function(x) { #7

  x$possible <- unique(x$select_7[c("axis", "name", "value", "label")])

  # Return all devices
  if (stringfish::sf_nchar(x$input) == 6L) {.cli(x); return(invisible(x))}

  if (stringfish::sf_nchar(x$input) > 6L) {

    .clierr(x, 7)

    x$select_7 <- dplyr::filter(
      x$select_7,
      value == stringfish::sf_substr(x$input, 7, 7)
      )

    x$id <- intersect(x$id, x$select_7$rowid)

    x$head <- vctrs::vec_rbind(
      x$head,
      unique(x$select_7[c("axis", "name", "value", "label")])
      )

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

      # procedure = dplyr::tibble(
      #   code = x$input,
      #   description = procedural::order(search = x$input)$description_code,
      # ),

      axes = x$head,

      definitions = fuimus::null_if_empty(x$definitions),

      includes = x$includes |>
        tidyr::nest(includes = "includes") |>
        dplyr::mutate(includes = purrr::map_chr(
        includes, ~paste(.x$includes, collapse = ", ")))
      )

    # if(vctrs::vec_is_empty(x$definitions)) x$definitions <- NA
    if(vctrs::vec_is_empty(x$includes))    x$includes <- NA
  }
  return(x)
}
