# DEBUG ####

x <- NULL
x <- "0"
x <- "00"
x <- "001"
x <- "0016"
x <- "00160"
x <- "001607"
x <- "0016070"


.pcs_section(x) |>
  .pcs_system() |>
  .pcs_operation() |>
  .pcs_part() |>
  .pcs_approach() |>
  .pcs_device() |>
  .pcs_qualifier() |>
  .pcs_finisher()

# ADD-ONS ####

# TODO Axis 3 Definition
x$definitions <- switch(
  stringfish::sf_substr(x$input, 1, 1),
  'D' = dplyr::tibble(label = character(0),
                      definition = character(0)),
  definitions(section = stringfish::sf_substr(x$input, 1, 1),
              axis = "3",
              col = "value",
              search = stringfish::sf_substr(x$input, 3, 3),
              display = TRUE))

# TODO Axis 4 Includes
x$includes <- switch(
  stringfish::sf_substr(x$input, 1, 1),
  "0" = ,
  "3" = ,
  "F" = ,
  "G" = ,
  "X" = includes(section = stringfish::sf_substr(x$input, 1, 1),
                 axis = "4",
                 col = "label",
                 search = fuimus::delister(x$head[4, 4])),
  dplyr::tibble(section = character(0),
                axis = character(0),
                name = character(0),
                label = character(0),
                includes = character(0)))


# TODO Axis 5 Definition
x$definitions <- switch(
  stringfish::sf_substr(x$input, 1, 1),
  "0" = ,
  "1" = ,
  "2" = ,
  "3" = ,
  "4" = ,
  "7" = ,
  "8" = ,
  "9" = ,
  "F" = ,
  "X" = vctrs::vec_rbind(
    x$definitions,
    definitions(
      section = stringfish::sf_substr(x$input, 1, 1),
      axis = "5",
      col = "value",
      search = stringfish::sf_substr(x$input, 5, 5),
      # col = "label",
      # search = delister(x$head[5, 4])
      display = TRUE)
  ),
  vctrs::vec_rbind(
    x$definitions,
    dplyr::tibble(label = character(0),
                  definition = character(0))))

# TODO Axis 6 Includes
x$includes <- switch(
  stringfish::sf_substr(x$input, 1, 1),
  "0" = ,
  "3" = ,
  "F" = ,
  "G" = ,
  "X" = vctrs::vec_rbind(
    x$includes,
    includes(section = stringfish::sf_substr(x$input, 1, 1),
             axis = "4",
             col = "label",
             search = fuimus::delister(x$head[6, 4]))
  ),
  vctrs::vec_rbind(
    x$includes,
    dplyr::tibble(section = character(0),
                  axis = character(0),
                  name = character(0),
                  label = character(0),
                  includes = character(0))))


# PINS ####
vec <- get_pin("tables_order") |>
  dplyr::pull(row)

tbls <- collapse::funique(vec)

vctrs::vec_size(tbls)
northstar::construct_regex2(tbls)

sections()

systems() |>
  dplyr::count(value) |>
  dplyr::pull(value) |>
  northstar::construct_regex2()

get_pin("tables_rows")



get_pin("rowbase")

get_pin("pcs_tbl3")

get_pin("pcs_tbl2")


get_pin("index_v1")
get_pin("index_v2")
get_pin("newindex_ind2")
get_pin("newindex_ind3")
get_pin("newindex_usesee")
