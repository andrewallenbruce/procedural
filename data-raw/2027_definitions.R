# load libraries ----------------------------------------------------------

library(xmlrectr)
library(collapse)
library(cheapr)
library(vctrs)
library(purrr)

# data rectangling --------------------------------------------------------

xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index"
)
def_xml <- fs::path(xml, "icd10pcs_definitions_2027", ext = "xml")
def_xsd <- fs::path(xml, "icd10pcs_definitions", ext = "xsd")
def_prop <- propose_xml_profile(def_xml, xsd = def_xsd)
def_prof <- xml_profile(rows = "ICD10PCS.definitions/section")
def_spec <- compile_xml_profile(def_prof, def_xml)
def_rect <- rectangle_xml(def_xml, def_spec, parallel = TRUE)
x <- ss(def_rect, j = c(2L, 4:6, 8:14))

# data transformation -----------------------------------------------------

x$section <- if_else_(
  x$entity == "section" & x$value_kind == "attribute",
  x$value,
  NA_character_
) |>
  vec_fill_missing()
x$axis <- if_else_(
  x$entity == "axis" & x$value_kind == "attribute",
  x$value,
  NA_character_
)
x$name <- if_else_(
  x$entity == "axis" & x$field == "title",
  x$value,
  NA_character_
) |>
  lag_(-1L)

x <- colorderv(x, c("section", "axis", "name"))

x <- ss(x, x$entity %!=% "section", c(1:5, 7:8)) |>
  rsplit(~record_index)

# map function ------------------------------------------------------------

process <- function(x) {
  x$axis <- vec_fill_missing(x$axis)
  x$name <- vec_fill_missing(x$name)
  x$field <- if_else_(
    x$entity == "axis/terms/includes",
    "includes",
    x$field
  )
  x <- ss(x, x$entity %!=% "axis")
  x$entry <- x$entity == "axis/terms/title"
  x$run <- vec_identify_runs(x$entry)

  runs <- ss(x, x$entry) |>
    fcount(run) |>
    sbt(N > 1L) |>
    _$run

  xrun <- ss(x, x$run %iin% runs)
  x <- ss(x, x$run %!iin% runs)

  if (nrow(xrun) > 0L) {
    x <- rowbind(
      x,
      gby(xrun, run) |>
        mtt(value = paste_(value, collapse = " | ")) |>
        funique(cols = "run") |>
        fungroup()
    ) |>
      roworderv("run")
  }

  gv(x, c("run", "entry", "entity")) <- NULL

  return(x)
}

# final steps -------------------------------------------------------------

x <- map(x, process) |>
  rowbind() |>
  unique_()

x <- av(x, entry = cumsum(x$field == "value"), pos = "front")
x$axis <- as.integer(x$axis)

pcs_definitions <- x

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_definitions, overwrite = TRUE)
