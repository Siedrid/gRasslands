#' Return date of S-2 Acquisition
#'
#' `acq_date` returns Date of the Sentinel-2 Acquisition.
#'
#' @param acq path to the S2 acquisition folder.
#'
#' @return A date string of the S-2 acquisition.
#' @examples
#'
#' acquisitions <- get_acquisitions("2022", "04", "E:/Grasslands_BioDiv/Data/SatData/")
#' dt <- acq_date(acquisitions[1])
#'
#' @export

acq_date <- function(acq){
  date <- as.Date(stringr::str_split(stringr::str_split(acq, '_')[[1]][3], '-')[[1]][1], "%Y%m%d")
  return(date)
}
