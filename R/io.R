#' @noRd
pkg_files <- function(ext = NULL) {
  x <- system.file("extdata", package = "procedural")
  if (x == "") {
    stop("No extdata found")
  }
  x <- list.files(x, full.names = TRUE, ignore.case = TRUE)
  if (length(x) == 0L) {
    stop("No files found")
  }
  # split by file path ext
  x <- split(x, sub(".*[.]([[:alnum:]]+)$", "\\1", x))
  if (!is.null(ext)) {
    i <- match_(ext, names(x))
    if (cheapr::all_na(i, recursive = FALSE)) {
      stop(paste0("No files with extension `.", ext, "` found"))
    }
    x <- x[[i]]
  }
  return(x)
}

#' @noRd
load_parquet <- function(
  profile = c(
    "index",
    "tables",
    "definitions",
    "order",
    "conversion"
  )
) {
  parq_ <- pkg_files(ext = "parquet")
  prof_ <- rlang::arg_match(profile)
  path_ <- grep(
    cheapr::paste_("icd10pcs_", prof_),
    parq_,
    value = TRUE,
    perl = TRUE
  )
  nanoparquet::read_parquet(file = path_)
}

#' @noRd
process_order <- function() {
  x <- load_parquet(profile = "order")
  collapse::gv(x, "description_short") <- NULL
  ss_(
    x,
    row = cheapr::c_(
      collapse::num_vars(x, 3L),
      collapse::cat_vars(x, 3L)
    )
  )
}

#' @noRd
process_conversion <- function() {
  x <- load_parquet(profile = "conversion")
  x <- av_(
    x,
    date_effective = as.Date(
      cheapr::paste_(
        x$year_effective,
        "-",
        gsub(
          ".",
          "-",
          ifelse_(
            cheapr::is_na(x$mday_effective),
            x$comment,
            x$mday_effective
          ),
          fixed = TRUE
        )
      ),
      format = "%Y-%m-%d"
    )
  )
  collapse::setrename(
    x,
    current_code = "current",
    prior_code = "prior",
    date_effective = "date",
    year_effective = "year"
  )
  collapse::settfmv(x, "year", as.integer)
  collapse::gv(x, c("year", "date", "change", "current", "prior"))
}

#' @noRd
process_index <- function() {
  x <- load_parquet(profile = "index")
  x <- ss_(
    x,
    col = match_(c("entity", "field", "value", "source"), colnames(x))
  )

  # create letter column ----------------------------------------------------
  x <- av_(
    x,
    letter = fill_(
      ifelse_(
        x$entity == "letter",
        x$value,
        NA_character_
      )
    )
  )

  x <- ss_(x, x$entity %!=% "letter", colnames(x) %!=% "entity")

  # create entry/term columns -----------------------------------------------
  x <- av_(
    x,
    entry = csum_(x$source == "mainTerm/title"),
    term = fill_(
      ifelse_(
        x$source == "mainTerm/title",
        x$value,
        NA_character_
      )
    )
  )

  x <- ss_(x, x$source %!=% "mainTerm/title")

  x <- av_(
    x,
    row = collapse::seq_row(x),
    lvl = as.integer(ifelse_(x$field == "level", x$value, NA)),
    lid = csum_(x$field == "level")
  )

  ss_(
    x,
    col = match_(
      c(
        "row",
        "entry",
        "letter",
        "lvl",
        "lid",
        "field",
        "value",
        "source",
        "term"
      ),
      colnames(x)
    )
  )
}

#' @noRd
process_tables <- function() {
  x <- load_parquet(profile = "tables")
  x <- ss_(
    x,
    x$field %!iin% c("definition", "values"),
    match_(c("record_index", "entity", "field", "value"), colnames(x))
  )

  collapse::setrename(x, table = "record_index")

  x$field <- cheapr::val_replace(x$field, "label/code", "code")

  x <- collapse::rsplit(x, ~table, keep.by = TRUE)
  x <- purrr::map(x, map_tables)
  x <- rbind_(x)

  collapse::settfmv(x, "pos", as.integer)
  return(x)
}

