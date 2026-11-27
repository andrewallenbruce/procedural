#' @noRd
is_single_id <- function(x, y) {
  length(vctrs::vec_set_intersect(x, y)) == 1L
}

#' @noRd
check_nchar <- function(
  x,
  n = 1,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_number_whole(n, min = 1)

  if (any_(nchar(x) != n)) {
    cli::cli_abort(
      "{.arg {arg}} must be {.val {n}} character{?s} long.",
      arg = arg,
      call = call
    )
  }
  toupper(x)
}

#' @noRd
.cli <- function(x) {
  cl <- glue::glue_data(
    .x = x$opt,
    "{.strong {.field <<value>>}} >=> <<label>>",
    .open = "<<",
    .close = ">>"
  )

  pkg_rule <- cli::cli_rule(
    "{.strong {.fn procedural::pcs}}",
    right = "{.strong {.emph ICD-10-PCS 2024}}"
  )

  if (x$opt$name[[1]] == "Section") {
    pkg_rule

    cli::cli_bullets(c("!" = "No Section Selected"))

    cli::cli_h3("Select {.val {rlang::sym(x$opt$name[[1]])}}")
    cli::cli_li(cl)
    cli::cli_end()

    return(invisible(NULL))
  } else {
    hd <- glue::glue_data(
      .x = x$head,
      "[{.strong {.field <<value>>}}] <<name>>: <<label>>",
      .open = "<<",
      .close = ">>"
    )

    pkg_rule

    cli::cli_bullets(
      c(" " = " ", " " = "Selected: {.field {rlang::sym(x$input)}}", " ")
    )
    cli::cli_ol(hd)

    cli::cli_bullets(
      c(" ", ">" = "{.emph Select} {.val {rlang::sym(x$opt$name[[1]])}}", " ")
    )
    cli::cli_ul(cl)
    cli::cli_end()

    return(invisible(NULL))
  }
}

#' @noRd
.clierr <- function(x, n) {
  arg <- rlang::caller_arg(x)
  call <- rlang::caller_env()

  put <- substr(x$input, n, n)

  if (!put %in% un_(x$opt["value"])) {
    cli::cli_abort(
      paste(
        "{.strong {.val {rlang::sym(put)}}} is an invalid",
        "{.val {rlang::sym(x$opt$name[[1]])}} value."
      ),
      call = call
    )
  }
}
