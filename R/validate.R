#' Check that input is 7 characters long
#'
#' @param x `<chr>` string
#'
#' @inheritParams rlang::args_error_context
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
}

#' Validate Section 0 Code
#'
#' Section 0 (Medical and Surgical) accounts for approx. 87% of all PCS codes.
#'
#' `68058 / 78603` = `0.8658448`
#'
#' ## Valid Code Structure
#'
#' A valid Section 0 Code is 7 characters long and follows the pattern:
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
#' try(is_section_0("1164"))
#'
#' @autoglobal
#'
#' @export
is_section_0 <- function(pcs_code) {
  check_7chars(pcs_code)
  pcs_code <- stringfish::sf_toupper(pcs_code)
  stringfish::sf_grepl(
    pcs_code,
    "^[0][B-DF-HJ-NP-Y0-9]{2}[A-HJ-NP-Y0-9][FX03478][A-HJ-NP-Z0-9]{2}$"
    )
}


# Section 1: Obstetrics || 304 / 78603 = 0.38%
# "^[1][0][ADEHJPQSTY29][0-2][X03478][YZ3][A-HJ-NP-Z0-9]$"

# Section 2: Placement || 861 / 78603 = 1.09%
# "^[2][WY][0-6][A-HJ-NP-V0-9][X][YZ0-79][Z]$"

# Section 3: Administration || 1271 / 78603 = 1.62%
# "^[3][CE0][012][A-HJ-NP-Z0-9][X03478][A-HJ-NP-Y0-9][A-DF-HJ-NP-RX-Z0-9]$"

# Section 4: Measurement and Monitoring || 422 / 78603 = 0.54%
# "^[4][AB][01][B-DF-HJZ0-9][X03478][B-DF-HJ-NP-TVW0-9][A-HZ0-9]$"

# Section 5: Extracorporeal or Systemic Assistance and Performance || 54 / 78603 = 0.07%
# "^[5][A][0-2][CD259][A-D0-9][0-5][A-DF-HJKZ0-24-9]$"

# Section 6: Extracorporeal or Systemic Therapies || 46 / 78603 = 0.06%
# "^[6][A][B0-9][BFTZ0-35][01][BZ][TVZ0-7]$"

# Section 7: Osteopathic || 100 / 78603 = 0.13%
# "^[7][W][0][0-9][X][0-9][Z]$"

# Section 8: Other Procedures || 88 / 78603 = 0.11%
# "^[8][CE][0][HKUVWXYZ129][X03478][BCDEY016][CDFGHJKLMNZ0-9]$"

# Section 9: Chiropractic || 90 / 78603 = 0.11%
# "^[9][W][B][0-9][X][B-DF-HJ-L][Z]$"

# Section B: Imaging || 2978 / 78603 = 3.79%
# "^[B][BDFGHLNPQRTUVWY0-57-9][0-5][A-HJ-NP-Y0-9][YZ0-2][Z0-3][AZ0134]$"

# Section C: Nuclear Medicine || 463 / 78603 = 0.59%
# "^[C][BDF-HPTVW0257-9][1-7][B-DF-HJ-NP-RYZ0-9][B-DF-HK-NP-TVWYZ17-9][Z][Z]$"

# Section D: Radiation Therapy || 2056 / 78603 = 2.61%
# "^[D][BDFGHMPT-W07-9][Y0-2][B-DFKLP-RXY0-9][B-DF-HJ0-9][B-DF-HYZ6-9][Z01]$"

# Section F: Physical Rehabilitation and Diagnostic Audiology || 1380 / 78603
# "^[F][01][B-DF0-9][B-DF-HJ-NZ0-9][B-DF-HJ-NP-TV-X0-9][B-HJ-NPQS-Z0-9][Z]$"

# Section G: Mental Health || 30 / 78603 = 0.04%
# "^[G][Z][BCFGHJ1-35-7][Z0-689][Z][Z][Z]$"

# Section H: Substance Abuse Treatment || 59 / 78603 = 0.08%
# "^[H][Z][2-689][BCDZ0-9][Z][Z][Z]$"

# Section X: New Technology || 343 / 78603 = 0.44%
# "^[X][DFHKNRTW-Y02][ACEGHJKPRSUVZ0-257][A-HJ-NP-Y0-9][X03478][A-HJ-NP-Y0-9][235-9]$"




