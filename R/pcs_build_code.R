#' @autoglobal
#'
#' @noRd
.pcs_code_cli <- function(x) {

  cl <- glue::glue_data(
    .x = x$opt,
    "{.strong {.field <<value>>}} : <<label>>",
    .open = "<<",
    .close = ">>")

  if (x$opt$name[[1]] == "Section") {

    cli::cli_bullets(c("!" = "No Section Selected"))

    cli::cli_h3("Select {.val {rlang::sym(x$opt$name[[1]])}}")
    cli::cli_li(cl)
    cli::cli_end()

    return(invisible(x))

  } else {

    hd <- glue::glue_data(
      .x = x$head,
      "[{.strong {.field <<value>>}}] <<name>>: <<label>>",
      .open = "<<",
      .close = ">>")

    cli::cli_bullets(
      c(" " = " ",
        " " = "Selected: {.field {rlang::sym(x$input)}}",
        " "
      )
    )
    cli::cli_ol(hd)

    cli::cli_bullets(
      c(" ",
        ">" = "{.emph Select} {.val {rlang::sym(x$opt$name[[1]])}}",
        " "
      )
    )
    cli::cli_ul(cl)
    cli::cli_end()

    return(invisible(x))
  }
}

#' @autoglobal
#'
#' @noRd
.pcs_code_cli_error <- function(x, n) {

  arg  <- rlang::caller_arg(x)
  call <- rlang::caller_env()

  input <- stringfish::sf_substr(x$input, n, n)

  if (input %!in% fuimus::delister(x$opt["value"])) {

    cli::cli_abort(
      paste(
        "{.strong {.val {rlang::sym(input)}}} is an invalid",
        "{.val {rlang::sym(x$opt$name[[1]])}} value."),
      call = call)
  }
}

#' Look up ICD-10-PCS Codes or Tables
#'
#' @param x an alphanumeric character vector, can be 3 to 7 characters long.
#'
#' @template returns-default
#'
#' @examples
#'
#' pcs_code("0G9")
#'
#' pcs_code("0G90")
#'
#' pcs_code("0G900")
#'
#' pcs_code("0G9000")
#'
#' pcs_code("0G9000Z")
#'
#' @autoglobal
#'
#' @export
pcs_code <- function(x = NULL) {

  xs <- .pcs_section(x)
  if (is.null(x)) return(invisible(xs))

  x_chars <- stringfish::sf_nchar(x)

  xs <- .pcs_system(xs)
  if (x_chars == 1L) return(invisible(xs))

  xs <- .pcs_operation(xs)
  if (x_chars == 2L) return(invisible(xs))

  xs <- .pcs_part(xs)
  if (x_chars == 3L) return(invisible(xs))

  xs <- .pcs_approach(xs)
  if (x_chars == 4L) return(invisible(xs))

  xs <- .pcs_device(xs)
  if (x_chars == 5L) return(invisible(xs))

  xs <- .pcs_qualifier(xs)
  if (x_chars == 6L) return(invisible(xs))

  xs <- .pcs_finisher(xs)

  class(xs) <- c("pcs_code", "list")

  return(xs)
}

pcs_code2 <- function(x = NULL) {

  xs <- .pcs_section(x)
  if (is.null(x)) return(xs)

  x_chars <- stringfish::sf_nchar(x)

  xs <- .pcs_system(xs)
  if (x_chars == 1L) return(xs)

  xs <- .pcs_operation(xs)
  if (x_chars == 2L) return(xs)

  xs <- .pcs_part(xs)
  if (x_chars == 3L) return(xs)

  xs <- .pcs_approach(xs)
  if (x_chars == 4L) return(xs)

  xs <- .pcs_device(xs)
  if (x_chars == 5L) return(xs)

  xs <- .pcs_qualifier(xs)
  if (x_chars == 6L) return(xs)

  xs <- .pcs_finisher(xs)

  class(xs) <- c("pcs_code", "list")

  return(xs)
}

# 0. Check
#' @autoglobal
#'
#' @noRd
.pcs_check <- function(x = NULL) {

  arg  <- rlang::caller_arg(x)
  call <- rlang::caller_env()

  if (is.null(x)) return(list(input = NA_character_))

  x <- stringfish::sf_toupper(as.character(x))

  if (stringfish::sf_nchar(x) > 7) {
    cli::cli_abort(
      "{.arg {arg}} must be {.strong 0-7} characters long.",
      arg = arg,
      call = call)
  }
  return(list(input = x))
}

# 1. Section
#' @autoglobal
#'
#' @noRd
.pcs_section <- function(x) {

  x     <- .pcs_check(x)
  x$opt <- sections()

  if (is.na(x$input)) return(x)

  if (!is.na(x$input)) {
    step <- 1

    x$head <- collapse::fsubset(
      x$opt,
      value %==% stringfish::sf_substr(x$input, step, step))

    class(x) <- c("pcs_section", "list")

    return(x)
  }
}

# 2. System
#' @autoglobal
#'
#' @noRd
.pcs_system <- function(x) {

  stopifnot(
    "`x` hasn't passed through `.pcs_section()`" = inherits(x, "pcs_section")
    )

  step  <- 1
  x$opt <- system <- systems(
    stringfish::sf_substr(x$input, step, step))[2:5]

  if (stringfish::sf_nchar(x$input) == step) return(x)

  if (stringfish::sf_nchar(x$input) > step) {
    step <- 2

    x$head <- collapse::rowbind(x$head,
      collapse::fsubset(system,
        value %==% stringfish::sf_substr(x$input, step, step))
    )

    class(x) <- c("pcs_system", "list")

    return(x)
  }
}

