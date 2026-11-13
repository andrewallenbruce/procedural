#' ICD-10-PCS Order File
#'
#' @format ## `pcs_order`
#' A data frame with 80,174 rows and 5 columns:
#' \describe{
#'   \item{order}{code order number}
#'   \item{valid}{code is valid billing code}
#'   \item{code}{ICD-10-PCS code}
#'   \item{description_short}{code description, short}
#'   \item{description_long}{code description, long}
#'   ...
#' }
#' @keywords internal
"pcs_order"

#' ICD-10-PCS Tables File
#'
#' @format ## `pcs_tables`
#' A data frame with 113,280 rows and 11 columns:
#' \describe{
#'   \item{record_index}{description}
#'   \item{entity}{description}
#'   \item{entity_index}{description}
#'   \item{field}{description}
#'   \item{value}{description}
#'   \item{value_kind}{description}
#'   \item{source}{description}
#'   \item{record_node_id}{description}
#'   \item{entity_node_id}{description}
#'   \item{parent_entity_node_id}{description}
#'   \item{source_node_id}{description}
#'   ...
#' }
#' @keywords internal
"pcs_tables"

#' ICD-10-PCS Definitions File
#'
#' @format ## `pcs_definitions`
#' A data frame with 3,602 rows and 15 columns:
#' \describe{
#'   \item{record_index}{description}
#'   \item{entity}{description}
#'   \item{entity_index}{description}
#'   \item{field}{description}
#'   \item{value}{description}
#'   \item{value_kind}{description}
#'   \item{source}{description}
#'   \item{record_node_id}{description}
#'   \item{entity_node_id}{description}
#'   \item{parent_entity_node_id}{description}
#'   \item{source_node_id}{description}
#'   ...
#' }
#' @keywords internal
"pcs_definitions"

#' ICD-10-PCS Index File
#'
#' @format ## `pcs_index`
#' A data frame with 65,333 rows and 11 columns:
#' \describe{
#'   \item{record_index}{description}
#'   \item{entity}{description}
#'   \item{entity_index}{description}
#'   \item{field}{description}
#'   \item{value}{description}
#'   \item{value_kind}{description}
#'   \item{source}{description}
#'   \item{record_node_id}{description}
#'   \item{entity_node_id}{description}
#'   \item{parent_entity_node_id}{description}
#'   \item{source_node_id}{description}
#'   ...
#' }
#' @keywords internal
"pcs_index"
