code_range <- function(start, end) {

  ord <- pins::pin_read(mount_board(), "order_minimum") |>
    dplyr::filter(code == start | code == end) |>
    dplyr::pull(order)

}
