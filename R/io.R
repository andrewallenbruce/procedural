#' @noRd
process_order_file <- function(path) {
  x <- readr::read_fwf(
    file = path,
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

  cheapr::col_c(
    collapse::num_vars(x),
    collapse::cat_vars(x)
  )
}

#' @noRd
process_index_file <- function(path) {
  collapse::ss(
    xmlrectr::rectangle_xml(
      file = path,
      xmlrectr::compile_xml_profile(
        profile = xmlrectr::xml_profile(rows = "ICD10PCS.index/letter"),
        sample = path
      ),
      parallel = TRUE
    ),
    j = c(2L, 4:6, 8:14)
  )
}

#' @noRd
process_tables_file <- function(path) {
  x <- xmlrectr::rectangle_xml(
    file = path,
    spec = xmlrectr::compile_xml_profile(
      profile = xmlrectr::xml_profile(rows = "ICD10PCS.tabular/pcsTable"),
      sample = path
    ),
    parallel = TRUE
  )

  x <- collapse::ss(x, j = c(2L, 4:6, 8:14))
  x <- collapse::ss(x, x$field %!=% "definition", c(1:2, 4:5))
  x <- collapse::rnm(x, table = "record_index")
  x$field <- cheapr::if_else_(
    x$field == "label/code",
    "code",
    x$field
  )
  x <- collapse::rsplit(x, ~table, keep.by = TRUE) # 918 tables

  # map function ------------------------------------------------------------
  process_table <- function(x) {
    table <- collapse::ss(
      x,
      x$entity == "axis" & x$field != "values",
      3:4
    ) |>
      collapse::rsplit(~field) |>
      collapse::qTBL() |>
      collapse::colorderv(c("pos", "title", "code", "label"))

    rows <- collapse::ss(
      x,
      x$entity %!in_% c("axis", "pcsRow") & x$field != "values",
      3:4
    )

    rows$field <- cheapr::if_else_(
      rows$field == "value",
      "label",
      rows$field
    )

    rows <- collapse::av(
      rows,
      row = collapse::fcumsum(rows$field == "pos"),
      pos = "front"
    )
    rows <- collapse::rsplit(rows, ~row)
    rows <- purrr::map(rows, function(x) {
      cheapr::col_c(
        cheapr::fast_df(
          pos = collapse::ss(x, x$field %==% "pos") |> pull_("value"),
          title = collapse::ss(x, x$field %==% "title") |> pull_("value")
        ),
        cheapr::fast_df(
          code = collapse::ss(x, x$field %==% "code") |> pull_("value"),
          label = collapse::ss(x, x$field %==% "label") |> pull_("value")
        )
      )
    }) |>
      collapse::rowbind() |>
      collapse::qTBL()

    res <- collapse::rowbind(table, rows)
    collapse::av(
      res,
      table = rep.int(x$table[1L], collapse::fnrow(res)),
      pos = "front"
    )
  }
  # end function ------------------------------------------------------------

  x <- purrr::map(x, process_table) |>
    collapse::rowbind()

  collapse::settfmv(x, "pos", as.integer)

  return(x)
}

#' @noRd
process_definition_file <- function(path) {
  x <- xmlrectr::rectangle_xml(
    file = path,
    spec = xmlrectr::compile_xml_profile(
      profile = xmlrectr::xml_profile(
        rows = "ICD10PCS.definitions/section"
      ),
      sample = path
    ),
    parallel = TRUE
  )

  x <- collapse::ss(x, j = c(2L, 4:6, 8:14))

  x <- collapse::av(
    x,
    section = cheapr::if_else_(
      x$entity == "section" & x$value_kind == "attribute",
      x$value,
      NA_character_
    ) |>
      vctrs::vec_fill_missing(),
    axis = cheapr::if_else_(
      x$entity == "axis" & x$value_kind == "attribute",
      x$value,
      NA_character_
    ),
    name = cheapr::if_else_(
      x$entity == "axis" & x$field == "title",
      x$value,
      NA_character_
    ) |>
      cheapr::lag_(-1L),
    pos = "front"
  )

  # map function ------------------------------------------------------------
  process_definition <- function(x) {
    x$axis <- vctrs::vec_fill_missing(x$axis)
    x$name <- vctrs::vec_fill_missing(x$name)
    x$field <- cheapr::if_else_(
      x$entity == "axis/terms/includes",
      "includes",
      x$field
    )
    x <- collapse::ss(x, x$entity %!=% "axis")
    x <- collapse::av(x, entry = x$entity == "axis/terms/title")
    x <- collapse::av(x, run = vctrs::vec_identify_runs(x$entry))

    # runs <- collapse::ss(x, x$entry) |> pull_("run") |> cheapr::counts()
    # runs <- collapse::ss(runs, runs$count > 1L) |> pull_("key")

    runs <- collapse::ss(x, x$entry) |>
      collapse::fcount(run) |>
      collapse::sbt(N > 1L) |>
      _$run

    xrun <- collapse::ss(x, x$run %iin% runs)
    x <- collapse::ss(x, x$run %!iin% runs)

    if (nrow_(xrun)) {
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
  # end function -----------------------------------------------------

  x <- collapse::ss(
    x,
    x$entity %!=% "section",
    c(1:5, 7:8)
  ) |>
    collapse::rsplit(~record_index) |>
    purrr::map(process_definition, .progress = TRUE) |>
    collapse::rowbind() |>
    cheapr::unique_()

  x <- collapse::av(
    x,
    entry = collapse::fcumsum(x$field == "value")
  )
  collapse::settfmv(x, "axis", as.integer)

  term <- collapse::ss(x, x$field %==% "value", c(1:4, 6L))
  collapse::setrename(term, value = "term")

  x <- collapse::join(
    collapse::ss(x, x$field %!=% "value"),
    term,
    on = c("entry", "section", "axis", "name"),
    multiple = TRUE,
    overid = 0
  ) |>
    collapse::colorderv(
      c("entry", "section", "axis", "name", "term")
    )

  collapse::settfmv(x, "field", stringr::str_to_title)
  return(x)
}
