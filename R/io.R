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
  # split by file path ext
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
parse_xml <- function(profile = c("index", "tables", "definitions")) {
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
parse_txt <- function(profile = c("order", "conversion")) {
  prof_ <- rlang::arg_match(profile)
  path_ <- grep(
    paste0("icd10pcs_", prof_, "_"),
    pkg_files(ext = "txt"),
    value = TRUE,
    perl = TRUE
  )
  if (is.null(path_) || length(path_) != 1L) {
    return(NULL)
  }

  x <- switch(
    prof_,
    order = readr::read_fwf(
      file = path_,
      readr::fwf_cols(
        order = c(1L, 5L),
        code = c(6L, 13L),
        valid = 14:15,
        description_short = c(16L, 76L),
        description = c(77L, NA_integer_)
      ),
      show_col_types = FALSE,
      col_types = "icicc",
      num_threads = 4L
    ),
    conversion = suppressWarnings(
      collapse::ss(
        readr::read_tsv(
          file = path_,
          col_types = "c",
          col_names = c(
            "current",
            "curr_title",
            "year",
            "prior",
            "prior_title",
            "change",
            "comment",
            "mday"
          ),
          show_col_types = FALSE,
          num_threads = 4L
        ),
        -1L
      )
    )
  )

  class(x) <- cheapr::setdiff_(class(x), "spec_tbl_df")
  return(x)
}

#' @noRd
process_order <- function() {
  x <- parse_txt(profile = "order")
  collapse::gv(x, "description_short") <- NULL
  collapse::ss(
    x,
    j = cheapr::c_(
      collapse::num_vars(x, 3L),
      collapse::cat_vars(x, 3L)
    )
  )
}

#' @noRd
process_conversion <- function() {
  x <- parse_txt(profile = "conversion")
  x <- av_(
    x,
    date = readr::parse_date(cheapr::paste_(
      x$year,
      "-",
      gsub(
        ".",
        "-",
        ifelse_(cheapr::is_na(x$mday), x$comment, x$mday),
        fixed = TRUE
      )
    ))
  )
  collapse::gv(x, c("date", "change", "current", "prior"))
}

#' @noRd
process_index <- function(xml = FALSE) {
  if (xml) {
    return(parse_xml(profile = "index"))
  }
  x <- ss_(
    nanoparquet::read_parquet(
      file = grep(
        "icd10pcs_index",
        pkg_files(ext = "parquet"),
        value = TRUE,
        perl = TRUE
      )
    ),
    col = c(2:5, 7L)
  )

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
  if (xml) {
    return(parse_xml(profile = "tables"))
  }
  x <- nanoparquet::read_parquet(
    file = grep(
      "icd10pcs_tables",
      pkg_files(ext = "parquet"),
      value = TRUE,
      perl = TRUE
    )
  )
  x <- ss_(x, x$field %!iin% c("definition", "values"), c(1:2, 4:5))
  collapse::setrename(x, table = "record_index")
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
  if (xml) {
    return(parse_xml(profile = "definitions"))
  }
  x <- nanoparquet::read_parquet(
    file = grep(
      "icd10pcs_definitions",
      pkg_files(ext = "parquet"),
      value = TRUE,
      perl = TRUE
    )
  )

  x <- av_(
    x,
    section = vctrs::vec_fill_missing(
      ifelse_(
        x$entity == "section" & x$value_kind == "attribute",
        x$value,
        NA_character_
      )
    ),
    axis = ifelse_(
      x$entity == "axis" & x$value_kind == "attribute",
      x$value,
      NA_character_
    ),
    name = cheapr::lag_(
      ifelse_(
        x$entity == "axis" & x$field == "title",
        x$value,
        NA_character_
      ),
      -1L
    )
  )

  COLS <- c(
    "section",
    "axis",
    "name",
    "record_index",
    "entity",
    "field",
    "value"
  )

  x <- ss_(x, x$entity %!=% "section", colnames(x) %iin% COLS)
  x <- collapse::rsplit(x, ~record_index)
  x <- purrr::map(x, map_definitions)
  x <- collapse::rowbind(x)

  x <- av_(x, entry = csum_(x$field == "value"))
  collapse::settfmv(x, "axis", as.integer)

  term <- ss_(x, x$field %==% "value", colnames(x) %!=% "field")
  collapse::setrename(term, value = "term")

  x <- ss_(x, x$field %!=% "value")
  x <- collapse::join(
    x,
    term,
    on = c("entry", "section", "axis", "name"),
    multiple = TRUE,
    overid = 0
  )

  substr(x$field, 1L, 1L) <- toupper(substr(x$field, 1L, 1L))
  collapse::colorderv(x, c("entry", "section", "axis", "name", "term"))
}

#' @noRd
map_definitions <- function(x) {
  x$axis <- vctrs::vec_fill_missing(x$axis)
  x$name <- vctrs::vec_fill_missing(x$name)
  x$field <- ifelse_(
    x$entity == "axis/terms/includes",
    "includes",
    x$field
  )
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

#' @noRd
process_includes <- function(xml = FALSE) {
  if (xml) {
    return(parse_xml(profile = "definitions"))
  }
  x <- nanoparquet::read_parquet(
    file = grep(
      "icd10pcs_definitions",
      pkg_files(ext = "parquet"),
      value = TRUE,
      perl = TRUE
    )
  )

  x <- collapse::ss(x, x$field %==% "Includes", colnames(x) %!=% "field")
  collapse::setrename(x, value = "includes")

  i <- cheapr::counts(x$entry)
  i <- collapse::ss(i, i$count > 1L) |> _$key

  collapse::rowbind(
    collapse::ss(x, x$entry %!iin% i),
    collapse::ss(x, x$entry %iin% i) |>
      collapse::gby(entry, term) |>
      collapse::mtt(includes = cheapr::paste_(includes, collapse = " | ")) |>
      collapse::fungroup() |>
      collapse::funique()
  ) |>
    collapse::roworderv(c("entry"))
}
