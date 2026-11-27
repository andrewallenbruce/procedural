library(procedural)
library(tibble)

x <- process_order()

usethis::use_data(pcs_order, overwrite = TRUE)

# data transformation -----------------------------------------------------
x <- procedural::pcs_order

# table
y <- ss_(x, x$valid %==% 0L, colnames(x) %!=% "valid")
collapse::setrename(y, order = "start", code = "table")
y <- av_(y, end = cheapr::lag_(y$start, -1L) - 1L)
y$end <- ifelse_(cheapr::is_na(y$end), collapse::fmax(x$order), y$end)
y <- av_(y, codes = y$end - y$start)
y <- collapse::colorderv(y, c("start", "end", "codes", "table"))
y

# system
s <- ss_(x, x$valid %==% 0L, colnames(x) %!=% "valid")
collapse::setrename(s, order = "tab_start", code = "tab_code")
s <- collapse::av(s, system = substr(s$tab_code, 1L, 2L))
s <- collapse::gby(s, system) |>
  collapse::mtt(
    start = collapse::fmin(tab_start),
    end = collapse::fmax(tab_start)
  ) |>
  collapse::fungroup() |>
  collapse::colorderv(c("start", "end", "system", "description"))

collapse::gvr(s, "^tab_") <- NULL
s <- collapse::funique(s, cols = c("start", "end", "system"))
s <- av_(s, codes = s$end - s$start)
s <- collapse::colorderv(s, c("start", "end", "codes", "system", "description"))
s$codes <- ifelse_(s$codes == 0L, 1L, s$codes)

# section
o <- ss_(x, x$valid %==% 0L, colnames(x) %!=% "valid")
collapse::setrename(o, order = "start")
o <- av_(
  o,
  section = substr(o$code, 1L, 1L),
  end = cheapr::lag_(o$start, -1L) - 1L
)
o <- ss_(o, col = colnames(o) %!=% "code")
o <- collapse::gby(o, section) |>
  collapse::mtt(
    start = collapse::fmin(start),
    end = collapse::fmax(end)
  ) |>
  collapse::fungroup()
o <- av_(o, codes = o$end - o$start)
o <- collapse::funique(o, cols = c("start", "end", "section"))
o <- collapse::colorderv(o, c("start", "end", "codes", "section", "description"))


y |> print(n = 200) # table
s |> print(n = 200) # system
o |> print(n = 200) # section
ss_(x, grep("^X", x$code)) |>
  # tail() |>
  head()
