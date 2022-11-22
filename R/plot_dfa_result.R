#' Plot DFAclust results
#'
#' @param data_ts_save A `data.frame`. Input species time series.
#' @param data_ts_se_save A `data.frame`. Input uncertainty of species time series.
#' @param data_ts A `matrix`. The processed `matrix` of species time series.
#' @param data_ts_se A `matrix`. The processed `matrix` of uncertainty of species time series.
#' @param sdRep A `TMB` object. Summary of the TMB optimisation output.
#' @param ny An `integer`. Number of time series.
#' @param species_sub A `data.frame` of species names. It should be provided with species in row, the first column for complete species names and the second column for species names' codes.
#' @param x_hat A `matrix`. Estimated latent trends.
#' @param x_hat_se A `matrix`. Standard error of estimated latent trends.
#' @param Z_hat A `matrix`. Estimated factor loadings.
#' @param nfac An `integer`. Number of latent trends.
#' @param group_dfa A `list`. Clustering output.
#' @param nT An `integer`. Number of time steps.
#' @param min_year An `integer`. First year of time-series.
#'
#' @return A `list` of 13 objects: `data_to_plot_sp` data on species time-series and fit, `data_to_plot_tr` Data on latent trends, `data_loadings` Data on factor loadings, `exp_var_lt` Data on % of variance of species ts explained by latent trends, `plot_sp` Plot of species time-series and fit, `plot_tr` Plot of latent trends, `plot_ld` Plot of factor loadings, `plot_perc_var` Plot of % of variance of species ts explained by latent trends, `plot_sp_group` Plot clusters in factorial plan, `plot_group_ts` Plot clustertime-series, `plot_group_ts2` Plot clustertime-series from sdRep, `trend_group` Cluster barycentre times-series, `trend_group2` Cluster barycentre times-series from sdRep.
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
#' cov_mat_Z = dfa_result$cov_mat_Z, species_sub = species_name,
#' nboot = 500, ny = dfa_result$ny, nfac = dfa_result$nfac,
#' data_ts = dfa_result$data_ts)
#'
#' dfa_result_update <- update_dfa(tmbObj = dfa_result$tmbObj,
#' Z_pred_from_kmeans = cluster_result$Z_pred_from_kmeans,
#' W_from_kmeans = cluster_result$W_from_kmeans)
#'
#' dfa_result_plot = plot_dfa_result(data_ts_save = dfa_result$data_ts_save, data_ts_se_save = dfa_result$data_ts_se_save,
#' data_ts = dfa_result=data_ts, data_ts_se = dfa_result$data_ts_se, sdRep = dfa_result_update$sdRep,
#' ny = dfa_result$ny, species_sub = species_name, x_hat = dfa_result$x_hat, x_hat_se = dfa_result$x_hat_se,
#' Z_hat = dfa_result$Z_hat, nfac = dfa_result$nfac, group_dfa = cluster_result$group_dfa,
#' nT = dfa_result$nT, min_year = data_ready_dfa$min_year)
#' }
plot_dfa_result <- function(data_ts_save,
                            data_ts_se_save,
                            data_ts,
                            data_ts_se,
                            sdRep,
                            ny,
                            species_sub,
                            x_hat,
                            x_hat_se,
                            Z_hat,
                            nfac,
                            group_dfa,
                            nT,
                            min_year

){
  # Prepare data to plot

  if(!is.character(data_ts_save[,1]) & !is.factor(data_ts_save[,1])){
    data_ts_save <- data.frame(code_sp=as.character(row.names(data_ts_save)),
                               data_ts)
    data_ts_se_save <- data.frame(code_sp=as.character(row.names(data_ts_se_save)),
                                  data_ts_se)
  }else{
    data_ts_save <- data.frame(code_sp=data_ts_save[,1], data_ts)
    data_ts_se_save <- data.frame(code_sp=data_ts_se_save[,1], data_ts_se)
  }

  # Back-transform log values of prediction of species ts

  sp_ts <- data.frame(code_sp=data_ts_save[,1],
                      matrix(sdRep[rownames(sdRep)=="x_sp",1], nrow=ny))

  sp_se_ts <- data.frame(code_sp=data_ts_save[,1],
                         matrix(sdRep[rownames(sdRep)=="x_sp",2], nrow=ny))

  # Data for species time-series plot

  data_to_plot_sp <- cbind(data_ts_save_long,
                           reshape2::melt(data_ts_save, id.vars=names(data_ts_save)[1])[,3],
                           se=reshape2::melt(data_ts_se_save, id.vars=names(data_ts_se_save)[1])[,3],
                           pred=reshape2::melt(sp_ts, id.vars=names(data_ts_se_save)[1])[,3],
                           pred_se=reshape2::melt(sp_se_ts, id.vars=names(data_ts_se_save)[1])[,3])

  data_to_plot_sp <- merge(data_to_plot_sp, species_sub[,c("name_long","code_sp")],by="code_sp")
  data_to_plot_sp$pred.value_exp <- exp(data_to_plot_sp$pred.value)
  data_to_plot_sp$pred_se.value_exp <- exp(data_to_plot_sp$pred.value)*data_to_plot_sp$pred_se.value
  data_to_plot_sp$se.value_exp <- data_to_plot_sp$value*data_to_plot_sp$se.value

  data_to_plot_sp <- ddply(data_to_plot_sp, .(code_sp,name_long),
                           .fun = function(x){
                             x$value_1 <- x$value/x$value[1]
                             x$pred.value_exp_1 <- x$pred.value_exp/x$pred.value_exp[1]
                             x$se.value_exp_1 <- x$se.value_exp/x$value[1]
                             x$pred_se.value_exp_1 <- x$pred_se.value_exp/x$pred.value_exp[1]
                             return(x)
                           }, .progress="text")



  # Data for DFA trend plot

  data_to_plot_tr <- data.frame(t(x_hat), Year=min(data_to_plot_sp$Year):max(data_to_plot_sp$Year))
  data_to_plot_tr_se <- data.frame(t(x_hat_se), Year=min(data_to_plot_sp$Year):max(data_to_plot_sp$Year))

  if(nfac > 1){

    # Add rotated trends

    data_to_plot_tr_rot <- data.frame(t(solve(varimax(Z_hat)$rotmat) %*% x_hat), Year=min(data_to_plot_sp$Year):max(data_to_plot_sp$Year))

    data_to_plot_tr <- cbind(reshape2::melt(data_to_plot_tr, id.vars = "Year"),
                             se=reshape2::melt(data_to_plot_tr_se, id.vars = "Year")[,3], # This SE is ok as it comes directly from TMB
                             rot_tr=reshape2::melt(data_to_plot_tr_rot, id.vars = "Year")[,3])

    data_to_plot_tr$variable <- as.character(data_to_plot_tr$variable) %>% gsub(pattern="X", replacement = "Latent trend ") %>% as.factor()

    # Data for species loadings

    data_loadings <- cbind(reshape2::melt(data.frame(code_sp=data_ts_save[,1],
                                           Z_hat %*% varimax(Z_hat)$rotmat), id.vars="code_sp"),
                           se.value = NA)

    data_loadings <- merge(data_loadings, species_sub[,c("name_long","code_sp")],by="code_sp")
    data_loadings <- merge(data_loadings, group_dfa[[1]][[1]][,c("code_sp","PC1")],by="code_sp")
    data_loadings$name_long <- fct_reorder(data_loadings$name_long,data_loadings$PC1)

    data_loadings$variable <- as.character(data_loadings$variable) %>% gsub(pattern="X", replacement = "Latent trend ") %>% as.factor()

    # Data for % variance of species ts explained by latent trends

    exp_var_lt <- data_loadings[,c("variable","value","name_long")]
    exp_var_lt <- dcast(exp_var_lt, name_long~variable, value.var = "value", fun.aggregate = sum)
    eta_sp <- data.frame(name_long=species_sub$name_long, eta=sdRep[!grepl("log_re_sp", row.names(sdRep)) & grepl("re_sp", row.names(sdRep)) ,1])
    exp_var_lt <- merge(exp_var_lt,eta_sp, by="name_long", all.x=T)

    exp_var_lt$all <- apply(exp_var_lt[,-1],1,function(x){return(sum(abs(x)))})
    exp_var_lt[,2:(ncol(exp_var_lt)-1)] <- exp_var_lt[,2:(ncol(exp_var_lt)-1)]/exp_var_lt$all
    exp_var_lt$name_long <- fct_reorder(exp_var_lt$name_long,exp_var_lt$eta)
    exp_var_lt_long <- reshape2::melt(exp_var_lt[,1:(ncol(exp_var_lt)-1)])


    # Plots

    plot_sp <- ggplot(data_to_plot_sp, aes(x=Year, y=value)) + geom_point() +
      geom_pointrange(aes(ymax = value + 1.96 * se.value_exp, ymin=value - 1.96 * se.value_exp)) +
      geom_line(aes(y=pred.value_exp)) +
      geom_ribbon(aes(y=pred.value_exp, ymax = pred.value_exp + 1.96*pred_se.value_exp, ymin=pred.value_exp - 1.96*pred_se.value_exp), alpha=0.5) +
      facet_wrap(name_long ~ ., ncol=round(sqrt(length(unique(data_to_plot_sp$code_sp)))), scales = "free", labeller = label_bquote(col = italic(.(name_long)))) +
      theme_modern() + theme(axis.title.x = element_blank(), axis.title.y = element_blank())

    plot_tr <- ggplot(data_to_plot_tr, aes(x=Year, y=rot_tr.value)) +
      geom_line(aes(colour=variable))+ylab("Rotated value") +
      geom_ribbon(aes(ymax = (rot_tr.value+1.96*se.value), ymin=(rot_tr.value-1.96*se.value), fill=variable), alpha=0.1) +
      facet_wrap(variable ~ ., ncol=min(3,length(unique(data_to_plot_tr$variable)))) +
      theme_modern() + theme(legend.position = "none")

    plot_ld <- ggplot(data_loadings) +
      geom_col(aes(value, name_long, fill=variable)) +
      geom_errorbar(aes(x=value,y=name_long,xmax = value+se.value, xmin=value-se.value), alpha=0.5) +
      facet_wrap(variable ~ ., ncol=length(unique(data_loadings$variable))) +
      theme_modern() +
      theme(legend.position = "none", axis.title.x = element_blank(), axis.title.y = element_blank(),
            axis.text.x = element_text(angle = 45, hjust = 1), axis.text.y = element_text(face="italic"))

    plot_perc_var <- ggplot(exp_var_lt_long) +
      geom_col(aes(value, name_long, fill=variable)) +
      facet_wrap(variable ~ ., ncol=length(unique(exp_var_lt_long$variable))) +
      theme_modern() +
      theme(legend.position = "none", axis.title.x = element_blank(), axis.title.y = element_blank(),
            axis.text.x = element_text(angle = 45, hjust = 1), axis.text.y = element_text(face="italic"))

  }else{

    data_to_plot_tr <- cbind(reshape2::melt(data_to_plot_tr, id.vars = "Year"),
                             se=reshape2::melt(data_to_plot_tr_se, id.vars = "Year")[,3])

    # Data for species loadings

    data_loadings <- cbind(reshape2::melt(data.frame(code_sp=data_ts_save[,1],
                                           sdRep[rownames(sdRep)=="Z",1]), id.vars="code_sp"),
                           se.value = NA)

    data_loadings <- merge(data_loadings, species_sub[,c("name_long","code_sp")],by="code_sp")


    # Data for % variance of species ts explained by latent trends

    exp_var_lt <- data_loadings[,c("variable","value","name_long")]
    exp_var_lt <- dcast(exp_var_lt, name_long~variable, value.var = "value", fun.aggregate = sum)
    eta_sp <- data.frame(name_long=species_sub$name_long, eta=sdRep[!grepl("log_re_sp", row.names(sdRep)) & grepl("re_sp", row.names(sdRep)) ,1])
    exp_var_lt <- merge(exp_var_lt,eta_sp, by="name_long", all.x=T)

    exp_var_lt$all <- apply(exp_var_lt[,-1],1,function(x){return(sum(abs(x)))})
    exp_var_lt[,2:(ncol(exp_var_lt)-1)] <- exp_var_lt[,2:(ncol(exp_var_lt)-1)]/exp_var_lt$all
    exp_var_lt$name_long <- fct_reorder(exp_var_lt$name_long,exp_var_lt$eta)
    exp_var_lt_long <- reshape2::melt(exp_var_lt[,1:(ncol(exp_var_lt)-1)])


    # Plots

    plot_sp <- ggplot(data_to_plot_sp, aes(x=Year, y=value)) + geom_point() +
      geom_pointrange(aes(ymax = value + 1.96 * se.value_exp, ymin=value - 1.96 * se.value_exp)) +
      facet_wrap(code_sp ~ ., ncol=4, scales = "free") +
      theme_modern()

    plot_tr <- ggplot(data_to_plot_tr, aes(x=Year, y=value)) +
      geom_line(aes(colour=variable))+
      theme_modern()

    plot_ld <- ggplot(data_loadings) +
      geom_col(aes(value, name_long, fill=variable)) +
      geom_errorbar(aes(x=value,y=name_long,xmax = value+se.value, xmin=value-se.value), alpha=0.5) +
      facet_wrap(variable ~ ., ncol=4) +
      theme_modern() + theme(legend.position = "none")

    plot_perc_var <- ggplot(exp_var_lt_long) +
      geom_col(aes(value, name_long, fill=variable)) +
      facet_wrap(variable ~ ., ncol=length(unique(exp_var_lt_long$variable))) +
      theme_modern() +
      theme(legend.position = "none", axis.title.x = element_blank(), axis.title.y = element_blank(),
            axis.text.x = element_text(angle = 45, hjust = 1), axis.text.y = element_text(face="italic"))

  }
  if(is.list(group_dfa)){
    if(length(group_dfa[[3]])>1){
      plot_sp_group_all <- plot_group_boot(nb_group = nrow(group_dfa[[1]][[2]]),
                                           centroids = group_dfa[[2]],
                                           kmeans_res = group_dfa[[1]],
                                           sdrep = sdRep, nT = nT,
                                           min_year = min_year,
                                           stability_cluster_final = group_dfa[[3]],
                                           mean_dist_clust = group_dfa[[4]],
                                           pca_centre = group_dfa[[5]],
                                           Z_hat = Z_hat,
                                           x_hat = x_hat,
                                           data_ts = data_ts,
                                           data_ts_se = data_ts_se,
                                           data_to_plot_sp = data_to_plot_sp,
                                           species_name_ordre = species_name_ordre)
      plot_sp_group <- plot_sp_group_all$final_plot_list
      plot_group_ts <- plot_sp_group_all$graph
      trend_group <- plot_sp_group_all$data_trend_group
      plot_group_ts2 <- plot_sp_group_all$graph2
      trend_group2 <- plot_sp_group_all$data_trend_group2
    }
    if(length(group_dfa[[3]])==1){
      plot_sp_group_all <- plot_group_boot(nb_group = 1,
                                           centroids = group_dfa[[2]],
                                           kmeans_res = group_dfa[[1]],
                                           sdrep = sdRep, nT = nT,
                                           min_year = min_year,
                                           stability_cluster_final = group_dfa[[3]],
                                           mean_dist_clust = group_dfa[[4]],
                                           pca_centre = group_dfa[[5]],
                                           Z_hat = Z_hat,
                                           x_hat = x_hat,
                                           data_ts = data_ts,
                                           data_ts_se = data_ts_se,
                                           data_to_plot_sp = data_to_plot_sp,
                                           species_name_ordre = species_name_ordre)
      plot_sp_group <- plot_sp_group_all$final_plot_list
      plot_group_ts <- plot_sp_group_all$graph
      trend_group <- plot_sp_group_all$data_trend_group
      plot_group_ts2 <- plot_sp_group_all$graph2
      trend_group2 <- plot_sp_group_all$data_trend_group2
    }
  }

  if(!is.list(group_dfa)){
    plot_sp_group_all <- NA
    plot_sp_group <- NA
    plot_group_ts <- NA
    trend_group <- NA
    plot_group_ts2 <- NA
    trend_group2 <- NA
  }

  return(list(data_to_plot_sp = data_to_plot_sp, # Data on species time-series and fit
              data_to_plot_tr = data_to_plot_tr, # Data on latent trends
              data_loadings = data_loadings, # Data on factor loadings
              exp_var_lt = exp_var_lt, # Data on % of variance of species ts explained by latent trends
              plot_sp = plot_sp, # Plot of species time-series and fit
              plot_tr = plot_tr, # Plot of latent trends
              plot_ld = plot_ld, # Plot of factor loadings
              plot_perc_var = plot_perc_var, # Plot of % of variance of species ts explained by latent trends
              plot_sp_group = plot_sp_group, # Plot clusters in factorial plan
              plot_group_ts = plot_group_ts, # Plot clustertime-series
              plot_group_ts2 = plot_group_ts2, # Plot clustertime-series from sdRep
              aic = aic, # Best AIC
              sdRep = sdRep, # Optimisation output
              group = group_dfa, # Cluster results
              trend_group = trend_group, # Cluster barycentre times-series
              trend_group2 = trend_group2 # Cluster barycentre times-series from sdRep
  ))
}
