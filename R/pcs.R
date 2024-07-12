#' Look up ICD-10-PCS Codes or Tables
#'
#' @param x an alphanumeric character vector, can be 3 to 7 characters long.
#'
#' @template returns-default
#'
#' @examples
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

#' @autoglobal
#' @noRd
checks <- function(x = NULL) {

  arg  <- rlang::caller_arg(x)
  call <- rlang::caller_env()

  if (is.null(x)) return(list(input = NA_character_))

  x <- stringfish::sf_toupper(as.character(x))

  if (stringfish::sf_nchar(x) > 7L) {
    cli::cli_abort(
      c(
    "{.strong PCS} codes have {.strong 7} characters.",
    "x" = "{.strong {.val {rlang::sym(x)}}} has {.strong {.val {nchar(x)}}}."
       ),
    arg = arg,
    call = call
    )
  }
  return(list(input = x))
}


#' @autoglobal
#' @noRd
.section <- function(x) { #1

  x <- checks(x)
  x$opt <- sections()

  # Return all sections
  if (is.na(x$input)) {.cli(x); invisible(x)}

  # Return selected section
  if (!is.na(x$input)) {

    .clierr(x, 1)

    x$head <- x$opt[which(x$opt$value == stringfish::sf_substr(x$input, 1, 1)), ]

    # x$opt <- NULL

    return(x)
    }
  }

#' @autoglobal
#' @noRd
.system <- function(x) { #2

  # Filter to section
  x$opt <- system <- systems(stringfish::sf_substr(x$input, 1, 1))[2:5]

  # Return all systems
  if (stringfish::sf_nchar(x$input) == 1L) {.cli(x); invisible(x)}

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

    # x$opt <- NULL

    return(x)
  }
}

#' @autoglobal
#' @noRd
.operation <- function(x) { #3

  # Filter to system
  select <- get_pin("tables_rows") |>
    dplyr::filter(system == stringfish::sf_substr(x$input, 1, 2)) |>
    dplyr::select(code_2, name_3:rows)

  # Create operation object
  x$opt <- operation <- select |>
    dplyr::mutate(axis = "3") |>
    dplyr::select(axis,
                  name = name_3,
                  value = code_3,
                  label = label_3) |>
    dplyr::distinct()

  # Return all operations
  if (stringfish::sf_nchar(x$input) == 2L) {.cli(x); invisible(x)}

  # Return selected operation
  if (stringfish::sf_nchar(x$input) > 2L) {

    .clierr(x, 3)

    # TODO Axis 3 Definition
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

    # x$opt <- NULL

    return(x)
  }
}

# Construct Tail / Row ---------------------
#' @autoglobal
#' @noRd
.part <- function(x) { #4

  # Create part object
  x$opt <- part <- x$select |>
    dplyr::mutate(axis = "4") |>
    dplyr::select(axis,
                  name = name_4,
                  value = code_4,
                  label = label_4) |>
    dplyr::distinct()

  # Return all parts
  if (stringfish::sf_nchar(x$input) == 3L) {.cli(x); invisible(x)}

  # Return selected part
  if (stringfish::sf_nchar(x$input) > 3L) {

    .clierr(x, 4)

    x$head <- vctrs::vec_rbind(
      x$head,
      vctrs::vec_slice(
        part,
        part$value == stringfish::sf_substr(x$input, 4, 4)
      )
    )

    # TODO Axis 4 Includes
    x$includes <- switch(
      stringfish::sf_substr(x$input, 1, 1),
      "0" = ,
      "3" = ,
      "F" = ,
      "G" = ,
      "X" = includes(section = stringfish::sf_substr(x$input, 1, 1),
                     axis = "4",
                     col = "label",
                     search = fuimus::delister(x$head[4, 4])),
                     dplyr::tibble(section = character(0),
                                   axis = character(0),
                                   name = character(0),
                                   label = character(0),
                                   includes = character(0)))

    x$select <- vctrs::vec_slice(
      x$select,
      x$select$row == stringfish::sf_substr(x$input, 1, 4)
    ) |>
      dplyr::select(rowid:rows) |>
      tidyr::unnest(rows) |>
      dplyr::distinct() |>
      dplyr::rename(value = code)

    # x$opt <- NULL

    return(x)
  }
}

