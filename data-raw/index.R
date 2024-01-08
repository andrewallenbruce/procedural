# library(flatxml)
library(tidyverse)
library(janitor)
# index <- "E:\\icd_10_pcs_2024\\Zip File 2 2024 Code Tables and Index\\icd10pcs_index_2024.xml"
#
# pcs_index <- flatxml::fxml_importXMLFlat(index)
#
# pcs_index <- pcs_index |>
#   tibble() |>
#   clean_names()
#
# qs::qsave(pcs_index, "E:\\icd_10_pcs_2024\\converted_xml\\pcs_index")
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

pcs_index <- qs::qread("F:\\icd_10_pcs_2024\\converted_xml\\pcs_index")

pcs_index <- pcs_index[4:nrow(pcs_index), ] |>
  mutate(level1 = NULL,
         level2 = NULL,
         level3 = case_when(level3 == "title" ~ "letter", .default = level3),
         level3 = case_when(level3 == "mainTerm" ~ "main", .default = level3)) |>
  filter(elem != "mainTerm", elem != "letter") |>
  filter(!is.na(value))

idx_letter <- pcs_index |>
  filter(level3 == "letter") |>
  mutate(letter = value,
         letter_id = row_number())

pcs_index <- left_join(pcs_index, idx_letter) |>
  fill(letter, letter_id) |>
  filter(level3 != "letter") |>
  mutate(level3 = NULL)


idx_term <- pcs_index |>
  filter(level4 == "title") |>
  mutate(term = value,
         term_id = row_number())

pcs_index <- left_join(pcs_index, idx_term) |>
  fill(term, term_id) |>
  filter(level4 != "title")

# idx_lvl1 <- pcs_index |>
#   filter(attr == "level", value == "1") |>
#   mutate(level = value,
#          lvl1_id = row_number())
#
# pcs_index <- left_join(pcs_index, idx_lvl1) |>
#   fill(level, lvl1_id) |>
#   mutate(level = NULL,
#          letter_id = NULL) |>
#   mutate(attr = case_when(attr == "level" ~ value, .default = attr)) |>
#   rename(level = attr, lvl_1 = lvl1_id) |>
#   filter(level %in% c(as.character(2:5), NA))

#-------------------------------------------
pcs_index <- pcs_index |>
  mutate(level = case_when(
    attr == "level" & value == "1" ~ "1",
    attr == "level" & value == "2" ~ "2",
    attr == "level" & value == "3" ~ "3",
    attr == "level" & value == "4" ~ "4",
    attr == "level" & value == "5" ~ "5"),
    level = lag(level)) |>
  filter(is.na(attr)) |>
  mutate(attr = NULL,
         letter_id = NULL)

pcs_index <- pcs_index |>
  mutate(code = case_when(elem %in% c("code", "codes", "tab") ~ value),
         code = lead(code)) |>
  filter(elem %nin% c("code", "codes", "tab")) |>
  select(letter, term, elem, value, code, level, term_id)

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(pcs_index,
                         name = "index_v1",
                         description = "ICD-10-PCS 2024 Index v1",
                         type = "qs")

board |> pins::write_board_manifest()

#-------------------------------------------

pcs_level <- pcs_index |>
  filter(level4 == "term", level5 %in% c("title", "term")) |>
  unite("level_label", level4:level9, na.rm = TRUE, sep = "_") |>
  fill(level)

lvl_ids <- pcs_level |>
  filter(level_label %nin% c("term_term_see", "term_term_see_codes", "term_term_see_tab")) |>
  count(term_id, level) |>
  select(-n) |>
  filter(level == "2") |>
  pull(term_id)

pcs_level <- pcs_level |>
  filter(term_id %in% lvl_ids) |>
  filter(level_label %nin% c("term_term_see", "term_term_see_codes", "term_term_see_tab"))

lvl_grp_ids <- pcs_level |>
  filter(level == "1") |>
  mutate(level_group = row_number())

