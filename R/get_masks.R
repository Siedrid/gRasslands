#' Get Mask for S-2 Acquisition
#'
#' `get_masks` returns the Sentinel-2 masks to mask clouds etc. from the satellite image.
#'
#' @param acq path to the S2 acquisition
#'
#' @return A character vector of path to the two masks for the 10m and 20m bands.
#' @examples
#'
#' acquisitions <- get_acquisitions("2022", "04", "E:/Grasslands_BioDiv/Data/SatData/")
#' mask_path <- get_masks(acquisitions[1]) # select one acquisition from the vector
#'
#' @export

get_masks <- function(acq){
  mask_path <- paste0(acq, '/MASKS/')
  mask_lst <- list.files(mask_path, pattern = '.tif$', full.names = T)
  idx <- grep('MG2', mask_lst) # get index of file with MG2 in file name

  mask_path <- c(mask_lst[idx[1]],mask_lst[idx[2]]) # M10, M20
  return(mask_path)
}
