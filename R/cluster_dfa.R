#' Clustering function to process DFA results.
#'
#' @param data_loadings A `data.frame`. Factor loadings and standard error.
#' @param cov_mat_Z A `matrix`. Covariance matrix of factor loadings.
#' @param species_sub A `data.frame` of species names. It should be provided with species in row, the first column for complete species names and the second column for species names' codes.
#' @param nboot An `integer`. Number of bootdtrap iterations for clustering. Default is 500.
#' @param ny An `integer`. Number of time-series.
#' @param nfac An `integer`. Number of latent trends.
#' @param data_ts A `matrix` of species time series.
#'
#' @return A `list` of three objects: `group_dfa` clustering output, `Z_pred_from_kmeans` factor loadings of clusters, `W_from_kmeans` weight of species time series.
#' @export
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
#'
#' data(species_name)
#'
#' cluster_result <- cluster_dfa(data_loadings = dfa_result$data_loadings,
#' cov_mat_Z = dfa_result$cov_mat_Z, species_sub = species_name, nboot = 500,
#' ny = dfa_result$ny, nfac = dfa_result$nfac, data_ts = dfa_result$data_ts)
#' }
cluster_dfa <- function(data_loadings,
                        cov_mat_Z,
                        species_sub,
                        nboot = 500,
                        ny,
                        nfac,
                        data_ts
                        ){
  # Run group_from_dfa_boot to obtain species clusters

  if(nfac>1){
    group_dfa <- group_from_dfa_boot1(data_loadings, cov_mat_Z, species_sub, nboot=nboot, ny, nfac)

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

  return(list(group_dfa = group_dfa,
              Z_pred_from_kmeans = Z_pred_from_kmeans,
              W_from_kmeans = W_from_kmeans))
}
