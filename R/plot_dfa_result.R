#' Plot DFAclust results
#'
#' @param data_dfa A `fit_dfa` object. Results of `fit_dfa()`.
#' @param sdRep A `TMB` object. Summary of the TMB optimisation output.
#' @param species_sub A `data.frame` of species names. It should be provided with species in row, the first column for complete species names and the second column for species names' codes.
#' @param group_dfa A `list`. Clustering output.
#' @param min_year An `integer`. First year of time-series.
#' @param species_name_ordre A `character vector`. Species code following the order of `data_ts`.
#'
#' @return A `list` of 13 objects: `data_to_plot_sp` data on species time-series and fit, `data_to_plot_tr` Data on latent trends, `data_loadings` Data on factor loadings, `exp_var_lt` Data on % of variance of species ts explained by latent trends, `plot_sp` Plot of species time-series and fit, `plot_tr` Plot of latent trends, `plot_ld` Plot of factor loadings, `plot_perc_var` Plot of % of variance of species ts explained by latent trends, `plot_sp_group` Plot clusters in factorial plan, `plot_group_ts` Plot clustertime-series, `plot_group_ts2` Plot clustertime-series from sdRep, `trend_group` Cluster barycentre times-series, `trend_group2` Cluster barycentre times-series from sdRep.
#' @export
#'
#' @examples
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
#'
#' dfa_result_plot <- plot_dfa_result(data_dfa = dfa_result, sdRep = cluster_result$sdRep,
#' species_sub = species_name, group_dfa = cluster_result$group_dfa,
#' min_year = data_ready_dfa$min_year, species_name_ordre = data_ready_dfa$species_name_ordre)
plot_dfa_result <- function(data_dfa,
                            sdRep,
                            species_sub,
                            group_dfa,
                            min_year,
                            species_name_ordre

){

  data_ts_save = data_dfa$data_ts_save
  data_ts_se_save = data_dfa$data_ts_se_save
  data_ts_save_long = data_dfa$data_ts_save_long
  data_ts = data_dfa$data_ts
  data_ts_se = data_dfa$data_ts_se
  sdRep = cluster_result$sdRep
  ny = data_dfa$ny
  species_sub = species_name
  x_hat = data_dfa$x_hat
  x_hat_se = data_dfa$x_hat_se
  Z_hat = data_dfa$Z_hat
  nfac = data_dfa$nfac
  group_dfa = cluster_result$group_dfa
  nT = data_dfa$nT
  min_year = data_ready_dfa$min_year
  species_name_ordre = data_ready_dfa$species_name_ordre

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
                           value=reshape2::melt(data_ts_save, id.vars=names(data_ts_save)[1])[,3],
                           se=reshape2::melt(data_ts_se_save, id.vars=names(data_ts_se_save)[1])[,3],
                           pred=reshape2::melt(sp_ts, id.vars=names(data_ts_se_save)[1])[,3],
                           pred_se=reshape2::melt(sp_se_ts, id.vars=names(data_ts_se_save)[1])[,3])

  data_to_plot_sp <- merge(data_to_plot_sp, species_sub[,c("name_long","code_sp")],by="code_sp")
  data_to_plot_sp$pred.value_exp <- exp(data_to_plot_sp$pred)
  data_to_plot_sp$pred_se.value_exp <- exp(data_to_plot_sp$pred)*data_to_plot_sp$pred_se
  data_to_plot_sp$se.value_exp <- data_to_plot_sp$value*data_to_plot_sp$se

  data_to_plot_sp <- plyr::ddply(data_to_plot_sp,
                                 .variables = c("code_sp","name_long"),
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

    data_to_plot_tr$variable <- as.character(data_to_plot_tr$variable)
    data_to_plot_tr$variable <- gsub(pattern="X", replacement = "Latent trend ", x=data_to_plot_tr$variable)
    data_to_plot_tr$variable <- as.factor(data_to_plot_tr$variable)

    # Data for species loadings

    data_loadings <- cbind(reshape2::melt(data.frame(code_sp=data_ts_save[,1],
                                           Z_hat %*% varimax(Z_hat)$rotmat), id.vars="code_sp"),
                           se.value = NA)

    data_loadings <- merge(data_loadings, species_sub[,c("name_long","code_sp")],by="code_sp")
    data_loadings <- merge(data_loadings, group_dfa[[1]][[1]][,c("code_sp","PC1")],by="code_sp")
    data_loadings$name_long <- forcats::fct_reorder(data_loadings$name_long,data_loadings$PC1)

    data_loadings$variable <- as.character(data_loadings$variable)
    data_loadings$variable <- gsub(pattern="X", replacement = "Latent trend ", x = data_loadings$variable)
    data_loadings$variable <- as.factor(data_loadings$variable)

    # Data for % variance of species ts explained by latent trends

    exp_var_lt <- data_loadings[,c("variable","value","name_long")]
    exp_var_lt <- reshape2::dcast(exp_var_lt, name_long~variable, value.var = "value", fun.aggregate = sum)
    eta_sp <- data.frame(name_long=species_sub$name_long, eta=sdRep[!grepl("log_re_sp", row.names(sdRep)) & grepl("re_sp", row.names(sdRep)) ,1])
    exp_var_lt <- merge(exp_var_lt,eta_sp, by="name_long", all.x=T)

    exp_var_lt$all <- apply(exp_var_lt[,-1],1,function(x){return(sum(abs(x)))})
    exp_var_lt[,2:(ncol(exp_var_lt)-1)] <- exp_var_lt[,2:(ncol(exp_var_lt)-1)]/exp_var_lt$all
    exp_var_lt$name_long <- forcats::fct_reorder(exp_var_lt$name_long,exp_var_lt$eta)
    exp_var_lt_long <- reshape2::melt(exp_var_lt[,1:(ncol(exp_var_lt)-1)])


    # Plots

    plot_sp <- ggplot2::ggplot(data_to_plot_sp, ggplot2::aes(x=Year, y=value)) +
      ggplot2::geom_point() +
      ggplot2::geom_pointrange(ggplot2::aes(ymax = value + 1.96 * se.value_exp, ymin=value - 1.96 * se.value_exp)) +
      ggplot2::geom_line(ggplot2::aes(y=pred.value_exp)) +
      ggplot2::geom_ribbon(ggplot2::aes(y=pred.value_exp, ymax = pred.value_exp + 1.96*pred_se.value_exp, ymin=pred.value_exp - 1.96*pred_se.value_exp), alpha=0.5) +
      ggplot2::facet_wrap(name_long ~ ., ncol=round(sqrt(length(unique(data_to_plot_sp$code_sp)))), scales = "free", labeller = ggplot2::label_bquote(col = italic(.(name_long)))) +
      see::theme_modern() + ggplot2::theme(axis.title.x = ggplot2::element_blank(), axis.title.y = ggplot2::element_blank())

    plot_tr <- ggplot2::ggplot(data_to_plot_tr, ggplot2::aes(x=Year, y=rot_tr.value)) +
      ggplot2::geom_line(ggplot2::aes(colour=variable)) + ggplot2::ylab("Rotated value") +
      ggplot2::geom_ribbon(ggplot2::aes(ymax = (rot_tr.value+1.96*se.value), ymin=(rot_tr.value-1.96*se.value), fill=variable), alpha=0.1) +
      ggplot2::facet_wrap(variable ~ ., ncol=min(3,length(unique(data_to_plot_tr$variable)))) +
      see::theme_modern() + ggplot2::theme(legend.position = "none")

    plot_ld <- ggplot2::ggplot(data_loadings) +
      ggplot2::geom_col(ggplot2::aes(value, name_long, fill=variable)) +
      ggplot2::geom_errorbar(ggplot2::aes(x=value,y=name_long,xmax = value+se.value, xmin=value-se.value), alpha=0.5) +
      ggplot2::facet_wrap(variable ~ ., ncol=length(unique(data_loadings$variable))) +
      see::theme_modern() +
      ggplot2::theme(legend.position = "none", axis.title.x = ggplot2::element_blank(), axis.title.y = ggplot2::element_blank(),
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1), axis.text.y = ggplot2::element_text(face="italic"))

    plot_perc_var <- ggplot2::ggplot(exp_var_lt_long) +
      ggplot2::geom_col(ggplot2::aes(value, name_long, fill=variable)) +
      ggplot2::facet_wrap(variable ~ ., ncol=length(unique(exp_var_lt_long$variable))) +
      see::theme_modern() +
      ggplot2::theme(legend.position = "none", axis.title.x = ggplot2::element_blank(), axis.title.y = ggplot2::element_blank(),
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1), axis.text.y = ggplot2::element_text(face="italic"))

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
    exp_var_lt <- reshape2::dcast(exp_var_lt, name_long~variable, value.var = "value", fun.aggregate = sum)
    eta_sp <- data.frame(name_long=species_sub$name_long, eta=sdRep[!grepl("log_re_sp", row.names(sdRep)) & grepl("re_sp", row.names(sdRep)) ,1])
    exp_var_lt <- merge(exp_var_lt,eta_sp, by="name_long", all.x=T)

    exp_var_lt$all <- apply(exp_var_lt[,-1],1,function(x){return(sum(abs(x)))})
    exp_var_lt[,2:(ncol(exp_var_lt)-1)] <- exp_var_lt[,2:(ncol(exp_var_lt)-1)]/exp_var_lt$all
    exp_var_lt$name_long <- forcats::fct_reorder(exp_var_lt$name_long,exp_var_lt$eta)
    exp_var_lt_long <- reshape2::melt(exp_var_lt[,1:(ncol(exp_var_lt)-1)])


    # Plots

    plot_sp <- ggplot2::ggplot(data_to_plot_sp, ggplot2::aes(x=Year, y=value)) + ggplot2::geom_point() +
      ggplot2::geom_pointrange(ggplot2::aes(ymax = value + 1.96 * se.value_exp, ymin=value - 1.96 * se.value_exp)) +
      ggplot2::facet_wrap(code_sp ~ ., ncol=4, scales = "free") +
      see::theme_modern()

    plot_tr <- ggplot2::ggplot(data_to_plot_tr, ggplot2::aes(x=Year, y=value)) +
      ggplot2::geom_line(ggplot2::aes(colour=variable))+
      see::theme_modern()

    plot_ld <- ggplot2::ggplot(data_loadings) +
      geom_col(ggplot2::aes(value, name_long, fill=variable)) +
      ggplot2::geom_errorbar(ggplot2::aes(x=value,y=name_long,xmax = value+se.value, xmin=value-se.value), alpha=0.5) +
      ggplot2::facet_wrap(variable ~ ., ncol=4) +
      see::theme_modern() + ggplot2::theme(legend.position = "none")

    plot_perc_var <- ggplot2::ggplot(exp_var_lt_long) +
      geom_col(ggplot2::aes(value, name_long, fill=variable)) +
      facet_wrap(variable ~ ., ncol=length(unique(exp_var_lt_long$variable))) +
      see::theme_modern() +
      ggplot2::theme(legend.position = "none", axis.title.x = ggplot2::element_blank(), axis.title.y = ggplot2::element_blank(),
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1), axis.text.y = ggplot2::element_text(face="italic"))

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
              sdRep = sdRep, # Optimisation output
              group = group_dfa, # Cluster results
              trend_group = trend_group, # Cluster barycentre times-series
              trend_group2 = trend_group2 # Cluster barycentre times-series from sdRep
  ))
}