#' Run DFA
#'
#' @param data_ts  A `matrix` of species time series. It should be provided as a `matrix` with species time-series in row, species' codes as row names and years as column names.
#' @param data_ts_se A `matrix` of species of uncertainty (e.g. standard error) of species time series. It should be provided as a `matrix` with log species uncertainty time-series in row, species' codes as row names and years as column names.
#' @param min_year An `integer`. First year of time-series.
#' @param max_year An `integer`. Last year of time-series.
#' @param species_name_ordre A `character vector`. Species code following the order of `data_ts`.
#' @param species_sub A `data.frame` of species names. It should be provided with species in row, the first column for complete species names and the second column for species names' codes.
#' @param nfac An `integer`. Number of trends for the DFA. Default is 0 to test several values (between `mintrend` and `maxtrend`).
#' @param mintrend An `integer`. Minimum number of trends to test. Default is 1.
#' @param maxtrend An `integer`. Minimum number of trends to test. Default is 5.
#' @param AIC A `logical` value. `TRUE` computes and displays the AIC, `FALSE` does not. Default is `TRUE`.
#' @param center_option An `integer`. Option to handle time-series centered according to the first year (`center_option` = 0) or mean centred (default, `center_option` = 1).
#' @param silent A `logical` value. `TRUE` silences `MakeADFun()`, `FALSE` does not. Default is `TRUE`.
#' @param control A `list`. Control option for `MakeADFun()`. Default is list().
#'
#' @return A list of 21 objects: `tmbObj` the output of `MakeADFun()`, `tmbOpt` the optimisation from `tmbObj`, `data_ts` the processed `matrix` of species time series, `data_ts_se` the processed `matrix` of time series uncertainty, `data_ts_save` a `data.frame` of input species time series, `data_ts_save_long` a `data.frame` of input species time series in long format, `data_ts_se_save` a `data.frame` of input species uncertainty time series, `nfac` the number of latent trends, `ny` the number of time series, `nT` the number of time steps, `aic` the value of the AIC, `conv` the result of the convergence check, `sdRep_test` the summary of the TMB optimisation output, `sdRep_test_all` the complete TMB optimisation output, `x_hat` estimated latent trends, `x_hat_se` standard error of estimated latent trends, `Z_hat` estimated factor loadings, `Z_hat_orig` initial estimated factor loadings, `Z_hat_se` standard error of estimated factor loadings, `cov_mat_Z` covariance matrix of factor loadings, `data_loadings` `data.frame` of factor loadings.
#' @export
#' @importFrom graphics pie
#' @importFrom stats complete.cases dist kmeans lm na.omit nlminb optim prcomp rnorm runif sd setNames varimax weighted.mean
#'
#' @examples
#' \dontrun{
#' data(species_ts_mat)
#' data(species_uncert_ts_mat)
#' species_ts_mat[species_ts_mat==0] <- NA
#'
#' data_ready_dfa <- data_check_prepare(data_ts = species_ts_mat,data_ts_se = species_uncert_ts_mat,
#' se_log = FALSE,is_mean_centred = FALSE, min_year_sc=2000)
#'
#' dfa_result <- fun_make_dfa(data_ts = data_ready_dfa$data_ts,data_ts_se = data_ready_dfa$data_ts_se,
#' min_year = data_ready_dfa$min_year, max_year = data_ready_dfa$max_year, species_name_ordre = data_ready_dfa$species_name_ordre,
#' species_sub = species_name, nfac = 0, mintrend = 1, maxtrend = 5, AIC = TRUE,
#' center_option = 1, silent = TRUE, control = list())
#' }
fun_make_dfa <- function(data_ts,
                     data_ts_se,
                     min_year,
                     max_year,
                     species_name_ordre,
                     species_sub,
                     nfac = 0,
                     mintrend = 1,
                     maxtrend = 5,
                     AIC = TRUE,
                     center_option = 1,
                     silent = TRUE,
                     control = list()
)
{
  # Run the core_dfa function to find the best number of latent trend if not specified

  if(nfac==0){
    aic_best <- c()
    bic_best <- c()
    for(i in mintrend:maxtrend){
      core_dfa_res <- assign(paste0("core_dfa",i), core_dfa(data_ts=data_ts, data_ts_se=data_ts_se, nfac=i, silent = silent, control = control))

      if(core_dfa_res[[11]]==0){
        aic_best <- c(aic_best, core_dfa_res[[10]])
      } else {
        warning(paste0("Convergence issue:", core_dfa_res[[2]]$message))
        aic_best <- c(aic_best, core_dfa_res[[10]])
      }
    }
    if(length(which.min(aic_best))==0){stop("Convergence issues")}
    aic_min <- min(aic_best)
    delta_aic <- c()
    for(aic_ind in 1:length(aic_best)){
      delta_aic[aic_ind] <- aic_best[aic_ind] - aic_min
    }
    nfac <- min(which(delta_aic<2)) # which.min(aic_best)

    core_dfa_res <- get(paste0("core_dfa",nfac))
  }else{
    core_dfa_res <- core_dfa(data_ts=data_ts, data_ts_se=data_ts_se, nfac=nfac, silent = silent, control = control)
  }
  tmbObj <- core_dfa_res$tmbObj
  tmbOpt <- core_dfa_res$tmbOpt
  data_ts <- core_dfa_res$data_ts
  data_ts_se <- core_dfa_res$data_ts_se
  data_ts_save <- core_dfa_res$data_ts_save
  data_ts_save_long <- core_dfa_res$data_ts_save_long
  data_ts_se_save <- core_dfa_res$data_ts_se_save
  ny <- core_dfa_res$ny
  nT <- core_dfa_res$nT
  aic <- core_dfa_res$aic
  conv <- core_dfa_res$conv
  sdRep_test <- core_dfa_res$sdRep_test
  sdRep_test_all <- core_dfa_res$sdRep_test_all

  if(is.na(aic)){
    stop("Convergence issues")
  }

  # Get point estimates

  x_hat <- (tmbObj$env$parList)()$x
  Z_hat <- (tmbObj$env$parList)(par=tmbOpt$par)$Z

  Z_hat_se <- sdRep_test[rownames(sdRep_test)=="Z",2]
  if(nfac>1){
    for(i in 1:(nfac-1)){
      index_0 <- ny*i
      Z_hat_se <- append(Z_hat_se, rep(0,i), after=index_0)
    }
  }
  Z_hat_se <- matrix(Z_hat_se, ncol=ncol(Z_hat), nrow=nrow(Z_hat))

  Z_hat_orig <- sdRep_test[rownames(sdRep_test)=="Z",1]
  if(nfac>1){
    for(i in 1:(nfac-1)){
      index_0 <- ny*i
      Z_hat_orig <- append(Z_hat_orig, rep(0,i), after=index_0)
    }
  }
  Z_hat_orig <- matrix(Z_hat_orig, ncol=ncol(Z_hat), nrow=nrow(Z_hat))

  x_hat_se <- matrix(c(rep(0,nfac),sdRep_test[rownames(sdRep_test)=="x",2]), nrow=nfac)

  # Covariance matrix of species loadings

  cov_mat_Z <- sdRep_test_all$cov.fixed[which(rownames(sdRep_test)=="Z"),which(rownames(sdRep_test)=="Z")]

  # Initial data for species loadings

  data_loadings <- reshape2::melt(data.frame(code_sp=data_ts_save[,1],Z_hat_orig),
                        id.vars="code_sp")

  return(list(tmbObj = tmbObj,
              tmbOpt = tmbOpt,
              data_ts = data_ts,
              data_ts_se = data_ts_se,
              data_ts_save = data_ts_save,
              data_ts_save_long = data_ts_save_long,
              data_ts_se_save = data_ts_se_save,
              nfac = nfac,
              ny = ny,
              nT = nT,
              aic = aic,
              conv = conv,
              sdRep_test = sdRep_test,
              sdRep_test_all = sdRep_test_all,
              x_hat = x_hat,
              x_hat_se = x_hat_se,
              Z_hat = Z_hat,
              Z_hat_orig = Z_hat_orig,
              Z_hat_se = Z_hat_se,
              cov_mat_Z = cov_mat_Z,
              data_loadings = data_loadings))
}
