#' Stack monthly raster composites
#'
#' `stack_S2_months` returns the stack of monthly raster composites for the spatial predicition.
#'
#' @param fls vector of paths to the monthly raster composites which should be stacked.
#'
#' @return A raster brick object with monthly band composites as layers, e.g. B12_2022.04
#'
#' @export

stack_S2_months <- function(fls){
  bands <- c("B2", "B3", "B4", "B5", "B6", "B7", "B8", "B8A", "B11", "B12") # Sentinel-2 Bands
  max_comp <- list()
  for (i in 1:length(fls)){
    date.str <- stringr::str_split(fls[i],'-')[[1]][3] %>% stringr::str_split(., '.tif')
    date.str <- date.str[[1]][1] %>% gsub("_", "-", .)
    rst <- terra::rast(fls[i])
    names(rst) <- paste0(bands, "_", date.str)
    max_comp[[i]] <- rst
  }
  max_comp.stack.terra <- terra::rast(max_comp)
  max.brick <- raster::brick(max_comp.stack.terra)

  return(max.brick)
}
