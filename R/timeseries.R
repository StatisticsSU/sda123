#' Centered moving average to smooth out a time series
#'
#' @param y a vector with time series data
#' @param r the number of observations to the left of the center in the average,
#' i.e. the function computes a 2r+1 point average.
#' @param plotfig if TRUE then a figure is plotted with data and moving average.
#' @return a vector of the same length as y with moving averages (NA at boundaries)
#' @export
#' @examples
#' library(SUdatasets)
#' M = moving_average(globaltemp$temp, 2)
moving_average <- function(y, r, plotfig = TRUE){
  n = length(y)
  M = rep(NA,n)
  for (t in (r+1):(n-r)){
    M[t] = mean(y[(t-r):(t+r)])
  }
  if (plotfig){
    plot(y, type = "l", col = prettycol[2])
    lines(M, type = "l", col = prettycol[4], lwd = 2)
    legend(x = "topleft", inset=.05,
           legend = c("Data", paste(2*r+1,"-point moving average", sep = "")),
           pt.lwd = c(1,2), lty = c(1,1), col = c(prettycol[2],prettycol[4])
    )
  }
  return(M)
}

#' Moving average to smooth out seasonal time series
#'
#' @param y a vector with time series data
#' @param season season = 12 for montly, season = 4 for quarterly etc
#' @param plotfig if TRUE then a figure is plotted with data and moving average.
#' @return a vector of the same length as y with moving averages (NA at boundaries)
#' @export
#' @examples
#' M = moving_average_seasonal(c(AirPassengers), season = 12)
moving_average_seasonal <- function(y, season, plotfig = TRUE){
  w = rep(1/season, season + 1)
  w[1] = w[1]/2
  w[season + 1] = w[season + 1]/2
  r = season/2
  n = length(y)
  M = rep(NA,n)
  for (t in (r+1):(n-r)){
    M[t] = sum(w*y[(t-r):(t+r)])
  }
  if (plotfig){
    plot(y, type = "l", col = prettycol[2])
    lines(M, type = "l", col = prettycol[4], lwd = 2)
    legend(x = "topleft", inset=.05,
           legend = c("Data", "Seasonal moving average"),
           pt.lwd = c(1,2), lty = c(1,1), col = c(prettycol[2],prettycol[4])
    )
  }
  return(M)
}

#' Manipulate version of centered moving average to smooth out a time series
#'
#' @param y a vector with time series data
#' @export
#' @examples
#' library(SUdatasets)
#' moving_average_manip(globaltemp$temp)
moving_average_manip <- function(y){
  manipulate::manipulate(
    invisible(moving_average(y, r)),
    r = manipulate::slider(1, 20, step=1, initial = 1)
  )
}


#' Summarize the estimates from an ARIMA(p,d,q) fit
#'
#' Alternative to the usual `summary` function for `arima` fit.
#' @param arimafit an ARIMA fit from `arima`.
#' @return data frame with estimates, std err, z-ratio etc
#' @export
#' @examples
#' library(SUdatasets)
#' arimafit = arima(swedinfl$KPIF, order = c(2,0,2))
#' arimasumm = arima_summary(arimafit)
arima_summary <- function(arimafit){

  if ("(intercept)" %in% names(arimafit$coef)) intercept = 1 else intercept = 0

  arimasummary = summary(arimafit)
  nparam = length(arimafit$coef) + 1
  nobs = arimafit$nobs

  estimates = arimafit$coef
  stderror = sqrt(diag(arimafit$var.coef))
  zratio = arimafit$coef/sqrt(diag(arimafit$var.coef))
  ci95low = estimates - 1.96*stderror
  ci95high = estimates + 1.96*stderror

  nparam = length(arimafit$coef) + 1
  nobs = arimafit$nobs
  param_table = data.frame(Estimate = estimates, Std.Error = stderror,
        z.value =  zratio, p.value = 2*(1 - pnorm(abs(zratio))),
        ci95low = ci95low, ci95high = ci95high)
  names(param_table) <- c("Estimate", "Std. Error", "z-ratio", "Pr(>|z|)",
                          "2.5 %", "97.5 %")
  rownames(param_table)[nparam-1] <- "mean"
  {cat("\nParameter estimates\n--------------------------------------------------------------\n");
    print(param_table, digits = 5, na.print = "")}

  invisible(param_table)
}
