#' Get S-2 Acquisition paths
#'
#' `get_acquisitions` returns the acquisiton paths for specific year and month, used to load S2 masks and bands
#'
#' @param year string, indicating the year of the acquisitions
#' @param month string, indicating the month, two characters, e.g. "01","02",..., "12"
#' @param wd directory where the satellite data is stored
#'
#' @return A character vector of the acquisiton paths for a specific year and month, used to load S2 masks and bands.
#' @examples
#'
#' acquisitions <- get_acquisitions("2022", "04", "E:/Grasslands_BioDiv/Data/SatData/")
#'
#' @export

get_acquisitions <- function(year, month, wd){
  if (!file.exists(wd)) stop("wd does not exist.")
  month_path <- paste0(wd, year, '/', month)
  if (!file.exists(month_path)) stop("Year and month combination does not exist.")
  acquisitions <- list.files(month_path, full.names = T)
  return(acquisitions)
}