# Row IDs begin ---------------------
#' @autoglobal
#' @noRd
.approach <- function(x) { #5

  x$select <- collapse::rsplit(x$select, x$select$axis)

  x$opt <- collapse::funique(x$select$`5`[c("axis", "name", "value", "label")])

  # Return all approaches
  if (stringfish::sf_nchar(x$input) == 4L)  {.cli(x); invisible(x)}

  # Return selected approach
  if (stringfish::sf_nchar(x$input) > 4L) {

    .clierr(x, 5)

    x <- purrr::list_flatten(x)

    x$select_5 <- vctrs::vec_slice(
      x$select_5,
      x$select_5$value == stringfish::sf_substr(x$input, 5, 5))

    x$id <- collapse::funique(x$select_5$rowid)

    x$head <- vctrs::vec_rbind(
      x$head,
      collapse::funique(
        x$select_5[c("axis", "name", "value", "label")]
        )
      )

    x$select_6 <- fuimus::search_in(
      x$select_6,
      x$select_6$rowid,
      x$id
      )

    x$select_7 <- fuimus::search_in(
      x$select_7,
      x$select_7$rowid,
      x$id
      )

    # TODO Axis 5 Definition
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

#' @autoglobal
#' @noRd
.device <- function(x) { #6

  x$opt <- collapse::funique(x$select_6[c("axis", "name", "value", "label")])

  # Return all devices
  if (stringfish::sf_nchar(x$input) == 5L) {.cli(x); invisible(x)}

  # Return selected device
  if (stringfish::sf_nchar(x$input) > 5L) {

    .clierr(x, 6)

    x$select_6 <- vctrs::vec_slice(
      x$select_6,
      x$select_6$value == stringfish::sf_substr(x$input, 6, 6)
      )

    x$id <- vctrs::vec_set_intersect(
      x$id,
      x$select_6$rowid
      )

    x$head <- vctrs::vec_rbind(
      x$head,
      collapse::funique(
        x$select_6[c("axis", "name", "value", "label")]
        )
      )

    x$select_5 <- fuimus::search_in(
      x$select_5,
      x$select_5$rowid,
      x$id
      )

    x$select_7 <- fuimus::search_in(
      x$select_7,
      x$select_7$rowid,
      x$id
      )

    # TODO Axis 6 Includes
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
                 search = fuimus::delister(x$head[6, 4]))
        ),
      vctrs::vec_rbind(
        x$includes,
      dplyr::tibble(section = character(0),
                    axis = character(0),
                    name = character(0),
                    label = character(0),
                    includes = character(0))))
  }
  # FIXME: Move Return inside if statement?
  return(x)
}

#' @autoglobal
#' @noRd
.qualifier <- function(x) { #7

  x$opt <- collapse::funique(x$select_7[c("axis", "name", "value", "label")])

  # Return all devices
  if (stringfish::sf_nchar(x$input) == 6L) {.cli(x); invisible(x)}

  if (stringfish::sf_nchar(x$input) > 6L) {

    .clierr(x, 7)

    x$select_7 <- vctrs::vec_slice(
      x$select_7,
      x$select_7$value == stringfish::sf_substr(x$input, 7, 7)
      )

    x$id <- vctrs::vec_set_intersect(
      x$id,
      x$select_7$rowid
      )

    x$head <- vctrs::vec_rbind(
      x$head,
      collapse::funique(
        x$select_7[c("axis", "name", "value", "label")]
        )
      )

    x$select_5 <- fuimus::search_in(
      x$select_5,
      x$select_5$rowid,
      x$id
      )

    x$select_6 <- fuimus::search_in(
      x$select_6,
      x$select_7$rowid,
      x$id
      )
  }
  # FIXME: Move Return inside if statement?
  return(x)
}

#' @autoglobal
#' @noRd
.finisher <- function(x) {

  if (length(x$id) == 1L) {

    x <- list(

      code = x$input,
      description = procedural::order(search = x$input)$description_code,

      procedure = dplyr::tibble(
        code = x$input,
        description = procedural::order(search = x$input)$description_code,
      ),

      axes = x$head,

      definitions = fuimus::null_if_empty(x$definitions),

      includes = fuimus::null_if_empty(x$includes |>
        tidyr::nest(includes = "includes") |>
        dplyr::mutate(includes = purrr::map_chr(
        includes, ~paste(.x$includes, collapse = ", ")
        )
      ))
    ) |>
      purrr::compact()
  }
  return(x)
}
