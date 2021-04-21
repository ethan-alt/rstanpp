
functions {
#include /functions/link.stan
#include /functions/glm_pp.stan
}


data {
  int<lower=0>          nobs;          // number of observations
  int<lower=0>          p;             // number of predictors
  int<lower=0>          y0[nobs];      // historical data
  matrix[nobs,p]        X;             // design matrix
  real<lower=0,upper=1> a0;            // power prior parameter
  vector[p]             beta0;         // initial prior mean of beta
  matrix[p,p]           Sigma0;        // initial prior covariance matrix of beta
  int<lower=1,upper=9>  link;          // index of link function
  int<lower=0,upper=1>  incl_offset;   // whether an offset is included
  vector[nobs]          offset;        // offset (defaults to vector of 0s in R)
}

// Only one parameter: the regression coefficient
parameters {
  vector[p] beta;
}

// Assume beta is a priori MVN; obtain posterior
// based on power prior
model {
  vector[nobs] eta = X * beta;
  if (incl_offset == 1) {
    eta = eta + offset;
  }
  beta ~ multi_normal(beta0, Sigma0);
  target += poisson_glm_pp_lp(y0, a0, eta, link);
}
