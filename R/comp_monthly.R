#' Monthly compositing of Sentinel-2 time series
#'
#' `comp_monthly` composites S-2 time series to monthly reflectances.
#'
#' @param df data frame (interpolated) with the at plot reflectance.
#' @param date.column column name storing the acquisition dates.
#' @param stat statistic to use for compositing, e.g. max, min, mean.
#'
#' @return A data frame of monthly S-2 reflectances.
#'
#' @export
comp_monthly <- function(df, date.column, stat){
  # rename date column
  colnames(df)[colnames(df) == date.column] <- "dat"
  # Calculate maximum reflectance per band, plot and month
  comp_df <- df %>%
    dplyr::group_by(plot_names, month = format(dat, "%Y.%m")) %>%
    dplyr::summarize_if(is.numeric, stat, na.rm = TRUE)
  return(comp_df)
}
