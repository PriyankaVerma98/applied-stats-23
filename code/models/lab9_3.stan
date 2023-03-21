data {
  int<lower=0> N; // number of regions
  int y[N]; // deaths
  vector[N] log_e; //log of expected deaths
  vector[N] x; // prop of outside workers
}

parameters {
  vector[N] alpha;
  real beta;
  
  real mu;
  real <lower=0> sigma;
}
transformed parameters{
  vector[N] log_theta;
  log_theta = alpha + beta*x;
}
model {
  y ~ poisson_log(log_theta + log_e); //you are inputting the logged vale of rate parameter
  
  //priors
  alpha ~ normal(mu,sigma);  //checkk!!
  beta ~ normal (0,1);
  
  mu ~normal(0,1); 
  sigma ~normal(0,1);
}
