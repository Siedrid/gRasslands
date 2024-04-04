#' Convert Workbook to Dataframe
#'
#' `wb_to_df` converts the excel workbook containing the plot reflectances into a dataframe.
#'
#' @param wb_path path to the excel workbook.
#'
#' @return A dataframe with columns S-2 bands and acquisition date.
#' @examples
#'
#' wb_path <- "E:/Grasslands_BioDiv/Data/S2_Reflectances/reflectances_plot_center-v1.xlsx"
#' refl.df <- wb_to_df(wb_path)
#'
#' @export

wb_to_df <- function(wb_path){

  # load Workbook
  wb <- openxlsx::loadWorkbook(wb_path)
  dates <- as.Date(openxlsx::getSheetNames(wb_path), "%Y-%m-%d")
  sort_dates <- sort(dates)

  # initialize array
  df1 <- openxlsx::read.xlsx(wb, sheet = toString(sort_dates[1]))
  df1 <- df1[-2]
  df1$dat <- rep(sort_dates[1], nrow(df1))
  df2 <- openxlsx::read.xlsx(wb, sheet = toString(sort_dates[2]))
  df2 <- df2[-2]
  df2$dat <- rep(sort_dates[2], nrow(df2))

  a <- rbind(df1, df2)

  # stack Sentinel retrieved reflectances in increasing date order
  for (d in 3:length(sort_dates)){
    df1 <- openxlsx::read.xlsx(wb, sheet=toString(sort_dates[d]))
    df1 <- df1[-2]
    df1$dat <- rep(sort_dates[d], nrow(df1))

    a <- rbind(a, df1)
  }
  return(a)
}
