# library(S7)
#
# splitter <- function(x) {
#   unlist(strsplit(x, ""), use.names = FALSE)
# }
#
# collapser <- function(x) {
#   paste0(x, collapse = "")
# }
#
# prop_code <- new_property(
#   class = class_character,
#   validator = function(value) {
#     if (length(value) != 1L) {
#       "must be length 1"
#     } else if (nchar(value) != 7L) {
#       "must be 7 characters"
#     } else if (grepl("[^[0-9A-HJ-NP-Z]]*", value)) {
#       "must not contain `I` or `O`"
#     }
#   }
# )
#
# prop_table <- new_property(
#   class = class_character,
#   validator = function(value) {
#     if (length(value) != 1L) {
#       "must be length 1"
#     } else if (nchar(value) != 3L)
#       "must be 3 characters"
#   }
# )
#
# pcs <- new_class(
#   name = "pcs",
#   package = "procedural",
#   properties = list(
#         code = prop_code,
#         split = new_property(
#           class = class_vector,
#           getter = function(self) splitter(self@code)),
#         section = new_property(
#           class = class_character,
#           getter = function(self) collapser(self@split[1])),
#         system = new_property(
#           class = class_character,
#           getter = function(self) collapser(self@split[2])),
#         operation = new_property(
#           class = class_character,
#           getter = function(self) collapser(self@split[3])),
#         region = new_property(
#           class = class_character,
#           getter = function(self) collapser(self@split[4])),
#         approach = new_property(
#           class = class_character,
#           getter = function(self) collapser(self@split[5])),
#         device = new_property(
#           class = class_character,
#           getter = function(self) collapser(self@split[6])),
#         qualifier = new_property(
#           class = class_character,
#           getter = function(self) collapser(self@split[7])),
#         table = new_property(
#           class = class_character,
#           getter = function(self) collapser(self@split[1:3]))
#         )
#   )
# pcs@constructor
#
# x <- pcs("1155677")
#
# x@section
#
# x@section <- "0"
#
# describe <- new_generic("describe", "x")
#
# method(describe, pcs) <- function(x) {
#
#   sp <- unlist(strsplit(x, ""), use.names = FALSE)
#
#   names(sp) <- c("section",
#                  "system",
#                  "operation",
#                  "part",
#                  "approach",
#                  "device",
#                  "qualifier")
#
#   tbl <- paste0(unname(sp[1:3]), collapse = "")
#
#   return(list(code = rlang::sym(x),
#               split = sp,
#               table = rlang::sym(tbl)))
#
# }
