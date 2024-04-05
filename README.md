
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gRasslands

<!-- badges: start -->
<!-- badges: end -->

This project is part of the SUSALPS research project, which is
researching the sustainable use of alpine and pre-alpine grasslands in
Southern Germany. A key indicator of ecosystem health is the floral
biodiversity, which can be measured through indices like the species
number or the shannon and simpson index (webpage with explanation?). The
goal of this project was to estimate floral biodiverstiy at the help of
Sentinel-2 reflectances between 2022 and 2023. This package provides the
functions and code used to train a random forest model with the
extracted reflectances at the sample plot locations. Species inventories
sampled in the same plots served as response variable. Parts of the data
are also available through this package.

## Installation

You can install the development version of gRasslands like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## I. Data Preprocessing

In this section you find documentation how your data needs to be
preprocessed to train your random forest model. This is shown at the
hand of Sentinel-2 reflectances extracted at 60 plot locations in Lower
Franconia, Bavaria.

``` r
library(gRasslands)

summary(refl.df)
#>   plot_names              B2              B3              B4       
#>  Length:11248       Min.   :0.000   Min.   :0.000   Min.   :0.000  
#>  Class :character   1st Qu.:0.019   1st Qu.:0.052   1st Qu.:0.021  
#>  Mode  :character   Median :0.028   Median :0.061   Median :0.044  
#>                     Mean   :0.033   Mean   :0.064   Mean   :0.055  
#>                     3rd Qu.:0.046   3rd Qu.:0.074   3rd Qu.:0.084  
#>                     Max.   :0.180   Max.   :0.215   Max.   :0.242  
#>                     NA's   :8446    NA's   :8446    NA's   :8446   
#>        B5              B6              B7              B8       
#>  Min.   :0.009   Min.   :0.038   Min.   :0.051   Min.   :0.006  
#>  1st Qu.:0.093   1st Qu.:0.229   1st Qu.:0.263   1st Qu.:0.283  
#>  Median :0.111   Median :0.276   Median :0.321   Median :0.340  
#>  Mean   :0.117   Mean   :0.285   Mean   :0.340   Mean   :0.357  
#>  3rd Qu.:0.140   3rd Qu.:0.336   3rd Qu.:0.408   3rd Qu.:0.421  
#>  Max.   :0.281   Max.   :0.506   Max.   :0.675   Max.   :0.682  
#>  NA's   :8449    NA's   :8449    NA's   :8449    NA's   :8446   
#>       B8A             B11             B12             dat            
#>  Min.   :0.050   Min.   :0.006   Min.   :0.005   Min.   :2022-01-06  
#>  1st Qu.:0.307   1st Qu.:0.191   1st Qu.:0.083   1st Qu.:2022-06-16  
#>  Median :0.366   Median :0.225   Median :0.106   Median :2022-10-23  
#>  Mean   :0.382   Mean   :0.245   Mean   :0.127   Mean   :2022-12-07  
#>  3rd Qu.:0.447   3rd Qu.:0.293   3rd Qu.:0.166   3rd Qu.:2023-06-19  
#>  Max.   :0.712   Max.   :0.459   Max.   :0.287   Max.   :2023-12-05  
#>  NA's   :8449    NA's   :8449    NA's   :8449

int.ts <- interpolate.ts(refl.df, plot.column = "plot_names")
int.ts <- na.omit(int.ts)
monthly_max.df <- comp_monthly(int.ts, date.column = "dat", stat = "max")
monthly_max.df.piv <- pivot.df(monthly_max.df)
```

In the next step we take a look at the response variable: the
alpha-diversity indices. Species inventories were collected in the same
60 plots. Both datasets are now processed together.

``` r
summary(div.df)
#>   plot_names           shannon          simpson           specn      
#>  Length:60          Min.   :0.8192   Min.   :0.2763   Min.   :15.00  
#>  Class :character   1st Qu.:1.9584   1st Qu.:0.7237   1st Qu.:27.00  
#>  Mode  :character   Median :2.3325   Median :0.8255   Median :32.00  
#>                     Mean   :2.3205   Mean   :0.7863   Mean   :32.22  
#>                     3rd Qu.:2.7361   3rd Qu.:0.8916   3rd Qu.:37.25  
#>                     Max.   :3.5101   Max.   :0.9529   Max.   :52.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

## II. Train and Test Random Forest

``` r

m.nowinter <- c("03$", "04$", "05$", "06$","07$", "08$", "09$")
data_frame.nowinter <- RF_predictors(monthly_max.df.piv, m.nowinter)
rf_data <- preprocess_rf_data(data_frame.nowinter, div.df, "specn")

train_index <- get_train_index(rf_data, s= 10)
forest <- RF(rf_data, train_index = train_index, s= 123)
#> Lade nötiges Paket: ggplot2
#> Lade nötiges Paket: lattice
print(forest)
#> Random Forest 
#> 
#>  43 samples
#> 140 predictors
#> 
#> No pre-processing
#> Resampling: Cross-Validated (10 fold, repeated 5 times) 
#> Summary of sample sizes: 38, 39, 39, 40, 38, 39, ... 
#> Resampling results across tuning parameters:
#> 
#>   mtry  RMSE      Rsquared   MAE     
#>     2   5.323051  0.7368626  4.374899
#>    25   5.143115  0.7160370  4.359800
#>    48   5.155358  0.7062304  4.388615
#>    71   5.231955  0.7047199  4.470787
#>    94   5.273131  0.6946005  4.507952
#>   117   5.309512  0.6863588  4.542902
#>   140   5.267442  0.6978876  4.502137
#> 
#> RMSE was used to select the optimal model using the smallest value.
#> The final value used for the model was mtry = 25.

summarize.RF(forest, rf_data, div.df, train_index, "specn", plot_labels = F)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r
#write.RF("no winter", "specn", forest, 10, csv.path)
```

## III. Spatial Prediction of Alpha-Diversity

``` r

# write functions for spatial prediction and plotting first
```
