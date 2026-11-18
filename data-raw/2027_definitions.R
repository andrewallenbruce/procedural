# load libraries ----------------------------------------------------------

library(collapse)
library(cheapr)
library(vctrs)
library(purrr)

# data rectangling --------------------------------------------------------

definition_file <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index",
  "icd10pcs_definitions_2027",
  ext = "xml"
)

x <- procedural:::process_definitions(definition_file)

x <- collapse::ss(
  procedural::pcs_definitions,
  procedural::pcs_definitions$field %==% "Definition",
  colnames(procedural::pcs_definitions) %!=% "field"
)

x <- collapse::rnm(x, value = "definition")

y <- collapse::ss(
  procedural::pcs_definitions,
  procedural::pcs_definitions$field %==% "Explanation",
  colnames(procedural::pcs_definitions) %!=% "field"
)

x <- collapse::join(x, y, on = c("entry", "section", "axis", "name", "term"))
x$definition <- cheapr::paste_(x$definition, ".")
x$definition <- cheapr::if_else_(
  !cheapr::is_na(x$value),
  cheapr::paste_(x$definition, " ", x$value, "."),
  x$definition
)
pcs_definitions <- collapse::ss(x, j = -7L)
## use_data ---------------------------------------------------------------

usethis::use_data(pcs_definitions, overwrite = TRUE)

# includes ----------------------------------------------------------------

x <- collapse::ss(
  procedural::pcs_definitions,
  procedural::pcs_definitions$field %==% "Includes",
  colnames(procedural::pcs_definitions) %!=% "field"
)

x <- collapse::rnm(x, value = "includes")
i <- cheapr::counts(x$entry)
i <- collapse::ss(i, i$count > 1L) |> _$key
x <- collapse::rowbind(
  collapse::ss(x, x$entry %!iin% i),
  collapse::ss(x, x$entry %iin% i) |>
    collapse::gby(entry, term) |>
    collapse::mtt(includes = cheapr::paste_(includes, collapse = " | ")) |>
    collapse::fungroup() |>
    collapse::funique()
) |>
  collapse::roworderv(c("entry"))

pcs_includes <- x
## use_data ---------------------------------------------------------------

usethis::use_data(pcs_includes, overwrite = TRUE)

# table_definition --------------------------------------------------------

# start with the parsed 2027 tables XML file
tables_file <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index",
  "icd10pcs_tables_2027",
  ext = "xml"
)

x <- procedural:::process_xml(tables_file, profile = "tables")
d <- collapse::ss(x, x$field %==% "definition")
i <- whichv_(
  x$record_index %in_%
    cheapr::unique_(d$record_index) &
    x$entity_index %in_% cheapr::unique_(d$entity_index)
)

x <- collapse::ss(x, i)
i <- whichv_(x$entity == "axis" & x$field != "values")
x <- collapse::ss(x, i, c(1L, 4:5))

extract_field <- function(x, name) {
  x <- collapse::ss(x, x$field %==% name, -2L)
  collapse::setrename(x, value = name)
  if (name == "pos") {
    collapse::settfmv(x, "pos", as.integer)
  }
  return(x)
}

tables_definition <- cheapr::fast_df(
  entry = pos$record_index,
  pos = extract_field(x, "pos"),
  title = extract_field(x, "title"),
  code = extract_field(x, "code"),
  label = extract_field(x, "label"),
  definition = extract_field(x, "definition")
) |>
  collapse::qTBL()

usethis::use_data(tables_definition, overwrite = TRUE)
