#' Plot groups and clustering trends
#'
#' @param nb_group An `integer`. Number of clusters.
#' @param centroids A `data.frame`. Position of cluster centres.
#' @param kmeans_res A `data.frame`. Results of clustering.
#' @param sdrep A `sdrep` object. Optimisation output from DFA.
#' @param nT An `integer`. Number of time step.
#' @param min_year An `integer`. Oldest year in time-series.
#' @param stability_cluster_final Stability of clusters.
#' @param mean_dist_clust Average distance between species and centre.
#' @param pca_centre A `list`. Coordinates to plot trends of PCA axes.
#' @param Z_hat A `data.frame`. Factor loadings.
#' @param x_hat A `data.frame`. Latent trends.
#' @param data_ts A `data.table`. Dataset of species time series. It should be provided as a data.table with species time-series in row, the first column for species names' codes and years as column names.
#' @param data_ts_se A `data.table`. Dataset of uncertainty (e.g. standard error) of species time series. It should be provided as a data.table with species uncertainty time-series in row, the first column for species names' codes and years as column names.
#' @param data_to_plot_sp A `data.frame`. Data for species time-series plot.
#' @param species_name_ordre A `character vector`. Species code in the same order as in the input time-series.
#'
#' @return A `list` of five objects: `final_plot_list` the plot of species clusters, `graph` the plot of time-series of cluster centres, `data_trend_group` the `data.frame` of time-series of cluster centres, `graph2` the plot of time-series of cluster centres from sdRep, `data_trend_group2` the `data.frame` of time-series of cluster centres from sdRep.
#' @export
#'
#' @examples
#' \dontrun{
#' plot_group_boot(nb_group = nrow(group_dfa[[1]][[2]]), centroids = group_dfa[[2]],
#' kmeans_res = group_dfa[[1]], sdrep = sdRep, nT = nT, min_year = min_year,
#'  stability_cluster_final = group_dfa[[3]], mean_dist_clust = group_dfa[[4]],
#'   pca_centre = group_dfa[[5]],Z_hat = Z_hat,x_hat = x_hat,data_ts = data_ts,
#'   data_ts_se = data_ts_se,data_to_plot_sp = data_to_plot_sp,species_name_ordre = species_name_ordre)
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
                            data_to_plot_sp,
                            species_name_ordre
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

  outlier_cluster <- paste0("g",names(which(table(kmeans_res[[1]]$group)==1)))

  if(outlier_cluster != "g"){
    data_trend_group2 <- data_trend_group2[which(data_trend_group2$group != outlier_cluster),]
  }

  # Plot time-series of barycentres

  graph2 <- setNames(lapply(1:length(unique(data_trend_group2$group)), function(i){
    if(i==1){
      test <- data_trend_group2[data_trend_group2$group==unique(data_trend_group2$group)[i],]
    }else{
      if(nb_group==1){
        test <- data_trend_group[data_trend_group$group=="g1",]
      }else{
        test <- data_trend_group2[data_trend_group2$group==unique(data_trend_group2$group)[i],]
      }
    }
    test$Index_SE <- test$Std..Error
    test$Index <- test$Estimate

    min_scale <- min(data_trend_group2$Estimate-2*data_trend_group2$Std..Error)
    max_scale <- max(data_trend_group2$Estimate+2*data_trend_group2$Std..Error)

    min1 <- min(data_trend_group2$Estimate-1.96*data_trend_group2$Std..Error)  + (max_scale-min_scale)/10
    min2 <- min(data_trend_group2$Estimate-1.96*data_trend_group2$Std..Error)

    if(i==1){
      geom_mean_data1 <- data.frame(Index = apply(t(apply(data_ts,1,function(y){y/y[1]})), 2, function(x){ sum(log(x), na.rm=T)/length(x) }),
                                    year = as.numeric(names(data_ts)))

      geom_mean_data1$Index <- geom_mean_data1$Index-mean(geom_mean_data1$Index)

      ggplot(test, aes(x=year, y=Index)) +
        geom_line(col="black", size=2) +
        geom_ribbon(aes(ymin=Index-1.96*Index_SE,ymax=Index+1.96*Index_SE),alpha=0.2,fill="black")+
        geom_point(data=geom_mean_data1, col="black", size=2) +
        xlab(NULL) +
        ylab(NULL) +
        ylim(c(min_scale,max_scale)) +
        theme_modern() +
        theme(plot.margin=unit(c(0,0,0,0),"mm"),aspect.ratio = 2/(nb_group+1))
    }else{
      ggplot(test, aes(x=year, y=Index)) +
        geom_line(col=hex_codes1[as.numeric(sub(".*g","",unique(data_trend_group2$group)[i]))], size=2) +
        geom_ribbon(aes(ymin=Index-1.96*Index_SE,ymax=Index+1.96*Index_SE),alpha=0.2,fill=hex_codes1[as.numeric(sub(".*g","",unique(data_trend_group2$group)[i]))])+
        xlab(NULL) +
        ylab(NULL) +
        ylim(c(min_scale,max_scale)) +
        annotate("text", x=mean(test$year), y=min1, label= paste0("Stability = ", round(stability_cluster_final[as.numeric(sub(".*g","",unique(data_trend_group2$group)[i]))],3))) +
        annotate("text", x=mean(test$year), y=min2, label= paste0("Mean distance = ", round(mean_dist_clust[as.numeric(sub(".*g","",unique(data_trend_group2$group)[i])),1],3))) +
        theme_modern() +
        theme(plot.margin=unit(c(0,0,0,0),"mm"),aspect.ratio = 2/(nb_group+1))
    }

  }), levels(as.factor(data_trend_group2$group)))


  # Combine data for PCA centres

  mat_tr_rot <- t(solve(varimax(Z_hat)$rotmat) %*% x_hat)

  ts_pca <- apply(pca_centre[[1]], 2, function(x){mat_tr_rot %*% matrix(x)})
  min_y_graph3 <- min(apply(ts_pca, 2, min))
  max_y_graph3 <- max(apply(ts_pca, 2, max))

  graph3 <- setNames(lapply(1:4, function(i){
    test <- data.frame(Index=ts_pca[,i], year=1:length(ts_pca[,i]))
    ggplot(test, aes(x=year, y=Index)) +
      geom_line(size=1.5, alpha=0.4) + xlab(NULL) + ylab(NULL) +
      theme_modern() +
      ggimage::theme_transparent() +
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
        theme_modern() +
        ggimage::theme_transparent() +
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
        theme_modern() +
        ggimage::theme_transparent() +
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
    ggimage::geom_subview(aes(x=x, y=y, subview=pie, width=width, height=width), data=pca_centre_data2) +
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
      ggimage::geom_subview(aes(x=x, y=y, subview=pie, width=width, height=width), data=pca_centre_data2b) +
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
      ggimage::geom_subview(aes(x=x, y=y, subview=pie, width=width, height=width), data=pca_centre_data2c) +
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

  return(list(final_plot_list = final_plot_list, # Plot of species clusters
              graph = graph, # Plot of time-series of cluster barycentres
              data_trend_group = data_trend_group, # Data of time-series of cluster barycentres
              graph2 = graph2, # Plot of time-series of cluster barycentres from sdRep
              data_trend_group2 = data_trend_group2 # Data of time-series of cluster barycentres from sdRep
  ))
}
