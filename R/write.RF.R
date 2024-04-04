#' Write Random Forest results to a csv file.
#'
#' `write.RF` saves the prediction results from the Random Forest model to a csv file.
#'  With each call of `write.RF` the prediction results are appended to the csv file. The csv file serves as a documentation, which predictors etc.
#'  were used with which R2, RMSE and Standard Deviation. Also the three most important predictors are saved.
#'
#' @param pred short string to indicate which predictors, compositing metrics etc. were used.
#' @param biodiv_idx vector of the months to be used in the prediction.
#' @param forest The Random Forest model.
#' @param s seed used for the prediction and data partitioning.
#' @param csv.path path to the csv file, which should be created or already exists.
#'
#' @return A data frame with the columns: Predictors (= which months were used, which compositing method),
#' Resp_var (= alpha diversity indice used for the prediction), seed, R2, RMSE, stdev, var1, var2, var3 (= the three most important predictors).
#'
#' @export

write.RF <- function(pred, biodiv_idx, forest, s, csv.path){

  if (!file.exists(csv.path)){ # create new csv if non existent
    df <- data.frame(matrix(ncol = 9))
    colnames(df) <- c("Predictors", "Resp_var", "seed", "R2", "RMSE", "stdev", "var1", "var2", "var3")
    write.csv(df, csv.path, row.names = F)
  }else{
    df <- read.csv(csv.path) # open exisiting csv
  }
  RFImp <- caret::varImp(forest, scale = F)
  imp <- RFImp$importance
  r2 <- round(forest$results[forest$results$mtry == as.numeric(forest$bestTune),]$Rsquared,3)
  rmse <- round(forest$results[forest$results$mtry == as.numeric(forest$bestTune),]$RMSE,3)
  sd <- round(forest$results[forest$results$mtry == as.numeric(forest$bestTune),]$RsquaredSD,3)

  vars <- rownames(imp[order(-rowSums(imp)),, drop = F])[1:3] # first three most important variables
  if (is.na(df$Predictors[1])){
    df[1,] <- c(pred, biodiv_idx, s, r2, rmse, sd, vars)
  }else{
    df[nrow(df)+1,] <- c(pred, biodiv_idx, s, r2, rmse, sd, vars)
  }
  write.csv(df, csv.path, row.names = F)
  return(df)
}
