#' @noRd
pcs_matrix <- function(x) {
  axis <- c(1:7)
  value <- c(0:9, LETTERS[c(1:8, 10:14, 16:26)])

  m <- matrix(
    data = 0L,
    nrow = length(axis),
    ncol = length(value),
    dimnames = list(axis, value)
  )

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
