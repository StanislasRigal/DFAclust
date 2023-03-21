
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
#> Le chargement a nécessité le package : TMB
#> Le chargement a nécessité le package : RcppEigen

data(species_ts_mat)
data(species_uncert_ts_mat)

data_ready_dfa <- prepare_data(data_ts = species_ts_mat,data_ts_se = species_uncert_ts_mat, se_log = TRUE, perc_replace = 0.01)

dfa_result <- fit_dfa(data_ts = data_ready_dfa$data_ts,data_ts_se = data_ready_dfa$data_ts_se, min_year = data_ready_dfa$min_year, max_year = data_ready_dfa$max_year, species_name_ordre = data_ready_dfa$species_name_ordre, species_sub = species_name, nfac = 0, mintrend = 1, maxtrend = 5, AIC = TRUE, center_option = 1, silent = TRUE, control = list())
#> NLMINB   BFGS NLMINB   BFGS NLMINB   BFGS 
#>      1      0      1      0      1      0 
#>    NLMINB      BFGS    NLMINB      BFGS    NLMINB      BFGS 
#> -212.8637 -212.8637 -212.8637 -212.8637 -212.8637 -212.8637 
#>       NLMINB         BFGS       NLMINB         BFGS       NLMINB         BFGS 
#> 1.550339e-03 4.107811e-04 3.596174e-03 9.591960e-05 2.133745e-03 6.990511e-05 
#> AIC:  -349.727431695359
#> NLMINB   BFGS NLMINB   BFGS NLMINB   BFGS 
#>      1      0      1      0      1      0 
#>   NLMINB     BFGS   NLMINB     BFGS   NLMINB     BFGS 
#> -238.047 -238.047 -238.047 -238.047 -238.047 -238.047 
#>       NLMINB         BFGS       NLMINB         BFGS       NLMINB         BFGS 
#> 1.082367e-02 2.159021e-05 2.517590e-03 6.952452e-05 3.490888e-03 5.648240e-05 
#> AIC:  -364.094023754003
#> NLMINB   BFGS NLMINB   BFGS NLMINB   BFGS 
#>      1      0      1      0      1      0 
#>    NLMINB      BFGS    NLMINB      BFGS    NLMINB      BFGS 
#> -252.9337 -252.9337 -252.9337 -252.9337 -252.9337 -252.9337 
#>       NLMINB         BFGS       NLMINB         BFGS       NLMINB         BFGS 
#> 4.552585e-03 3.257769e-05 3.606228e-03 2.526495e-05 3.590844e-03 1.878731e-04 
#> AIC:  -359.867412329169
#> NLMINB   BFGS NLMINB   BFGS NLMINB   BFGS 
#>      1      0      1      0      1      0 
#>   NLMINB     BFGS   NLMINB     BFGS   NLMINB     BFGS 
#> -263.296 -263.296 -263.296 -263.296 -263.296 -263.296 
#>       NLMINB         BFGS       NLMINB         BFGS       NLMINB         BFGS 
#> 2.903516e-03 9.501159e-05 1.876821e-03 5.326096e-05 4.978793e-03 3.017970e-04 
#> AIC:  -348.591986099229
#> NLMINB   BFGS NLMINB   BFGS NLMINB   BFGS 
#>      1      0      1      0      1      0 
#>    NLMINB      BFGS    NLMINB      BFGS    NLMINB      BFGS 
#> -267.0942 -267.0942 -267.0942 -267.0942 -267.0942 -267.0942 
#>       NLMINB         BFGS       NLMINB         BFGS       NLMINB         BFGS 
#> 0.0023911394 0.0003654005 0.0008730892 0.0001357068 0.0086393842 0.0003010670 
#> AIC:  -326.188482708722

data(species_name)

