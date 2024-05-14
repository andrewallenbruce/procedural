#' Mount [pins][pins::pins-package] board
#'
#' @param source `<chr>` `"local"` or `"remote"`
#'
#' @returns `<pins_board_folder>` or `<pins_board_url>`
#'
#' @noRd
mount_board <- function(source = c("local", "remote")) {

  source <- match.arg(source)

  switch(
    source,
    local  = pins::board_folder(
      fs::path_package(
        "extdata/pins",
        package = "procedural")
    ),
    remote = pins::board_url(
      fuimus::gh_raw(
        "andrewallenbruce/procedural/master/inst/extdata/pins/")
    )
  )
}

#' List pins from a [pins][pins::pins-package] board
#'
#' @param ... arguments to pass to [mount_board()]
#'
#' @returns `<list>` of [pins][pins::pins-package]
#'
#' @noRd
list_pins <- function(...) {

  board <- mount_board(...)

  pins::pin_list(board)

}

#' Get a pinned dataset from a [pins][pins::pins-package] board
#'
#' @param pin `<chr>` string name of pinned dataset
#'
#' @template args-dots
#'
#' @returns `<tibble>`
#'
#' @noRd
get_pin <- function(pin, ...) {

  board <- mount_board(...)

  pin <- rlang::arg_match0(pin, list_pins())

  pins::pin_read(board, pin)

}

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
