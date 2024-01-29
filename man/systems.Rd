% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reference.R
\name{systems}
\alias{systems}
\title{ICD-10-PCS Body Systems}
\usage{
systems(x = NULL)
}
\arguments{
\item{x}{ICD-10-PCS body systems character, an alphanumeric code of length 1.
If \code{NULL} (default), returns all 114 systems.}
}
\value{
a \code{\link[dplyr:reexports]{dplyr::tibble()}}
}
\description{
ICD-10-PCS Body Systems
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
systems()

systems("0")

systems("2")

systems("X")
\dontshow{\}) # examplesIf}
}