cluster_result <- cluster_dfa(data_dfa = dfa_result, species_sub = species_name, nboot = 500)
```

<img src="man/figures/README-example-1.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-2.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-3.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-4.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-5.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-6.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-7.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-8.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-9.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-10.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-11.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-12.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-13.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-14.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 17 proposed 3 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-15.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-16.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-17.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-18.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-19.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-20.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-21.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-22.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-23.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-24.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-25.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-26.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 13 proposed 5 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-27.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-28.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-29.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-30.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-31.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-32.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 15 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-33.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-34.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-35.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-36.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-37.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-38.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> ******************************************************************* 
    #> [1] "Frey index : No clustering structure in this data set"

<img src="man/figures/README-example-39.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-40.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-41.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-42.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-43.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-44.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-45.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-46.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 11 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-47.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-48.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-49.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-50.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-51.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-52.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-53.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-54.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-55.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-56.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-57.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-58.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-59.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-60.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 12 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-61.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-62.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-63.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-64.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-65.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-66.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-67.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-68.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-69.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-70.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-71.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-72.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-73.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-74.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-75.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-76.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-77.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-78.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-79.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-80.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-81.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-82.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-83.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-84.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-85.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-86.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-87.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-88.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-89.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-90.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-91.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-92.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-93.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-94.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-95.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-96.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 14 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-97.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-98.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-99.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-100.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-101.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-102.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-103.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-104.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 8 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-105.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-106.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-107.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-108.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-109.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-110.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-111.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-112.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-113.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-114.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-115.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-116.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-117.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-118.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 17 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> ******************************************************************* 
    #> [1] "Frey index : No clustering structure in this data set"

<img src="man/figures/README-example-119.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-120.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-121.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-122.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-123.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-124.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-125.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-126.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-127.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-128.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-129.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-130.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-131.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-132.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-133.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-134.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 14 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-135.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-136.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-137.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-138.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-139.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-140.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-141.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-142.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-143.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-144.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-145.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-146.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 14 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-147.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-148.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-149.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-150.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 15 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-151.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-152.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 14 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-153.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-154.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 13 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-155.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-156.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-157.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-158.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-159.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-160.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 11 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-161.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-162.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-163.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-164.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-165.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-166.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-167.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-168.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-169.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-170.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-171.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-172.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-173.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-174.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-175.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-176.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-177.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-178.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-179.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-180.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-181.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-182.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-183.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-184.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-185.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-186.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-187.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-188.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-189.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-190.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-191.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-192.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-193.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-194.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-195.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-196.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-197.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-198.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-199.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-200.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 8 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-201.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-202.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-203.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-204.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-205.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-206.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-207.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-208.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-209.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-210.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-211.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-212.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-213.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-214.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-215.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-216.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 14 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-217.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-218.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 14 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-219.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-220.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-221.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-222.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-223.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-224.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-225.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-226.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-227.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-228.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-229.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-230.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-231.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-232.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-233.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-234.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-235.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-236.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-237.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-238.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-239.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-240.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-241.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-242.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-243.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-244.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-245.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-246.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-247.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-248.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-249.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-250.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-251.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-252.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-253.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-254.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-255.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-256.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-257.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-258.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-259.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-260.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-261.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-262.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-263.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-264.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-265.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-266.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-267.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-268.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-269.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-270.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-271.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-272.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-273.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-274.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-275.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-276.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-277.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-278.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-279.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-280.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-281.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-282.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-283.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-284.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-285.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-286.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-287.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-288.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-289.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-290.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-291.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-292.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-293.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-294.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 11 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-295.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-296.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-297.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-298.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-299.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-300.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-301.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-302.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-303.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-304.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 14 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-305.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-306.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-307.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-308.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-309.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-310.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-311.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-312.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-313.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-314.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-315.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-316.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 8 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-317.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-318.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-319.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-320.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-321.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-322.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-323.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-324.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-325.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-326.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 15 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-327.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-328.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-329.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-330.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-331.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-332.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-333.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-334.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 19 proposed 3 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-335.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-336.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-337.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-338.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-339.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-340.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-341.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-342.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-343.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-344.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-345.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-346.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 18 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-347.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-348.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-349.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-350.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-351.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-352.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-353.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-354.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-355.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-356.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-357.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-358.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 18 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-359.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-360.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-361.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-362.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-363.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-364.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-365.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-366.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 13 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-367.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-368.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-369.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-370.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-371.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-372.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-373.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-374.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 19 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-375.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-376.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-377.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-378.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-379.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-380.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-381.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-382.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-383.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-384.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-385.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-386.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-387.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-388.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-389.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-390.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-391.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-392.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-393.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-394.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 17 proposed 4 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-395.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-396.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-397.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-398.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-399.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-400.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-401.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-402.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-403.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-404.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-405.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-406.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-407.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-408.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 14 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-409.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-410.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-411.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-412.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-413.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-414.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-415.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-416.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-417.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-418.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 11 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-419.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-420.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-421.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-422.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-423.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-424.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-425.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-426.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-427.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-428.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-429.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-430.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-431.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-432.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-433.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-434.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-435.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-436.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-437.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-438.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-439.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-440.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-441.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-442.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-443.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-444.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-445.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-446.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-447.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-448.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-449.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-450.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-451.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-452.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-453.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-454.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-455.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-456.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 15 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-457.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-458.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-459.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-460.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-461.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-462.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-463.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-464.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-465.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-466.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-467.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-468.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 11 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-469.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-470.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-471.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-472.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 12 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-473.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-474.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-475.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-476.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-477.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-478.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-479.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-480.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-481.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-482.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-483.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-484.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-485.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-486.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-487.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-488.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-489.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-490.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-491.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-492.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-493.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-494.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-495.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-496.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 16 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-497.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-498.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-499.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-500.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-501.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-502.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-503.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-504.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-505.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-506.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-507.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-508.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-509.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-510.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-511.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-512.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-513.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-514.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-515.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-516.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-517.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-518.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-519.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-520.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-521.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-522.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-523.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-524.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-525.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-526.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 18 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-527.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-528.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 11 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-529.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-530.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-531.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-532.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-533.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-534.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-535.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-536.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 14 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-537.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-538.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-539.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-540.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-541.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-542.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-543.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-544.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-545.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-546.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-547.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-548.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-549.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-550.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-551.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-552.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-553.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-554.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-555.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-556.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 14 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-557.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-558.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-559.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-560.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-561.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-562.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-563.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-564.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-565.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-566.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-567.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-568.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-569.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-570.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-571.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-572.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-573.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-574.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-575.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-576.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-577.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-578.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-579.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-580.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-581.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-582.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-583.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-584.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 18 proposed 3 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-585.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-586.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-587.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-588.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-589.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-590.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-591.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-592.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-593.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-594.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-595.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-596.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-597.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-598.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-599.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-600.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-601.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-602.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-603.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-604.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 17 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-605.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-606.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-607.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-608.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-609.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-610.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-611.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-612.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 12 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-613.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-614.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-615.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-616.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-617.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-618.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-619.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-620.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-621.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-622.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-623.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-624.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-625.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-626.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 11 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-627.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-628.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 8 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-629.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-630.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-631.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-632.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 11 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-633.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-634.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-635.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-636.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-637.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-638.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-639.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-640.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-641.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-642.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-643.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-644.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-645.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-646.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-647.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-648.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 11 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-649.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-650.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-651.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-652.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-653.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-654.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-655.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-656.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-657.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-658.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-659.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-660.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-661.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-662.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 18 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-663.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-664.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-665.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-666.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-667.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-668.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-669.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-670.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-671.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-672.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-673.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-674.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-675.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-676.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-677.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-678.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-679.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-680.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 11 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-681.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-682.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-683.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-684.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-685.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-686.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-687.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-688.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-689.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-690.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-691.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-692.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-693.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-694.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-695.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-696.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-697.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-698.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-699.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-700.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-701.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-702.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 14 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-703.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-704.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-705.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-706.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-707.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-708.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-709.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-710.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-711.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-712.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-713.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-714.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-715.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-716.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-717.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-718.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-719.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-720.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-721.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-722.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-723.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-724.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-725.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-726.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 18 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-727.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-728.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-729.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-730.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-731.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-732.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-733.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-734.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-735.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-736.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-737.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-738.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-739.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-740.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-741.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-742.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-743.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-744.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-745.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-746.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 15 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-747.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-748.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-749.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-750.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-751.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-752.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-753.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-754.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-755.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-756.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-757.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-758.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 12 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-759.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-760.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 11 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-761.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-762.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-763.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-764.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-765.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-766.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-767.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-768.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-769.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-770.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 17 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-771.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-772.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-773.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-774.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-775.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-776.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-777.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-778.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 12 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-779.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-780.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-781.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-782.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 17 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-783.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-784.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-785.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-786.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 14 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-787.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-788.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-789.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-790.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 15 proposed 4 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-791.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-792.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> ******************************************************************* 
    #> [1] "Frey index : No clustering structure in this data set"

<img src="man/figures/README-example-793.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-794.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-795.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-796.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 11 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-797.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-798.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-799.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-800.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-801.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-802.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-803.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-804.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-805.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-806.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-807.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-808.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-809.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-810.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 14 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-811.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-812.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-813.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-814.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-815.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-816.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-817.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-818.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-819.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-820.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 13 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-821.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-822.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 15 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-823.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-824.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-825.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-826.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 17 proposed 3 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-827.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-828.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-829.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-830.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-831.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-832.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-833.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-834.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-835.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-836.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-837.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-838.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-839.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-840.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-841.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-842.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 17 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-843.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-844.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-845.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-846.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-847.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-848.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-849.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-850.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-851.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-852.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-853.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-854.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-855.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-856.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-857.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-858.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-859.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-860.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 18 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-861.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-862.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-863.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-864.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-865.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-866.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-867.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-868.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-869.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-870.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-871.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-872.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-873.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-874.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-875.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-876.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-877.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-878.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-879.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-880.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-881.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-882.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-883.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-884.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-885.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-886.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-887.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-888.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 11 proposed 5 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-889.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-890.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 8 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-891.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-892.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-893.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-894.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-895.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-896.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-897.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-898.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-899.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-900.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-901.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-902.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 3 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-903.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-904.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-905.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-906.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-907.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-908.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 12 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-909.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-910.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-911.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-912.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-913.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-914.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-915.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-916.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-917.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-918.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 14 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-919.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-920.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 15 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-921.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-922.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-923.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-924.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-925.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-926.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 10 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-927.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-928.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 5 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 6 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-929.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-930.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-931.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-932.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-933.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-934.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 2 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-935.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-936.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-937.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-938.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-939.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-940.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-941.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-942.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-943.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-944.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 9 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-945.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-946.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 10 proposed 5 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-947.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-948.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-949.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-950.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 14 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-951.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-952.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-953.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-954.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 10 proposed 3 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-955.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-956.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 13 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-957.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-958.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 6 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-959.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-960.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 8 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 5 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-961.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-962.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 11 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 7 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-963.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-964.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-965.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-966.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 8 proposed 2 as the best number of clusters 
    #> * 9 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-967.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-968.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-969.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-970.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 6 proposed 3 as the best number of clusters 
    #> * 3 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 11 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-971.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-972.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 13 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-973.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-974.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 8 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-975.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-976.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 7 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 9 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-977.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-978.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-979.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-980.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 5 proposed 4 as the best number of clusters 
    #> * 1 proposed 5 as the best number of clusters 
    #> * 12 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-981.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-982.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 15 proposed 3 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-983.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-984.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 7 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-985.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-986.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 2 proposed 2 as the best number of clusters 
    #> * 16 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 3 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-987.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-988.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 7 proposed 2 as the best number of clusters 
    #> * 2 proposed 3 as the best number of clusters 
    #> * 9 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 4 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  4 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-989.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-990.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 1 proposed 3 as the best number of clusters 
    #> * 2 proposed 4 as the best number of clusters 
    #> * 16 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-991.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-992.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 10 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 6 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-993.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-994.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 1 proposed 2 as the best number of clusters 
    #> * 12 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 7 proposed 5 as the best number of clusters 
    #> * 2 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  3 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-995.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-996.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 11 proposed 2 as the best number of clusters 
    #> * 5 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 4 proposed 5 as the best number of clusters 
    #> * 5 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  2 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-997.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-998.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 6 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 8 proposed 4 as the best number of clusters 
    #> * 10 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-999.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-1000.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 3 proposed 2 as the best number of clusters 
    #> * 4 proposed 3 as the best number of clusters 
    #> * 1 proposed 4 as the best number of clusters 
    #> * 8 proposed 5 as the best number of clusters 
    #> * 9 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  6 
    #>  
    #>  
    #> *******************************************************************

<img src="man/figures/README-example-1001.png" width="100%" />

    #> *** : The Hubert index is a graphical method of determining the number of clusters.
    #>                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
    #>                 significant increase of the value of the measure i.e the significant peak in Hubert
    #>                 index second differences plot. 
    #> 

<img src="man/figures/README-example-1002.png" width="100%" />

    #> *** : The D index is a graphical method of determining the number of clusters. 
    #>                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
    #>                 second differences plot) that corresponds to a significant increase of the value of
    #>                 the measure. 
    #>  
    #> ******************************************************************* 
    #> * Among all indices:                                                
    #> * 4 proposed 2 as the best number of clusters 
    #> * 3 proposed 3 as the best number of clusters 
    #> * 4 proposed 4 as the best number of clusters 
    #> * 13 proposed 5 as the best number of clusters 
    #> * 1 proposed 6 as the best number of clusters 
    #> 
    #>                    ***** Conclusion *****                            
    #>  
    #> * According to the majority rule, the best number of clusters is  5 
    #>  
    #>  
    #> *******************************************************************

    dfa_result_plot <- plot_dfa_result(data_dfa = dfa_result, sdRep = cluster_result$sdRep, species_sub = species_name, group_dfa = cluster_result$group_dfa, min_year = data_ready_dfa$min_year, species_name_ordre = data_ready_dfa$species_name_ordre)
    #>   |                                                                              |                                                                      |   0%  |                                                                              |====                                                                  |   5%  |                                                                              |=======                                                               |  11%  |                                                                              |===========                                                           |  16%  |                                                                              |===============                                                       |  21%  |                                                                              |==================                                                    |  26%  |                                                                              |======================                                                |  32%  |                                                                              |==========================                                            |  37%  |                                                                              |=============================                                         |  42%  |                                                                              |=================================                                     |  47%  |                                                                              |=====================================                                 |  53%  |                                                                              |=========================================                             |  58%  |                                                                              |============================================                          |  63%  |                                                                              |================================================                      |  68%  |                                                                              |====================================================                  |  74%  |                                                                              |=======================================================               |  79%  |                                                                              |===========================================================           |  84%  |                                                                              |===============================================================       |  89%  |                                                                              |==================================================================    |  95%  |                                                                              |======================================================================| 100%
    #> Using name_long as id variables
