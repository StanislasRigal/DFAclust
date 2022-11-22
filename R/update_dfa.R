#' Updating DFA parameters after clustering
#'
#' @param tmbObj A `MakeADFun` object. Output of `MakeADFun()`.
#' @param Z_pred_from_kmeans A `matrix`. Factor loadings of cluster centres.
#' @param W_from_kmeans A `matrix`.  Weight of species time series.
#'
#' @return A `list` of two objects: `tmbObj` updated output of `MakeADFun()`, `sdRep` updated output of TMB optimisation
#' @export
#'
#' @examples
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
#'
#' data(species_name)
#'
#' cluster_result <- cluster_dfa(data_loadings = dfa_result$data_loadings,
#' cov_mat_Z = dfa_result$cov_mat_Z, species_sub = species_name,
#' nboot = 500, ny = dfa_result$ny, nfac = dfa_result$nfac,
#' data_ts = dfa_result$data_ts)
#'
#' dfa_result_update <- update_dfa(tmbObj = dfa_result$tmbObj,
#' Z_pred_from_kmeans = cluster_result$Z_pred_from_kmeans,
#' W_from_kmeans = cluster_result$W_from_kmeans)
update_dfa <- function(tmbObj,
                       Z_pred_from_kmeans,
                       W_from_kmeans
                       ){

  # Update z_pred with actual values after clustering

  tmbObj$env$data$Z_pred <- Z_pred_from_kmeans
  tmbObj$env$data$W <- W_from_kmeans

  # Recalcul sdreport

  sdRep <- summary(sdreport(tmbObj))

  return(list(tmbObj = tmbObj,
              sdRep = sdRep))
}
