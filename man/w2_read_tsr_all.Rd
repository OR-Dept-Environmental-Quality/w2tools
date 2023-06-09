% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/w2_read_tsr.R
\name{w2_read_tsr_all}
\alias{w2_read_tsr_all}
\title{Read all W2 Time Series (TSR) plot outputs}
\usage{
w2_read_tsr_all(dir, sim_name = NA_character_, year = 1900)
}
\arguments{
\item{dir}{The path to the directory where the TSR file is located.}

\item{sim_name}{The name of the model scenario. String format. Default is NA.}

\item{year}{The model starting or reference year. Should be the same as YEAR
in the w2 control file. Default is 1900. The year and Julian day from the TSR
file are converted to POSIXct datetimes. UTC is the default timezone.
#' @export}
}
\description{
Function will read any text file with the regex pattern = "^tsr_.*opt.
}
