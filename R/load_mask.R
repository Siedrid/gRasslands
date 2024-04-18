#' Load Mask for S-2 Acquisition
#'
#' `load_mask` returns the Sentinel-2 masks to mask clouds etc. from the satellite image.
#'
#' @param mask_path path to S-2 masks
#' @param res resolution of the S-2 band which needs to be masked, either 10 or 20.
#' @param study_area sf object of bounding box of study area
#'
#' @return A SpatialRaster, terra object with true and false.
#'
#' @export

load_mask <- function(res, mask_path, study_area){
  if (res == 10){
    mask10 <- terra::rast(mask_path[1])
    mask_crp <- terra::crop(mask10, study_area) # crop mask to extent
    m <- mask_crp > 1 # all values greater 1 are set to TRUE and masked in the next step
  }
  if (res == 20){
    mask20 <- terra::rast(mask_path[2])
    mask_crp <- terra::crop(mask20, study_area) # crop mask to extent
    m <- mask_crp > 1 # all values greater 1 are set to TRUE and masked in the next step
  }
  return(m)
}