# 3. Root Operation
# Head = First 4 axes, Tail = Last 3 axes
#' @autoglobal
#'
#' @noRd
.pcs_operation <- function(x) {

  stopifnot(
    "`x` hasn't passed through `.pcs_system()`" = inherits(x, "pcs_system")
  )

  step   <- 2
  select <- get_pin("tables_rows") |>
    collapse::fsubset(
      system %==% stringfish::sf_substr(x$input, 1, step),
      code_2,
      name_3:rows)

  x$opt <- operation <- select |>
    collapse::fcompute(axis  = "3",
                       name  = name_3,
                       value = code_3,
                       label = label_3) |>
    collapse::funique()

  if (stringfish::sf_nchar(x$input) == step) return(x)

  if (stringfish::sf_nchar(x$input) > step) {
    step <- 3

    x$head <- collapse::rowbind(
      x$head,
      collapse::fsubset(
        operation,
        value %==% stringfish::sf_substr(x$input, step, step)
      )
    )

    x$select <- collapse::fsubset(
      select,
      table %==% stringfish::sf_substr(x$input, 1, step),
      name_4:rows)

    return(x)
  }
}

# 4. Body Part
# Construct Tail / Row
#' @autoglobal
#'
#' @noRd
.pcs_part <- function(x) {

  step  <- 3
  x$opt <- part <- x$select |>
    collapse::fcompute(axis  = "4",
                       name  = name_4,
                       value = code_4,
                       label = label_4) |>
    collapse::funique()

  if (stringfish::sf_nchar(x$input) == step) return(x)

  if (stringfish::sf_nchar(x$input) > step) {
    step <- 4

    x$head <- collapse::rowbind(
      x$head,
      collapse::fsubset(
        part,
        value %==% stringfish::sf_substr(x$input, step, step)
        )
      )

    x$select <- collapse::fsubset(
      x$select,
      row %==% stringfish::sf_substr(x$input, 1, step),
      rowid:rows) |>
      tidyr::unnest(rows) |>
      collapse::funique() |>
      collapse::frename(value = code)

    return(x)
  }
}

# 5. Approach
# Row IDs begin
#' @autoglobal
#'
#' @noRd
.pcs_approach <- function(x) {

  step <- 4
  x$select <- collapse::rsplit(x$select, x$select$axis)
  x <- purrr::list_flatten(x)
  x$opt <- collapse::funique(x$select_5[2:5])

  if (stringfish::sf_nchar(x$input) == step) return(x)

  if (stringfish::sf_nchar(x$input) > step) {
    step <- 5

    x$select_5 <- collapse::fsubset(
      x$select_5,
      value %==% stringfish::sf_substr(x$input, step, step))

    x$id <- collapse::funique(x$select_5$rowid)

    x$head <- collapse::rowbind(x$head, collapse::funique(x$select_5[2:5]))

    x$select_6 <- collapse::fsubset(x$select_6, rowid %iin% x$id)
    x$select_7 <- collapse::fsubset(x$select_7, rowid %iin% x$id)

    return(x)
  }
}

# 6. Device
#' @autoglobal
#'
#' @noRd
.pcs_device <- function(x) {

  step  <- 5
  x$opt <- collapse::funique(x$select_6[2:5])

  if (stringfish::sf_nchar(x$input) == step) return(x)

  if (stringfish::sf_nchar(x$input) > step) {
    step <- 6

    x$select_6 <- collapse::fsubset(
      x$select_6,
      value %==% stringfish::sf_substr(x$input, step, step))

    x$id <- vctrs::vec_set_intersect(x$id, x$select_6$rowid)

    x$head <- collapse::rowbind(x$head, collapse::funique(x$select_6[2:5]))

    x$select_5 <- collapse::fsubset(x$select_5, rowid %iin% x$id)
    x$select_7 <- collapse::fsubset(x$select_7, rowid %iin% x$id)

    return(x)
  }
}

# 7. Qualifier
#' @autoglobal
#'
#' @noRd
.pcs_qualifier <- function(x) {

  step  <- 6
  x$opt <- collapse::funique(x$select_7[2:5])

  if (stringfish::sf_nchar(x$input) == step) return(x)

  if (stringfish::sf_nchar(x$input) > step) {
    step <- 7

    x$select_7 <- collapse::fsubset(
      x$select_7,
      value %==% stringfish::sf_substr(x$input, step, step))

    x$id <- vctrs::vec_set_intersect(x$id, x$select_7$rowid)

    x$head <- collapse::rowbind(x$head, collapse::funique(x$select_7[2:5]))

    x$select_5 <- collapse::fsubset(x$select_5, rowid %iin% x$id)
    x$select_6 <- collapse::fsubset(x$select_6, rowid %iin% x$id)

    return(x)
  }
}

#' @autoglobal
#'
#' @noRd
.pcs_finisher <- function(x) {

  if (length(x$id) == 1) {

    x$head$axis <- as.integer(x$head$axis)

    x <- list(
      pcs_code = x$input,
      pcs_description = procedural::order(search = x$input)$description_code,
      pcs_axes = x$head
    )
  }
  return(x)
}
