#' Plot groups and clustering trends
#'
#' @param nb_group Number of clusters
#' @param centroids Position of cluster barycentres
#' @param kmeans_res Results of clustering
#' @param sdrep Optimisation output from DFA
#' @param nT Number of time step
#' @param min_year Oldest year in time-series
#' @param stability_cluster_final Stability of clusters
#' @param mean_dist_clust Average distance between species and barycentre
#' @param pca_centre Coordinates to plot trends of PCA axes
#' @param Z_hat Factor loadings
#' @param x_hat Latent trends
#' @param data_ts A `data.table`. Dataset of species time series. It should be provided as a data.table with species time-series in row, the first column for species names' codes and years as column names.
#' @param data_ts_se A `data.table`. Dataset of uncertainty (e.g. standard error) of species time series. It should be provided as a data.table with species uncertainty time-series in row, the first column for species names' codes and years as column names.
#' @param data_to_plot_sp Data for species time-series plot
#'
#' @return A `list` of six objects: `final_plot_list` the plot of species clusters, `graph` the plot of time-series of cluster centres, `data_trend_group` the `data.frame` of time-series of cluster centres, `graph2` the plot of time-series of cluster centres from sdRep, `data_trend_group2` the `data.frame` of time-series of cluster centres from sdRep, `data_msi` the `data.frame` for multi-species index
#' @export
#'
#' @examples
#' \dontrun{
#' group_dfa <- group_from_dfa_boot1(data_loadings, cov_mat_Z, species_sub, nboot=nboot, ny, nfac)
#' plot_group_boot(nb_group = nrow(group_dfa[[1]][[2]]), centroids = group_dfa[[2]], kmeans_res = group_dfa[[1]], sdrep = sdRep, nT = nT, min_year = min_year, stability_cluster_final = group_dfa[[3]], mean_dist_clust = group_dfa[[4]], pca_centre = group_dfa[[5]],Z_hat = Z_hat,x_hat = x_hat,data_ts = data_ts,data_ts_se = data_ts_se,data_to_plot_sp = data_to_plot_sp)
#' }
plot_group_boot <- function(nb_group,
                            centroids,
                            kmeans_res,
                            sdrep,
                            nT,
                            min_year,
                            stability_cluster_final,
                            mean_dist_clust,
                            pca_centre,
                            Z_hat,
                            x_hat,
                            data_ts,
                            data_ts_se,
                            data_to_plot_sp
){

  # Combine all data for x_pred

  data_trend_group <- data.frame(group=rep(paste0("g",1:nb_group),nT),
                                 year=sort(rep(c(min_year:(nT+min_year-1)), nb_group)),
                                 sdrep[grepl("x_pred",row.names(sdrep)) & !grepl("x_pred2",row.names(sdrep)),])

  # Set colour code by group

  n1 <- length(unique(data_trend_group$group))
  hex_codes1 <- hue_pal()(n1)

  # Plot time-series of barycentres

  graph <- setNames(lapply(1:nb_group, function(i){
    test <- data_trend_group[data_trend_group$group==paste0("g",i),]
    test$Index_SE <- test$Std..Error
    test$Index <- test$Estimate
    min1 <- min(test$Index-1.96*test$Index_SE) + (max(test$Index+1.96*test$Index_SE)-min(test$Index-1.96*test$Index_SE))/10
    min2 <- min(test$Index-1.96*test$Index_SE)
    ggplot(test, aes(x=year, y=Index)) +
      geom_line(col=hex_codes1[i], size=2) +
      geom_ribbon(aes(ymin=Index-1.96*Index_SE,ymax=Index+1.96*Index_SE),alpha=0.2,fill=hex_codes1[i])+
      xlab(NULL) +
      ylab(NULL) +
      annotate("text", x=mean(test$year), y=min1, label= paste0("Stability = ", round(stability_cluster_final[i],3))) +
      annotate("text", x=mean(test$year), y=min2, label= paste0("Mean distance = ", round(mean_dist_clust[i,1],3))) +
      theme_modern() +
      theme(plot.margin=unit(c(0,0,0,0),"mm"),aspect.ratio = 2/(nb_group+1))

  }), levels(as.factor(data_trend_group$group)))


  # Combine all data for x_pred2

  data_trend_group2 <- data.frame(group=rep(c("all",paste0("g",1:nb_group)),nT),
                                  year=sort(rep(c(min_year:(nT+min_year-1)), (nb_group+1))),
                                  sdrep[grepl("x_pred2",row.names(sdrep)),])

  geom_mean_data <- data.frame(Index = apply(t(apply(data_ts,1,function(y){y/y[1]})), 2, function(x){ exp(sum(log(x), na.rm=T)/length(x)) }),
                               year = as.numeric(names(data_ts)))

  data_mean_pred <- dcast(data_to_plot_sp, name_long~Year, value.var = "pred.value_exp_1")
  geom_mean_pred <- data.frame(Index = apply(data_mean_pred[,-1], 2, function(x){ exp(sum(log(x), na.rm=T)/length(x)) }),
                               year = as.numeric(names(data_mean_pred[,-1])))

  # Plot time-series of barycentres

  graph2 <- setNames(lapply(1:(nb_group+1), function(i){
    if(i==1){
      test <- data_trend_group2[data_trend_group2$group=="all",]
    }else{
      if(nb_group==1){
        test <- data_trend_group[data_trend_group$group==paste0("g",(i-1)),]
        min_scale <- min(data_trend_group$Estimate-2*data_trend_group$Std..Error)
        max_scale <- max(data_trend_group$Estimate+2*data_trend_group$Std..Error)
        min1 <- min(data_trend_group$Estimate-1.96*data_trend_group$Std..Error) + (max(data_trend_group$Estimate+1.96*data_trend_group$Std..Error)-min(data_trend_group$Estimate-1.96*data_trend_group$Std..Error))/10
        min2 <- min(data_trend_group$Estimate-1.96*data_trend_group$Std..Error)
      }else{
        test <- data_trend_group2[data_trend_group2$group==paste0("g",(i-1)),]
        #min_scale <- min(data_trend_group2$Estimate)-2*data_trend_group2$Std..Error[which.min(data_trend_group2$Estimate)]
        #max_scale <- max(data_trend_group2$Estimate)+2*data_trend_group2$Std..Error[which.max(data_trend_group2$Estimate)]
        min_scale <- min(test$Estimate-2*test$Std..Error)
        max_scale <- max(test$Estimate+2*test$Std..Error)
        min1 <- min(test$Estimate-1.96*test$Std..Error) + (max(test$Estimate+1.96*test$Std..Error)-min(test$Estimate-1.96*test$Std..Error))/10
        min2 <- min(test$Estimate-1.96*test$Std..Error)
      }
    }
    test$Index_SE <- test$Std..Error
    test$Index <- test$Estimate
    test$Index_scal <- (test$Estimate-mean(test$Estimate))/sd(test$Estimate)
    test$Index_SE_scal <- test$Std..Error/sd(test$Estimate)


    if(i==1){

      #lm_pred <- lm(Index~year,geom_mean_pred)
      lm_pred <- lm(Index~year,geom_mean_data)
      lm_test <- lm(Index~year,test)

      sse <- abs(lm_test$fitted.values-geom_mean_pred$Index)
      sse_min <- sort(sse)[1:2]
      first_val <- which(sse==sse_min[1])
      second_val <- which(sse==sse_min[2])

      alpha <- (lm_pred$fitted.values[first_val]-lm_pred$fitted.values[second_val])/(lm_test$fitted.values[first_val]-lm_test$fitted.values[second_val])
      beta <- lm_pred$fitted.values[second_val]-alpha*lm_test$fitted.values[second_val]
      test$Index_SE_c <- alpha*test$Index_SE
      test$Index_c <- alpha*test$Index+beta

      data_msi <- test

      res_plot <- ggplot(test, aes(x=year, y=Index)) +
        geom_line(aes(y=Index_c),col="black", size=2) +
        geom_ribbon(aes(ymin=Index_c-1.96*Index_SE_c,ymax=Index_c+1.96*Index_SE_c),alpha=0.2,fill="black")+
        geom_point(data=geom_mean_data, col="black", size=2) +
        xlab(NULL) +
        ylab(NULL) +
        theme_modern() +
        theme(plot.margin=unit(c(0,0,0,0),"mm"),aspect.ratio = 2/(nb_group+1))

      res_list <- list(res_plot, data_msi)
      return(res_list)

    }else{
      res_plot <- ggplot(test, aes(x=year, y=Index)) +
        geom_line(col=hex_codes1[(i-1)], size=2) +
        geom_ribbon(aes(ymin=Index-1.96*Index_SE,ymax=Index+1.96*Index_SE),alpha=0.2,fill=hex_codes1[(i-1)])+
        xlab(NULL) +
        ylab(NULL) +
        ylim(c(min_scale,max_scale)) +
        annotate("text", x=mean(test$year), y=min1, label= paste0("Stability = ", round(stability_cluster_final[(i-1)],3))) +
        annotate("text", x=mean(test$year), y=min2, label= paste0("Mean distance = ", round(mean_dist_clust[(i-1),1],3))) +
        theme_modern() +
        theme(plot.margin=unit(c(0,0,0,0),"mm"),aspect.ratio = 2/(nb_group+1))
      return(res_plot)
    }


  }), levels(as.factor(data_trend_group2$group)))


  data_msi <- graph2$all[[2]]
  graph2$all <- graph2$all[[1]]

  # Combine data for PCA centres

  mat_tr_rot <- t(solve(varimax(Z_hat)$rotmat) %*% x_hat)

  ts_pca <- apply(pca_centre[[1]], 2, function(x){mat_tr_rot %*% matrix(x)})
  min_y_graph3 <- min(apply(ts_pca, 2, min))
  max_y_graph3 <- max(apply(ts_pca, 2, max))

  graph3 <- setNames(lapply(1:4, function(i){
    test <- data.frame(Index=ts_pca[,i], year=1:length(ts_pca[,i]))
    ggplot(test, aes(x=year, y=Index)) +
      geom_line(size=1.5, alpha=0.4) + xlab(NULL) + ylab(NULL) +
      theme_modern() + theme_transparent() +
      ylim(c(min_y_graph3,max_y_graph3)) +
      theme(plot.margin=unit(c(0,0,0,0),"mm"),aspect.ratio = 2/3,
            axis.title = element_blank(),
            axis.text = element_blank(),
            axis.text.x = element_blank())
  }), paste0("pca centre ", 1:4))

  if(length(kmeans_res[[3]])>2){
    ts_pca2 <- apply(pca_centre[[2]], 2, function(x){mat_tr_rot %*% matrix(x)})
    min_y_graph32 <- min(apply(ts_pca2, 2, min))
    max_y_graph32 <- max(apply(ts_pca2, 2, max))

    graph32 <- setNames(lapply(1:4, function(i){
      test <- data.frame(Index=ts_pca2[,i], year=1:length(ts_pca2[,i]))
      ggplot(test, aes(x=year, y=Index)) +
        geom_line(size=1.5, alpha=0.4) + xlab(NULL) + ylab(NULL) +
        theme_modern() + theme_transparent() +
        ylim(c(min_y_graph32,max_y_graph32)) +
        theme(plot.margin=unit(c(0,0,0,0),"mm"),aspect.ratio = 2/3,
              axis.title = element_blank(),
              axis.text = element_blank(),
              axis.text.x = element_blank())
    }), paste0("pca centre ", 1:4))

    ts_pca3 <- apply(pca_centre[[3]], 2, function(x){mat_tr_rot %*% matrix(x)})
    min_y_graph33 <- min(apply(ts_pca3, 2, min))
    max_y_graph33 <- max(apply(ts_pca3, 2, max))

    graph33 <- setNames(lapply(1:4, function(i){
      test <- data.frame(Index=ts_pca3[,i], year=1:length(ts_pca3[,i]))
      ggplot(test, aes(x=year, y=Index)) +
        geom_line(size=1.5, alpha=0.4) + xlab(NULL) + ylab(NULL) +
        theme_modern() + theme_transparent() +
        ylim(c(min_y_graph33,max_y_graph33)) +
        theme(plot.margin=unit(c(0,0,0,0),"mm"),aspect.ratio = 2/3,
              axis.title = element_blank(),
              axis.text = element_blank(),
              axis.text.x = element_blank())
    }), paste0("pca centre ", 1:4))
  }


  # Plot species cluster in the first factorial plane

  res_to_plot <- kmeans_res[[1]]
  res_to_plot$group2 <- res_to_plot$group
  res_to_plot$group2 <- as.factor(res_to_plot$group2)

  # Add some space between species name and dot
  width_nudge <- (max(res_to_plot$PC1)-min(res_to_plot$PC1))/50

  # Species latin name in italic
  res_to_plot$name_long2 <- paste0("italic('",res_to_plot$name_long,"')")

  pca_centre_data <- t(matrix(data = c(0,min(kmeans_res[[1]]$PC2)-(max(kmeans_res[[1]]$PC2)-min(kmeans_res[[1]]$PC2))/8,
                                       0,max(kmeans_res[[1]]$PC2)+(max(kmeans_res[[1]]$PC2)-min(kmeans_res[[1]]$PC2))/8,
                                       min(kmeans_res[[1]]$PC1)-(max(kmeans_res[[1]]$PC1)-min(kmeans_res[[1]]$PC1))/8,0,
                                       max(kmeans_res[[1]]$PC1)+(max(kmeans_res[[1]]$PC1)-min(kmeans_res[[1]]$PC1))/8,0),nrow=2))

  pca_centre_data2 <- tibble(x=pca_centre_data[,1],
                             y=pca_centre_data[,2],
                             width=0.08,
                             pie = graph3)

  if(length(kmeans_res[[3]])>2){

    pca_centre_datab <- t(matrix(data = c(0,min(kmeans_res[[1]]$PC3)-(max(kmeans_res[[1]]$PC3)-min(kmeans_res[[1]]$PC3))/8,
                                          0,max(kmeans_res[[1]]$PC3)+(max(kmeans_res[[1]]$PC3)-min(kmeans_res[[1]]$PC3))/8,
                                          min(kmeans_res[[1]]$PC1)-(max(kmeans_res[[1]]$PC1)-min(kmeans_res[[1]]$PC1))/8,0,
                                          max(kmeans_res[[1]]$PC1)+(max(kmeans_res[[1]]$PC1)-min(kmeans_res[[1]]$PC1))/8,0),nrow=2))

    pca_centre_data2b <- tibble(x=pca_centre_datab[,1],
                                y=pca_centre_datab[,2],
                                width=0.08,
                                pie = graph32)


    pca_centre_datac <- t(matrix(data = c(0,min(kmeans_res[[1]]$PC3)-(max(kmeans_res[[1]]$PC3)-min(kmeans_res[[1]]$PC3))/8,
                                          0,max(kmeans_res[[1]]$PC3)+(max(kmeans_res[[1]]$PC3)-min(kmeans_res[[1]]$PC3))/8,
                                          min(kmeans_res[[1]]$PC2)-(max(kmeans_res[[1]]$PC2)-min(kmeans_res[[1]]$PC2))/8,0,
                                          max(kmeans_res[[1]]$PC2)+(max(kmeans_res[[1]]$PC2)-min(kmeans_res[[1]]$PC2))/8,0),nrow=2))

    pca_centre_data2c <- tibble(x=pca_centre_datac[,1],
                                y=pca_centre_datac[,2],
                                width=0.04,
                                pie = graph33)
  }


  final_plot <- ggplot(res_to_plot, aes(PC1,PC2)) +
    geom_point(aes(colour=group2, size=(1-uncert),alpha=uncert)) +
    geom_text_repel(label=res_to_plot$name_long2, nudge_x = width_nudge, nudge_y = width_nudge, parse = TRUE, max.overlaps = 30) +
    geom_point(data=centroids,aes(x=PC1,y=PC2), shape=15) +
    geom_subview(aes(x=x, y=y, subview=pie, width=width, height=width), data=pca_centre_data2) +
    theme_modern() + xlab(paste0("PC1 (",round(kmeans_res[[3]][1]*100,1)," %)")) +
    ylab(paste0("PC2 (",round(kmeans_res[[3]][2]*100,1)," %)")) +
    xlim(c(min(kmeans_res[[1]]$PC1)-(max(kmeans_res[[1]]$PC1)-min(kmeans_res[[1]]$PC1))/5,
           max(kmeans_res[[1]]$PC1)+(max(kmeans_res[[1]]$PC1)-min(kmeans_res[[1]]$PC1))/5))+
    ylim(c(min(kmeans_res[[1]]$PC2)-(max(kmeans_res[[1]]$PC2)-min(kmeans_res[[1]]$PC2))/5,
           max(kmeans_res[[1]]$PC2)+(max(kmeans_res[[1]]$PC2)-min(kmeans_res[[1]]$PC2))/5))+
    theme(legend.position='none')

  if(length(kmeans_res[[3]])>2){

    final_plot2 <- ggplot(res_to_plot, aes(PC1,PC3)) +
      geom_point(aes(colour=group2, size=(1-uncert),alpha=uncert)) +
      geom_text_repel(label=res_to_plot$name_long2, nudge_x = width_nudge, nudge_y = width_nudge, parse = TRUE, max.overlaps = 30) +
      geom_point(data=centroids,aes(x=PC1,y=PC3), shape=15) +
      geom_subview(aes(x=x, y=y, subview=pie, width=width, height=width), data=pca_centre_data2b) +
      theme_modern() + xlab(paste0("PC1 (",round(kmeans_res[[3]][1]*100,1)," %)")) +
      ylab(paste0("PC3 (",round(kmeans_res[[3]][3]*100,1)," %)")) +
      xlim(c(min(kmeans_res[[1]]$PC1)-(max(kmeans_res[[1]]$PC1)-min(kmeans_res[[1]]$PC1))/5,
             max(kmeans_res[[1]]$PC1)+(max(kmeans_res[[1]]$PC1)-min(kmeans_res[[1]]$PC1))/5))+
      ylim(c(min(kmeans_res[[1]]$PC3)-(max(kmeans_res[[1]]$PC3)-min(kmeans_res[[1]]$PC3))/5,
             max(kmeans_res[[1]]$PC3)+(max(kmeans_res[[1]]$PC3)-min(kmeans_res[[1]]$PC3))/5))+
      theme(legend.position='none')

    final_plot3 <- ggplot(res_to_plot, aes(PC2,PC3)) +
      geom_point(aes(colour=group2, size=(1-uncert),alpha=uncert)) +
      geom_text_repel(label=res_to_plot$name_long2, nudge_x = width_nudge, nudge_y = width_nudge, parse = TRUE, max.overlaps = 30) +
      geom_point(data=centroids,aes(x=PC2,y=PC3), shape=15) +
      geom_subview(aes(x=x, y=y, subview=pie, width=width, height=width), data=pca_centre_data2c) +
      theme_modern() + xlab(paste0("PC2 (",round(kmeans_res[[3]][2]*100,1)," %)")) +
      ylab(paste0("PC3 (",round(kmeans_res[[3]][3]*100,1)," %)")) +
      xlim(c(min(kmeans_res[[1]]$PC2)-(max(kmeans_res[[1]]$PC2)-min(kmeans_res[[1]]$PC2))/5,
             max(kmeans_res[[1]]$PC2)+(max(kmeans_res[[1]]$PC2)-min(kmeans_res[[1]]$PC2))/5))+
      ylim(c(min(kmeans_res[[1]]$PC3)-(max(kmeans_res[[1]]$PC3)-min(kmeans_res[[1]]$PC3))/5,
             max(kmeans_res[[1]]$PC3)+(max(kmeans_res[[1]]$PC3)-min(kmeans_res[[1]]$PC3))/5))+
      theme(legend.position='none')

  }else{
    final_plot2 <- final_plot3 <- NA
  }

  final_plot_list <- list(final_plot, final_plot2, final_plot3)

  return(list(final_plot_list, # Plot of species clusters
              graph, # Plot of time-series of cluster barycentres
              data_trend_group, # Data of time-series of cluster barycentres
              graph2, # Plot of time-series of cluster barycentres from sdRep
              data_trend_group2, # Data of time-series of cluster barycentres from sdRep
              data_msi # Data for multi-species index
  ))
}
