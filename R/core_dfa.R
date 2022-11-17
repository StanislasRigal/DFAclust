#' Core function running the DFA and compute the AIC for a given number of latent trends
#'
#' @param data_ts A `data.table`. Dataset of species time series. It should be provided as a data.table with species time-series in row, the first column for species names' codes and years as column names.
#' @param data_ts_se A `data.table`. Dataset of uncertainty (e.g. standard error) of species time series. It should be provided as a data.table with species uncertainty time-series in row, the first column for species names' codes and years as column names.
#' @param nfac An `integer`. Number of trends for the DFA.
#' @param AIC A `logical` value. `TRUE` computes and displays the AIC, `FALSE` does not. Default is TRUE.
#' @param silent A `logical` value. `TRUE` silences `MakeADFun()`, `FALSE` does not. Default is TRUE.
#' @param control A `list`. Control option for `MakeADFun()`. Default is list().
#'
#' @return A `list` of 13 objects: `tmbObj` the output of `MakeADFun()`, `tmbOpt` the optimisation from `tmbObj`, `data_ts` the processed dataset of species time series, `data_ts_se` the processed dataset of time series uncertainty, `data_ts_save` the input dataset of species time series, `data_ts_save_long` the input dataset of species time series in long format, `data_ts_se_save` the input dataset of species uncertainty time series, `ny` the number of time series, `nT` the number of time steps, `aic` the value of the AIC, `conv` the result of the convergence check, `sdRep_test` the summary of the TMB optimisation output, `sdRep_test_all` the complete TMB optimisation output
#' @export
#'
#' @examples
#' \dontrun{
#' core_dfa(data_ts=data_ts, data_ts_se=data_ts_se, nfac=i, silent = silent, control = control)
#' }
core_dfa <- function(data_ts,
                     data_ts_se,
                     nfac,
                     AIC=TRUE,
                     silent = TRUE,
                     control = list()
) {

  # Save input data for plot

  data_ts_save <- as.data.frame(data_ts)
  data_ts_se_save <- as.data.frame(data_ts_se)
  data_ts_save_long <- cbind(melt(data_ts_save, id.vars=names(data_ts_save)[1]),
                             se=melt(data_ts_se_save, id.vars=names(data_ts_se_save)[1])[,3])
  names(data_ts_save_long)[2:4] <- c("Year","value_orig","se_orig")
  data_ts_save_long$Year <- as.numeric(as.character(data_ts_save_long$Year))

  # Remove potential column of ts names

  data_ts <- data_ts %>% select_if(Negate(is.character))
  data_ts_se <- data_ts_se %>% select_if(Negate(is.character))

  # Overwrite any changes to default control
  con <- list(nstart = 3, maxit = 10000, reltol = 1e-12, factr = 1e-11, gradtol = 1e-3, nlldeltatol = 1e-4, method = c('NLMINB', 'BFGS'))
  con[names(control)] <- control

  # Initialise Z_pred, actual values will be provided by group_from_dfa2

  Z_predinit <- matrix(rep(0, 10 * nfac), ncol = nfac)
  W_init <- rbind(1/nrow(data_ts),       # Overall mean, useful to get geometric mean trend across all species
                  rep(0, nrow(data_ts)),rep(0, nrow(data_ts)),
                  rep(0, nrow(data_ts)),rep(0, nrow(data_ts)),
                  rep(0, nrow(data_ts)),rep(0, nrow(data_ts)),
                  rep(0, nrow(data_ts)),rep(0, nrow(data_ts)),
                  rep(0, nrow(data_ts)),rep(0, nrow(data_ts))) # Two mean trends can currently computed, add more rows to W_init to compute more mean trends.

  # SE is on log-scale, so no transformation needed

  dataTmb <- list(y = log(as.matrix(data_ts)),
                  obs_se = as.matrix(data_ts_se),
                  center = 1,
                  Z_pred = Z_predinit,
                  W = W_init)

  # Prepare parameters for DFA

  nfac <- nfac # Number of factors
  ny <- nrow(data_ts) # Number of time series
  nT <- ncol(data_ts) # Number of time step

  # Set up parameter constraints. Elements set to NA will be fixed and not estimated.
  constrInd <- rep(1:nfac, each = ny) > rep(1:ny,  nfac)
  Zmap <- matrix(ncol = nfac, nrow = ny)
  Zmap[constrInd] <- NA
  Zmap[!constrInd] <- 1:sum(!constrInd)
  xmap <- matrix(ncol = nT, nrow = nfac)
  xmap[,1] <- NA
  xmap[(nfac + 1) : (nT * nfac)] <- 1:((nT - 1)* nfac)
  tmbMap <- list(Z = as.factor(Zmap),
                 x = as.factor(xmap))

  # Starting values for the optimisation

  optList <- vector(con$nstart * length(con$method), mode = 'list')
  names(optList) <- rep(con$method, con$nstart)
  tmbList <- vector(con$nstart * length(con$method), mode = 'list')
  names(tmbList) <- rep(con$method, con$nstart)

  for (i in 1:length(optList)) {
    log_re_sp <- runif(ny, -1, 0)

    Zinit <- matrix(rnorm(ny * nfac), ncol = nfac)

    # Set constrained elements to zero

    Zinit[constrInd] <- 0

    # List of parameters for DFA

    tmbPar <-  list(log_re_sp=log_re_sp, Z = Zinit,
                    x=matrix(c(rep(0, nfac), rnorm(nfac * (nT - 1))),
                             ncol = nT, nrow = nfac))


    # Make DFA
    tmbObj <- MakeADFun(data = dataTmb, parameters = tmbPar, map = tmbMap, random= c("x"), DLL= "dfa_model_se", silent = silent)
    optList[[i]] = switch(names(optList)[i],
                          NLMINB = nlminb(tmbObj$par, tmbObj$fn, tmbObj$gr, control = list(iter.max = con$maxit, eval.max  =2*con$maxit, rel.tol =  con$reltol)),
                          BFGS = optim(tmbObj$par, tmbObj$fn, tmbObj$gr, method = 'BFGS', control = list(maxit = con$maxit, reltol = con$reltol)),
                          LBFGS = optim(tmbObj$par, tmbObj$fn, tmbObj$gr, method = 'L-BFGS-B', control = list(maxit = con$maxit, factr = con$factr))
    )
    if (names(optList)[i] == 'NLMINB')
      optList[[i]]$value <- optList[[i]]$objective
    tmbList[[i]] <- tmbObj
  }
  convergence = sapply(optList, FUN = `[[`, 'convergence')
  print(convergence)
  nll = sapply(optList, FUN = `[[`, 'value')
  print(nll)
  maxgrad = sapply(optList, FUN = function(opt) {max(abs(tmbObj$gr(opt$par))) })
  print(maxgrad)
  eligible = abs(nll - min(nll)) < con$nlldeltatol & convergence == 0 & maxgrad < con$gradtol
  if (!any(eligible)) {
    eligible = abs(nll - min(nll)) < con$nlldeltatol & convergence == 0 # Currently prioritizes optim convergence over gradient check
    if(!any(eligible))
      eligible = abs(nll - min(nll)) < con$nlldeltatol
  }

  ind.best <-  which.min((nll - 1e6 * sign(min(nll)) * !eligible)) # Return the smallest loglikelihood fit that meets other convergence criteria
  tmbOpt <- optList[[ind.best]]
  tmbObj <- tmbList[[ind.best]]

  sdRep_test_all <- sdreport(tmbObj)
  sdRep_test <- summary(sdRep_test_all)

  # Check convergence
  conv <- tmbOpt$convergence
  if(tmbOpt$convergence != 0){warning(paste0("Convergence issue:", tmbOpt$message))}
  if (tmbOpt$convergence == 0 & maxgrad[ind.best] > con$gradtol)
    warning(paste0('Optimization converged, but maximum gradient = ', maxgrad[ind.best]))

  # Compute AIC

  if(AIC){
    aic <- AIC.tmb(tmbObj)
    writeLines(paste('AIC: ', aic))
  } else {aic <- bic <- NA}

  return(list(tmbObj, # TMB output
              tmbOpt, # Optimisation from TMB
              data_ts, # Dataset of time series (output)
              data_ts_se, # Dataset of standard error of time series (output)
              data_ts_save, # Dataset of time series (input saved)
              data_ts_save_long, # Dataset of time series (input saved in long format)
              data_ts_se_save, # Dataset of standard error of time series (input saved)
              ny, # Number of time series
              nT, # Number of time step
              aic, # AIC
              conv, # Convergence check
              sdRep_test, # Summary of the TMB optimisation output
              sdRep_test_all # Complete TMB optimisation output
  ))
}
