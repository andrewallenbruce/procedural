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
  collapse::setrename(x, description_long = "description")
  i <- cheapr::c_(collapse::num_vars(x, 3L), collapse::cat_vars(x, 3L))
  ss_(x, col = i)
}

#' @noRd
process_conversion <- function() {
  x <- load_parquet(profile = "conversion")

  m <- ifelse_(cheapr::is_na(x$mday_effective), x$comment, x$mday_effective)
  m <- gsub(".", "-", m, fixed = TRUE)
  m <- cheapr::paste_(x$year_effective, "-", m)
  x <- av_(x, date_effective = as.Date(m, format = "%Y-%m-%d"))

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
  COLS <- c("entity", "field", "value", "source")
  x <- ss_(x, col = match_(COLS, colnames(x)))

  # create letter/entry/term columns ----------------------------------------
  x <- av_(
    x,
    letter = fill_(
      ifelse_(
        x$entity == "letter",
        x$value,
        NA_character_
      )
    ),
    entry = csum_(x$source == "mainTerm/title"),
    term = fill_(
      ifelse_(
        x$source == "mainTerm/title",
        x$value,
        NA_character_
      )
    ),
    lvl = as.integer(
      ifelse_(x$field == "level", x$value, NA)
    )
  )

  x <- ss_(
    x,
    cheapr::intersect_(
      x$entity %!=% "letter",
      x$source %!=% "mainTerm/title"
    ),
    colnames(x) %!=% "entity"
  )

  x <- av_(x, row = collapse::seq_row(x))

  x <- collapse::fgroup_by(x, entry) |>
    collapse::mtt(
      lvl = fill_(lvl),
      lid = csum_(field == "level"),
      lid = ifelse_(cheapr::is_na(lvl), NA_integer_, lid)
    ) |>
    collapse::fungroup()

  COLS <- c(
    "row",
    "entry",
    "letter",
    "lvl",
    "lid",
    "field",
    "value",
    "term",
    "source"
  )

  x <- ss_(x, col = match_(COLS, colnames(x)))

  list(
    non = index_non_level(x),
    lvl = index_levels(x)
  )
}

#' @noRd
index_non_level <- function(x) {
  i <- cheapr::intersect_(cheapr::which_na(x$lvl), cheapr::which_na(x$lid))

  non <- ss_(x, i, colnames(x) %!iin% c("lvl", "lid", "source"))

  i <- count_(non$entry)
  i <- funique_(pull_(ss_(i, i$count > 1L), "key"))

  single <- ss_(non, non$entry %!iin% i)
  multi <- ss_(non, non$entry %iin% i)

  COLS <- c("use", "see")
  usee <- ss_(single, single$field %iin% COLS)
  code <- ss_(single, single$field %!iin% COLS)
  unique(code$field)

  collapse::gv(code, "field") <- cheapr::paste_(
    cheapr::val_match(
      code$field,
      "code" ~ "code::",
      "tab" ~ "table::",
      "see/tab" ~ "see::table::",
      "codes" ~ "row::",
      "see/codes" ~ "see::row::",
      "use/tab" ~ "use::table::",
      .default = code$field
    ),
    code$value
  )

  collapse::setrename(usee, field = "action")
  collapse::setrename(code, field = "action")
  collapse::gv(code, "value") <- NULL

  single <- rbind_(usee, code, fill_in = TRUE) |>
    rorderv_(c("row", "letter", "entry")) |>
    collapse::colorderv(c(
      "row",
      "entry",
      "letter",
      "term",
      "action",
      "value"
    ))

  usee <- ss_(multi, multi$field %iin% COLS)
  code <- ss_(multi, multi$field %!iin% COLS)
  collapse::gv(code, "field") <- cheapr::paste_(
    cheapr::val_match(
      code$field,
      "code" ~ "code::",
      "tab" ~ "table::",
      "see/tab" ~ "see::table::",
      "codes" ~ "row::",
      "see/codes" ~ "see::row::",
      "use/tab" ~ "use::table::",
      .default = code$field
    ),
    code$value
  )

  collapse::setrename(usee, field = "action")
  collapse::setrename(code, field = "action")
  collapse::gv(code, "value") <- NULL

  multi <- rbind_(usee, code, fill_in = TRUE) |>
    rorderv_(c("row", "letter", "entry")) |>
    collapse::colorderv(c(
      "row",
      "entry",
      "letter",
      "term",
      "action",
      "value"
    ))

  # multi <- collapse::join(
  #   usee,
  #   code,
  #   how = "full",
  #   on = c("entry", "letter"),
  #   verbose = 0L,
  #   overid = 0L
  # ) |>
  #   rorderv_(c("row", "letter", "entry")) |>
  #   collapse::colorderv(c(
  #     "row",
  #     "entry",
  #     "letter",
  #     "term",
  #     "action",
  #     "value",
  #     "action_code",
  #     "code"
  #   ))

  non <- rbind_(single, multi, fill_in = TRUE) |>
    rorderv_(c("row", "letter", "entry"))

  return(non)

  # collapse::gv(non, "action") <- ifelse_(
  #   !cheapr::is_na(non$action_code),
  #   non$action_code,
  #   non$action
  # )
  #
  # ss_(non, col = colnames(non) %!=% "action_code")
}

