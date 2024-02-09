library(janitor)
library(tidyverse)
library(qs)
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

ind <- pins::pin_read(procedural:::mount_board(), "source_index") |>
  slice(4:n()) |>
  select(-level1)

idx_letter <- ind |>
  filter(level2 == "letter", level3 == "title") |>
  select(elemid, letter = value)

ind <- left_join(ind, idx_letter) |>
  fill(letter) |>
  filter(!is.na(level3), level3 != "title") |>
  select(-level2)

# idx_mainTerm <- ind |>
#   filter(level3 == "mainTerm", level4 == "title") |>
#   select(elemid, mainTerm = value)

idx_mainTerm <- ind |>
  filter(elem == "mainTerm") |>
  select(elemid, mainTerm = elem) |>
  mutate(id = row_number(mainTerm)) |>
  select(elemid, mainTerm = id)

ind <- left_join(ind, idx_mainTerm) |>
  fill(mainTerm) |>
  filter(!is.na(level4)) |>
  select(-level3)

idx_title <- ind |>
  filter(elem == "title") |>
  select(elemid, title = value, mainTerm)

ind <- left_join(ind, idx_title) |>
  fill(title) |>
  filter(elem != "title")

#------------- SPLIT - top level terms
top <- ind |>
  filter(level4 != "term") |>
  remove_empty() |>
  rename(action = level4)

topidx_code <- top |>
  filter(!is.na(level5)) |>
  select(code = value, mainTerm)

top <- left_join(top, topidx_code) |>
  filter(is.na(level5)) |>
  select(-level5)

codes <- c("codes", "code", "tab")

top <- top |>
  mutate(code = ifelse(elem %in% codes, value, code),
         value = ifelse(elem %in% codes, NA_character_, value),
         action = ifelse(elem %in% codes, "see", action)) |>
  select(letter,
         mainTerm,
         term = title,
         action,
         value,
         code)

top # FINAL

#------------- SPLIT - top level terms
deep <- ind |>
  filter(level4 == "term")


deepidx_term <- deep |>
  filter(elem == "term") |>
  select(elemid, mainTerm) |>
  distinct() |>
  mutate(term_id = row_number())

deep <- left_join(deep, deepidx_term) |>
  fill(term_id) |>
  filter(!is.na(value)) |>
  select(letter,
         mainTerm,
         title,
         term_id,
         elem,
         elemid,
         attr,
         value,
         level5:level9)

deepidx_lvls_234 <- deep |>
  filter(attr == "level", value != "1") |>
  select(mainTerm) |>
  distinct() |>
  pull(mainTerm)


#------------- SPLIT - terms with one level
deep_one_level <- deep |>
  filter(mainTerm %nin% deepidx_lvls_234) |>
  remove_empty()

deep_one_level_idx <- deep_one_level |>
  filter(attr == "level") |>
  mutate(lvl_id = row_number()) |>
  select(mainTerm, term_id, elemid, lvl_id)

deep_one_level <- left_join(deep_one_level,
                            deep_one_level_idx) |>
  fill(lvl_id) |>
  filter(is.na(attr)) |>
  select(-attr)

deep_one_code_idx <- deep_one_level |>
  filter(!is.na(level6)) |>
  select(code = value, lvl_id)

deep_one_level <- left_join(deep_one_level, deep_one_code_idx) |>
  filter(is.na(level6)) |>
  select(-level6)

codes <- c("codes", "code", "tab")

deep_one_level <- deep_one_level |>
  rename(action = level5) |>
  mutate(code = ifelse(elem %in% codes, value, code),
         value = ifelse(elem %in% codes, NA_character_, value),
         action = ifelse(elem %in% codes, "see", action)) |>
  select(letter,
         mainTerm,
         term = title,
         action,
         value,
         code)

deep_one_level # FINAL

# vctrs::vec_rbind(top, deep_one_level) |>
#   arrange(mainTerm) |>
#   print(n = 200)

#------------- SPLIT - terms with more than one level
deep_more_levels <- deep |>
  filter(mainTerm %in% deepidx_lvls_234) |>
  remove_empty()

deep_more_main_idx <- deep_more_levels |>
  group_by(mainTerm) |>
  slice_min(elemid) |>
  ungroup() |>
  mutate(main_term = title) |>
  select(mainTerm, term_id, elemid, main_term)

deep_more_levels <- left_join(deep_more_levels,
                              deep_more_main_idx) |>
  fill(main_term) |>
  filter(value != "1")

deep_more_1 <- deep_more_levels |>
  filter(level5 %nin% "term") |>
  remove_empty() |>
  select(letter,
         mainTerm,
         term = main_term,
         sub_term = title,
         elem,
         value) |>
  mutate(code = ifelse(elem %in% codes, value, NA_character_),
         value = ifelse(elem %in% codes, NA_character_, value),
         action = ifelse(elem %in% codes, "see", elem)) |>
  select(letter, mainTerm, term, sub_term, action, value, code)

#------------- SPLIT
deep_more_levels <- deep_more_levels |>
  filter(level5 %in% "term")

