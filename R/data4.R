#' Species Indices and log standard errors for brreding birds in Sweden
#'
#' A processed subset of data from the Swedish Monitoring Bird Survey. See the processed steps in the vignette Using "DFAclust to analyse bird indices"
#'
#' @format ## `species_ts_mat`
#' A matrix with 3993 rows and 23 columns:
#' \describe{
#'   \item{code_sp}{Species code}
#'   \item{year}{Years}
#'   \item{nb_year}{Number of monitored years}
#'   \item{firstY}{First monitored year}
#'   \item{lastY}{Last monitored year}
#'   \item{relative_abundance}{Abundance relative to the first year}
#'   \item{CI_inf}{Lower bound of the 95 % confidence interval}
#'   \item{CI_sup}{Upper bound of the 95 % confidence interval}
#'   \item{Standard_error}{Standard error of the relative abundance}
#'   \item{Log_SE}{Log standard error of the relative abundance}
#'   \item{p_value}{P value of year effect}
#'   \item{relative_abundance_m0}{Relative abundance from a mean-centring model}
#'   \item{Standard_error_m0}{Standard error of the relative abundance from a mean-centring model}
#'   \item{Log_SE_m0}{Log standard error of the relative abundance from a mean-centring model}
#'   \item{p_value_m0}{P value of year effect in the mean-centring model}
#'   \item{signif}{Enough data for this year}
#'   \item{nb_route}{Number of routes monitored this year}
#'   \item{nb_route_presence}{Number of routes where the species was present this year}
#'   \item{abundance}{Species abundance}
#'   \item{mediane_occurrence}{Average number of occurrence of the species}
#'   \item{mediane_ab}{Average abundance of the species}
#'   \item{valid}{Species occurrence and abundance are above the selection thresholds}
#'   \item{uncertanity_reason}{Threshold not matched}
#' }
#' @source <Lindström, Å., & Green, M. (2021). Swedish Bird Survey: Fixed routes (Standardrutterna). Version 1.12. Department of Biology, Lund University. Sampling event dataset accessed via GBIF.org. Sveriges Ornitologiska Förening. https://doi.org/10.15468/hd6w0r>
"ts_bird_se_allcountry"
