#' Write extracted Plot Reflectances from one acquisition to Excel Workbook
#'
#' `to_wb` writes reflectances from data frame into a new excel workbook sheet.
#'
#' @param path path to the Excel Workbook
#' @param date date of the S-2 Acquisition
#' @param df data frame with extracted reflectances at plot locations.
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
