#' List monthly raster composites
#'
#' `list_comp_months` returns the monthly raster composites for the spatial predicition.
#'
#' @param path string, indicating the year of the acquisitions
#' @param ms vector, indicating the month, e.g. c(3:9) for months March to September.
#'
#' @return A character vector of the paths to the calculated composites.
#' Code to calculate the composites is provided in the `data-raw` folder in the `comp.S2.bands.R` script. On request, we can make these composites available.
#'
#' @export

list_comp_months <- function(path, ms){
  idx.lst <- c()
  m_str <- paste0(sprintf("%02d", ms), ".tif$")
  for (m in m_str){
    idx <- grep(m, list.files(path))
    idx.lst <- append(idx.lst, idx)
  }
  fls <- list.files(path, full.names = T)[idx.lst]
  return(fls)
}
