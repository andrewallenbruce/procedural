## code to prepare `order` dataset goes here
library(tidyverse)

ord <- "D:\\icd_10_pcs_2024\\Zip File 4 2024 ICD-10-PCS Order File (Long and Abbreviated Titles)\\icd10pcs_order_2024.txt"
ord <- readr::read_fwf(ord)
names(ord) <- c('order', 'code', 'valid', 'description_short', 'description_long')

# ord |> filter(order %in% c(ord[ord$code == "XX2", ]$order:nrow(ord)))

ord_min <- ord |>
  select(order, code) |>
  mutate(order = as.integer(order))

########________________________________________
board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(ord,
                         name = "order",
                         description = "ICD-10-PCS Order File 2024",
                         type = "qs")

board |> pins::pin_write(ord_min,
                         name = "order_minimum",
                         description = "ICD-10-PCS Order File 2024, order and codes only",
                         type = "qs")

board |> pins::write_board_manifest()

