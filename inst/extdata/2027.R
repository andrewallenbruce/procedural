# 2027 ICD-10-PCS Procedure Codes List
# Effective Oct 1, 2026 – Sep 30, 2027
# Built from the official CMS FY 2027 dataset
# 80,174 procedure codes across 17 sections (79,256 billable)

# Site (link): https://www.cms.gov/medicare/coding-billing/icd-10-codes
# Errata (pdf): https://www.cms.gov/files/document/2027-errata-icd-10-ms-drgs-version-44.pdf
# Version Update Summary (zip): https://www.cms.gov/files/zip/2027-version-update-summary.zip
# Code Tables and Index (zip): https://www.cms.gov/files/zip/2027-icd-10-pcs-code-tables-index.zip
# Codes File (zip): https://www.cms.gov/files/zip/2027-icd-10-pcs-codes-file.zip
# Order File (zip): https://www.cms.gov/files/zip/2027-icd-10-pcs-order-file-long-abbreviated-titles.zip
# Addendum (zip): https://www.cms.gov/files/zip/2027-icd-10-pcs-addendum.zip
# Conversion Table (zip): https://www.cms.gov/files/zip/2027-icd-10-pcs-conversion-table.zip
# Coding Guidelines (pdf): https://www.cms.gov/files/document/2027-official-icd-10-pcs-coding-guidelines.pdf

# Every code has exactly seven characters and each position carries meaning. The
# first character names the Section, the second the Body System, and the third
# the Root Operation. Characters four through seven add the Body Part, Approach,
# Device, and Qualifier. Medical and Surgical (Section 0) is by far the largest
# with 69,099 codes, because it covers the full surgical repertoire on every
# anatomical region.
zips <- fs::dir_ls("inst/extdata/2027", glob = "*.zip")
fs::path_dir(zips)
pkg <- fs::path_package(package = "procedural", "extdata/2027")
archive::archive_write_dir("pcs_2027.tar.gz", dir = pkg)

normalizePath(".", winslash = "/")

fs::path_package(
  package = "procedural",
  "extdata",
  "2027",
  "zip-file-2-2027-code-tables-and-index.zip"
)
system.file(
  package = "procedural",
  "extdata",
  "2027",
  "zip-file-2-2027-code-tables-and-index.zip"
)
