#' ICD-10-PCS Sections
#'
#' @param x ICD-10-PCS section value, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 17 sections.
#'
#' @template returns-default
#'
#' @examples
#' sections()
#'
#' sections("0")
#'
#' sections("2")
#'
#' sections("X")
#'
#' @autoglobal
#'
#' @export
sections <- function(x = NULL) {

  sec <- get_pin("sections")

  if (!is.null(x)) {x <- toupper(as.character(x))}

  sec <- fuimus::search_in_if(sec, sec$value, x)

  return(sec)
}

#' ICD-10-PCS Body Systems
#'
#' @param x ICD-10-PCS body systems character, an alphanumeric code of length 1.
#'    If `NULL` (default), returns all 114 systems.
#'
#' @template returns-default
#'
#' @examples
#' systems()
#'
#' systems("0")
#'
#' systems("2")
#'
#' systems("X")
#'
#' @autoglobal
#'
#' @export
systems <- function(x = NULL) {

  sys <- get_pin("systems")

  if (!is.null(x)) x <- stringfish::sf_toupper(as.character(x))

  sys <- fuimus::search_in_if(
    sys,
    sys$section,
    x
    )

  return(sys)
}

#' @noRd
pcs_matrix <- function(x) {

  axis   <- c(1:7)
  value  <- c(0:9, LETTERS[c(1:8, 10:14, 16:26)])

  m <- matrix(data = 0L,
              nrow = length(axis),
              ncol = length(value),
              dimnames = list(axis, value))

  x <- lk(x)
  y <- 1L

  m[1, x[1]] <- y
  m[2, x[2]] <- y
  m[3, x[3]] <- y
  m[4, x[4]] <- y
  m[5, x[5]] <- y
  m[6, x[6]] <- y
  m[7, x[7]] <- y

  return(m)
  # x <- pcs_matrix("0G9000Z")
  # drawr::draw_matrix(x, highlight_area = x == 1, show_indices = "none")
}

#' @noRd
lk <- function(x) {

  x <- fuimus::splitter(stringfish::sf_toupper(x))

  values <- 1:34

  names(values) <- c(0:9, LETTERS[c(1:8, 10:14, 16:26)])

  unname(values[x])

}
