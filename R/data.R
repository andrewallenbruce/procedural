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
#' A data frame with 34,790 rows and 5 columns:
#' \describe{
#'   \item{table}{description}
#'   \item{pos}{description}
#'   \item{title}{description}
#'   \item{code}{description}
#'   \item{label}{description}
#'   ...
#' }
#' @keywords internal
"pcs_tables"

#' ICD-10-PCS Definitions File
#'
#' @format ## `pcs_definitions`
#' A data frame with 320 rows and 6 columns:
#' \describe{
#'   \item{entry}{Entry number}
#'   \item{section}{PCS section character}
#'   \item{axis}{PCS code position}
#'   \item{name}{PCS code position name}
#'   \item{term}{PCS code position term}
#'   \item{definition}{PCS code definition attribute}
#'   ...
#' }
#' @keywords internal
"pcs_definitions"

#' ICD-10-PCS Definitions File
#'
#' @format ## `pcs_includes`
#' A data frame with 641 rows and 6 columns:
#' \describe{
#'   \item{entry}{Entry number}
#'   \item{section}{PCS section character}
#'   \item{axis}{PCS code position}
#'   \item{name}{PCS code position name}
#'   \item{term}{PCS code position term}
#'   \item{includes}{PCS code includes attribute}
#'   ...
#' }
#' @keywords internal
"pcs_includes"

#' ICD-10-PCS Definition Tables
#'
#' @format ## `table_definition`
#' A data frame with 861 rows and 6 columns:
#' \describe{
#'   \item{entry}{Entry number}
#'   \item{pos}{PCS code position}
#'   \item{title}{PCS code position name}
#'   \item{code}{PCS code position term}
#'   \item{label}{PCS code attribute category}
#'   \item{definition}{PCS code attribute description}
#'   ...
#' }
#' @keywords internal
"table_definition"

#' ICD-10-PCS Index File
#'
#' @format ## `pcs_index`
#' A data frame with 61,866 rows and 6 columns:
#' \describe{
#'   \item{entry}{description}
#'   \item{letter}{description}
#'   \item{term}{description}
#'   \item{field}{description}
#'   \item{value}{description}
#'   \item{source}{description}
#'   ...
#' }
#' @keywords internal
"pcs_index"
