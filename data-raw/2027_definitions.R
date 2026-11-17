# load libraries ----------------------------------------------------------

library(collapse)
library(cheapr)
library(vctrs)
library(purrr)

# data rectangling --------------------------------------------------------

xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index",
  "icd10pcs_definitions_2027",
  ext = "xml"
)
prof <- xmlrectr::xml_profile(rows = "ICD10PCS.definitions/section")
spec <- xmlrectr::compile_xml_profile(prof, xml)
rect <- xmlrectr::rectangle_xml(xml, spec, parallel = TRUE)
x <- collapse::ss(rect, j = c(2L, 4:6, 8:14))

# map function ------------------------------------------------------------

process <- function(x) {
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

# data transformation -----------------------------------------------------
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

x <- collapse::ss(
  x,
  x$entity %!=% "section",
  c(1:5, 7:8)
) |>
  collapse::rsplit(~record_index) |>
  purrr::map(process) |>
  collapse::rowbind() |>
  cheapr::unique_()

x <- collapse::av(x, entry = collapse::fcumsum(x$field == "value"))
x$axis <- as.integer(x$axis)

term <- collapse::ss(x, x$field %==% "value", c(1:4, 6L))
term <- collapse::rnm(term, value = "term")

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

x$field <- stringr::str_to_title(x$field)
pcs_definitions <- x

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_definitions, overwrite = TRUE)
