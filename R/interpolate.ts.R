#' Interpolate S-2 Time Series
#'
#' `interpolate.ts` interpolates missing values in the dataframe.
#'
#' @param df dataframe with the plot reflectance.
#' @param plot.column name of the column storing the plot names.
#'
#' @return A dataframe with columns S-2 bands and acquisition date, with interpolated NA values.
#'
#' @export

interpolate.ts <- function(df, plot.column){
  bands <- c("B2", "B3", "B4", "B5", "B6", "B7", "B8", "B8A", "B11", "B12") # Sentinel-2 Bands
  # rename plot column
  colnames(df)[colnames(df) == plot.column] <- "plot_names"
  int.ts <- df %>% dplyr::group_by(plot_names) %>%
    dplyr::mutate_at(bands, ~ zoo::na.approx(., na.rm = FALSE))
  return(int.ts)
}
