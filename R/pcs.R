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
    xs$split <- NULL
    xs <- purrr::list_rbind(xs)
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

  return(
    list(
      input = x,
      split = splitter(x)
      ))
}

#' @noRd
prep <- function(x) {

  x   <- checks(x)
  xs  <- splitter(x)
  purrr::compact(
    list(split = xs,
         `1` = xs[1],
         `2` = collapser(xs[2]),
         `3` = collapser(xs[3]),
         `4` = collapser(xs[4]),
         `5` = collapser(xs[5]),
         `6` = collapser(xs[6]),
         `7` = collapser(xs[7])))
}

.section <- function(x) {

  x <- checks(x)

  set <- pins::pin_read(mount_board(), "tables_rows") |>
    dplyr::filter(code_1 == x$split[1])

  tbl <- set |>
    dplyr::select(name_1, code_1, label_1) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "1", .before = 1)

  names(tbl) <- c("axis", "name", "value", "label")

  x[[3]] <- tbl


  x[[4]] <- dplyr::select(set, code_1, name_2:rows) |>
    dplyr::mutate(axis = "2", .before = 1) |>
    dplyr::select(axis, name = name_2, value = code_2, label = label_2)

  x$set <- set |> dplyr::select(name_2:rows)

  return(x)
}

.system <- function(x) {

  set <- dplyr::filter(x$`2`, code_2 == x$split[2])

  tbl <- set |>
    dplyr::select(name_2, code_2, label_2) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "2", .before = 1)

  names(tbl) <- c("axis", "name", "value", "label")

  x$`2` <- tbl
  x$`3` <- dplyr::select(set, name_3:rows)
  names(x)[3] <- tbl$name

  return(x)
}

.operation <- function(x) {

  set <- dplyr::filter(x$`3`, code_3 == x$split[3])

  tbl <- set |>
    dplyr::select(name_3, code_3, label_3) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "3", .before = 1)

  names(tbl) <- c("axis", "name", "value", "label")

  x$`3` <- tbl
  x$`4` <- dplyr::select(set, name_4:rows)
  names(x)[4] <- tbl$name

  return(x)
}

.part <- function(x) {

  set <- dplyr::filter(x$`4`, code_4 == x$split[4])

  tbl <- set |>
    dplyr::select(name_4, code_4, label_4) |>
    dplyr::distinct() |>
    dplyr::mutate(axis = "4", .before = 1)

  names(tbl) <- c("axis", "name", "value", "label")

  x$`4` <- tbl
  x$`5` <- dplyr::select(set, rowid:rows) |> tidyr::unnest(rows)
  names(x)[5] <- tbl$name

  return(x)
}

.approach <- function(x) {

  tbl <- dplyr::filter(x$`5`, axis == "5", code == x$split[5]) |>
    dplyr::select(-rowid) |>
    dplyr::distinct()

  names(tbl) <- c("axis", "name", "value", "label")

  x$`6` <- dplyr::filter(x$`5`, axis != "5") |> dplyr::distinct()

  x$`5` <- tbl
  names(x)[6] <- tbl$name

  return(x)
}

.device <- function(x) {

  tbl <- dplyr::filter(x$`6`, axis == "6", code == x$split[6]) |>
    dplyr::select(-rowid) |>
    dplyr::distinct()

  names(tbl) <- c("axis", "name", "value", "label")

  x$`7` <- dplyr::filter(x$`6`, axis != "6") |> dplyr::distinct()

  x$`6` <- tbl
  names(x)[7] <- tbl$name

  return(x)
}

.qualifier <- function(x) {

  tbl <- dplyr::filter(x$`7`, axis == "7", code == x$split[7]) |>
    dplyr::select(-rowid) |>
    dplyr::distinct()

  names(tbl) <- c("axis", "name", "value", "label")

  x$`7` <- tbl
  names(x)[8] <- tbl$name

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
