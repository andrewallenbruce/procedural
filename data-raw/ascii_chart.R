# altered from https://github.com/blmayer/asciichartr for fun
ascii_chart <- function(.data) {
  ldata <- length(.data)
  if (!ldata || collapse::fsum(!cheapr::is_na(.data)) == 0) {
    stop("No data to plot")
  }

  MIN <- collapse::fmin(.data)
  MAX <- collapse::fmax(.data)
  INT <- c(9532L, 9508L, 9590L, 9588L, 9472L, 9584L, 9581L, 9582L, 9583L, 9474L)
  SYM <- purrr::map_chr(INT, intToUtf8)

  if (MIN > MAX) {
    stop("Minimum value cannot exceed Maximum")
  }

  interval <- MAX - MIN
  offset <- 3L
  height <- interval
  ratio <- ifelse_(interval > 0L, height / interval, 1L)

  MIN2 <- as.integer(cheapr::floor_(MIN * ratio))
  MAX2 <- as.integer(cheapr::ceiling_(MAX * ratio))

  clamp <- \(n) collapse::fmin(c(collapse::fmax(c(n, MIN)), MAX))
  scale <- \(y) cheapr::round_(clamp(y) * ratio) - MIN2

  rows <- MAX2 - MIN2
  width <- ldata + offset
  place <- "%8.0f"
  result <- array(" ", c(rows + 1L, width))

  # Max label size
  len <- 1L
  for (y in MIN2:MAX2) {
    label <- sprintf(
      place,
      MAX - ((y - MIN2) * interval / ifelse_(rows == 0L, 1L, rows))
    )
    len <- collapse::fmax(c(nchar(label), len))
  }

  # Axis and labels
  for (y in MIN2:MAX2) {
    label <- sprintf(
      place,
      MAX - ((y - MIN2) * interval / ifelse_(rows == 0L, 1L, rows))
    )
    result[y - MIN2 + 1L, collapse::fmax(c(offset - len - 1L, 1L))] <- sprintf(
      "%*s",
      len,
      label
    )
    result[y - MIN2 - 1L, offset] <- ifelse_(y == 0L, SYM[1], SYM[2])
    # zero tick mark
  }

  # First value is a tick mark across the y-axis
  d0 <- .data[[1]]
  if (is.numeric(d0)) {
    result[rows - scale(d0) + 1L, offset] <- SYM[1]
  }

  # Plot the line
  lend <- ldata - 1L
  for (x in 1:lend) {
    d0 <- .data[[x]]
    d1 <- .data[[x + 1L]]

    if (cheapr::is_na(d0) && cheapr::is_na(d1)) {
      next()
    }

    if (cheapr::is_na(d0) && is.numeric(d1)) {
      result[rows - scale(d1) + 1L, x + offset] <- SYM[3]
      next()
    }

    if (is.numeric(d0) && cheapr::is_na(d1)) {
      result[rows - scale(d0) + 1L, x + offset] <- SYM[4]
      next()
    }

    y0 <- scale(d0)
    y1 <- scale(d1)

    if (y0 == y1) {
      result[rows - y0 + 1L, x + offset] <- SYM[5]
      next()
    }

    result[rows - y1 + 1L, x + offset] <- ifelse_(y0 > y1, SYM[6], SYM[7])
    result[rows - y0 + 1L, x + offset] <- ifelse_(y0 > y1, SYM[8], SYM[9])

    start <- collapse::fmin(c(y0, y1)) + 1L
    end <- collapse::fmax(c(y0, y1)) - 1L
    if (end < start) {
      next()
    }
    for (y in start:end) {
      result[rows - y + 1L, x + offset] <- SYM[10]
    }
  }

  result <- apply(result, 1, \(x) paste(x, collapse = ""))
  result <- paste(cheapr::c_(result, "\n"), collapse = "\n")
  cat(result)
  invisible(result)
}

x <- rep.int(c(1L, 2L, 3L, 4L, 5L, 4L, 3L, 2L, 1L), 5L)
ascii_chart(x)
x <- diff(npis::npi(npis::generate(50, valid = TRUE), sort = TRUE))
x <- cheapr::c_(x %% 10L, x %/% 10L %% 10L)
x <- x[x > 2L]
ascii_chart(x)
