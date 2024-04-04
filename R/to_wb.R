#' Write extracted Plot Reflectances from one acquisition to Excel Workbook
#'
#' `acq_date` returns Date of the Sentinel-2 Acquisition.
#'
#' @param path path to the Excel Workbook
#' @param date date of the S-2 Acquisition
#' @param df dataframe with extracted reflectances
#'
#' @return An Excel Workbook with the Acquisition date as sheet name, storing the Plot Reflectances.
#'
#' @export
#'

to_wb <- function(path, date, df){
  wb <- openxlsx::loadWorkbook(path)

  if (toString(date) %in% openxlsx::getSheetNames(path)){
    openxlsx::writeData(wb, sheet=date, df)
    openxlsx::saveWorkbook(wb, path, overwrite = T)
  }else{
    openxlsx::addWorksheet(wb, date)
    openxlsx::writeData(wb, sheet=date, df)
    openxlsx::saveWorkbook(wb, path, overwrite = T)
  }
}
