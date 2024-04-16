
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gRasslands <img align="right" src="man/figures/logo_susalps_kl.jpg" alt="SUSALPS Logo" style="width: 400px;"/>

<!-- badges: start -->
<!-- badges: end -->

`gRasslands` is part of the SUSALPS research project
(<https://www.susalps.de/en/>), which is researching the sustainable use
of alpine and pre-alpine grasslands in Southern Germany. A key indicator
of ecosystem health is the floral biodiversity, which can be measured
through indices like the species number or the shannon and simpson index
(webpage with explanation?). The goal of this project was to estimate
floral diversity at the help of Sentinel-2 reflectances between 2022 and
2023. This package provides the functions and code used to train a
random forest model with the extracted reflectances at the sample plot
locations. Species inventories sampled in the same plots served as
response variable. Parts of the data are also available through this
package.

Map of Study Area some logos somewhere?

## Installation

You can install the development version of gRasslands like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## I. Data Preprocessing

In this section you find documentation how your data needs to be
preprocessed to train your random forest model. This is shown at the
hand of Sentinel-2 surface reflectances extracted at 60 plot locations
in Lower Franconia, Bavaria. The Sentinel-2 scenes were atmospherically
corrected using the MAJA processor (<https://www.cesbio.cnrs.fr/maja/>).
The Sentinel-2 Level 2A product is for some areas freely distributed on
the THEIA portal:
<https://theia.cnes.fr/atdistrib/rocket/#/search?collection=SENTINEL2>

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
```

The `refl.df` dataframe has a column for each Sentinel-2 band, and two
additional columns for the plot names and date of the Sentinel-2
acquisition. You can find the code to extract create this data frame in
`data-raw/refl.df.R`. The functions used in the refl.df.R script are
also provided within this package. In the following the `refl.df` data
frame is brought into the right form to be processed in the random
forest model.

``` r
int.ts <- interpolate.ts(refl.df, plot.column = "plot_names") # interpolate missing values
int.ts <- na.omit(int.ts)
monthly_max.df <- comp_monthly(int.ts, date.column = "dat", stat = "max") # composite to monthly maximum reflectances
monthly_max.df.piv <- pivot.df(monthly_max.df) # pivot the data into wide table
```

In the next step we take a look at the response variable: the
alpha-diversity indices. Species inventories were collected in the same
60 plots in May 2022 and April 2023. Both datasets are processed
together in step II.

``` r
# get_diversity(...)
summary(div.df)
#>   plot_names           shannon          simpson           specn      
#>  Length:60          Min.   :0.8192   Min.   :0.2763   Min.   :15.00  
#>  Class :character   1st Qu.:1.9584   1st Qu.:0.7237   1st Qu.:27.00  
#>  Mode  :character   Median :2.3325   Median :0.8255   Median :32.00  
#>                     Mean   :2.3205   Mean   :0.7863   Mean   :32.22  
#>                     3rd Qu.:2.7361   3rd Qu.:0.8916   3rd Qu.:37.25  
#>                     Max.   :3.5101   Max.   :0.9529   Max.   :52.00
```

The alpha diversity indices used are the species number, shannon and
simpson index. Many studies have shown, that species number is the best
response variable, therefore this alpha-diversity indice will be used in
the following random forest model. The code to calculate these indices
is provided in the `data-raw` folder.

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

## II. Train and Test Random Forest

For the training, only the maximum reflectances from the months March to
September are used. The winter months are influenced by clouds and are
limited by less acquisitions, which could potentially impact our results
negatively.

``` r

m.nowinter <- c("03$", "04$", "05$", "06$","07$", "08$", "09$")
data_frame.nowinter <- RF_predictors(monthly_max.df.piv, m.nowinter) # use only months from March to September
rf_data <- preprocess_rf_data(data_frame.nowinter, div.df, "specn") # merge reflectance and alpha diversity dataframe

train_index <- get_train_index(rf_data, s = 10) # split samples into training and testing (70:30)
forest <- RF(rf_data, train_index = train_index, s = 10) # train Random Forest
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
#> Summary of sample sizes: 40, 39, 39, 39, 38, 39, ... 
#> Resampling results across tuning parameters:
#> 
#>   mtry  RMSE      Rsquared   MAE     
#>     2   5.189678  0.7091475  4.223472
#>    25   4.971855  0.6854268  4.234894
#>    48   5.011213  0.6817031  4.292484
#>    71   5.047436  0.6754444  4.328216
#>    94   5.067761  0.6744548  4.354348
#>   117   5.090105  0.6728903  4.377323
#>   140   5.151373  0.6663269  4.441661
#> 
#> RMSE was used to select the optimal model using the smallest value.
#> The final value used for the model was mtry = 25.
```

In the output of the `forest` variable, it is summarized that 43 samples
were used for the training (i.e. 70% of the dataset) and 140 predictors
(i.e. 10 bands x 2 years x 7 months). Per default a cross-validation
with 10 folds and 5 repeats is used. The forest with the highest R2 and
the lowest RMSE is returned in the end. Training and testing results are
visualized in a scatter plot with the actual species number on the
x-axis and the predicted species number on the y-axis. Further
statistics can be summarized in a csv file with the function `write.RF`.
This function is especially usefull, when testing different compositing
methods, and month combinations or running the model multiple times with
different seeds.

``` r
summarize.RF(forest, rf_data, div.df, train_index, "specn", plot_labels = F) # returns scatter plot
```

<img src="man/figures/README-Random Forest 2-1.png" width="70%" />

``` r
#write.RF("no winter", "specn", forest, 10, csv.path)
```

Species Numbers between 20 and 40 have the highest accuracy. Lower and
higher species numbers are over and underestimated, respecitively, due
to the limited sample number with these numbers. The R2 is given for the
training and testing split. The testing split was not used to train the
random forest model. With `plot_labels = T`, the points are labeled
according to their plot names.

``` r

plt.varimp(forest)
```

<img src="man/figures/README-Variable Importance-1.png" width="70%" />

`plt.varimp` is an important function to evaluate the predictors
according to their band, year and month. The SWIR bands and B4 and B5
are the most important Sentinel-2 bands (A). March is by far the most
important month in the prediction (D).

## III. Spatial Prediction of Alpha-Diversity

For the spatial prediction, all variables, that trained the random
forest, need to be stacked to a spatial Raster, on which the species
number can be predicted. In the case of the random forest trained with
all summer months, the monthly maximum raster composites of all
acquisitions from March until September 2022 and 2023 respectively need
to be calculated first. Due to the limited storage capacity, these
raster composites can’t be part of this package. The code to calculate
these raster composites is provided in the `data-raw` folder. On
request, we can make these composites available. The code to calculate
spatial predictions is provided in the following.

``` r

# select months as predictors 
m <- c("03.tif", "04.tif", "05.tif", "06.tif","07.tif", "08.tif", "09.tif")
#fls <- list_comp_months(comp_path, m)

#max.brick <- stack_S2_months(fls, comp_path, m, "G:/Grasslands_BioDiv/Data/SpatialRF_Data/Monthly_Maximum_comp-nowinter2.tif")

#s2_pred <- terra::predict(max_comp.brick, model = forest, na.rm = T)
#s2_pred.masked <- mask.grasslands(s2_pred, grass.mask)

#plt.diversity(s2_pred.masked)
```

`comp_path` is the path to the directory, where the monthly raster
composites are stored. After creating a list of these raster composites,
the rasters are stacked with the terra package and then transformed into
a brick object. With `predict`, the random forest model `forest` is
applied to the brick.

## IV. Further Resources

In the following, the entire workflow of the analysis is visualized.
This package was designed to encourage a similar analysis at grassland
sites, where species inventories are available. A valuable database for
such inventories and environmental parameters is also the Biodiversity
Exploratories Information System: <https://www.bexis.uni-jena.de/> This
is an important step towards a broader understanding of grassland sites,
how to manage them and protect their valuable ecosystem services.

![Worflow of
Analysis](man/figures/GrasslandsBiodiv_Flowchart.drawio.png) Contact
Details
