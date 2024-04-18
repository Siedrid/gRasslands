#' Simple Feature of the plot locations with diversity indices.
#'
#' `div2sf` returns a simple feature object (sf) with point geometries of the diversity data frame.
#'
#' @param div.df data frame with the diversity indices.
#' @param x.column name of the column with x-coordinates.
#' @param y.column name of the column with y-coordinates
#' @param epsg.code epsg code, e.g. 25832
#' @param write True or False, write Geopackage to files.
#'
#' @return An sf object with 4 features, i.e. the plot names, and alpha diversity indices. Geopackage of the div.df is stored in the data-raw folder.
#'
#' @export
#'

div2sf <- function(div.df, x.column, y.column, epsg.code, write = F){

  div.sf <- sf::st_as_sf(div.df, coords = c(x.column, y.column), crs = sf::st_crs(epsg.code)) # check if correct epsg code
  if (write == T){
    sf::st_write(div.sf, "data-raw/Biodiv-indices_2022-23.gpkg", driver = "GPKG")
  }
  return(div.sf)
}
