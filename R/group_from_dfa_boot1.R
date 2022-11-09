#' Get cluster for DFA results
#'
#' @param data_loadings A `data.frame` of species initial factor loadings.
#' @param cov_mat_Z A `matrix` corresponding to the covariance matrix of species factor loadings.
#' @param species_sub A `data.frame` of species names. It should be provided with species in row, the first column for complete species names and the second column for species names' codes.
#' @param nboot An `integer`. Number of bootstrap iteration. Default is 100.
#' @param ny An `integer`. Number of time series.
#' @param nfac An `integer`. Number of latent trends.
#'
#' @return A `list` of five objects: `kmeans_res` a data.frame containing the results of clustering, `centroids` a data.frame with the coordinates of cluster centres, `stability_cluster_final` a vector of stability for each cluster, `mean_dist_clust` a vector of the mean distance between species and centre for each cluster, `pca_centre_list` a list containing coordinates to plot trends of PCA axes.
#' @export
#'
#' @examples
#' \dontrun{
#' group_from_dfa_boot1(data_loadings, cov_mat_Z, species_sub, nboot=nboot, ny, nfac)
#' }
group_from_dfa_boot1 <- function(data_loadings,
                                 cov_mat_Z,
                                 species_sub,
                                 nboot=100,
                                 ny,
                                 nfac
){

  # Indices of fixed loadings

  row_col_0 <- which(data_loadings$value==0)

  # Loadings in matrix

  dfa_res_val <- dcast(data_loadings, code_sp~variable, value.var = "value")
  mat_loading <- as.matrix(dfa_res_val[,-1])

  # Find the best number of clusters in the original data

  NbClust2 <- function(data, diss=NULL, distance = "euclidean",
                       method = "kmeans", min.nc=2, max.nc=min(max(c(2,round(ny/3))),10),
                       index = "alllong", alphaBeale = 0.1){
    tryCatch(
      #try to do this
      {
        NbClustb(data, diss=NULL, distance = "euclidean",
                 method = "kmeans", min.nc=2, max.nc=min(max(c(2,round(ny/3))),10),
                 index = "alllong", alphaBeale = 0.1)
      },
      #if an error occurs
      error=function(e) {
        data.frame(Best.partition=rep(NA,nrow(mat_loading)))
      }
    )
  }

  if(min(max(c(2,round(ny/3))),10)>4){
    nb <- NbClust2(mat_loading, diss=NULL, distance = "euclidean",
                   method = "kmeans", min.nc=2, max.nc=min(max(c(2,round(ny/3))),10),
                   index = "alllong", alphaBeale = 0.1)
    nb_group_best <- max(nb$Best.partition)
  }else{
    idx <- 0
    nb_group_best_part <- c()
    for(index in c("kl", "ch", "ccc", "db",
                   "silhouette", "duda", "ratkowsky", "ptbiserial",
                   "mcclain", "gamma", "gplus",
                   "tau", "dunn", "sdindex", "sdbw")){
      nb_part <- NbClustb(mat_loading, diss=NULL, distance = "euclidean",
                          method = "kmeans", min.nc=2, max.nc=min(max(c(2,round(ny/3))),10),
                          index = index, alphaBeale = 0.1)
      idx <- idx + 1
      nb_group_best_part[idx] <- max(nb_part$Best.partition)
    }
    nb_group_best <- as.numeric(names(which.max(table(nb_group_best_part))))
  }



  # Check cluster stability

  stability_cluster_gr <- list()
  all_partition_gr <- list()

  # Bootstrap for cluster stability

  for(i in 1:nboot){

    # Draw factor loadings using covariance matrix
    set.seed(i)
    rand_load <- mvtnorm::rmvnorm(1, mean=data_loadings[!row_col_0,]$value, sigma=cov_mat_Z)

    # Complete loading vector with fixed values
    for(j in 1:(nfac-1)){
      index_0 <- ny*j
      rand_load <- append(rand_load, rep(0,j), after=index_0)
    }

    rand_load <- matrix(rand_load, ncol=nfac, nrow=ny)

    # Find the best number of clusters in the bootstrap loadings

    if(min(max(c(2,round(ny/3))),10)>4){
      nb <- NbClustb(rand_load, diss=NULL, distance = "euclidean",
                     method = "kmeans", min.nc=2, max.nc=min(max(c(2,round(ny/3))),10),
                     index = "alllong", alphaBeale = 0.1)
    }else{
      nb <- NbClustb(rand_load, diss=NULL, distance = "euclidean",
                     method = "kmeans", min.nc=2, max.nc=min(max(c(2,round(ny/3))),10),
                     index = "kl", alphaBeale = 0.1)
    }

    # Calculate reference partitions as a function of the number of cluster

    for(gr in nb_group_best:1){

      nb_group <- gr

      all_partition2_all <- kmeans(mat_loading, nb_group, iter.max = 1000, nstart = 10)
      all_partition2 <- all_partition2_all$cluster
      all_partition2_centers <- all_partition2_all$centers


      if(!anyNA(nb$Best.partition)){
        all_partition2 <- rbind(all_partition2,nb$Best.partition)

        # Compute Jaccard similarity to relabel clusters as in the original clustering

        jac_sim_res <- matrix(NA, ncol=length(unique(all_partition2[1,])),
                              nrow=length(unique(nb$Best.partition)))
        for(k in sort(unique(all_partition2[1,]))){
          for(l in sort(unique(nb$Best.partition))){
            jac_sim_mat <- all_partition2[c(1,(2)),]
            jac_sim_mat[1,][which(jac_sim_mat[1,]!=k)] <- 0
            jac_sim_mat[2,][which(jac_sim_mat[2,]!=l)] <- 0
            jac_sim_mat[jac_sim_mat>0] <- 1
            jac_sim <- c(1 - vegdist(jac_sim_mat, method="jaccard"))
            jac_sim_res[l,k] <- jac_sim
          }
        }

        # If same number of clusters

        if(length(unique(all_partition2[1,]))==length(unique(nb$Best.partition))){
          for(l in sort(unique(nb$Best.partition))){
            all_partition2[2,][which(nb$Best.partition==l)] <- which.max(jac_sim_res[l,])
          }
        }

        # If more clusters in the bootstrap clustering

        if(length(unique(all_partition2[1,]))<length(unique(nb$Best.partition))){
          l_data <- c()
          for(k in sort(unique(all_partition2[1,]))){
            l_data <- c(l_data,which.max(jac_sim_res[,k]))
          }
          k <- 0
          for(l in l_data){
            k <- k+1
            all_partition2[2,][which(nb$Best.partition==l)] <- k
          }
          extra_clus <- sort(unique(nb$Best.partition))[which(!(sort(unique(nb$Best.partition)) %in% l_data))]
          for(g_sup in 1:length(extra_clus)){
            k <- k +1
            all_partition2[2,][which(nb$Best.partition==extra_clus[g_sup])] <- k
          }

        }

        # If less clusters in the bootstrap clustering

        if(length(unique(all_partition2[1,]))>length(unique(nb$Best.partition))){
          k_data <- c()
          for(l in sort(unique(nb$Best.partition))){
            k_data <- c(k_data,which.max(jac_sim_res[l,]))
          }
          l <- 0
          for(k in k_data){
            l <- l+1
            all_partition2[2,][which(nb$Best.partition==l)] <- k
          }
        }

        if(i == 1){
          stability_cluster <- apply(jac_sim_res,2,max)
          stability_cluster_gr[[gr]] <- stability_cluster
          all_partition_gr[[gr]] <- all_partition2
        }else{
          stability_cluster <- stability_cluster_gr[[gr]]
          stability_cluster <- rbind(stability_cluster,apply(jac_sim_res,2,max))
          stability_cluster_gr[[gr]] <- stability_cluster
          all_partition <- all_partition_gr[[gr]]
          all_partition <- rbind(all_partition,all_partition2[2,])
          all_partition_gr[[gr]] <- all_partition
        }
      }else{if(i == 1){
        stability_cluster_gr[[gr]] <- 1
        all_partition_gr[[gr]] <- rep(1,nrow(species_sub))
      }}
    }
  }

  stability_cluster_final <- 0

  gr <- nb_group_best + 1

  while(min(stability_cluster_final)<0.5 & gr > 1){  # dilution cluster if stability < 0.5

    gr <- gr - 1

    stability_cluster_final <- apply(stability_cluster_gr[[gr]],2,mean)

  }

  nb_group <- gr

  # Frequency of classification of each species in its reference cluster

  all_partition2 <- all_partition_gr[[nb_group]]
  all_partition2 <- na.omit(all_partition2)

  all_partition_uncertainty <- apply(all_partition2, 2,
                                     FUN = function(x){
                                       y <- max(table(x))/length(x)
                                       return(y)
                                     })

  all_partition_group <- all_partition2[1,]
  num_row <- 1
  while(length(unique(all_partition_group))!=nb_group){
    num_row <- num_row + 1
    all_partition_group <- all_partition2[num_row,]

  }


  # Compute PCA to get axes of the graph

  myPCA <- prcomp(mat_loading, scale. = F, center = T)

  # Group all info as output

  kmeans_1 <- merge(data.frame(code_sp = dfa_res_val[,1],
                               myPCA$x,
                               group = all_partition_group,
                               dfa_res_val[,-1],
                               uncert = all_partition_uncertainty),species_sub[,c("name_long","code_sp")],by="code_sp")
  kmeans_center <- rep(NA,nfac)
  for(i in 1:nb_group){
    kmeans_center_row <- c()
    for(j in 1:nfac){
      kmeans_center_row <- c(kmeans_center_row,weighted.mean(kmeans_1[kmeans_1$group==i,paste0("X",j)],
                                                             kmeans_1[kmeans_1$group==i,"uncert"]))
    }
    kmeans_center <- rbind(kmeans_center,kmeans_center_row)
  }
  kmeans_center <- kmeans_center[-1,]
  if(is.null(nrow(kmeans_center))){
    kmeans_2 <- data.frame(group=as.factor(1:nb_group),t(kmeans_center),
                           ((kmeans_center - myPCA$center) %*% myPCA$rotation))

  }else{
    kmeans_2 <- data.frame(group=as.factor(1:nb_group),kmeans_center,
                           (t(apply(kmeans_center, 1, function(x){x - myPCA$center})) %*% myPCA$rotation))
  }

  kmeans_3 <- myPCA$sdev/sum(myPCA$sdev)

  kmeans_res <- list(kmeans_1,kmeans_2,kmeans_3)

  # PCA centres
  # PC1 and PC2
  pca_centre <- myPCA$rotation[,1:2] %*% matrix(data = c(0,min(myPCA$x[,2]),
                                                         0,max(myPCA$x[,2]),
                                                         min(myPCA$x[,1]),0,
                                                         max(myPCA$x[,1]),0),nrow=2)

  pca_centre <- apply(pca_centre,2,function(x){x + myPCA$center})

  if(length(kmeans_3)>2){
    # PC1 and PC3
    pca_centre2 <- myPCA$rotation[,c(1,3)] %*% matrix(data = c(0,min(myPCA$x[,3]),
                                                               0,max(myPCA$x[,3]),
                                                               min(myPCA$x[,1]),0,
                                                               max(myPCA$x[,1]),0),nrow=2)

    pca_centre2 <- apply(pca_centre2,2,function(x){x + myPCA$center})

    # PC2 and PC3
    pca_centre3 <- myPCA$rotation[,2:3] %*% matrix(data = c(0,min(myPCA$x[,3]),
                                                            0,max(myPCA$x[,3]),
                                                            min(myPCA$x[,2]),0,
                                                            max(myPCA$x[,2]),0),nrow=2)

    pca_centre3 <- apply(pca_centre3,2,function(x){x + myPCA$center})
  }else{
    pca_centre2 <- pca_centre3 <- NA
  }

  pca_centre_list <- list(pca_centre, pca_centre2, pca_centre3)

  # Get weigthed centroid of groups

  centroids <- as.data.frame(kmeans_2[,c("group",names(kmeans_2)[grepl("PC",names(kmeans_2))])])

  # Average distance between species and cluster centres

  mean_dist_clust <- data.frame(mean_dist=rep(NA,length(unique(kmeans_1$group))))
  if(length(unique(kmeans_1$group))>1){
    for(g in 1:length(unique(kmeans_1$group))){
      kmeans_scale <- as.data.frame(scale(rbind(kmeans_1[kmeans_1$group==g, grepl("X",names(kmeans_1))],kmeans_2[kmeans_2$group==g, grepl("X",names(kmeans_2))])))
      sp_coord <- kmeans_scale[1:(nrow(kmeans_scale)-1),]
      cluster_coord <- kmeans_scale[nrow(kmeans_scale),]
      dist_clust <- c()
      for(i in 1:nrow(sp_coord)){
        mat_dist_clust <- as.matrix(rbind(cluster_coord,sp_coord[i,]))
        dist_clust <- c(dist_clust, dist(mat_dist_clust))
      }
      data_weight_mean <- data.frame(all_dist = dist_clust,
                                     uncert = kmeans_1[kmeans_1$group==g,"uncert"])
      mean_dist_clust[g,1] <- weighted.mean(data_weight_mean$all_dist,data_weight_mean$uncert)
      row.names(mean_dist_clust)[g] <- paste0("cluster_",g)
    }
  }else{
    kmeans_scale <- as.data.frame(scale(rbind(kmeans_1[, grepl("X",names(kmeans_1))],kmeans_center)))
    sp_coord <- kmeans_scale[1:(nrow(kmeans_scale)-1),]
    cluster_coord <- kmeans_scale[nrow(kmeans_scale),]
    dist_clust <- c()
    for(i in 1:nrow(sp_coord)){
      mat_dist_clust <- as.matrix(rbind(cluster_coord,sp_coord[i,]))
      dist_clust <- c(dist_clust, dist(mat_dist_clust))
    }
    mean_dist_clust[1,1] <- mean(dist_clust)
    row.names(mean_dist_clust) <- paste0("cluster_",1)
  }


  return(list(kmeans_res, # Results of clustering
              centroids, # Position of cluster barycentres
              stability_cluster_final, # Stability of clusters
              mean_dist_clust, # Average distance between species and barycentre
              pca_centre_list # Coordinates to plot trends of PCA axes
  ))
}
