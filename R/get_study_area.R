#' Returns a bounding box of the study area
#'
#' `get_study_area` gives the study area to crop the Sentinel-2 bands, coordinates should be in Gauss-Kruger Projection (epsg code: ...)
#'
#' @param df.coords data.frame with the plot coordinates
#' @param x.column name of the column with x-coordinates
#' @param y.column name of the column with y-coordinates
#'
#' @return A bounding box (sf object) of the study area.
#' @examples
#' df <- readxl::read_excel(path = "E:/Grasslands_BioDiv/Data/Field_Data/SUSALPS_samplingData_BT-RB-FE_2022-2023.xlsx")
#' study_area <- get_study_area(df, "PlotCenter_x_coord", "PlotCenter_y_coord")
#'
#' @export
#'

get_study_area <- function(df.coords, x.column, y.column){
  xcoords <- as.numeric(unlist(df.coords %>% dplyr::select(x.column)))
  ycoords <- as.numeric(unlist(df.coords %>% dplyr::select(y.column)))
  # create an extent file from study region
  xmin <- min(xcoords, na.rm = T) - 500
  xmax <- max(xcoords, na.rm = T) + 500
  ymax <- max(ycoords, na.rm = T) + 500
  ymin <- min(ycoords, na.rm = T) - 500

  study_area <- sf::st_bbox(c(xmin = xmin, xmax = xmax, ymax = ymax, ymin = ymin))
  return(study_area)
}
