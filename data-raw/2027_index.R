library(procedural)
library(tibble)
x <- process_index()

non <- ss_(
  x,
  cheapr::is_na(x$lvl) & cheapr::is_na(x$lid),
  colnames(x) %!iin% c("lvl", "lid", "source")
)

i <- cheapr::counts(non$entry) |> collapse::qTBL()
i <- pull_(ss_(i, i$count > 1L), "key") |> unique()

non_single <- ss_(non, non$entry %!iin% i, colnames(non) %!=% "row")
non_single <- collapse::rsplit(non_single, ~field)
collapse::setrename(non_single$code, value = "code")
collapse::setrename(non_single$codes, value = "code")
collapse::setrename(non_single$tab, value = "code")
collapse::setrename(non_single$see, value = "see")
collapse::setrename(non_single$use, value = "use")
non_single$code <- rbind_(non_single$code, non_single$codes, non_single$tab)
non_single$codes <- non_single$tab <- NULL

non_single <- collapse::join(
  non_single$code,
  non_single$see,
  how = "full",
  on = c("entry", "letter", "term"),
  verbose = 0L,
  overid = 0L
) |>
  collapse::join(
    non_single$use,
    how = "full",
    on = c("entry", "letter", "term"),
    verbose = 0L,
    overid = 0L
  ) |>
  collapse::colorderv(c("entry", "letter", "term", "see", "use", "code")) |>
  rorderv_(c("letter", "entry"))

non_multi <- ss_(non, non$entry %iin% i, colnames(non) %!=% "row")
non_multi <- collapse::rsplit(non_multi, ~field)
collapse::setrename(non_multi$see, value = "see")
collapse::setrename(non_multi$`see/codes`, value = "see_code")
collapse::setrename(non_multi$`see/tab`, value = "see_code")
collapse::setrename(non_multi$use, value = "use")
collapse::setrename(non_multi$`use/tab`, value = "use_code")

non_multi$see <- collapse::join(
  non_multi$see,
  non_multi$`see/tab`,
  how = "full",
  on = c("entry", "letter", "term"),
  verbose = 0L,
  overid = 0L
) |>
  collapse::join(
    non_multi$`see/codes`,
    how = "full",
    on = c("entry", "letter", "term"),
    verbose = 0L,
    overid = 0L
  )
non_multi$`see/tab` <- non_multi$`see/codes` <- NULL

non_multi$use <- collapse::join(
  non_multi$use,
  non_multi$`use/tab`,
  how = "full",
  on = c("entry", "letter", "term"),
  verbose = 0L,
  overid = 0L
)
non_multi$`use/tab` <- NULL

non_multi$see <- collapse::av(
  non_multi$see,
  code = ifelse_(
    cheapr::is_na(non_multi$see$see_code_y) &
      !cheapr::is_na(non_multi$see$see_code),
    non_multi$see$see_code,
    non_multi$see$see_code_y
  )
)

non_multi$see$see_code_y <- non_multi$see$see_code <- NULL
collapse::setrename(non_multi$use, use_code = "code", use = "value")
non_multi$use <- collapse::av(
  non_multi$use,
  act = rep.int("Use", nrow_(non_multi$use))
)
collapse::setrename(non_multi$see, see = "value")
non_multi$see <- collapse::av(
  non_multi$see,
  act = rep.int("See", nrow_(non_multi$see))
)
non_multi <- rbind_(non_multi) |>
  rorderv_(c("letter", "entry")) |>
  collapse::colorderv(c("entry", "letter", "term", "value", "act", "code"))
non_single
x <- ss_(
  x,
  !cheapr::is_na(x$lvl) & !cheapr::is_na(x$lid),
  colnames(x) %!=% "source"
)
x <- collapse::rsplit(x, ~letter)
x$G |>
  print(n = 100)

x$G$lvl |> unique()


# g <- collapse::GRP(x, ~entry)
# av_(
#   g,
#   # lvl = fill_(g$lv),
#   lvN = csum_(g$field == "level")
# ) |>
#   print(n = 50)
#
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
