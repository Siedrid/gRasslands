#' Load masked Sentinel-2 Band from one acquisition
#'
#' `load_band` returns the Sentinel-2 band, cloud masked and with the reflectance as the pixel values.
#'
#' @param band Sentinel-2 band (character), e.g. "B3".
#' @param acq path to the S-2 acquisition
#' @param m SpatialRaster of corresponding mask in matching spatial resolution
#' @param study_area sf object of bounding box of study area
#'
#' @return SpatRaster of the S-2 reflectances in the study area.
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
