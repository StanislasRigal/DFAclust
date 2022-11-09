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
