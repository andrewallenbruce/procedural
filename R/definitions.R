#' ICD-10-PCS Definitions
#'
#' @param section `<chr>` PCS section; one of `0:9, B, C, F, G, H, X`
#' @param axis `<int>` PCS axis; one of `3, 4, 5, 6`
#'    * 3: Operation
#'    * 3: Type
#'    * 4: Body Part
#'    * 4: Qualifier
#'    * 5: Approach
#'    * 5: Type Qualifier
#'    * 6: Substance
#'    * 6: Device
#'    * 6: Device / Substance / Technology
#' @param term `<chr>` term to search for
#' @returns a [tibble::tibble] containing the results
#' @examples
#' definitions(term = "drain")
#' definitions(section = "0", axis = 5)
#' definitions(section = "B", term = "fluoro")
#' definitions()
#' @export
definitions <- function(section = NULL, axis = NULL, term = NULL) {
  x <- if (!is.null(section)) {
    collapse::ss(
      pcs_definitions,
      pcs_definitions[["section"]] %iin% section,
      check = FALSE
    )
  } else {
    pcs_definitions
  }

  if (!is.null(axis)) {
    x <- collapse::ss(x, x[["axis"]] %iin% axis, check = FALSE)
  }

  if (!is.null(term)) {
    x <- collapse::ss(
      x,
      grep(term, x[["value"]], ignore.case = TRUE, perl = TRUE),
      check = FALSE
    )
  }
  return(x)
}

#' ICD-10-PCS Includes
#'
#' @param section PCS section:
#'    * `"0"` (Medical and Surgical),
#'    * `"3"` (Administration)
#'    * `"F"` (Physical Rehabilitation and Diagnostic Audiology)
#'    * `"G"` (Mental Health)
#'    * `"X"` (New Technology)
#'
#' @param axis PCS axis:
#'    * `"3"`
#'      * Operation (0:9, X)
#'      * Type (B, C, F, G, H)
#'    * `"4"`
#'      * Qualifier (G)
#'    * `"5"`
#'      * Approach (0:4, 7:9, X)
#'      * Type Qualifier (F)
#'
#' @param col column to search: `"name"`, `"label"` (default), `"includes"`
#'
#' @param search string to search for in `col`
#'
#' @template returns-default
#'
#' @examples
#' includes(section = "0", axis = "3")
#' @export
includes <- function(
  section = NULL,
  axis = NULL,
  col = c("label", "name", "includes"),
  search = NULL
) {
  col <- match.arg(col)

  if (!is.null(section)) {
    section <- stringfish::sf_toupper(as.character(section))
    section <- rlang::arg_match0(section, c(0, 3, "F", "G", "X"))
    includes <- vctrs::vec_slice(includes, includes$section == section)
  }

  if (!is.null(axis)) {
    axis <- as.character(axis)
    axis <- rlang::arg_match0(axis, c("3", "4", "5"))
    includes <- vctrs::vec_slice(includes, includes$axis == axis)
  }

  if (!is.null(search)) {
    includes <- fuimus::srchcol(includes, col = col, search = search)
  }
  return(.add_class(includes))
}

#' ICD-10-PCS Index
#'
#' @param col column to search: "term" (default), "index", "type", "value",
#'   "code"
#'
#' @param search string to search for in `col`
#'
#' @template returns-default
#'
#' @examplesIf FALSE
#' index(search = "Abdominohysterectomy")
#' index(search = "Attain Ability")
#' index(search = "radi*")
#' @export
index <- function(
  search = NULL,
  col = c("term", "index", "verb", "value", "code")
) {
  # ind <- get_pin("index_v2") |>
  # tidyr::unite("term", term, subterm, sep = ", ", na.rm = TRUE) |>
  # dplyr::mutate(id = dplyr::row_number(), .before = 1) |>
  # dplyr::rename(index = letter, type = verb) |>
  # dplyr::select(-c(letter, term_id))

  col <- match.arg(col)

  if (!is.null(search)) {
    ind <- fuimus::srchcol(ind, col = col, search = search)
  }
  return(.add_class(ind))
}

#' ICD-10-PCS Order File
#'
#' @param col column to search: "code" (default), "table", "row",
#'   "description_code", "description_table", "order"
#'
#' @param search string to search for in `col`
#' @template returns-default
#' @examplesIf FALSE
#' order(search = "00X")
#' order(search = "Olfactory", col = "description_code")
#' @export
order <- function(
  search = NULL,
  col = c(
    "code",
    "table",
    "row",
    "description_code",
    "description_table",
    "order"
  )
) {
  col <- match.arg(col)

  if (!is.null(search)) {
    tbl <- fuimus::srchcol(tbl, col = col, search = search)
  }
  return(.add_class(tbl))
}

#' Return a range of ICD-10-PCS codes
#'
#' @param start 7-character ICD-10-PCS code.
#'
#' @param end 7-character ICD-10-PCS code.
#'
#' @template returns-default
#'
#' @examplesIf FALSE
#' code_range("0G9000Z", "0G9100Z")
#' code_range("0G9000Z", "10D20ZZ")
#' @export
code_range <- function(start, end) {
  # start <- checks(start)
  # end <- checks(end)
  #
  # if (nchar(start) < 7L) {
  #   cli::cli_abort("{.var start} must be 7 characters long.")
  # }
  #
  # if (nchar(end) < 7L) {
  #   cli::cli_abort("{.var end} must be 7 characters long.")
  # }
  #
  # base <- get_pin("tables_order")[c('order', 'code', 'table', 'row')]
  #
  # o_start <- dplyr::filter(base, code == start) |> dplyr::pull(order)
  # o_end <- dplyr::filter(base, code == end) |> dplyr::pull(order)
  #
  # if (o_start > o_end) {
  #   cli::cli_abort(
  #     c(
  #       "{.val {start}} comes after {.val {end}}",
  #       "x" = "{.val {o_start}} > {.val {o_end}}."
  #     )
  #   )
  # }
  # dplyr::filter(base, dplyr::between(order, o_start, o_end)) |> .add_class()
}

#' ICD-10-PCS Devices
#'
#' @param system PCS system character.
#'
#' @param operation PCS operation character.
#'
#' @param device PCS device character.
#'
#' @param col column to search: "device_name" (default), "section", "system", "operation", "device", "includes"
#'
#' @param search string to search for in `col`
#'
#' @template returns-default
#'
#' @examples
#' devices()
#' @export
devices <- function(
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
  dev <- get_pin("devices")
  col <- match.arg(col)

  if (!is.null(system)) {
    system <- rlang::arg_match0(
      system,
      c(2:6, 8:9, "B", "C", "D", "J", "P", "Q", "R", "S", "U")
    )
    dev <- vctrs::vec_slice(dev, dev$system == system)
  }

  if (!is.null(operation)) {
    operation <- rlang::arg_match0(
      operation,
      c("All applicable", "H", "R", "S", "V")
    )
    dev <- vctrs::vec_slice(dev, dev$operation == operation)
  }

  if (!is.null(device)) {
    device <- as.character(device)
    device <- rlang::arg_match0(device, c(2, 4:7, "D", "J", "M", "P", "S"))
    dev <- vctrs::vec_slice(dev, dev$device == device)
  }

  if (!is.null(search)) {
    dev <- fuimus::srchcol(dev, col = col, search = search)
  }
  return(.add_class(dev))
}
