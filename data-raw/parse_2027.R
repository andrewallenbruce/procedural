#' @noRd
pkg_files <- function(ext = NULL) {
  x <- system.file("extdata", package = "procedural")
  if (x == "") {
    stop("No extdata found")
  }
  x <- list.files(x, full.names = TRUE, ignore.case = TRUE)
  if (length(x) == 0L) {
    stop("No files found")
  }
  # split by file path ext
  x <- split(x, sub(".*[.]([[:alnum:]]+)$", "\\1", x))
  if (!is.null(ext)) {
    i <- match_(ext, names(x))
    if (cheapr::all_na(i, recursive = FALSE)) {
      stop(paste0("No files with extension `.", ext, "` found"))
    }
    x <- x[[i]]
  }
  return(x)
}

#' @noRd
parse_xml <- function(profile = c("index", "tables", "definitions")) {
  xmls_ <- pkg_files(ext = "xml")
  prof_ <- rlang::arg_match(profile)
  path_ <- grep(
    paste0("icd10pcs_", prof_),
    xmls_,
    value = TRUE,
    perl = TRUE
  )
  if (is.null(path_) || length(path_) != 1L) {
    return(NULL)
  }

  collapse::ss(
    xmlrectr::rectangle_xml(
      file = path_,
      xmlrectr::compile_xml_profile(
        profile = xmlrectr::xml_profile(
          rows = switch(
            prof_,
            index = "ICD10PCS.index/letter",
            tables = "ICD10PCS.tabular/pcsTable",
            definitions = "ICD10PCS.definitions/section"
          )
        ),
        sample = path_
      ),
      parallel = TRUE
    ),
    j = c(2L, 4:6, 8:14)
  )
}

#' @noRd
parse_txt <- function(profile = c("order", "conversion")) {
  txts_ <- pkg_files(ext = "txt")
  prof_ <- rlang::arg_match(profile)
  path_ <- grep(
    paste0("icd10pcs_", prof_, "_"),
    txts_,
    value = TRUE,
    perl = TRUE
  )
  if (is.null(path_) || length(path_) != 1L) {
    return(NULL)
  }

  x <- switch(
    prof_,
    order = readr::read_fwf(
      file = path_,
      readr::fwf_cols(
        order = c(1L, 5L),
        code = c(6L, 13L),
        valid = 14:15,
        description_short = c(16L, 76L),
        description = c(77L, NA_integer_)
      ),
      show_col_types = FALSE,
      col_types = "icicc",
      num_threads = 4L
    ),
    conversion = suppressWarnings(
      collapse::ss(
        readr::read_tsv(
          file = path_,
          col_types = "c",
          col_names = c(
            "current_code",
            "current_title",
            "year_effective",
            "prior_code",
            "prior_title",
            "change",
            "comment",
            "mday_effective"
          ),
          show_col_types = FALSE,
          num_threads = 4L
        ),
        -1L
      )
    )
  )

  class(x) <- cheapr::setdiff_(class(x), "spec_tbl_df")
  return(x)
}
