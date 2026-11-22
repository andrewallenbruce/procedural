utils::globalVariables(c("N", "run", "value", "entry", "term"))

.onLoad <- function(...) {
  cheapr::set_threads(4L)
  S7::S7_on_load()
}
.onUnload <- function(...) {
  cheapr::set_threads(2L)
  S7::S7_on_unload()
}
S7::S7_on_build()
