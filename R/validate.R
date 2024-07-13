#' Check that input is 7 characters long
#'
#' @param x `<chr>` string
#'
#' @autoglobal
#'
#' @noRd
check_7chars <- function(x) {

  arg  <- rlang::caller_arg(x)
  call <- rlang::caller_env()

  if (any(stringfish::sf_nchar(x) != 7L, na.rm = TRUE)) {
    cli::cli_abort(
      "{.arg {arg}} must be 7 characters long.",
      arg = arg,
      call = call)
  }
  stringfish::sf_toupper(x)
}

#' Validate Medical & Surgical Codes
#'
#' Section 0 accounts for 87% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 0 codes adhere to the following the pattern:
#'
#'    1. `[0]`
#'    2. `[B-DF-HJ-NP-Y0-9]`
#'    3. `[B-DF-HJ-NP-Y0-9]`
#'    4. `[A-HJ-NP-Y0-9]`
#'    5. `[FX03478]`
#'    6. `[A-HJ-NP-Z0-9]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_0(x)
#'
#' x[which(is_section_0(x))]
#'
#' try(is_section_0("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_0 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[0][B-DF-HJ-NP-Y0-9]{2}[A-HJ-NP-Y0-9][FX03478][A-HJ-NP-Z0-9]{2}$"
    )
}

#' Validate Obstetrics Codes
#'
#' Section 1 accounts for 0.38% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 1 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_1(x)
#'
#' x[which(is_section_1(x))]
#'
#' try(is_section_1("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_1 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[1][0][ADEHJPQSTY29][0-2][X03478][YZ3][A-HJ-NP-Z0-9]$"
  )
}

#' Validate Placement Codes
#'
#' Section 2 accounts for 1.09% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 2 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_2(x)
#'
#' x[which(is_section_2(x))]
#'
#' try(is_section_2("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_2 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[2][WY][0-6][A-HJ-NP-V0-9][X][YZ0-79][Z]$"
  )
}

#' Validate Administration Codes
#'
#' Section 3 accounts for 1.62% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 3 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_3(x)
#'
#' x[which(is_section_3(x))]
#'
#' try(is_section_3("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_3 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[3][CE0][012][A-HJ-NP-Z0-9][X03478][A-HJ-NP-Y0-9][A-DF-HJ-NP-RX-Z0-9]$"
  )
}

#' Validate Measurement and Monitoring Codes
#'
#' Section 4 accounts for 0.54% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 4 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_4(x)
#'
#' x[which(is_section_4(x))]
#'
#' try(is_section_4("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_4 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[4][AB][01][B-DF-HJZ0-9][X03478][B-DF-HJ-NP-TVW0-9][A-HZ0-9]$"
  )
}

#' Validate Extracorporeal or Systemic Assistance and Performance Codes
#'
#' Section 5 accounts for 0.07% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 5 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_5(x)
#'
#' x[which(is_section_5(x))]
#'
#' try(is_section_5("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_5 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[5][A][0-2][CD259][A-D0-9][0-5][A-DF-HJKZ0-24-9]$"
  )
}

#' Validate Extracorporeal or Systemic Therapies Codes
#'
#' Section 6 accounts for 0.06% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 6 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_6(x)
#'
#' x[which(is_section_6(x))]
#'
#' try(is_section_6("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_6 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[6][A][B0-9][BFTZ0-35][01][BZ][TVZ0-7]$"
  )
}

#' Validate Osteopathic Codes
#'
#' Section 7 accounts for 0.13% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 7 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_7(x)
#'
#' x[which(is_section_7(x))]
#'
#' try(is_section_7("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_7 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[7][W][0][0-9][X][0-9][Z]$"
  )
}

#' Validate Other Procedures Codes
#'
#' Section 8 accounts for 0.11% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 8 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_8(x)
#'
#' x[which(is_section_8(x))]
#'
#' try(is_section_8("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_8 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[8][CE][0][HKUVW-Z129][X03478][B-EY016][CDF-HJ-NZ0-9]$"
  )
}

#' Validate Chiropractic Codes
#'
#' Section 9 accounts for 0.11% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section 9 codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_9(x)
#'
#' x[which(is_section_9(x))]
#'
#' try(is_section_9("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_9 <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[9][W][B][0-9][X][B-DF-HJ-L][Z]$"
  )
}

#' Validate Imaging Codes
#'
#' Section B accounts for 3.79% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section B codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_B(x)
#'
#' x[which(is_section_B(x))]
#'
#' try(is_section_B("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_B <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[B][BDF-HLNP-RT-WY0-57-9][0-5][A-HJ-NP-Y0-9][YZ0-2][Z0-3][AZ0134]$"
  )
}

#' Validate Nuclear Medicine Codes
#'
#' Section C accounts for 0.59% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section C codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_C(x)
#'
#' x[which(is_section_C(x))]
#'
#' try(is_section_C("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_C <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[C][BDF-HPTVW0257-9][1-7][B-DF-HJ-NP-RYZ0-9][B-DF-HK-NP-TVWYZ17-9][Z]{2}$"
  )
}

#' Validate Radiation Therapy Codes
#'
#' Section D accounts for 2.61% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section D codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_D(x)
#'
#' x[which(is_section_D(x))]
#'
#' try(is_section_D("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_D <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[D][BDF-HMPT-W07-9][Y0-2][B-DFKLP-RXY0-9][B-DF-HJ0-9][B-DF-HYZ6-9][Z01]$"
  )
}

#' Validate Physical Rehabilitation and Diagnostic Audiology Codes
#'
#' Section F accounts for 1.76% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section F codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_F(x)
#'
#' x[which(is_section_F(x))]
#'
#' try(is_section_F("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_F <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[F][01][B-DF0-9][B-DF-HJ-NZ0-9][B-DF-HJ-NP-TV-X0-9][B-HJ-NPQS-Z0-9][Z]$"
  )
}

#' Validate Mental Health Codes
#'
#' Section G accounts for 0.04% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section G codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_G(x)
#'
#' x[which(is_section_G(x))]
#'
#' try(is_section_G("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_G <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[G][Z][BCFGHJ1-35-7][Z0-689][Z]{3}$"
  )
}

#' Validate Substance Abuse Treatment Codes
#'
#' Section H accounts for 0.08% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section H codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_H(x)
#'
#' x[which(is_section_H(x))]
#'
#' try(is_section_H("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_H <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[H][Z][2-689][B-DZ0-9][Z]{3}$"
  )
}

#' Validate New Technology Codes
#'
#' Section X accounts for 0.44% of all PCS codes.
#'
#' ## Code Pattern
#'
#' Section X codes adhere to the following the pattern:
#'
#'    1. `[1]`
#'    2. `[0]`
#'    3. `[ADEHJPQSTY29]`
#'    4. `[0-2]`
#'    5. `[X03478]`
#'    6. `[YZ3]`
#'    7. `[A-HJ-NP-Z0-9]`
#'
#' @param pcs_code `<chr>` string
#'
#' @returns `<lgl>` `TRUE` if valid, otherwise `FALSE`
#'
#' @examples
#' x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")
#'
#' is_section_X(x)
#'
#' x[which(is_section_X(x))]
#'
#' try(is_section_X("01UB3K"))
#'
#' @family Section Validators
#'
#' @autoglobal
#'
#' @export
is_section_X <- function(pcs_code) {
  check_7chars(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[X][DFHKNRTW-Y02][ACEGHJKPRSUVZ0-257][A-HJ-NP-Y0-9][X03478][A-HJ-NP-Y0-9][235-9]$"
  )
}
