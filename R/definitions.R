#' ICD-10-PCS Definitions
#' @return [tibble()]
#' @examplesIf interactive()
#' definitions()
#' @export
definitions <- function() {

  definition <- pins::pin_read(mount_board(), "pcs_definitions_v2")

  return(definition)
}
