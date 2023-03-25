data {
  int<lower=0> N; // number of observations
  int<lower=0> t; //number of years
  int<lower=0> mid_year; // mid-year of study
  vector[N] y; //log ratio
  vector[N] se; // standard error around observations
  vector[t] years; // unique years of study
  int<lower=0> year_i[N]; // year index of observations
  int <lower=0> P; // number of prjection year
}

parameters {
  vector[t] mu;
  real <lower=0> sigma;

}
/*
transformed parameters{
  vector[t] mu;
  
  for(i in 1:t){
    mu[i] = alpha + beta*(years[i] - mid_year);
  }
}*/

model {
  
  y ~ normal(mu[year_i], se);
  mu[1] ~ normal(0,1);
  mu[2:t] ~ normal(mu[1:(t-1)], sigma);
  
  sigma ~ normal(0,1);
  mu ~ normal(0,1);
}

generated quantities{
  vector[P] mu_p;
  mu_p[1] = normal_rng(mu[t], sigma);
  
  for(i in 2:P){
    mu_p[i] = normal_rng(mu_p[i-1], sigma); 
  }
}
