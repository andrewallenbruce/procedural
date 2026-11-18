# load libraries ----------------------------------------------------------

library(collapse)
library(cheapr)
library(vctrs)
library(purrr)

# data rectangling --------------------------------------------------------
index_file <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index",
  "icd10pcs_index_2027",
  ext = "xml"
)

x <- procedural:::process_index(index_file)
# use_data ----------------------------------------------------------------

usethis::use_data(pcs_index, overwrite = TRUE)

# data transformation -----------------------------------------------------
x <- procedural::pcs_index
x <- collapse::rsplit(x, ~letter, keep.by = TRUE)

# Simple Example: letter == "3" -------------------------------------------
x3 <- collapse::av(
  x$`3`,
  entry = collapse::fcumsum(x$`3`$source == "mainTerm/title"),
  term = cheapr::if_else_(
    x$`3`$source == "mainTerm/title",
    x$`3`$value,
    NA_character_
  ) |>
    vctrs::vec_fill_missing(),
  pos = "front"
)
x3 <- collapse::ss(x3, x3$source %!=% "mainTerm/title", c(1L, 3L, 2L, 5:6))

# Level Example: letter == "G" --------------------------------------------
xG <- collapse::av(
  x$G,
  entry = collapse::fcumsum(x$G$source == "mainTerm/title"),
  term = cheapr::if_else_(
    x$G$source == "mainTerm/title",
    x$G$value,
    NA_character_
  ) |>
    vctrs::vec_fill_missing(),
  pos = "front"
)

xG <- collapse::ss(xG, xG$source %!=% "mainTerm/title", c(3L, 1L, 2L, 5:7))
# collapse::ss(xG, xG$field %==% "level") |> _$value |> cheapr::unique_()

# Split Entries with and without levels -----------------------------------
has_level <- collapse::ss(xG, xG$field %==% "level") |>
  _$entry |>
  cheapr::unique_()
xG_level <- collapse::ss(xG, xG$entry %iin% has_level)
collapse::ss(xG_level, xG_level$value %==% "2")
collapse::ss(xG_level, xG_level$entry %iin% c(67L, 103L)) |> print(n = Inf)
xG <- collapse::ss(xG, xG$entry %!iin% has_level)


cheapr::unique_(xG_level$field)
xG_level |> print(n = 100)