pcs_level <- left_join(pcs_level, lvl_grp_ids) |> fill(level_group)

sub_ids <- pcs_level |>
  filter(level_label == "term_title") |>
  mutate(subterm = value)

pcs_level <- left_join(pcs_level, sub_ids) |>
  fill(subterm) |>
  rename(subgroup = level_group) |>
  filter(level_label != "term_title")

lvl_345 <- pcs_level |>
  filter(level %in% c(as.character(3:5))) |>
  pull(term_id) |>
  unique()

level_2 <- pcs_level |>
  filter(term_id %nin% lvl_345) |>
  mutate(elem = if_else(elem == "codes", "code", elem)) |>
  select(elem, value, letter, term, term_id, subterm) |>
  pivot_wider(names_from = elem, values_from = value) |>
  unnest(cols = c(code, title)) |>
  select(letter, term, subterm, title, code, term_id)

lvl_245 <- pcs_level |>
  filter(level %in% c('2', 4:5)) |>
  pull(term_id) |>
  unique()

pcs_level |>
  filter(term_id %in% lvl_345) |>
  mutate(elem = if_else(elem == "codes", "code", elem),
         level_label = str_remove(level_label, "term_term_"),
         level_label = case_when(
           level_label == "codes" ~ "code",
           level_label == "term_codes" ~ "term_code",
           level_label == "term_term_codes" ~ "term_term_code",
           level_label == "term_term_term_codes" ~ "term_term_term_code",
           .default = level_label)) |>
  select(letter, term, subterm, value, level_label, term_id) |>
  pivot_wider(names_from = level_label, values_from = value) |>
  unnest(cols = c(title), keep_empty = TRUE) |>
  unnest(cols = c(code), keep_empty = TRUE) |>
  unnest(cols = c(term_title), keep_empty = TRUE) |>
  unnest(cols = c(term_code), keep_empty = TRUE)

###########-------------- Term Use / Table
term_use <- pcs_index |>
  filter(level4 == "term", level5 == "use") |>
  select(term, value, level4:level9, letter, term_id) |>
  unite("level", level4:level9, na.rm = TRUE, sep = "-") |>
  mutate(rowid = row_number(), .before = 1)

term_rows <- term_use |> filter(level == "term-use-tab") |> pull(term_id) |> unique()

term_use_tab <- term_use |>
  filter(term_id %in% term_rows) |>
  pivot_wider(names_from = level, values_from = value) |>
  janitor::clean_names() |>
  mutate(term_use_tab = lead(term_use_tab)) |>
  filter(!is.na(term_use_tab))

term_use <- left_join(term_use, term_use_tab) |>
  filter(level != "term-use-tab") |>
  select(-term_use, -level, -rowid)

use_tab <- pcs_index |>
  filter(level4 == "use") |>
  unite("level", level4:level9, na.rm = TRUE, sep = "-") |>
  mutate(rowid = row_number(), .before = 1) |>
  pivot_wider(names_from = level, values_from = value) |>
  janitor::clean_names() |>
  mutate(use_tab = lead(use_tab)) |>
  filter(!is.na(use)) |>
  select(term,
         value = use,
         letter,
         term_id,
         term_use_tab = use_tab)

use <- bind_rows(term_use, use_tab) |>
  arrange(term_id) |>
  rename(pcs_value = value, table = term_use_tab) |>
  mutate(type = "use")

see <- pcs_index |>
  filter(level4 == "see") |>
  unite("level", level4:level9, na.rm = TRUE, sep = "_") |>
  select(value:term_id) |>
  pivot_wider(names_from = level, values_from = value) |>
  unite("table", see_codes:see_tab, na.rm = TRUE) |>
  mutate(table = na_if(table, "")) |>
  select(term, pcs_value = see, letter, term_id, table) |>
  mutate(type = "see")

use_see <- bind_rows(use, see) |> arrange(term_id)


board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(use_see,
                         name = "use_see",
                         description = "ICD-10-PCS 2024 Index (Use/See)",
                         type = "qs")

