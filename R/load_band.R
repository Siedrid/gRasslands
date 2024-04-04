#' Load masked Sentinel-2 Band from one acquisition
#'
#' `load_band` returns the Sentinel-2 masks to mask clouds etc. from the satellite image.
#'
#' @param band Sentinel-2 band (character)
#' @param acq path to the S2 acquisition
#' @param m SpatialRaster of corresponding mask in matching spatial resolution
#' @param study_area sf object of bounding box of study area
#'
#' @return A character vector of path to the two masks for the 10m and 20m bands.
#'
#' @export

load_band <- function(band, acq, m, study_area){
  scal_factor <- 10000
  band_lst <- list.files(acq, full.names = T)
  band_lab <- paste0("FRE_", band, ".tif$")
  band_path <- band_lst[grep(band_lab, band_lst)]

  if (band %in% c("B2", "B3", "B4", "B8")){
    rast <- terra::crop(terra::rast(band_path), study_area)/scal_factor

    rast_m <- terra::mask(rast, m, maskvalue = TRUE)

  }else{
    rast <- terra::crop(terra::rast(band_path), study_area)/scal_factor

    rast_m <- terra::mask(rast, m, maskvalue = TRUE)
  }
  return(rast_m)
}
