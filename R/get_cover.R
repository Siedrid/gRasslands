#' Percentage of the masked area in the study_area for an acquisition.
#'
#' `get_cover` returns the acquisiton paths for specific year and month, used to load S2 masks and bands
#'
#' @param acq path to the acquisition directory with masks and bands
#' @param study_area sf bounding box object of the study area.
#'
#' @return Float, percentage of the masked study area.
#'
#' @export

get_cover <- function(acq, study_area){

  mask_path <- gRasslands::get_masks(acq)
  m <- gRasslands::load_mask(10, mask_path, study_area)

  assign("rst", load_band("B2", acq, m, study_area = study_area))

  # calculate cover
  masked <- terra::global(rst, fun = "isNA")
  notmasked <- terra::global(rst, fun = "notNA")

  p <- masked/(masked+notmasked)
  p <- p[[1]] * 100
  message(paste0("Cloud Cover is ", round(p,2), '%'))
  return(p)
}
