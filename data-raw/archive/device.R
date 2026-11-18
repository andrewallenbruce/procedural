#' ICD-10-PCS Devices
#'
#' @param system PCS system character.
#' @param operation PCS operation character.
#' @param device PCS device character.
#' @param col column to search: "device_name" (default), "section", "system", "operation", "device", "includes"
#' @param search string to search for in `col`
#' @returns tibble
#' @examplesIf FALSE
#' device()
#' @export
device <- function(
  system = NULL,
  operation = NULL,
  device = NULL,
  col = c(
    "device_name",
    "section",
    "system",
    "operation",
    "device",
    "includes"
  ),
  search = NULL
) {
  # if (!is.null(system)) {
  #   system <- rlang::arg_match0(
  #     system,
  #     c(2:6, 8:9, "B", "C", "D", "J", "P", "Q", "R", "S", "U")
  #   )
  #   dev <- vctrs::vec_slice(dev, dev$system == system)
  # }
  #
  # if (!is.null(operation)) {
  #   operation <- rlang::arg_match0(
  #     operation,
  #     c("All applicable", "H", "R", "S", "V")
  #   )
  #   dev <- vctrs::vec_slice(dev, dev$operation == operation)
  # }
  #
  # if (!is.null(device)) {
  #   device <- as.character(device)
  #   device <- rlang::arg_match0(device, c(2, 4:7, "D", "J", "M", "P", "S"))
  #   dev <- vctrs::vec_slice(dev, dev$device == device)
  # }
  #
  # if (!is.null(search)) {
  #   dev <- fuimus::srchcol(dev, col = col, search = search)
  # }
  # return(.add_class(dev))
}
