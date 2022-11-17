#' Log mean-centred species indices and uncertainty
#'
#' @param index A `numeric` vector containing indices of a species across years.
#' @param se A `numeric` vector containing uncertainty that comes with indices of a species across years.
#' @param ref A `logical` vector containing the years to be used at reference for the scaling (TRUE) and the years not used in the reference (FALSE).
#' @param denom A `numeric` value inferior to 1 and superior to 0 to calculate the variance of the first year. Default to 1.01 is conservative, consider using 2 for a less conservative approach.
#'
#' @return A matrix/array with log mean-centred indices and uncertainty
#' @export
#'
#' @examples
#' set.seed(123)
#' index <- c(100,round(runif(19, min = 50, max = 150)))
#' se <- c(0,round(runif(19, min = 5, max = 15)))
#' ref <- c(rep(FALSE,5),rep(TRUE,15))
#' rescale_index(index, se, ref, denom = 1.01)
rescale_index <- function(index, se, ref, denom = 1.01) {
  missing <- is.na(index)
  log_index <- log(index[!missing])
  log_var <- se[!missing]^2 / index[!missing]^2
  ref_nmiss <- ref[!missing]
  first.ix <- which(log_index == log(100) & log_var == 0)
  n <- length(log_index)
  M <- diag(1, n) - 1/sum(ref_nmiss) * rep(1,n) %*% t(as.integer(ref_nmiss)) # Rescaling matrix

  # Assume variance of first year raw log index is close to the smallest of the remaining indices.

  if(se[first.ix] > 0){
    vy1 <- min(min(log_var[-first.ix])/denom,log_var[first.ix])
  }else{
    vy1 <- min(log_var[-first.ix])/denom
  }

  log_index_scaled <- NA + index
  log_index_scaled[!missing] <- M %*% log_index
  log_index_se <- NA + index
  log_index_se[!missing] <- sqrt(diag(M %*% (diag(log_var  +  vy1 * replace(rep(-1, length(log_index)), first.ix, 1))) %*% t(M)))
  scale_index_se <- rbind(log_index = log_index_scaled, se_log = log_index_se)
  return(scale_index_se)
}
