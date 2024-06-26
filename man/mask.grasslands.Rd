% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mask.grasslands.R
\name{mask.grasslands}
\alias{mask.grasslands}
\title{Mask non Grasslands in Prediction Maps}
\usage{
mask.grasslands(s2_pred, grass.mask)
}
\arguments{
\item{s2_pred}{the prediciton raster to be masked}

\item{grass.mask}{the SpatialRaster object (terra) with the Copernicus grassland layer. The Layer can be downloaded at https://land.copernicus.eu/en/products/high-resolution-layer-grassland}
}
\value{
The masked prediciton map of the study area. Only in grassland areas a prediction of the diversity will be returned.
}
\description{
\code{mask.grasslands} masks non-grassland pixels at a spatial resolution of 10m.
}
