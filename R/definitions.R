#' ICD-10-PCS Definitions
#' @param section PCS section character.
#' @param axis PCS axis position.
#' @return a [dplyr::tibble()]
#' @examples
#' definitions(section = "2", axis = "3")
#'
#' definitions(section = "4", axis = "5")
#'
#' @export
definitions <- function(section = NULL, axis = NULL) {

  def <- pins::pin_read(mount_board(), "pcs_definitions_v3")

  # def <- pins::pin_read(mount_board(), "pcs_definitions_v2")

  if (!is.null(section)) {
    if (is.numeric(section)) section <- as.character(section)
    if (grepl("[[:lower:]]*", section)) section <- toupper(section)
    section <- rlang::arg_match(section, c(0:9, "B", "C", "F", "G", "H", "X"))
    def <- vctrs::vec_slice(def, def$code == section)
    }

  if (!is.null(axis)) {
    if (is.numeric(axis)) axis <- as.character(axis)
    axis <- rlang::arg_match(axis, c("3", "5", "6"))
    def <- vctrs::vec_slice(def, def$axis == axis)
    }
  return(def)
}

#' ICD-10-PCS Index
#' @param search Search term
#' @return a [dplyr::tibble()]
#' @examples
#' index(search = "Abdominohysterectomy")
#'
#' index(search = "Attain Ability(R) lead")
#'
#' @export
index <- function(search = NULL) {

  ind <- pins::pin_read(mount_board(), "index_v2")
  # ind |>
  #   dplyr::filter(!is.na(code)) |>
  #   dplyr::mutate(n_obs = nchar(code)) |>
  #   dplyr::count(n_obs)
  #
  # use_see <- pins::pin_read(mount_board(), "use_see") |>
  #   dplyr::select(letter, term, verb = type, pcs_value, table)

  # ind |> dplyr::filter(verb == "Use")
  # ind |> dplyr::filter(verb == "See")

  if (!is.null(search)) ind <- vctrs::vec_slice(ind, ind$term == search)
  return(ind)
}
