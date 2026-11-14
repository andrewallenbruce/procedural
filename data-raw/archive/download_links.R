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
