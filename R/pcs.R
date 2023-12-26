#' Look up ICD-10-PCS Codes
#' @param x ICD-10-PCS code, a __7-character__ alphanumeric code
#' @return description
#' @examplesIf interactive()
#' pcs("2W0UX0Z")
#' pcs("2W20X4Z")
#' pcs("2W10X7Z")
#' pcs("2W10X6Z")
#' pcs("2W1HX7Z")
#' pcs("0G9000Z")
#' pcs("0016070")
#' @export
pcs <- function(x) {

  xs <- unlist(strsplit(x, ""), use.names = FALSE)

  sec_sys_op <- pins::board_url(
    github_raw("andrewallenbruce/provider/main/pkgdown/assets/pins-board/")) |>
    pins::pin_read("pcs_2024_tables")

  search <- sec_sys_op |>
    filter(sec_code == xs[1]) |>
    filter(sys_code == xs[2]) |>
    filter(op_code == xs[3])

  rmin <- min(search$rowid)
  rmax <- max(search$rowid)

  pcs_2024 <- pins::board_url(
    github_raw("andrewallenbruce/provider/main/pkgdown/assets/pins-board/")) |>
    pins::pin_read("pcs_2024")

  pcs2 <- pcs_2024 |>
    filter(between(rowid, rmin, rmax))

  tbl <- search |>
    mutate(rowid = NULL) |>
    distinct()

  table <- tibble(
    position = c(tbl$sec_pos, tbl$sys_pos, tbl$op_pos),
    title = c("Section", "Body System", "Root Operation"),
    code = c(tbl$sec_code, tbl$sys_code, tbl$op_code),
    label = c(tbl$sec_lbl, tbl$sys_lbl, tbl$op_lbl))

  b4 <- pcs2 |>
    filter(code == xs[3], axis_pos == "4" & axis_code == xs[4]) |>
    mutate(rowid = NULL) |>
    distinct()

  body <- tibble(
    position = b4$axis_pos,
    title = b4$axis_title,
    code = b4$axis_code,
    label = b4$axis_label)

  a5 <- pcs2 |>
    filter(code == xs[3],
           axis_pos == "5" &  axis_code == xs[5]) |>
    mutate(rowid = NULL) |>
    distinct()

  approach <- tibble(
    position = a5$axis_pos,
    title = a5$axis_title,
    code = a5$axis_code,
    label = a5$axis_label)

  d6 <- pcs2 |>
    filter(code == xs[3],
           axis_pos == "6" &  axis_code == xs[6]) |>
    mutate(rowid = NULL) |>
    distinct()

  device <- tibble(
    position = d6$axis_pos,
    title = d6$axis_title,
    code = d6$axis_code,
    label = d6$axis_label)

  q7 <- pcs2 |>
    filter(code == xs[3],
           axis_pos == "7" &  axis_code == xs[7]) |>
    mutate(rowid = NULL) |>
    distinct()

  qualifier <- tibble(
    position = q7$axis_pos,
    title = q7$axis_title,
    code = q7$axis_code,
    label = q7$axis_label)

  cli::cli_blockquote("PCS Code: {.val {x}}")

  vctrs::vec_rbind(
    table,
    body,
    approach,
    device,
    qualifier
  )

  # list(
  #   table = table,
  #   body = body,
  #   approach = approach,
  #   device = device,
  #   qualifier = qualifier
  # )
}

#' @noRd
prep <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {

  if (!nzchar(x)) {cli::cli_abort("x" = "{.strong x} cannot be an {.emph empty} string.", call = call)}

  if (nchar(x) > 7L) {cli::cli_abort(c(
      "A valid {.strong PCS} code is {.emph {.strong 7} characters long}.",
      "x" = "{.strong {.val {x}}} is {.strong {.val {nchar(x)}}} characters long."),
      call = call)}

  if (grepl("[^[0-9A-HJ-NP-Z]]*", x)) {cli::cli_abort(c(
      "x" = "{.strong {.val {x}}} contains {.emph non-valid} characters."), call = call)}

  if (is.numeric(x)) x <- as.character(x)

  # If any chars are lowercase, capitalize
  if (grepl("[[:lower:]]*", x)) x <- toupper(x)

  sp <- unlist(strsplit(x, ""), use.names = FALSE)

  names(sp) <- c("section",
                 "system",
                 "operation",
                 "part",
                 "approach",
                 "device",
                 "qualifier")

  tbl <- paste0(unname(sp[1:3]), collapse = "")

  return(list(code = rlang::sym(x),
              split = sp,
              table = rlang::sym(tbl)))
}
