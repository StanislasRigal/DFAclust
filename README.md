
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DFAclust

<!-- badges: start -->
<!-- badges: end -->

The goal of DFAclust is to find clusters of time-series sharing similar
dynamics. It works in two steps: 1) latent trends in the set of
time-series and 2) searching for clusters of time-series based on their
relationship (factor loadings) with the latent trends.

## Installation

You can install the development version of DFAclust from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("StanislasRigal/DFAclust")
```

## Example

This is a basic example which shows you how to find clusters in
time-series of farmland bird populations in Czech Republic:

``` r
library(DFAclust)

data(species_ts_mat)
data(species_uncert_ts_mat)

data_ready_dfa <- prepare_data(data_ts = species_ts_mat,data_ts_se = species_uncert_ts_mat, se_log = TRUE, perc_replace = 0.01)

dfa_result <- fit_dfa(data_ts = data_ready_dfa$data_ts,data_ts_se = data_ready_dfa$data_ts_se, min_year = data_ready_dfa$min_year, max_year = data_ready_dfa$max_year, species_name_ordre = data_ready_dfa$species_name_ordre, species_sub = species_name, nfac = 0, mintrend = 1, maxtrend = 5, AIC = TRUE, center_option = 1, silent = TRUE, control = list())

data(species_name)

cluster_result <- cluster_dfa(data_dfa = dfa_result, species_sub = species_name, nboot = 500)

dfa_result_plot <- plot_dfa_result(data_dfa = dfa_result, sdRep = cluster_result$sdRep, species_sub = species_name, group_dfa = cluster_result$group_dfa, min_year = data_ready_dfa$min_year, species_name_ordre = data_ready_dfa$species_name_ordre)
```
