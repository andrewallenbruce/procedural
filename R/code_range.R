#' Return a range of ICD-10-PCS codes.
#' @param start 7-character string representing an ICD-10-PCS code.
#' @param end 7-character string representing an ICD-10-PCS code.
#' @return a [dplyr::tibble()]
#' @examplesIf interactive()
#' code_range("0G9000Z", "0G9100Z")
#'
#' code_range("0G9000Z", "10D20ZZ")
#'
#' @export
code_range <- function(start, end) {

  start <- checks(start)
  end <- checks(end)

  if (nchar(start) < 7L) {cli::cli_abort("{.var start} must be 7 characters long.")}
  if (nchar(end) < 7L) {cli::cli_abort("{.var end} must be 7 characters long.")}

  base <- pins::pin_read(mount_board(), "order_minimum")

  o_start <- base |> dplyr::filter(code == start) |> dplyr::pull(order)
  o_end <- base |> dplyr::filter(code == end) |> dplyr::pull(order)

  if (o_start > o_end) {cli::cli_abort("{.var start} comes after {.var end}.")}

  dplyr::filter(base, dplyr::between(order, o_start, o_end))

}
