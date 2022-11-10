#' Title
#'
#' @param data_ts  A `data.table`. Dataset of species time series. It should be provided as a data.table with species time-series in row, the first column for species names' codes and years as column names.
#' @param data_ts_se A `data.table`. Dataset of uncertainty (e.g. standard error) of species time series. It should be provided as a data.table with log species uncertainty time-series in row, the first column for species names' codes and years as column names.
#' @param nfac A `integer`. Number of trends for the DFA. Default is 0 to test several values (between `mintrend` and `maxtrend`).
#' @param mintrend An `integer`. Minimum number of trends to test. Default is 1.
#' @param maxtrend An `integer`. Minimum number of trends to test. Default is 5.
#' @param AIC A `logical` value. `TRUE` computes and displays the AIC, `FALSE` does not. Default is `TRUE`.
#' @param species_sub A `data.frame` of species names. It should be provided with species in row, the first column for complete species names and the second column for species names' codes.
#' @param nboot An `integer`. Number of bootstrap iteration. Default is 500.
#' @param silent A `logical` value. `TRUE` silences `MakeADFun()`, `FALSE` does not. Default is `TRUE`.
#' @param control A `list`. Control option for `MakeADFun()`. Default is list().
#' @param se_log A `logical` value. `TRUE` if `data_ts_se` is provided with log values. `FALSE` if it is provided with not log values. Default is `TRUE`.
#' @param is_mean_centred A `logical` value. `TRUE` if `data_ts` is provided with mean-centred values. `FALSE` if it is provided with non mean-centred values. Default is `TRUE`.
#' @param min_year_sc An `integer`. First year of the period to select for rescaling if `is_mean_centred` = `FALSE`.
#'
#' @return A list of 17 objects: `data_to_plot_sp` data on species time-series and fit, `data_to_plot_tr` data on latent trends, `data_loadings` data on factor loadings, `exp_var_lt` data on % of variance of species ts explained by latent trends, `plot_sp` plot of species time-series and fit, `plot_tr` plot of latent trends, `plot_ld` plot of factor loadings, `plot_perc_var` plot of % of variance of species ts explained by latent trends, `plot_sp_group` plot clusters in factorial plan, `plot_group_ts` plot clustertime-series, `plot_group_ts2` plot clustertime-series from sdRep, `aic` best AIC, `sdRep` optimisation output, `group_dfa` cluster results, `trend_group` cluster centre times-series, `trend_group2` cluster centre times-series from sdRep, `data_msi` data for multi-species index
#' @export
#' @importFrom graphics pie
#' @importFrom stats complete.cases dist kmeans lm na.omit nlminb optim prcomp rnorm runif sd setNames varimax weighted.mean
#'
#' @examples
#' data(species_ts)
#' data(species_uncert_ts)
#' data(species_name)
#' species_ts[species_ts==0] <- NA
#' dfa_aus_farm <- make_dfa(data_ts = species_ts,data_ts_se = species_uncert_ts,
#'species_sub = species_name,nfac = 0,
#'mintrend = 1,maxtrend = 5,AIC = TRUE,
#'nboot = 10,silent = TRUE,control = list(),
#'se_log = FALSE,is_mean_centred = FALSE, min_year_sc=2000)
make_dfa <- function(data_ts,
                     data_ts_se,
                     nfac = 0,
                     mintrend = 1,
                     maxtrend = 5,
                     AIC = TRUE,
                     species_sub,
                     nboot = 500,
                     silent = TRUE,
                     control = list(),
                     se_log = TRUE,
                     is_mean_centred = TRUE,
                     min_year_sc = NULL
)
{

  # Save first and last years for plot and first year + 1 for scaling

  min_year <- as.numeric(colnames(data_ts)[2])
  max_year <- as.numeric(colnames(data_ts)[ncol(data_ts)])

  # Log transformed standard errors if they are not (from Taylor expansion)
  # and check missing values in log transformed standard errors

  if(anyNA(data_ts_se)){
    if(sum(complete.cases(as.data.frame(t(data_ts_se))))<1){
      stop("Species names must be provided in data_ts_se.")
    }
    if(sum(complete.cases(as.data.frame(t(data_ts_se))))==1){
      warning("Only NAs in data_ts_se, standard errors set to 0.")
      data_ts_se <- as.data.frame(data_ts_se)
      data_ts_se[,-1] <- 0
      data_ts_se <- data.table::as.data.table(data_ts_se)
    }
    if(sum(complete.cases(as.data.frame(t(data_ts_se))))>1){
      warning("NAs in data_ts_se, missing values replaced by mean of standard errors.")
      data_ts_se <- as.data.frame(data_ts_se)
      na_coord <- which(is.na(data_ts_se),arr.ind = T)
      data_ts_se[na_coord] <- apply(data_ts_se[na_coord[,1],-1], 1, function(x){return(mean(x, na.rm=T))})
      data_ts_se <- data.table::as.data.table(data_ts_se)
    }
  }
  if(se_log == FALSE & is_mean_centred == TRUE){
    data_ts_se <- as.data.frame(data_ts_se)
    for(i in 1:nrow(data_ts_se)){
      data_ts_se[i,-1] <- 1/as.numeric(data_ts[i,-1])*as.numeric(data_ts_se[1,-1])
    }
    data_ts_se <- data.table::as.data.table(data_ts_se)
    data_ts_se[is.na(data_ts_se)] <- 0
  }

  # Handle 0 values in time-series (replacing 0 by 1 % of the reference year value)

  if(length(which(data_ts==0))>0){
    warning("At least one zero in time-series")
    data_ts <- as.data.frame(data_ts)
    zero_index <- which(data_ts==0, arr.ind = T)
    data_ts[,-1] <- t(apply(data_ts[,-1], 1, function(x){if(length(which(x==0))>0){x[which(x==0)] <- mean(x,na.rm=T)/100}; return(x)}))
    data_ts <- data.table::as.data.table(data_ts)

    data_ts_se <- as.data.frame(data_ts_se)
    if(anyNA(data_ts_se[zero_index[,1],zero_index[,2]])){
      for(i in 1:nrow(zero_index)){
        data_ts_se[zero_index[i,1],zero_index[i,2]] <- 0
      }
    }
    data_ts_se <- data.table::as.data.table(data_ts_se)
  }

  # Mean-centre values if they are not

  if(is_mean_centred == FALSE){

    data_ts_prov <- as.matrix(data_ts[,-1])
    data_ts_se_prov <- as.matrix(data_ts_se[,-1])
    for(i in 1:nrow(data_ts)){
      rescale_value <- rescale_index(index = data_ts_prov[i,], se = data_ts_se_prov[i,], ref = min_year:max_year %in% min_year_sc:max_year)
      data_ts_prov[i,] <- exp(rescale_value[1,])
      data_ts_se_prov[i,] <- rescale_value[2,]
    }
    data_ts_prov <- data.table::data.table(data_ts[,1],data_ts_prov[,attr(data_ts_prov,"dimnames")[[2]] %in% min_year_sc:max_year])
    data_ts_se_prov <- data.table::data.table(data_ts_se[,1],data_ts_se_prov[,attr(data_ts_se_prov,"dimnames")[[2]] %in% min_year_sc:max_year])

    data_ts <- data_ts_prov
    data_ts_se <- data_ts_se_prov
    min_year <- min_year_sc

  }


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
  tmbObj <- core_dfa_res[[1]]
  tmbOpt <- core_dfa_res[[2]]
  data_ts <- core_dfa_res[[3]]
  data_ts_se <- core_dfa_res[[4]]
  data_ts_save <- core_dfa_res[[5]]
  data_ts_save_long <- core_dfa_res[[6]]
  data_ts_se_save <- core_dfa_res[[7]]
  ny <- core_dfa_res[[8]]
  nT <- core_dfa_res[[9]]
  aic <- core_dfa_res[[10]]
  conv <- core_dfa_res[[11]]
  sdRep_test <- core_dfa_res[[12]]
  sdRep_test_all <- core_dfa_res[[13]]

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

  # Update z_pred with actual values after clustering

  tmbObj$env$data$Z_pred <- Z_pred_from_kmeans
  tmbObj$env$data$W <- W_from_kmeans

  # Recalcul sdreport

  sdRep <- summary(sdreport(tmbObj))

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
                                           data_to_plot_sp = data_to_plot_sp)
      plot_sp_group <- plot_sp_group_all[[1]]
      plot_group_ts <- plot_sp_group_all[[2]]
      trend_group <- plot_sp_group_all[[3]]
      plot_group_ts2 <- plot_sp_group_all[[4]]
      trend_group2 <- plot_sp_group_all[[5]]
      data_msi <- plot_sp_group_all[[6]]
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
                                           data_to_plot_sp = data_to_plot_sp)
      plot_sp_group <- plot_sp_group_all[[1]]
      plot_group_ts <- plot_sp_group_all[[2]]
      trend_group <- plot_sp_group_all[[3]]
      plot_group_ts2 <- plot_sp_group_all[[4]]
      trend_group2 <- plot_sp_group_all[[5]]
      data_msi <- plot_sp_group_all[[6]]
    }
  }

  if(!is.list(group_dfa)){
    plot_sp_group_all <- NA
    plot_sp_group <- NA
    plot_group_ts <- NA
    trend_group <- NA
    plot_group_ts2 <- NA
    trend_group2 <- NA
    data_msi <- NA
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
              trend_group2 = trend_group2, # Cluster barycentre times-series from sdRep
              data_msi = data_msi # Data for multi-species index
  ))
}