deep_more_levels <- deep_more_levels |>
  mutate(rowid = row_number())

term_vec <- deep_more_levels |>
  filter(level5 == "term", is.na(level6)) |>
  pull(term_id)

deep_sub1_idx <- deep_more_levels |>
  group_by(term_id) |>
  slice_min(elemid) |>
  ungroup() |>
  filter(value == "2") |>
  filter(title %nin% c("Anesthesia", "Left", "Right", "Bilateral", "Lower", "Upper", "No Qualifier")) |>
  rename(sub_term = title) |>
  select(mainTerm, term_id, sub_term)

deep_sub1_rowid <- deep_more_levels |>
  group_by(term_id) |>
  slice_min(elemid) |>
  ungroup() |>
  filter(value == "2") |>
  filter(title %nin% c("Anesthesia", "Left", "Right", "Bilateral", "Lower", "Upper", "No Qualifier")) |>
  pull(rowid)

deep_levels_2 <- left_join(deep_more_levels,
                              deep_sub1_idx) |>
  fill(sub_term) |>
  filter(rowid %nin% deep_sub1_rowid) |>
  filter(!is.na(level6)) |>
  select(-level5)

deep_more_2 <- deep_levels_2 |>
  filter(level6 == "code") |>
  remove_empty() |>
  mutate(action = ifelse(elem %in% codes, "see", elem)) |>
  select(letter,
         mainTerm,
         term = main_term,
         sub_term,
         action,
         value = title,
         code = value)

rowid_idx <- deep_levels_2 |>
  filter(level6 == "code") |>
  pull(rowid)

deep_lvl_3 <- deep_levels_2 |>
  filter(rowid %nin% rowid_idx)

deep_more_3 <- deep_lvl_3 |>
  filter(level6 %nin% "term") |>
  mutate(repeated = title == sub_term) |>
  filter(repeated == TRUE) |>
  remove_empty() |>
  select(letter,
         mainTerm,
         term = main_term,
         sub_term,
         elem,
         value) |>
  mutate(code = ifelse(elem %in% codes, value, NA_character_),
         value = ifelse(elem %in% codes, NA_character_, value),
         action = ifelse(elem %in% codes, "see", elem)) |>
  select(letter, mainTerm, term, sub_term, action, value, code)


vctrs::vec_rbind(top,
                 deep_one_level,
                 deep_more_1,
                 deep_more_2,
                 deep_more_3) |>
  arrange(mainTerm) |>
  select(letter, mainTerm, term, sub_term, action, value, code) |>
  # filter(action == "see") |>
  # remove_empty() |>
  print(n = 200)

deep_lvl_3 |>
  filter(level6 %nin% "term") |>
  mutate(repeated = title == sub_term) |>
  filter(repeated == FALSE) |>
  mutate(repeated = NULL) |>
  select(letter, mainTerm, term = main_term, sub_term, sub_term2 = title, elem, value) |>
  print(n = 400)

deep_lvl_3 |>
  filter(level6 %in% "term")


deep_more_main_idx <- deep_more_levels |>
  filter(level5 %in% "term") |>
  filter(is.na(level6)) |>
  group_by(term_id, elem) |>
  slice_min(elemid) |>
  ungroup() |>
  filter(value != "3") |>
  mutate(sub_term_1 = title) |>
  select(mainTerm, term_id, elemid, main_term)


deep_more_lvl_1_idx <- deep_more_levels |>
  filter(attr == "level", value == "1") |>
  mutate(lvl_id = row_number()) |>
  select(mainTerm, term_id, elemid, lvl_id, term_1 = title)





deep_more_levels |>
  filter(!is.na(level6)) |>
  filter(level6 %nin% "term")
  count(level6)


left_join(deep_more_levels, deep_more_lvl_1_idx) |>
  fill(lvl_id) |> print(n = 200)
  select(-c(level5:level9)) |>
  mutate(
    level = ifelse(!is.na(attr), value, attr),
    term_2 = ifelse(level == "2", title, NA_character_),
    code = ifelse(elem %in% codes, value, NA_character_)
    ) |>
  # filter(term_id != 39) |>
  print(n = 200)



deep_more_levels |>
  select(-c(level5:level9)) |>
  print(n = 200)



idx_lvl <- ind |>
  filter(!is.na(attr)) |>
  mutate(lid = paste0("L", value),
         llid = paste0(lid, "-", elemid)) |>
  select(elemid, llid, mainID)

ind <- left_join(ind, idx_lvl) |>
  group_by(mainID) |>
  fill(llid) |>
  ungroup() |>
  filter(is.na(attr), !is.na(value)) |>
  select(-attr)

#------------- Split - LVL 0
lvl_0 <- ind |>
  filter(is.na(llid)) |>
  remove_empty()

# Remove from `ind`, i.e.:
# ind |> filter(elemid %nin% elemid0) |> print(n = 100)
elemid0 <- lvl_0 |> pull(elemid) |> unique()

