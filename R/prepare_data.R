#' Function to check data before DFA
#'
#' @param data_ts  A `matrix`. Dataset of species time series. It should be provided as a matrix with species time-series in row, species' codes as row names and years as column names.
#' @param data_ts_se A `matrix`. Dataset of uncertainty (e.g. standard error) of species time series. It should be provided as a matrix with log uncertainty of species time-series in row, species' codes as row names and years as column names.
#' @param se_log A `logical` value. `TRUE` if `data_ts_se` is provided with log values. `FALSE` if it is provided with not log values. Default is `TRUE`.
#' @param perc_replace A `numeric` value. Proportion of the average index value used to replace zeros. Default is `0.01`.
#'
#' @return A `list` of five objects: `min_year` an `integer` corresponding to the first year of time-series, `max_year` an `integer` corresponding to the last year of time-series, `species_name_ordre` a `character vector` of species code following the ordre of `data_ts`, `data_ts` a `matrix` with ready-to-use time-series for DFA (`fun_make_dfa()`), `data_ts_se` a `matrix` with ready-to-use uncertainty for DFA (`fun_make_dfa()`).
#' @export
#'
#' @examples
#' data(species_ts_mat)
#' data(species_uncert_ts_mat)
#'
#' data_ready_dfa <- prepare_data(data_ts = species_ts_mat,data_ts_se = species_uncert_ts_mat,
#' se_log = TRUE, perc_replace = 0.01)
prepare_data <- function(data_ts,
                         data_ts_se,
                         se_log = TRUE,
                         perc_replace = 0.01
                         ){
  # Specify whether standard errors are available

  if(is.null(data_ts_se)){
    data_ts_se <- data_ts
    data_ts_se[] <- 0
  }

  # Save first and last years for plot

  min_year <- as.numeric(colnames(data_ts)[1])
  max_year <- as.numeric(colnames(data_ts)[ncol(data_ts)])
  species_name_ordre <- row.names(data_ts)

  # Log transformed standard errors if they are not (from Taylor expansion)
  # and check missing values in log transformed standard errors

  if(anyNA(data_ts_se)){
    if(sum(complete.cases(t(data_ts_se)))<1){
      stop("Species names must be provided in data_ts_se.")
    }
    if(sum(complete.cases(t(data_ts_se)))==1){
      warning("Only NAs in data_ts_se, standard errors set to 0.")
      data_ts_se[] <- 0
    }
    if(sum(complete.cases(t(data_ts_se)))>1){
      warning("NAs in data_ts_se, missing values replaced by square root of mean of squared standard errors.")
      na_coord <- which(is.na(data_ts_se),arr.ind = T)
      if(nrow(na_coord)>1){
        data_ts_se[na_coord] <- apply(data_ts_se[na_coord[,1],], 1,
                                      function(x){
                                        var_x <- x*x
                                        mean_var_x <- mean(var_x, na.rm=T)
                                        return(sqrt(mean_var_x))
                                        })
      }else{
        data_ts_se[na_coord] <- sqrt(mean(data_ts_se[na_coord[,1],]*data_ts_se[na_coord[,1],], na.rm=T))
      }
    }
  }

  if(se_log == FALSE){
    for(i in 1:nrow(data_ts_se)){
      data_ts_se[i,] <- 1/data_ts[i,]*data_ts_se[1,]
    }
    data_ts_se[is.na(data_ts_se)] <- 0
  }

  # Handle 0 values in time-series (replacing 0 by 1 % of the reference year value)

  if(length(which(data_ts==0))>0){
    warning("At least one zero in time-series")
    zero_index <- which(data_ts==0, arr.ind = T)
    data_ts <- t(apply(data_ts, 1, function(x){if(length(which(x==0))>0){x[which(x==0)] <- mean(x,na.rm=T)*perc_replace}; return(x)}))

    if(anyNA(data_ts_se[zero_index[,1],zero_index[,2]])){
      for(i in 1:nrow(zero_index)){
        data_ts_se[zero_index[i,1],zero_index[i,2]] <- 0
      }
    }
  }

  return(list(
    min_year = min_year,
    max_year = max_year,
    species_name_ordre = species_name_ordre,
    data_ts = data_ts,
    data_ts_se = data_ts_se
  ))
}
