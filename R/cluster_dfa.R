#' Clustering function to process DFA results.
#'
#' @param data_dfa A `fit_dfa` object. Results of `fit_dfa()`.
#' @param species_sub A `data.frame` of species names. It should be provided with species in row, the first column for complete species names and the second column for species names' codes.
#' @param nboot An `integer`. Number of bootstrap iterations for clustering. Default is 500.
#'
#' @return A `list` of three objects: `group_dfa` clustering output, `tmbObj` updated output of `MakeADFun()`, `sdRep` updated output of TMB optimisation.
#' @export
#'
#' @examples
#' \dontrun{
#' data(species_ts_mat)
#' data(species_uncert_ts_mat)
#'
#' data_ready_dfa <- prepare_data(data_ts = species_ts_mat,data_ts_se = species_uncert_ts_mat,
#' se_log = TRUE, perc_replace = 0.01)
#'
#' dfa_result <- fit_dfa(data_ts = data_ready_dfa$data_ts,data_ts_se = data_ready_dfa$data_ts_se,
#' min_year = data_ready_dfa$min_year, max_year = data_ready_dfa$max_year, species_name_ordre = data_ready_dfa$species_name_ordre,
#' species_sub = species_name, nfac = 0, mintrend = 1, maxtrend = 5, AIC = TRUE,
#' center_option = 1, silent = TRUE, control = list())
#'
#' data(species_name)
#'
#' cluster_result <- cluster_dfa(data_dfa = dfa_result, species_sub = species_name, nboot = 500)
#' }
cluster_dfa <- function(data_dfa,
                        species_sub,
                        nboot = 500
                        ){

  data_loadings <- data_dfa$data_loadings
  cov_mat_Z <- data_dfa$cov_mat_Z
  ny <- data_dfa$ny
  nfac <- data_dfa$nfac
  data_ts <- data_dfa$data_ts
  tmbObj <- data_dfa$tmbObj

  # Run group_from_dfa_boot to obtain species clusters

  if(nfac>1){
    group_dfa <- group_from_dfa_boot(data_loadings, cov_mat_Z, species_sub, nboot=nboot, ny, nfac)

    if(length(group_dfa[[3]])>1){
      Z_pred_from_kmeans <- as.matrix(group_dfa[[1]][[2]][grepl("X",names(group_dfa[[1]][[2]]))])
      W_from_kmeans <- t(matrix(rep(t(as.matrix(group_dfa[[1]][[1]][grepl("uncert",names(group_dfa[[1]][[1]]))])),(1+length(group_dfa[[3]]))), nrow=nrow(data_ts)))
      for(wg in 1:length(group_dfa[[3]])){
        W_from_kmeans[(wg+1),][group_dfa[[1]][[1]]$group!=wg] <- 0
      }
      W_from_kmeans[1,] <- 1
    }else{

      Z_pred_from_kmeans <- as.matrix(group_dfa[[1]][[2]][grepl("X",names(group_dfa[[1]][[2]]))])
      W_from_kmeans <- rbind(1/nrow(data_ts), rep(0, nrow(data_ts)))

    }

  }else{
    group_dfa <- 1

    Z_pred_from_kmeans <- matrix(rep(0, 10 * nfac), ncol = nfac)
    W_from_kmeans <- rbind(1/nrow(data_ts), rep(0, nrow(data_ts)))
  }

  # Update z_pred with actual values after clustering

  tmbObj$env$data$Z_pred <- Z_pred_from_kmeans
  tmbObj$env$data$W <- W_from_kmeans

  # Recalcul sdreport

  sdRep <- summary(TMB::sdreport(tmbObj))

  return(list(group_dfa = group_dfa,
              tmbObj = tmbObj,
              sdRep = sdRep))
}
