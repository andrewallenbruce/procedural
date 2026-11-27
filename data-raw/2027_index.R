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

x <- procedural:::process_index()
x$non$act <- ifelse_(
  !cheapr::is_na(x$non$code),
  cheapr::paste_(x$non$act, cheapr::paste_(" <[", x$non$code, "]>")),
  x$non$act
)

codes <- ss_(x$lvl$`1`, grep("::", x$lvl$`1`$field, fixed = TRUE))
act <- ss_(x$lvl$`1`, grep("::", x$lvl$`1`$field, fixed = TRUE, invert = TRUE))

i_title <- ss_(x$lvl$`1`, x$lvl$`1`$field %==% "title") |>
  _$entry |>
  cheapr::unique_()

s <- ss_(x$lvl$`1`, x$lvl$`1`$entry %iin% i_title) |> collapse::rsplit(~field)
ss_(s$title, )


print(n = 200)
codes <- ss_(x$lvl$`1`, grep("::", x$lvl$`1`$field, fixed = TRUE)) |>
  collapse::rnm(field = "act::code", value = "code") |>
  collapse::mtt(uid = cheapr::paste_(entry, letter, lid)) |>
  collapse::slt(c(
    "uid",
    "row",
    "entry",
    "letter",
    "act::code",
    "code",
    "term"
  )) |>
  collapse::roworderv(c("letter", "entry", "row"))

act <- ss_(
  x$lvl$`1`,
  grep("::", x$lvl$`1`$field, fixed = TRUE, invert = TRUE)
) |>
  collapse::rnm(field = "act") |>
  collapse::mtt(uid = cheapr::paste_(entry, letter, lid)) |>
  collapse::slt(c("uid", "row", "entry", "letter", "act", "value", "term")) |>
  collapse::roworderv(c("letter", "entry", "row"))

lvl_1 <- collapse::join(
  lv1_2,
  ss_(lv1_1, col = colnames(lv1_1) %!iin% c("row", "term")),
  on = c("uid", "entry", "letter"),
  how = "full",
  multiple = TRUE,
  overid = 0L,
  verbose = 0L
) |>
  collapse::colorderv(c(
    "row",
    "letter",
    "entry",
    "term",
    "act",
    "value",
    "act::code",
    "code"
  ))
lvl_1 <- ss_(lvl_1, col = colnames(lvl_1) %!iin% c("uid"))

funique_(lvl_1$act) |> print(n = 300)

collapse::rsplit(lvl_1, ~letter)

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
