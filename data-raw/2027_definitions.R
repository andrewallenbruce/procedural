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
  x[["axis"]] <- vec_fill_missing(x[["axis"]])
  x[["title"]] <- vec_fill_missing(x[["title"]])
  x <- ss(x, x[["entity"]] %!=% "axis")
  x[["field"]] <- if_else_(
    x[["entity"]] == "axis/terms/includes",
    "includes",
    x[["field"]]
  )
  x <- av(
    x,
    term = if_else_(
      x[["entity"]] == "axis/terms/title",
      1L,
      NA_character_
    ),
    entry = cumsum(x[["entity"]] == "axis/terms/title"),
    pos = "front"
  )
  av(x, run = vec_identify_runs(x[["term"]]), pos = "front")
})

ss(def$`1`, def$`1`$term == 1L) |>
  print(n = 200)

pcs_definitions$`1` |> print(n = 200)
