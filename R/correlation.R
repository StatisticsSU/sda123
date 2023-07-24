#' Compute pair-wise correlations and hypothesis test
#'
#' Computes pair-wise correlations between variables in a dataframe df
#' Uses p-values to test:\cr\cr
#' H0: rho = 0\cr
#' H1: rho != 0
#'
#' @param df dataframe
#' @return list with two tables: corrs (correlations), pvals (p-values)
#' @export
#' @examples
#' library(sda123)
#' corr_matrix(mtcars[,c("mpg","hp","drat","wt")])
corr_matrix <- function(df){
  p = dim(df)[2]
  corrs = matrix(NA, p, p)
  pvals = matrix(NA, p, p)
  for (i in 1:(p-1)){
    for (j in (i+1):p){
      corr_res = cor.test(df[,i], df[,j])
      corrs[i,j] = corr_res$estimate
      pvals[i,j] = corr_res$p.value
    }
  }
  colnames(corrs) <- rownames(corrs) <- names(df)
  colnames(pvals) <- rownames(pvals) <- names(df)
  {cat("\nCorrelations\n------------------------------------------------\n");
    print(corrs, digits = 5, na.print = "")}
  {cat("\np-values\n------------------------------------------------\n");
    print(pvals, digits = 5, na.print = "")}
  return(invisible(list(corrs = corrs, pvals = pvals)))
}
