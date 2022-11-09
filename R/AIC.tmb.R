#' Compute AIC of DFA models
#'
#' @param obj A tmb object from MakeADFun(). Only works if obj has been already optimized.
#'
#' @return A numeric value corresponding to the AIC, computed excluding zero variance.
#' @export
#'
#' @examples
#' tmbObj <- MakeADFun(data = dataTmb, parameters = tmbPar, map = tmbMap, random= c("x"), DLL= "dfa_model_se", silent = silent)
#' aic <- AIC.tmb(tmbObj)
AIC.tmb <- function(obj) {
  as.numeric(2 * obj$env$value.best + 2*(sum(obj$env$lfixed())))
}
