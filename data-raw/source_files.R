library(janitor)
library(tidyverse)
library(qs)
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

## Order File ------------------------------
ord <- "D:\\icd_10_pcs_2024\\Zip File 4 2024 ICD-10-PCS Order File (Long and Abbreviated Titles)\\icd10pcs_order_2024.txt"

ord <- readr::read_fwf(ord)

names(ord) <- c('order', 'code', 'valid', 'description_short', 'description_long')

ord <- ord |>
  mutate(order = as.integer(order),
         valid = as.integer(valid))

## Tables File ------------------------------
table <- qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_tables_2024") |>
  tibble() |>
  clean_names() |>
  filter(elem %nin% c("version", "ICD10PCS.tabular")) |>
  select(-level1) |>
  mutate(rowid = row_number(), .before = 1)



## Index File ------------------------------
# index <- "E:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_index_2024.xml"
index <- qs::qread("F:\\icd_10_pcs_2024\\converted_xml\\pcs_index") |>
  tibble() |>
  clean_names()

## Definitions File ------------------------------
definition <- qs::qread("D:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_definition_2024") |>
  tibble() |>
  clean_names()

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |>
  pins::pin_write(ord,
                  name = "source_order",
                  description = "ICD-10-PCS 2024 Order-Source",
                  type = "qs")

board |>
  pins::pin_write(table,
                  name = "source_table",
                  description = "ICD-10-PCS Tables & Rows-Source",
                  type = "qs")

board |>
  pins::pin_write(index,
                  name = "source_index",
                  description = "ICD-10-PCS 2024 Index-Source",
                  type = "qs")

board |>
  pins::pin_write(definition,
                  name = "source_definitions",
                  description = "ICD-10-PCS 2024 Definitions-Source",
                  type = "qs")

board |> pins::write_board_manifest()