idx_v0 <- lvl_0 |>
  filter(is.na(level5)) |>
  mutate(val_0 = value) |>
  unite("act_0", level4, level5, sep = ":", na.rm = TRUE) |>
  select(mainID, val_0)

lvl_0 <- left_join(lvl_0, idx_v0) |>
  mutate(x_0 = ifelse(!is.na(level5), value, level5),
         act_0 = ifelse(!is.na(level5), paste0(level4, ":", level5), level5),
         act_0 = ifelse(is.na(level5), level4, act_0),
         x_0 = lead(x_0),
         act_0 = ifelse(!is.na(x_0), lead(act_0), act_0)) |>
  filter(is.na(level5)) |>
  select(elemid, letter, mainTerm, mainID, lid, act_0, val_0, x_0)

lvl_0 <- lvl_0 |>
  mutate(x_0 = ifelse((is.na(x_0) & elem %in% c("code", "codes", "tab")), val_0, x_0),
         val_0 = ifelse(elem %in% c("code", "codes", "tab"), NA_character_, val_0)) |>
  select(-elem)

lvl_0 |>
  print(n = 100)

##----- Remove from `ind`, i.e.:
ind <- ind |> filter(elemid %nin% elemid0)

#------------- Split - LVL 1
lvl_1 <- ind |>
  separate_wider_delim(llid,
                       delim = "-",
                       names = c("lvl", "lid"),
                       cols_remove = TRUE) |>
  filter(lvl == "L1")

# Remove from `ind`, i.e.:
# ind |> filter(elemid %nin% elemid0) |> print(n = 100)
elemid1 <- lvl_1 |> pull(elemid) |> unique()

lvl_1 <- lvl_1 |>
  remove_empty() |>
  select(-level4) |>
  mutate(x_1 = ifelse(!is.na(level6), value, level6),
         act_1 = ifelse(!is.na(level6), paste0(level5, ":", level6), level5),
         x_1 = lead(x_1),
         act_1 = ifelse(!is.na(x_1), lead(act_1), act_1)) |>
  filter(is.na(level6)) |>
  select(-level6, -lvl) |>
  mutate(x_1 = ifelse(level5 %in% c("code", "codes", "tab"), value, x_1)) |>
  group_by(lid) |>
  fill(x_1, .direction = "up") |>
  ungroup() |>
  filter(level5 %nin% c("code", "codes", "tab")) |>
  select(elemid, letter, mainTerm, mainID, lid, act_1, val_1 = value, x_1)

lvl_1 |>
  print(n = 100)

#------------- Split - LVL 2
lvl_2 <- ind |>
  separate_wider_delim(llid,
                       delim = "-",
                       names = c("lvl", "lid"),
                       cols_remove = TRUE) |>
  filter(lvl == "L2")


lvl_2 <- lvl_2 |>
  remove_empty() |>
  select(-level4, -level5) |>
  mutate(x_2 = ifelse(level6 %in% c("code", "codes", "tab"), value, NA_character_),
         act_2 = ifelse(level6 %in% c("code", "codes", "tab"), level6, NA_character_),
         x_2 = lead(x_2),
         act_2 = ifelse(!is.na(x_2), lead(act_2), act_2)) |>
  filter(level6 %nin% c("code", "codes", "tab")) |>
  select(elemid, letter, mainTerm, mainID, lid, act_2, val_2 = value, x_2)

lvl_2 |>
  print(n = 100)

#------------- Split - LVL 3
lvl_3 <- ind |>
  separate_wider_delim(llid,
                       delim = "-",
                       names = c("lvl", "lid"),
                       cols_remove = TRUE) |>
  filter(lvl == "L3")


lvl_3 <- lvl_3 |>
  remove_empty() |>
  select(-c(level4:level6)) |>
  mutate(x_3 = ifelse(level7 %in% c("code", "codes", "tab"), value, NA_character_),
         act_3 = ifelse(level7 %in% c("code", "codes", "tab"), level7, NA_character_),
         x_3 = lead(x_3),
         act_3 = ifelse(!is.na(x_3), lead(act_3), act_3)) |>
  filter(level7 %nin% c("code", "codes", "tab")) |>
  select(elemid, letter, mainTerm, mainID, lid, act_3, val_3 = value, x_3)

lvl_23 <- lvl_3 |>
  select(elemid) |>
  bind_rows(lvl_2) |>
  distinct(elemid, .keep_all = TRUE) |>
  arrange(elemid)

left_join(lvl_23, lvl_3, by = join_by("elemid")) |>
  unite('letter', letter.x, letter.y, sep = "", na.rm = TRUE) |>
  unite('mainTerm', mainTerm.x, mainTerm.y, sep = "", na.rm = TRUE) |>
  unite('action', act_2, act_3, sep = "", na.rm = TRUE) |>
  unite('codes', x_2, x_3, sep = "", na.rm = TRUE) |>
  mutate(action = na_if(action, ""),
         codes = na_if(codes, "")) |>
  select(-contains(c(".x", ".y"))) |>
  select(elemid, letter, mainTerm, action, val_2, val_3, codes) |>
  # fill(val_2) |>
  print(n = 100)
