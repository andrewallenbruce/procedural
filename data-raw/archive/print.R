#' @export
print.procedural <- function(x, ...) {
  withr::with_options(
    list(
      pillar.bold = TRUE,
      pillar.subtle_num = TRUE,
      pillar.print_min = 20
    ),
    NextMethod()
  )
  invisible(x)
}

#' @noRd
.add_class <- function(data) {
  data <- tibble::as_tibble(data)

  class(data) <- unique(c("procedural", class(data)))

  data
}
