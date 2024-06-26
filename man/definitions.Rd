% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/definitions.R
\name{definitions}
\alias{definitions}
\title{ICD-10-PCS Definitions}
\usage{
definitions(
  section = NULL,
  axis = NULL,
  col = c("value", "label", "name", "definition", "explanation"),
  search = NULL,
  display = FALSE
)
}
\arguments{
\item{section}{PCS section: 0:9, B, C, F, G, H, X}

\item{axis}{PCS axis: 3, 4, 5}

\item{col}{column to search: "name", "value" (default), "label" "definition", "explanation"}

\item{search}{string to search for in \code{col}}

\item{display}{output for display, e.g. in \code{ggplot} or \code{gt}: \code{TRUE} or \code{FALSE} (default)}
}
\value{
a \link[tibble:tibble-package]{tibble}
}
\description{
ICD-10-PCS Definitions
}
\examples{
definitions(col = "label", search = "drain")

definitions(section = "0", axis = "5")

definitions(section = "B", col = "label", search = "fluoro")

definitions(section = "B", col = "label", search = "fluoro", display = TRUE)

}
