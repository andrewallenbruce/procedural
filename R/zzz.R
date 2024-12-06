.onLoad <- function(libname, pkgname) {

  board <- pins::board_folder(
    fs::path_package(
      "extdata/pins",
      package = "procedural")
  )

  .__sections <<- pins::pin_read(board, "sections")
  .__systems  <<- pins::pin_read(board, "systems")
  .__tables   <<- pins::pin_read(board, "tables_rows")

}

.onUnload <- function(libpath) {

  remove(
    ".__sections",
    ".__systems",
    ".__tables",
    envir = .GlobalEnv)

}

#' Read from a URL
#'
#' @param url `<chr>` url
#'
#' @autoglobal
#'
#' @noRd
read_url <- \(url) qs::qread_url(url)
