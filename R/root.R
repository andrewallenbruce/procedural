#' ICD-10-PCS Root Operations
#' @return [tibble()]
#' @examplesIf interactive()
#' operations()
#' @export
operations <- function() {

  # Medical and Surgical
  # Central Nervous System and Cranial Nerves
  dplyr::tibble(
    axis = 3L,
    name = "Operation",
    code = c(paste0(rep(0, 22), rep(0, 22),
                    c(1:2, 5, 7:9,
                      LETTERS[c(2:4, 6, 8, 10:11, 14, 16:21, 23:24)]))),
    label = c("Bypass",
              "Change",
              "Destruction",
              "Dilation",
              "Division",
              "Drainage",
              "Excision",
              "Extirpation",
              "Extraction",
              "Fragmentation",
              "Insertion",
              "Inspection",
              "Map",
              "Release",
              "Removal",
              "Repair",
              "Replacement",
              "Reposition",
              "Resection",
              "Supplement",
              "Revision",
              "Transfer"))

}
