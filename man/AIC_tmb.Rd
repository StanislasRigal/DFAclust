% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AIC_tmb.R
\name{AIC_tmb}
\alias{AIC_tmb}
\title{Compute AIC of DFA models (internal function).}
\usage{
AIC_tmb(obj)
}
\arguments{
\item{obj}{A tmb object from MakeADFun(). Only works if obj has been already optimized.}
}
\value{
A numeric value corresponding to the AIC, computed excluding zero variance.
}
\description{
Compute AIC of DFA models (internal function).
}
\examples{
\dontrun{
tmbObj <- MakeADFun(data = dataTmb, parameters = tmbPar, map = tmbMap, random= c("x"), DLL= "dfa_model_se", silent = silent)
aic <- AIC.tmb(tmbObj)
}
}
