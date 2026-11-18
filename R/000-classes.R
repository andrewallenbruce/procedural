#' @noRd
prop_scalar <- function(class, default = NULL) {
  S7::new_property(
    class,
    validator = function(value) {
      if (!rlang::is_scalar_atomic(value)) {
        "must be a scalar atomic"
      }
    },
    default = default
  )
}

#' @noRd
prop_integer <- S7::new_property(
  S7::class_integer,
  setter = function(self, name, value) {
    S7::prop(self, name) <- as.integer(value)
    self
  }
)

#' @noRd
prop_list_of <- function(
  class,
  names = c("any", "all", "none")
) {
  force(class)
  names <- rlang::arg_match(names)

  S7::new_property(
    class = S7::class_list,
    validator = function(value) {
      for (i in seq_along(value)) {
        val <- value[[i]]
        if (!S7::S7_inherits(val, class)) {
          return(paste0(
            "must be a list of <",
            class@name,
            ">s. ",
            "Element ",
            i,
            " is ",
            obj_type_friendly(val),
            "."
          ))
        }
      }
      if (names == "all" && any(rlang::names2(value) == "")) {
        "must be a named list."
      } else if (names == "none" && any(rlang::names2(value) != "")) {
        "must be an unnamed list."
      }
    }
  )
}

#' @noRd
class_string <- prop_scalar(
  S7::class_character,
  default = NA_character_
)

#' @noRd
Enum := S7::new_class(
  abstract = TRUE,
  properties = list(
    value = class_string,
    variants = S7::class_character
  ),
  validator = function(self) {
    if (cheapr::is_na(self@value)) {
      "@value must not be NA"
    }
    if (self@value %!in_% self@variants) {
      cli::format_inline("@value must be one of {.val {self@variants}}")
    }
  }
)

#' @noRd
new_enum <- function(name, variants, default = NULL) {
  check_string(name, allow_empty = FALSE)
  check_character(variants)
  check_string(default, allow_na = FALSE, allow_null = TRUE)

  if (length(variants) == 0L) {
    cli::cli_abort("{.arg variants} must contain at least one value.")
  }
  if (anyDuplicated(variants)) {
    cli::cli_abort("{.arg variants} must be unique.")
  }

  if (!rlang::is_null(default)) {
    if (cheapr::is_na(default) || default %!in_% variants) {
      cli::cli_abort("{.arg default} must be one of {.val {variants}}.")
    }
  }

  S7::new_class(
    name,
    parent = Enum,
    package = "procedural",
    properties = list(
      value = class_string,
      variants = S7::new_property(
        S7::class_character,
        default = rlang::expr(variants)
      )
    ),
    constructor = rlang::new_function(
      args = if (rlang::is_null(default)) {
        rlang::pairlist2(value = )
      } else {
        rlang::pairlist2(value = default)
      },
      body = rlang::expr({
        S7::new_object(
          S7::S7_object(),
          value = value,
          variants = variants
        )
      }),
      env = rlang::current_env()
    )
  )
}

#' @noRd
CodePCS := S7::new_class(
  properties = list(
    code = S7::class_character,
    description = S7::class_character,
    axes = S7::new_property(
      S7::class_data.frame,
      default = quote(data.frame(
        axis = 1:7,
        name = character(7L),
        value = character(7L),
        label = character(7L)
      ))
    ),
    definitions = S7::new_property(
      S7::class_data.frame,
      default = quote(data.frame(
        axis = integer(0L),
        name = character(0L),
        term = character(0L),
        definition = character(0L)
      ))
    ),
    includes = S7::new_property(
      S7::class_data.frame,
      default = quote(data.frame(
        axis = integer(0L),
        name = character(0L),
        term = character(0L),
        includes = character(0L)
      ))
    )
  )
  # ),
  # validator = function(self) {
  #   A <- length(self@code)
  #   E <- 7L
  #   if (A != E) {
  #     cli::format_inline(
  #       "{.arg @code} length must be {.val {E}} not {.val {A}}."
  #     )
  #     A <- length(self@description)
  #     E <- 1L
  #   } else if (A != E) {
  #     cli::format_inline(
  #       "{.arg @description} length must be {.val {A}} not {.val {E}}."
  #     )
  #     A <- nrow_(self@axes)
  #     E <- 7L
  #   } else if (A != E) {
  #     cli::format_inline(
  #       "{.arg @axes} must have {.val {A}} rows, not {.val {E}}."
  #     )
  #   }
  # }
)