board |> pins::write_board_manifest()



################################################
pcs_idx <- pcs_index[4:nrow(pcs_index), ] |>
  mutate(level1 = NULL) |>
  unite("level_23", level2:level3, na.rm = TRUE, sep = "-") |>
  unite("level_234", level_23:level4, na.rm = TRUE, sep = "-") |>
  unite("level_567", level5:level7, na.rm = TRUE, sep = "-") |>
  unite("level_89", level8:level9, na.rm = TRUE, sep = "-") |>
  mutate(level = dplyr::case_when(!is.na(attr) ~ value),
         level_567 = na_if(level_567, ""),
         level_89 = na_if(level_89, "")) |>
  # fill(level) |>
  # filter(!attr %in% c("level")) |>
  # mutate(attr = NULL) |>
  # filter(!is.na(value)) |>
  unite("hierarchy", level_234:level_89, na.rm = TRUE, sep = "-") |>
  mutate(elem = if_else(hierarchy == "letter-title", "letter", elem)) |>
  mutate(rowid = row_number(), .before = 1) |>
  filter(hierarchy != "letter")

idx_letter <- pcs_idx |>
  filter(elem == "letter") |>
  mutate(start = rowid,
         end = lead(rowid) - 1,
         end = dplyr::case_when(start == max(start) ~ {dplyr::slice_tail(pcs_idx) |> dplyr::pull(rowid)}, .default = end),
         letter = value)

pcs_idx <- left_join(pcs_idx, idx_letter) |>
  fill(start, end, letter) |>
  filter(elem != "letter") |>
  mutate(rowid = row_number(), .before = 1) |>
  mutate(elem = if_else(elem == "title", "term", elem)) |>
  select(-start, -end)


pcs_idx <- pcs_idx |> mutate(hierarchy = str_remove(hierarchy, "letter-mainTerm-"))

idx_title <- pcs_idx |>
  filter(hierarchy == "title") |>
  mutate(title = value,
         title_id = row_number())

left_join(pcs_idx, idx_title) |>
  fill(title, title_id) |>
  filter(elem != "term") |>
  print(n = 200)


################################################
idx_see <- pcs_idx |>
  select(rowid, elem, value, letter) |>
  filter(elem == "see") |>
  mutate(start = rowid,
         end = lead(rowid) - 1,
         end = dplyr::case_when(start == max(start) ~ {dplyr::slice_tail(pcs_idx) |> dplyr::pull(rowid)}, .default = end),
         see = value)

pcs_idx <- left_join(pcs_idx, idx_see) |>
  select(-start, -end) |>
  #filter(elem != "see") |>
  mutate(rowid = row_number(), .before = 1)

idx_use <- pcs_idx |>
  select(rowid, elem, elemid, value) |>
  filter(elem == "use") |>
  mutate(start = rowid,
         end = lead(rowid) - 1,
         end = dplyr::case_when(start == max(start) ~ {dplyr::slice_tail(pcs_idx) |> dplyr::pull(rowid)}, .default = end),
         use = value)

pcs_idx <- left_join(pcs_idx, idx_use) |>
  select(-start, -end) |>
  #filter(elem != "use") |>
  mutate(rowid = row_number(), .before = 1)

pcs_use <- pcs_idx |>
  select(rowid, elem, value, letter, use) |>
  filter(elem == "term" | elem == "use") |>
  mutate(elem = if_else(elem == "use", NA_character_, elem),
         value = if_else(is.na(elem), NA_character_, value),
         use = lead(use)) |>
  filter(!is.na(use)) |>
  fill(elem, value)

pcs_idx |>
  select(-use) |>
  filter(elem != "use") |>
  mutate(rowid = row_number(), .before = 1) |>
  fill(level, .direction = "up") |>
  filter(level == "2") |>
  print(n = 205)

pivot_wider(names_from = elem, values_from = value) |>
  mutate(codes = lead(codes)) |>
  print(n = 200)

