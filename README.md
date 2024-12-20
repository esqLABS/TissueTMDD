
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TissueTMDD

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

TissueTMDD is a shiny that provide an interactive way to run simulations
of drug-target binding in tissue interstitial space.

Using TissueTMDD, you can:

- Setup simulation parameters,
- Run simulations,
- Compare simulations,
- Export and import simulation settings

[**Try the Web Application Here
↗️**](https://tissuetmdd.azurewebsites.net/)

![](vignettes/assets/tmdd_preview.gif)

## Installation

### Prerequisites

- Git Installation and GitHub setup
  ([instructions](https://gist.github.com/z3tt/3dab3535007acf108391649766409421)),
- R Installation (\>= 4.3.0),
- (optional) RTools Installation (for Windows users,
  [instructions](https://cran.r-project.org/bin/windows/Rtools/rtools40.html)).

### Install TissueTMDD

``` r
# install.packages("remotes")
remotes::install_github("esqLABS/TissueTMDD@release")
```

To install the latest development version, use:

``` r
# install.packages("remotes")
remotes::install_github("esqLABS/TissueTMDD")
```

## Run the App

``` r
library(TissueTMDD)
run_app()
```

## Code of Conduct

Please note that the TissueTMDD project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
