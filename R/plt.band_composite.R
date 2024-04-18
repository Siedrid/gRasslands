#' Plot Band Combination
#'
#' `plt.band_composite` creates a plot of a specific Sentinel-2 Band Combination.
#'
#' @param acq path to the acquisition directory with masks and bands
#' @param bands vector of bands, for RGB e.g.: c("B2", "B3", "B4")
#' @param study_area sf bounding box object of the study area.
#' @param df Data frame with plot coordinates, default column names are "X" and "Y", points will be added, when add.plots = T
#' @param add.plots default is F, if T, points of plot locations will be added.
#'
#' @return A map of the study area, optionally with the plot locations.
#'
#' @examples
#' bands <- c("B2", "B3", "B4")
#' acq <- get_acquisitions("2022", "04", "E:/Grasslands_Biodiv/Data/SatData/")[1]
#' plt.band_composite(acq, bands)
#'
#' @export


plt.band_composite <- function(acq, bands, study_area, df = NULL, add.plots = F){
  mask_path <- get_masks(acq) #check cloud cover
  dat <- acq_date(acq)

  for (band in bands){

    if (band %in% c("B2", "B3", "B4", "B8")){
      m <- load_mask(10, mask_path, study_area)
    }else{
      m <- load_mask(20, mask_path, study_area)
    }

    assign(band, load_band(band, acq, m, study_area = study_area))
  }

  RGB_img <- raster::stack(c(get(bands[1]), get(bands[2]), get(bands[3])))
  sub_title <- paste0("Band Combination: ", paste(bands, collapse = ' '))
  plt <- raster::plotRGB(RGB_img, axes = TRUE, stretch = "lin", main = paste(dat, "Sentinel-2 band composite"), cex.axis = 0.3)
  mtext(side = 3, line = 0, adj = 0, cex =1, sub_title)
  if (add.plots == T){
    points(df$X, df$Y, pch = 19, col = "red")
  }

  return(plt)
}

