#' Pivot data frame to long format for easy printing
#' @param df data frame
#' @param cols columns to pivot long, default is [dplyr::everything()]
#' @export
#' @keywords internal
long <- function(df, cols = dplyr::everything()) {
  df |>
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(), as.character)) |>
    tidyr::pivot_longer({{ cols }})
}

#' @noRd
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

#' Return GitHub raw url
#' @param x url
#' @returns raw url
#' @examplesIf interactive()
#' github_raw("andrewallenbruce/provider/")
#' @noRd
github_raw <- function(x) {
  paste0("https://raw.githubusercontent.com/", x)
}
