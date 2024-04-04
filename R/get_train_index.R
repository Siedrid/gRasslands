#' Partitioning the Data into training and testing split.
#'
#' `get_train_index` returns the data frame indices of the training split. By default a split of 70:30 is created.
#'
#' @param rf_data data frame, preprocessed random forest data.
#' @param s integer, seed.
#'
#' @return A vector of the data frame indices of the training split, which are 70% of the samples.
#'
#' @export
#'

get_train_index <- function(rf_data, s){
  set.seed(s)
  train_index <- caret::createDataPartition(y=rf_data$biodiv, p=0.7, list = FALSE)
  return(train_index)
}
