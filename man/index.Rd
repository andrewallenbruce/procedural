% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/definitions.R
\name{index}
\alias{index}
\title{ICD-10-PCS Index}
\usage{
index(search = NULL, col = c("term", "index", "verb", "value", "code"))
}
\arguments{
\item{search}{string to search for in \code{col}}

\item{col}{column to search: "term" (default), "index", "type", "value",
"code"}
}
\value{
a \link[tibble:tibble-package]{tibble}
}
\description{
ICD-10-PCS Index
}
\examples{
index(search = "Abdominohysterectomy")

index(search = "Attain Ability")

index(search = "radi*")

}
