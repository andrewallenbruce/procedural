utils::globalVariables(c(
  "entry",
  "field",
  "lid",
  "lvl",
  "N",
  "run",
  "term",
  "value"
))

.onLoad <- function(...) {
  cheapr::set_threads(4L)
  collapse::set_collapse(nthreads = 4L, verbose = 0L)
  S7::S7_on_load()
}
.onUnload <- function(...) {
  cheapr::set_threads(2L)
  collapse::set_collapse(nthreads = 1L, verbose = 1L)
  S7::S7_on_unload()
}
S7::S7_on_build()