#' @noRd
map_tables <- function(x) {
  tab <- ss_(
    x,
    x$entity %==% "axis",
    colnames(x) %!iin% c("table", "entity")
  ) |>
    collapse::rsplit(~field) |>
    collapse::qTBL() |>
    collapse::colorderv(c("pos", "title", "code", "label"))

  grab <- \(x, n) pull_(ss_(x, x[["field"]] %==% n), "value")

  row <- ss_(
    x,
    x$entity %!iin% c("axis", "pcsRow"),
    colnames(x) %!iin% c("table", "entity")
  )
  row <- av_(row, row = csum_(row$field == "pos"))
  row$field <- cheapr::val_replace(row$field, "value", "label")

  row <- collapse::rsplit(row, ~row) |>
    purrr::map(function(x) {
      cheapr::col_c(
        .args = list(
          cheapr::fast_df(
            .args = list(
              pos = grab(x, "pos"),
              title = grab(x, "title")
            )
          ),
          cheapr::fast_df(
            .args = list(
              code = grab(x, "code"),
              label = grab(x, "label")
            )
          )
        )
      )
    })

  row <- rbind_(tab, rbind_(row))
  av_(row, table = rep.int(x$table[1L], nrow_(row)))
}

#' @noRd
definitions_file <- function() {
  x <- load_parquet(profile = "definitions")

  # create section/axis/name columns ----------------------------------------
  x <- av_(
    x,
    section = fill_(
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

  x <- ss_(
    x,
    x$entity %!=% "section",
    colnames(x) %iin%
      c(
        "section",
        "axis",
        "name",
        "record_index",
        "entity",
        "field",
        "value"
      )
  )
  x <- collapse::rsplit(x, ~record_index)
  x <- purrr::map(x, map_definitions_file)
  x <- rbind_(x)

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
    overid = 0L,
    verbose = 0L
  )

  substr(x$field, 1L, 1L) <- toupper(substr(x$field, 1L, 1L))
  collapse::colorderv(x, c("entry", "section", "axis", "name", "term"))
}

#' @noRd
map_definitions_file <- function(x) {
  x$axis <- fill_(x$axis)
  x$name <- fill_(x$name)
  x$field <- ifelse_(
    x$entity == "axis/terms/includes",
    "includes",
    x$field
  )
  x <- ss_(x, x$entity %!=% "axis")
  x <- av_(x, entry = x$entity == "axis/terms/title")
  x <- av_(x, run = vctrs::vec_identify_runs(x$entry))

  runs <- ss_(x, x$entry) |> pull_("run") |> cheapr::counts()
  runs <- ss_(runs, runs$count > 1L) |> pull_("key")

  xrun <- ss_(x, x$run %iin% runs)
  x <- ss_(x, x$run %!iin% runs)

  if (nrow_(xrun) > 0L) {
    x <- rbind_(
      x,
      collapse::gby(xrun, run) |>
        collapse::mtt(value = cheapr::paste_(value, collapse = " | ")) |>
        collapse::funique(cols = "run") |>
        collapse::fungroup()
    ) |>
      rorderv_(c("run"))
  }

  collapse::gv(x, c("run", "entry", "entity")) <- NULL
  return(x)
}

#' @noRd
process_includes <- function() {
  x <- definitions_file()
  x <- ss_(x, x$field %==% "Includes", colnames(x) %!=% "field")
  collapse::setrename(x, value = "includes")

  i <- cheapr::counts(x$entry)
  i <- ss_(i, i$count > 1L) |> pull_("key")

  rbind_(
    ss_(x, x$entry %!iin% i),
    ss_(x, x$entry %iin% i) |>
      collapse::gby(entry, term) |>
      collapse::mtt(includes = cheapr::paste_(includes, collapse = " | ")) |>
      collapse::fungroup() |>
      collapse::funique()
  ) |>
    rorderv_(c("entry"))
}

#' @noRd
process_explanation <- function() {
  x <- definitions_file()
  x <- ss_(x, x$field %==% "Explanation", colnames(x) %!=% "field")
  collapse::setrename(x, value = "includes")
  return(x)
}

#' @noRd
process_definitions <- function() {
  x <- definitions_file()
  x <- ss_(x, x$field %==% "Definition", colnames(x) %!=% "field")
  collapse::setrename(x, value = "definition")
  return(x)
}
