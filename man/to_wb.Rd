% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/to_wb.R
\name{to_wb}
\alias{to_wb}
\title{Write extracted Plot Reflectances from one acquisition to Excel Workbook}
\usage{
to_wb(path, date, df)
}
\arguments{
\item{path}{path to the Excel Workbook}

\item{date}{date of the S-2 Acquisition}

\item{df}{data frame with extracted reflectances at plot locations.}
}
\value{
An Excel Workbook with the Acquisition date as sheet name, storing the Plot Reflectances.
}
\description{
\code{to_wb} writes reflectances from data frame into a new excel workbook sheet.
}
