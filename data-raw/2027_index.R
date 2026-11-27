#    entry letter term                            act   value                      code
#  * <int> <chr>  <chr>                           <chr> <chr>                      <chr>
#  1     2 3      3M(tm) V.A.C.(R) Therapy System See   Activities of Daily Living F08
#  2     6 A      Abdominohysterectomy            See   Resection, Uterus          0UT9
#  3    28 A      Achillorrhaphy                  See   Repair, Tendons            0LQ
#  4    38 A      Activa PC neurostimulator       Use   Stimulator Generator, Mult 0JH
#  5    39 A      Activa RC neurostimulator       Use   Stimulator Generator, Mult 0JH
#  6    40 A      Activa SC neurostimulator       Use   Stimulator Generator, Sing 0JH
#  7    52 A      Adenoidotomy                    See   Drainage, Adenoids         0C9Q
#  8    57 A      Adrenalorrhaphy                 See   Repair, Endocrine System   0GQ
#  9    58 A      Adrenalotomy                    See   Drainage, Endocrine System 0G9
# 10    60 A      Advisa (MRI)                    Use   Pacemaker, Dual Chamber in 0JH

library(procedural)
library(tibble)

x <- process_index()

# collapse::fgroup_by(x, entry) |>
#   collapse::mtt(
#     lvl = fill_(lv),
#     lid = csum_(field == "level") / 10 + entry,
#     lid = as.character(lid),
#     lid = ifelse_(cheapr::is_na(lvl), NA_character_, lid),
#     lvl = NULL
#   ) |>
#   print(n = 50)
#
#
# level_by_entry <- ss_(
#   x,
#   cheapr::which_not_na(x$lv),
#   colnames(x) %iin% c("id", "entry", "lv")
# ) |>
#   collapse::funique()
#
# av_(level_by_entry, id2 = cheapr::lag_(level_by_entry$id, -1L))
# collapse::rsplit(level_by_entry, ~entry)
# Entry <- ss_(x, x$field %==% "level") |> pull_("entry") |> cheapr::unique_()
# ss_(x, x$entry %iin% Entry)

# data transformation -----------------------------------------------------

## Simple Example: letter == "3" -------------------------------------------
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

## Level Example: letter == "G" --------------------------------------------
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

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_index, overwrite = TRUE)
