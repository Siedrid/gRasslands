#' Mask non Grasslands in Prediction Maps
#'
#' `mask.grasslands` masks non-grassland pixels at a spatial resolution of 10m.
#'
#' @param s2_pred the prediciton raster to be masked
#' @param grass.mask the SpatialRaster object (terra) with the Copernicus grassland layer. The Layer can be downloaded at https://land.copernicus.eu/en/products/high-resolution-layer-grassland
#'
#' @return The masked prediciton map of the study area. Only in grassland areas a prediction of the diversity will be returned.
#'
#' @export

mask.grasslands <- function(s2_pred, grass.mask){
  mask <- (grass.mask != 1)
  mask.proj <- terra::project(mask, "epsg:32632")

  s2_pred.rast <- terra::rast(s2_pred)

  mask.res <- terra::resample(mask.proj, s2_pred.rast)
  mask.crp <- terra::crop(mask.res, s2_pred.rast)
  s2_pred.mask <- terra::mask(s2_pred.rast, mask.crp, maskvalue = 1)
  return(s2_pred.mask)
}
