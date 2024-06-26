% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/definitions.R
\name{order}
\alias{order}
\title{ICD-10-PCS Order File}
\usage{
order(
  search = NULL,
  col = c("code", "table", "row", "description_code", "description_table", "order")
)
}
\arguments{
\item{search}{string to search for in \code{col}}

\item{col}{column to search: "code" (default), "table", "row",
"description_code", "description_table", "order"}
}
\value{
a \link[tibble:tibble-package]{tibble}
}
\description{
ICD-10-PCS Order File
}
\examples{
order(search = "00X")

order(search = "Olfactory", col = "description_code")

}
