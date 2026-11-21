#' @noRd
pkg_files <- function(ext = NULL) {
  x <- system.file("extdata", package = "procedural")
  if (x == "") {
    return(NULL)
  }
  x <- list.files(x, full.names = TRUE, ignore.case = TRUE)
  if (length(x) == 0L) {
    return(NULL)
  }
  x <- split(x, sub(".*[.]([[:alnum:]]+)$", "\\1", x))
  if (!is.null(ext)) {
    i <- match_(ext, names(x))
    if (cheapr::all_na(i, recursive = FALSE)) {
      return(NULL)
    }
    x <- x[[i]]
  }
  return(x)
}

#' @noRd
process_xml <- function(profile = c("index", "tables", "definitions")) {
  prof_ <- rlang::arg_match(profile)
  path_ <- grep(
    paste0("icd10pcs_", prof_),
    pkg_files(ext = "xml"),
    value = TRUE,
    perl = TRUE
  )
  if (is.null(path_) || length(path_) != 1L) {
    return(NULL)
  }

  collapse::ss(
    xmlrectr::rectangle_xml(
      file = path_,
      xmlrectr::compile_xml_profile(
        profile = xmlrectr::xml_profile(
          rows = switch(
            prof_,
            index = "ICD10PCS.index/letter",
            tables = "ICD10PCS.tabular/pcsTable",
            definitions = "ICD10PCS.definitions/section"
          )
        ),
        sample = path_
      ),
      parallel = TRUE
    ),
    j = c(2L, 4:6, 8:14)
  )
}

#' @noRd
process_order <- function() {
  path_ <- grep(
    "icd10pcs_order_",
    pkg_files(ext = "txt"),
    value = TRUE,
    perl = TRUE
  )
  if (is.null(path_) || length(path_) != 1L) {
    return(NULL)
  }
  x <- readr::read_fwf(
    file = path_,
    readr::fwf_cols(
      order = c(1L, 5L),
      code = c(6L, 13L),
      valid = 14:15,
      description_short = c(16L, 76L),
      description_long = c(77L, NA_integer_)
    ),
    show_col_types = FALSE,
    col_types = "icicc"
  )

  class(x) <- cheapr::setdiff_(class(x), "spec_tbl_df")

  collapse::ss(
    x,
    j = cheapr::c_(
      collapse::num_vars(x, 3L),
      collapse::cat_vars(x, 3L)
    )
  )
}

#' @noRd
process_index <- function(xml = FALSE) {
  x <- process_xml(profile = "index")
  if (xml) {
    return(x)
  }
  x <- ss_(x, col = c(2:5, 7L))

  # create letter column ----------------------------------------------------
  x <- av_(
    x,
    letter = ifelse_(
      x$entity == "letter",
      x$value,
      NA_character_
    ) |>
      vctrs::vec_fill_missing()
  )

  x <- ss_(x, x$entity %!=% "letter", -2L)

  # create entry/term columns -----------------------------------------------
  x <- av_(
    x,
    entry = csum_(x$source == "mainTerm/title"),
    # term = cheapr::val_replace(x$source, "mainTerm/title", x$value),
    term = ifelse_(
      x$source == "mainTerm/title",
      x$value,
      NA_character_
    ) |>
      vctrs::vec_fill_missing()
  )

  ss_(x, x$source %!=% "mainTerm/title", c(1L, 3L, 2L, 5:7))
}

#' @noRd
process_tables <- function(xml = FALSE) {
  x <- process_xml(profile = "tables")
  if (xml) {
    return(x)
  }
  x <- ss_(x, x$field %!iin% c("definition", "values"), c(1:2, 4:5))
  collapse::setrename(x, table = "record_index")

  # collapse::recode_char(x$field, `label/code` = "code", set = TRUE)
  # x$field <- ifelse_(x$field == "label/code", "code", x$field)
  x$field <- cheapr::val_replace(x$field, "label/code", "code")

  x <- ss_(x, col = 3:4)
  x <- collapse::rsplit(x, ~table, keep.by = TRUE)
  x <- purrr::map(x, map_tables)
  x <- collapse::rowbind(x)

  collapse::settfmv(x, "pos", as.integer)
  return(x)
}

