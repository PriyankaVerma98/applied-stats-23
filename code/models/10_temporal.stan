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
  real alpha;
  real beta;

}

transformed parameters{
  vector[t] mu;
  
  for(i in 1:t){
    mu[i] = alpha + beta*(years[i] - mid_year);
  }
}

model {
  
  y ~ normal(mu[year_i], se);
  
  alpha ~ normal(0, 1);
  beta ~ normal(0,1);
}

generated quantities{
  vector[P] mu_p;
  for(i in 1:P){
    mu_p[i] = alpha + beta*(years[t+i] - mid_year);
  }
}
