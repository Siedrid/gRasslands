#' Training the Random Forest model
#'
#' `RF` returns the Random Forest model trained with the S-2 reflectances and the alpha diversity indices.
#' A repeated cross validation with 10 folds and 5 repeats is used.
#'
#' @param rf_data data frame, preprocessed random forest data.
#' @param train_index data frame indices of the training split.
#' @param s integer, seed.
#'
#' @return A train object, the random forest model to predict alpha diversity from Sentinel-2 reflectances.
#'
#' @export

RF <- function(rf_data, train_index, s){
  train_control <- caret::trainControl(method = "repeatedcv", number = 10, repeats = 5)

  training_set <- rf_data[train_index,]

  set.seed(s)
  forest <- caret::train(biodiv~., data = training_set, method = 'rf', trControl = train_control, tuneLength = 7)
  return(forest)
}
