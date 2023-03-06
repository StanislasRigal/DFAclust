

// Dynamic Factor Analysis for multivariate time series
#include <TMB.hpp>
template<class Type>
  Type objective_function<Type>::operator() ()
{
  // Data
  DATA_ARRAY(y);
  // Observation standard error
  DATA_ARRAY(obs_se);
  DATA_INTEGER(center); // 0 if centered on the first year, 1 if log mean centered

  int nSp = y.dim[0];
  int nT = y.dim[1];

  // For one-step-ahead residuals
  DATA_ARRAY_INDICATOR(keep, y);

  DATA_MATRIX(Z_pred);
  DATA_UPDATE(Z_pred);

  DATA_MATRIX(W); // Weighting matrix to compute mean trends over species.
  DATA_UPDATE(W);

  // Parameters
  PARAMETER_VECTOR(log_re_sp); // log of sd for random effect by species

  // Loadings matrix
  PARAMETER_MATRIX(Z);

  // Latent trends
  PARAMETER_MATRIX(x);

  // Cluster center
  matrix<Type> x_pred(Z_pred.rows(), nT);
  matrix<Type> x_pred2(W.rows(), nT);
  matrix<Type> WZ(W.rows(), Z.cols());

  // Mean of latent trends
  matrix<Type> x_mean(x.rows(), 1);
  x_mean.setZero();

  // Mean-centred latent trends
  matrix<Type> x_mc(x.rows(), x.cols());

  // Matrix to hold predicted species trends
  matrix<Type> x_sp(nSp, nT);

  // Random error by species
  vector<Type> re_sp;
  re_sp = exp(log_re_sp);
  // Optimization target: negative log-likelihood (nll)
  Type nll = 0.0;


    // Latent random walk model. x(0) = 0.
    for(int t = 1; t < x.cols(); ++t){
      for(int f = 0; f < x.rows(); ++f){
        nll -= dnorm(x(f, t), x(f, t-1), Type(1), true);

      // Simulation block for process equation
      SIMULATE {
          x(f, t) = rnorm(x(f, t-1), Type(1));
          REPORT(x);
      }
      }
    }

    if (center) {
      for (int f = 0; f < x.rows(); ++f) {
        x_mean(f) = x.row(f).sum()/x.cols();
        SIMULATE {
          x_mean(f) = x.row(f).sum()/x.cols();
        }
      }
    }

    // Mean-centred random walks
    for(int t = 0; t < nT; ++t){
      for(int f = 0; f < x.rows(); ++f){
        x_mc(f, t) = (x(f,t)-x_mean(f));
      }
    }


  // Species trends
  for(int i = 0; i < nSp; ++i) {
    for(int t = 0; t < nT; ++t) {
      x_sp(i, t) = (Z.row(i) * (x.col(t)-x_mean)).sum();
    }
  }

  // Cluster center
  WZ = W * Z;
  for (int t=0; t < nT; ++t) {
      x_pred.col(t) = Z_pred * (x.col(t)-x_mean);
      x_pred2.col(t) = WZ * (x.col(t)-x_mean);
  }


  // Observation model
  for(int i = 0; i < nSp; ++i){
  // Skipping t = 0 when y(i, 0) is fixed at 0. Need to change this if y(i, 0) is not 0.
  // Also had had to change the index of x from t+1 to t, so that x is fixed at zero at time t=0.
    for(int t = 0; t < nT; ++t){
    if(!R_IsNA(asDouble(y(i,t)))){
    nll -= keep(i,t) * dnorm(y(i, t), x_sp(i, t), sqrt(obs_se(i, t)*obs_se(i, t)+re_sp(i)*re_sp(i)), true); // with random effect
    }


      //*----------------------- SECTION I --------------------------*/
        // Simulation block for observation equation
      SIMULATE {
          y(i,t) = rnorm(x_sp(i, t), sqrt(obs_se(i, t)*obs_se(i, t)+re_sp(i)*re_sp(i)));
          REPORT(y);
        }
    }
  }

  //Penalty for very small random effects variances, this is to avoid issues with non semidefinite variance matrices.
  for (int i=0; i < nSp; ++i) {
    nll += exp(-3.5 * log_re_sp(i) - 20);
  }

  // State the transformed parameters to report
  // Using ADREPORT will return the point values and the standard errors
  // Note that we only need to specify this for parameters
  // we transformed, see section D above
  // The other parameters, including the random effects (states),Q
  // will be returned automatically
  ADREPORT(re_sp);
  ADREPORT(x_sp);
  ADREPORT(x_pred);
  ADREPORT(x_pred2);
  ADREPORT(Z_pred);
  ADREPORT(x_mc);

  // Report simulated values
  //SIMULATE{
    //  REPORT(x);
    //  REPORT(y);
    //}

  return nll;
}