#' @noRd
map_tables <- function(x) {
  tab <- ss_(x, x$entity %==% "axis") |>
    collapse::rsplit(~field) |>
    collapse::qTBL() |>
    collapse::colorderv(c("pos", "title", "code", "label"))

  grab <- \(x, n) {
    ss_(x, x[["field"]] %==% n) |>
      pull_("value") |>
      name_(n)
  }

  row <- ss_(x, x$entity %!iin% c("axis", "pcsRow"))
  row <- av_(row, row = csum_(row$field == "pos"))
  row$field <- cheapr::val_replace(row$field, "value", "label")
  # collapse::recode_char(row$field, value = "label", set = TRUE)
  # row$field <- ifelse_(row$field == "value", "label", row$field)

  row <- collapse::rsplit(row, ~row) |>
    purrr::map(function(x) {
      cheapr::col_c(
        .args = list(
          cheapr::fast_df(
            .args = list(
              grab(x, "pos"),
              grab(x, "title")
            )
          ),
          cheapr::fast_df(
            .args = list(
              grab(x, "code"),
              grab(x, "label")
            )
          )
        )
      )
    })

  row <- collapse::rowbind(table, collapse::rowbind(row))
  av_(row, table = rep.int(x$table[1L], nrow_(row)))
}

#' @noRd
process_definitions <- function(xml = FALSE) {
  x <- process_xml(profile = "definitions")
  if (xml) {
    return(x)
  }
  x <- av_(
    x,
    section = ifelse_(
      x$entity == "section" & x$value_kind == "attribute",
      x$value,
      NA_character_
    ) |>
      vctrs::vec_fill_missing(),
    axis = ifelse_(
      x$entity == "axis" & x$value_kind == "attribute",
      x$value,
      NA_character_
    ),
    name = ifelse_(
      x$entity == "axis" & x$field == "title",
      x$value,
      NA_character_
    ) |>
      cheapr::lag_(-1L)
  )

  x <- ss_(x, x$entity %!=% "section", c(1:5, 7:8))
  x <- collapse::rsplit(x, ~record_index)
  x <- purrr::map(x, map_definitions)
  x <- collapse::rowbind(x)
  x <- cheapr::unique_(x)

  x <- av_(x, entry = csum_(x$field == "value"))
  collapse::settfmv(x, "axis", as.integer)

  term <- ss_(x, x$field %==% "value", -4L)
  collapse::setrename(term, value = "term")

  x <- ss_(x, x$field %!=% "value")
  x <- collapse::join(
    x,
    term,
    on = c("entry", "section", "axis", "name"),
    multiple = TRUE,
    overid = 0
  ) |>
    collapse::colorderv(c("entry", "section", "axis", "name", "term"))

  collapse::settfmv(x, "field", stringr::str_to_title)
  return(x)
}

#' @noRd
map_definitions <- function(x) {
  # x$field <- cheapr::if_else_(x$entity == "axis/terms/includes", "includes", x$field)
  x$axis <- vctrs::vec_fill_missing(x$axis)
  x$name <- vctrs::vec_fill_missing(x$name)
  x$field <- cheapr::val_replace(x$entity, "axis/terms/includes", "includes")
  x <- ss_(x, x$entity %!=% "axis")
  x <- av_(x, entry = x$entity == "axis/terms/title")
  x <- av_(x, run = vctrs::vec_identify_runs(x$entry))

  # runs <- ss_(x, x$entry) |> pull_("run") |> cheapr::counts()
  # runs <- ss_(runs, runs$count > 1L) |> pull_("key")

  runs <- ss_(x, x$entry) |>
    collapse::fcount(run) |>
    collapse::sbt(N > 1L) |>
    _$run

  xrun <- ss_(x, x$run %iin% runs)
  x <- ss_(x, x$run %!iin% runs)

  if (nrow_(xrun) > 0L) {
    x <- collapse::rowbind(
      x,
      collapse::gby(xrun, run) |>
        collapse::mtt(value = cheapr::paste_(value, collapse = " | ")) |>
        collapse::funique(cols = "run") |>
        collapse::fungroup()
    ) |>
      collapse::roworderv("run")
  }

  collapse::gv(x, c("run", "entry", "entity")) <- NULL
  return(x)
}
