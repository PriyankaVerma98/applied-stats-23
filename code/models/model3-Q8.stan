//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=1> N;
  vector[N] log_gest;    // x
  vector[N] log_weight; // y 
  vector[N] preterm ; // z
  vector[N] sex; // z2 sex of baby
}

transformed data {
  vector[N] inter;           // interaction term
  inter = log_gest .* preterm; // why the dot??????????
}

// The parameters accepted by the model. 
parameters {
  vector[5] beta;           // coefs
  real<lower=0> sigma;  // error sd 
}

model {
  target += normal_lpdf(log_weight | beta[1] + beta[2]*log_gest + beta[3]*preterm + beta[4]*inter + beta[5]*sex, sigma);
  //or
  //log_weight ~ normal(beta[1] + beta[2]*log_gest + beta[3]*preterm + beta[4]*inter, sigma)
  
  // Log-priors
  target += normal_lpdf(sigma | 0, 1) 
          + normal_lpdf(beta | 0, 1);   //// ???? how do we write this ???  // Log-priors // sigma ~ sigma(0,1)
}
generated quantities {
  vector[N] log_lik;    // pointwise log-likelihood for LOO
  vector[N] log_weight_rep; // replications from posterior predictive dist

  for (n in 1:N) {
    real log_weight_hat_n = beta[1] + beta[2]*log_gest[n] + beta[3]*preterm[n] + beta[4]*inter[n] + beta[5]*sex[n];
    log_lik[n] = normal_lpdf(log_weight[n] | log_weight_hat_n, sigma);
    log_weight_rep[n] = normal_rng(log_weight_hat_n, sigma);
  }
}

