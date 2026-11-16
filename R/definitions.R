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
#' @param complete `<lgl>`  Return complete entries; default is `TRUE`
#' @returns a [tibble::tibble] containing the results
#' @examples
#' try(definitions(term = "drinnn"))
#' definitions(term = "drain")
#' definitions(section = "0", axis = 5)
#' definitions(section = "B", term = "fluoro")
#' definitions()
#' @export
definitions <- function(
  section = NULL,
  axis = NULL,
  term = NULL,
  complete = TRUE
) {
  if (!is.null(section)) {
    x <- ss_(
      procedural::pcs_definitions,
      procedural::pcs_definitions[["section"]] %iin% section
    )
    if (!nrow(x)) {
      cli::cli_abort('{.pkg section = "{section}"} returned 0 rows')
    }
  } else {
    x <- procedural::pcs_definitions
  }

  if (!is.null(axis)) {
    x <- ss_(x, x[["axis"]] %iin% axis)
    if (!nrow(x)) {
      cli::cli_abort('{.pkg axis = "{axis}"} returned 0 rows')
    }
  }

  if (!is.null(term)) {
    x <- ss_(
      x,
      grep(
        term,
        x[["term"]],
        ignore.case = TRUE,
        perl = TRUE
      )
    )
    if (!nrow(x)) {
      cli::cli_abort('{.pkg term = "{term}"} returned 0 rows')
    }
    if (complete) {
      x <- ss_(
        procedural::pcs_definitions,
        procedural::pcs_definitions[["entry"]] %iin% unique(x$entry)
      )
    }
  }
  return(x)
}

#' Return a range of ICD-10-PCS codes
#'
#' @param start,end `<chr>` Full 7-character ICD-10-PCS code.
#' @returns a [tibble::tibble] containing the results
#' @examples
#' code_range(start = "0G9000Z", end = "0G9100Z")
#' code_range("0G9000Z", "10D20ZZ")
#' code_range(start = "0G9000Z", end = "0G9000Z")
#' try(code_range(start = "0G9100Z", end = "0G9000Z"))
#' @export
code_range <- function(start, end) {
  check_string(start, allow_empty = FALSE)
  check_string(end, allow_empty = FALSE)
  if (any_(nchar(c(start, end)) < 7L)) {
    cli::cli_abort("Both {.pkg start} and {.pkg end} must be 7 characters.")
  }

  o <- name_(c(start, end), c("start", "end"))
  i <- match_(o, procedural::pcs_order[["code"]])

  if (anyNA(i)) {
    args <- names(o[cheapr::which_na(i)])
    cli::cli_abort("{.pkg {args}} returned no results.")
  }

  if (diff(i) < 0L) {
    cli::cli_abort(
      c(
        "x" = "{.pkg {start}} {.emph (#{i[1]})} comes after {.pkg {end}} {.emph (#{i[2]})}",
        "i" = "Did you mean {.code code_range(start = {.val {end}}, end = {.val {start}})} ?"
      )
    )
  }

  ss_(procedural::pcs_order, cheapr::seq_(i[1L], i[2L]))
}


#' ICD-10-PCS Index
#'
#' @param col column to search: "term" (default), "index", "type", "value",
#'   "code"
#' @param search string to search for in `col`
#' @template returns-default
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
  # col <- match.arg(col)
  #
  # if (!is.null(search)) {
  #   ind <- fuimus::srchcol(ind, col = col, search = search)
  # }
  # return(.add_class(ind))
}

#' ICD-10-PCS Order File
#'
#' @param col column to search: "code" (default), "table", "row",
#'   "description_code", "description_table", "order"
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
  # col <- match.arg(col)
  # tbl <- pcs_order
  #
  # if (!is.null(search)) {
  #   tbl <- fuimus::srchcol(tbl, col = col, search = search)
  # }
  # return(.add_class(tbl))
}

#' ICD-10-PCS Devices
#'
#' @param system PCS system character.
#' @param operation PCS operation character.
#' @param device PCS device character.
#' @param col column to search: "device_name" (default), "section", "system", "operation", "device", "includes"
#' @param search string to search for in `col`
#' @template returns-default
#' @examplesIf FALSE
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
  # dev <- get_pin("devices")
  # col <- match.arg(col)
  #
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

#' ICD-10-PCS Includes
#'
#' @param section PCS section:
#'    * `"0"` (Medical and Surgical),
#'    * `"3"` (Administration)
#'    * `"F"` (Physical Rehabilitation and Diagnostic Audiology)
#'    * `"G"` (Mental Health)
#'    * `"X"` (New Technology)
#' @param axis PCS axis:
#'    * `"3"`
#'      * Operation (0:9, X)
#'      * Type (B, C, F, G, H)
#'    * `"4"`
#'      * Qualifier (G)
#'    * `"5"`
#'      * Approach (0:4, 7:9, X)
#'      * Type Qualifier (F)
#' @param col column to search: `"name"`, `"label"` (default), `"includes"`
#' @param search string to search for in `col`
#' @template returns-default
#' @examplesIf FALSE
#' includes(section = "0", axis = "3")
#' @export
includes <- function(
  section = NULL,
  axis = NULL,
  col = c("label", "name", "includes"),
  search = NULL
) {
  # col <- match.arg(col)
  #
  # if (!is.null(section)) {
  #   section <- toupper(as.character(section))
  #   section <- rlang::arg_match0(section, c(0, 3, "F", "G", "X"))
  #   includes <- vctrs::vec_slice(includes, includes$section == section)
  # }
  #
  # if (!is.null(axis)) {
  #   axis <- as.character(axis)
  #   axis <- rlang::arg_match0(axis, c("3", "4", "5"))
  #   includes <- vctrs::vec_slice(includes, includes$axis == axis)
  # }
  #
  # if (!is.null(search)) {
  #   includes <- fuimus::srchcol(includes, col = col, search = search)
  # }
  # return(.add_class(includes))
}
