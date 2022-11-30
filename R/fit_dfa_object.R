#' S4 class for `fit_dfa()`
#'
#' @slot tmbObj list.
#' @slot tmbOpt list.
#' @slot data_ts matrix.
#' @slot data_ts_se matrix.
#' @slot data_ts_save data.frame.
#' @slot data_ts_save_long data.frame.
#' @slot data_ts_se_save data.frame.
#' @slot nfac numeric.
#' @slot ny integer.
#' @slot nT integer.
#' @slot aic numeric.
#' @slot conv integer.
#' @slot sdRep_test matrix.
#' @slot sdRep_test_all sdreport.
#' @slot x_hat matrix.
#' @slot x_hat_se matrix.
#' @slot Z_hat matrix.
#' @slot Z_hat_orig matrix.
#' @slot Z_hat_se matrix.
#' @slot cov_mat_Z matrix.
#' @slot data_loadings data.frame.
methods::setOldClass("sdreport")
fit_dfa_object <- methods::setClass("fit_dfa", slots=list(tmbObj = "list",
                                        tmbOpt = "list",
                                        data_ts = "matrix",
                                        data_ts_se = "matrix",
                                        data_ts_save = "data.frame",
                                        data_ts_save_long = "data.frame",
                                        data_ts_se_save = "data.frame",
                                        nfac = "numeric",
                                        ny = "integer",
                                        nT = "integer",
                                        aic = "numeric",
                                        conv = "integer",
                                        sdRep_test = "matrix",
                                        sdRep_test_all = "sdreport",
                                        x_hat = "matrix",
                                        x_hat_se = "matrix",
                                        Z_hat = "matrix",
                                        Z_hat_orig = "matrix",
                                        Z_hat_se = "matrix",
                                        cov_mat_Z = "matrix",
                                        data_loadings = "data.frame"))

methods::setMethod("$", "fit_dfa",
          function(x, name)
          {
            ## 'name' is a character(1)
            slot(x, name)
          })
