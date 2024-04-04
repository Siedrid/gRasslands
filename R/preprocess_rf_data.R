#' Preprocess Random Forest Input Data
#'
#' `preprocess_rf_data` returns dataframe ready for training and testing the random forest model
#'
#' @param refl_df data frame with the monthly Sentinel-2 reflectances at plot locations.
#' @param div_df data frame with the alpha diversity indices at plot locations, predictor variables.
#' @param biodiv_index alpha diversity indice which should be used to train and test, either specn (= Species Number),
#' shannon (= shannon index) or simpson (= simpson index)
#'
#' @return A data frame of the monthly Sentinel-2 Reflectances merged with the alpha diversity at plot locations. Ready to train the Random Forest.
#'
#' @export

preprocess_rf_data <- function(refl_df, div_df, biodiv_index){
  idx <- which(colnames(div_df) == biodiv_index)
  rf_data <- div_df[c(1,idx)] %>% merge(.,refl_df, by= "plot_names")
  # Change the name of the biodiv column
  rf_data <- dplyr::rename(rf_data, biodiv = biodiv_index)

  rownames(rf_data) <- rf_data$plot_names
  rf_data <- rf_data[-1]

  return(rf_data)
}