#' @noRd
index_levels <- function(x) {
  i <- cheapr::intersect_(
    cheapr::which_not_na(x$lvl),
    cheapr::which_not_na(x$lid)
  )
  x <- ss_(x, i, colnames(x) %!iin% c("source"))

  collapse::gv(x, "field") <- cheapr::val_match(
    x$field,
    "code" ~ "use::code::",
    "tab" ~ "see::table::",
    "see/tab" ~ "see::table::",
    "codes" ~ "see::row::",
    "see/codes" ~ "see::row::",
    "use/tab" ~ "use::table::",
    .default = x$field
  )

  lvl4_ <- funique_(ss_(x, x$lvl %==% 4L)$entry)
  lvl_4 <- ss_(x, x$entry %iin% lvl4_)
  non_4 <- ss_(x, x$entry %!iin% lvl4_)

  lvl3_ <- funique_(ss_(non_4, non_4$lvl %==% 3L)$entry)
  lvl_3 <- ss_(non_4, non_4$entry %iin% lvl3_)
  non_3 <- ss_(non_4, non_4$entry %!iin% lvl3_)

  lvl2_ <- funique_(ss_(non_3, non_3$lvl %==% 2L)$entry)
  lvl_2 <- ss_(non_3, non_3$entry %iin% lvl2_)
  non_2 <- ss_(non_3, non_3$entry %!iin% lvl2_)

  lvl1_ <- funique_(ss_(non_2, non_2$lvl %==% 1L)$entry)
  lvl_1 <- ss_(non_2, non_2$entry %iin% lvl1_)
  lvl_1 <- ss_(lvl_1, lvl_1$field %!=% "level", colnames(lvl_1) %!iin% c("lvl"))

  list(
    `4` = lvl_4,
    `3` = lvl_3,
    `2` = lvl_2,
    `1` = lvl_1
  )
}

#' @noRd
process_tables <- function() {
  x <- load_parquet(profile = "tables")
  COLS <- c("record_index", "entity", "field", "value")
  i <- match_(COLS, colnames(x))
  x <- ss_(x, x$field %!iin% c("definition", "values"), i)

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

  COLS <- c(
    "section",
    "axis",
    "name",
    "record_index",
    "entity",
    "field",
    "value"
  )

  x <- ss_(x, x$entity %!=% "section", match_(COLS, colnames(x)))
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

  runs <- count_(pull_(ss_(x, x$entry), "run"))
  runs <- pull_(ss_(runs, runs$count > 1L), "key")

  xrun <- ss_(x, x$run %iin% runs)
  x <- ss_(x, x$run %!iin% runs)

  if (nrow_(xrun) > 0L) {
    x <- rbind_(
      x,
      collapse::gby(xrun, run) |>
        collapse::mtt(value = cheapr::paste_(value, collapse = " | ")) |>
        funique_(cols = "run") |>
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

  i <- count_(x$entry)
  i <- ss_(i, i$count > 1L) |> pull_("key")

  rbind_(
    ss_(x, x$entry %!iin% i),
    ss_(x, x$entry %iin% i) |>
      collapse::gby(entry, term) |>
      collapse::mtt(includes = cheapr::paste_(includes, collapse = " | ")) |>
      collapse::fungroup() |>
      funique_()
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
