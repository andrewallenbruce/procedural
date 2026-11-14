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
x$name <- if_else_(
  x$entity == "section" & x$field == "title",
  x$value,
  NA_character_
) |>
  lag_(-1L) |>
  vec_fill_missing()
x$axis <- if_else_(
  x$entity == "axis" & x$value_kind == "attribute",
  x$value,
  NA_character_
)
x$title <- if_else_(
  x$entity == "axis" & x$field == "title",
  x$value,
  NA_character_
) |>
  lag_(-1L)
pcs_definitions <- colorderv(x, c("section", "name", "axis", "title"))

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_definitions, overwrite = TRUE)

# data transform ----------------------------------------------------------
def = pcs_definitions
def <- ss(
  def,
  def$entity %!=% "section",
  j = c(1:6, 8:9)
) |>
  rsplit(~record_index)

def <- map(def, \(x) {
  x$axis <- vec_fill_missing(x$axis)
  x$title <- vec_fill_missing(x$title)

  x <- ss(x, x$entity %!=% "axis")
  x$field <- if_else_(
    x$entity == "axis/terms/includes",
    "includes",
    x$field
  )
  x <- av(
    x,
    entry = x$entity == "axis/terms/title",
    pos = "front"
  )
  x <- av(x, run = vec_identify_runs(x$entry), pos = "front")

  runs <- ss(x, x$entry) |> fcount(run) |> sbt(N > 1L) |> _$run

  x$entry <- NULL

  x1 <- ss(x, x$run %!iin% runs)

  x2 <- ss(x, x$run %iin% runs)

  if (nrow(x2) != 0L) {
    x2 <- x2 |>
      fgroup_by(run) |>
      fmutate(value = paste_(value, collapse = " | ")) |>
      funique(cols = "run") |>
      fungroup()

    x1 <- vec_rbind(x1, x2) |>
      roworderv("run")
  }

  x1$run <- NULL
  x1$entity <- NULL
  return(x1)
})

pcs_definitions <- collapse::rowbind(def) |> cheapr::unique_()
