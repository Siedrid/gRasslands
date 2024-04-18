#' Select months to use as predictors for the Random Forest.
#'
#' `RF_predictors` slices the monthly Sentinel-2 reflectance data frame to the desired months.
#'
#' @param data_frame monthly S-2 reflectance data frame.
#' @param m_lst vector of the months to be used in the prediction, e.g. c(3:9) for March until September.
#'
#' @return A data frame.
#'
#' @export

RF_predictors <- function(data_frame, m_lst){
  idx.lst <- c()
  m_str <- paste0(sprintf("%02d", m_lst), "$")
  for (m in m_str){
    idx <- grep(m, colnames(data_frame))
    idx.lst <- append(idx.lst, idx)
  }
  data_frame.spring <- data_frame[idx.lst]
  data_frame.spring["plot_names"] <- data_frame$plot_names
  return(data_frame.spring)
}
