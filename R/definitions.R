#' ICD-10-PCS Definitions
#' @return [tibble()]
#' @examplesIf interactive()
#' definitions()
#' @export
definitions <- function() {

  definition <- pins::pin_read(mount_board(), "pcs_definitions")

  return(definition)
}

# library(tidyverse)
#
# tbl <- tables() |>
#   select(section, system, table, description) |>
#   rowwise() |>
#   mutate(code = splitter(table)[3],
#          name = strex::str_after_last(description, ", ")) |>
#   ungroup() |>
#   select(-system, -table, -description) |>
#   distinct() |>
#   select(code = section, axis_code = code, label = name)
#
# def <- definitions() |> filter(axis == "3")
#
# def |>
#   left_join(tbl) |>
#   select(code, section, axis, axis_code, axis_name, label, everything()) |>
#   full_join(definitions()) |>
#   print(n = Inf)
