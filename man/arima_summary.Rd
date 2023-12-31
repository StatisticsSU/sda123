% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timeseries.R
\name{arima_summary}
\alias{arima_summary}
\title{Summarize the estimates from an ARIMA(p,d,q) fit}
\usage{
arima_summary(arimafit)
}
\arguments{
\item{arimafit}{an ARIMA fit from \code{arima}.}
}
\value{
data frame with estimates, std err, z-ratio etc
}
\description{
Alternative to the usual \code{summary} function for \code{arima} fit.
}
\examples{
library(SUdatasets)
arimafit = arima(swedinfl$KPIF, order = c(2,0,2))
arimasumm = arima_summary(arimafit)
}
