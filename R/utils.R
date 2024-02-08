#' Pivot data frame to long format for easy printing
#' @param df data frame
#' @param cols columns to pivot long, default is [dplyr::everything()]
#' @returns Pivoted data frame
#' @export
#' @keywords internal
long <- function(df, cols = dplyr::everything()) {
  df |>
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(), as.character)) |>
    tidyr::pivot_longer({{ cols }})
}

#' Return GitHub raw url
#' @param x url
#' @returns raw url
#' @examplesIf interactive()
#' github_raw("andrewallenbruce/provider/")
#' @noRd
github_raw <- function(x) {
  paste0("https://raw.githubusercontent.com/", x)
}

#' Wrapper to mount package's [pins::board_url()]
#' @noRd
mount_board <- function() {
  pins::board_url(github_raw(
  "andrewallenbruce/procedural/main/pkgdown/assets/pins-board/"))
}


#' Wrapper to mount package's [pins::board_url()]
#' @noRd
mount_source <- function(set = c("definitions", "index", "order", "table")) {
  if(set == "definitions") pins::pin_read(mount_board(), "source_definitions")
  if(set == "index") pins::pin_read(mount_board(), "source_index")
  if(set == "order") pins::pin_read(mount_board(), "source_order")
  if(set == "table") pins::pin_read(mount_board(), "source_table")
}


#' Infix operator for `if (!is.null(x)) y else x` statements
#' @param x,y description
#' @return description
#' @examplesIf interactive()
#' x <- 123456
#' x %nn% as.character(x)
#' @noRd
`%nn%` <- function(x, y) if (!is.null(x)) y else x #nocov

#' @noRd
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

#' Wrapper for [unlist()], with `use.names` set to `FALSE`
#' @param x character vector
#' @return split character vector
#' @noRd
delister <- function(x) unlist(x, use.names = FALSE)

#' Wrapper for [strsplit()] that unlists result
#' @param x character string
#' @return character vector
#' @noRd
splitter <- function(x) unlist(strsplit(x, ""), use.names = FALSE)

#' Wrapper for [paste0()] that collapses result
#' @param x split character vector
#' @return character string
#' @noRd
collapser <- function(x) paste0(x, collapse = "")

#' Search a data frame's column by string
#' @param df data frame
#' @param col column to search
#' @param search string to search
#' @param ignore ignore string case?
#' @return collapsed character vector
#' @noRd
srchcol <- function(df, col, search, ignore = FALSE) {
  dplyr::filter(df, stringr::str_detect(
    !!rlang::sym(col), stringr::regex(search, ignore_case = ignore)))
}

#' @noRd
download_links <- function() {
  # https://www.cms.gov/medicare/coding-billing/icd-10-codes/2024-icd-10-pcs
  dplyr::tibble(
    codeset = "ICD-10-PCS",
    version = 2024L,
    updated = as.Date("2023-12-19"),
    filename = c(
      "Order File (Long and Abbreviated Titles)",
      "Official Coding Guidelines",
      "Version Update Summary",
      "Codes File",
      "Conversion Table",
      "Code Tables and Index",
      "Addendum"),
    filetype = c(
      "zip",
      "pdf",
      "zip",
      "zip",
      "zip",
      "zip",
      "zip"),
    link = c(
      "https://www.cms.gov/files/zip/2024-icd-10-pcs-order-file-long-and-abbreviated-titles-updated-12/19/2023.zip",
      "https://www.cms.gov/files/document/2024-official-icd-10-pcs-coding-guidelines-updated-12/19/2023.pdf",
      "https://www.cms.gov/files/zip/2024-version-update-summary-updated-12/19/2023.zip",
      "https://www.cms.gov/files/zip/2024-icd-10-pcs-codes-file-updated-12/19/2023.zip",
      "https://www.cms.gov/files/zip/2024-icd-10-pcs-conversion-table-updated-12/19/2023.zip",
      "https://www.cms.gov/files/zip/2024-icd-10-pcs-code-tables-and-index-updated-12/19/2023.zip",
      "https://www.cms.gov/files/zip/2024-icd-10-pcs-addendum-updated-12/19/2023.zip"))
}
