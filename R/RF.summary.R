#' Scatter Plot of Alpha Diversity Prediction
#'
#' `RF.summary` returns a ggplot scatter plot of the predicted vs. sampled alpha diversity per plot location.
#' The training and testing splits are visualized as well as the individual R2.
#'
#' @param forest Random Forest train object.
#' @param rf_data the input data frame to the Random Forest model.
#' @param div_df data frame with the alpha diversity indices at plot locations, predictor variables.
#' @param train_index data frame indices of the training split.
#' @param biodiv_index alpha diversity indice which was used to train and test, either specn (= Species Number),
#' shannon (= shannon index) or simpson (= simpson index)
#' @param plot_labels should points in scatter plot be labled with their plot name (T/F).
#'
#' @return A ggplot scatter plot.
#'
#' @export

RF.summary <- function(forest, rf_data, div_df, train_index, biodiv_index, plot_labels = T){
  # Visualization of model prediction
  train.res <- forest$trainingData['.outcome']
  train.res$predicted <- unname(forest$finalModel$predicted)
  train.res$traintest <- rep("train", nrow(train.res))
  # Testing with test set
  testing_set <- rf_data[-train_index,]

  test <- stats::predict(object=forest, newdata=testing_set)
  test_df <- merge(div_df[c('plot_names', biodiv_index)], data.frame(plot_names = names(test),predicted = test), by = "plot_names")
  test_df <- dplyr::rename(test_df, .outcome = biodiv_index)
  test_df$traintest <- rep("test", nrow(test_df))
  test_df <- tibble::column_to_rownames(test_df, var="plot_names")
  test_df <- rbind(train.res, test_df)
  R2 <- round(forest$results[forest$results$mtry == as.numeric(forest$bestTune),]$Rsquared,3)

  # get x and y range
  limx <- c(min(test_df$.outcome), max(test_df$.outcome))
  limy <- limx[2]*(1-0.04)

  model <- stats::lm(predicted ~ .outcome, data = test_df)
  r2_test <- summary(model)$r.squared
  # text position
  text.pos <- stats::quantile(test_df$.outcome, 0.1) %>% unname()

  lab <- c(paste("R[train]^2 == ", round(R2,3)),
           paste("n[train] ==", nrow(train.res)),
           paste("R[test]^2 == ", round(r2_test,3)),
           paste("n[test] ==", length(test)))

  if (plot_labels == T){
    rf_plot <- ggplot2::ggplot(data = test_df, aes(x=.outcome, y=predicted, col=traintest, label = rownames(test_df)))+
      geom_point(size = 2.5)+
      geom_text(check_overlap = T, nudge_y = 1, size = 2.7)+
      geom_abline(slope = 1)+
      xlim(limx)+
      ylim(limx)+
      xlab(paste("Actual", biodiv_index))+
      ylab(paste("Predicted", biodiv_index))+
      annotate("text", x= limx[1], y=c(limy, limy *0.96, limy * 0.92, limy * 0.88), label = lab, hjust = 0, parse = T)+
      ggtitle(paste("Random Forest Result:", biodiv_index))

  }else{
    rf_plot <- ggplot2::ggplot(data = test_df, aes(x=.outcome, y=predicted, col=traintest))+
      geom_point(size = 2.5)+
      #geom_text(check_overlap = T, nudge_y = 1, size = 2.7)+
      geom_abline(slope = 1)+
      xlim(limx)+
      ylim(limx)+
      xlab(paste("Actual", biodiv_index))+
      ylab(paste("Predicted", biodiv_index))+
      annotate("text", x= limx[1], y=c(limy, limy *0.96, limy * 0.92, limy * 0.88), label = lab, hjust = 0, parse = T)+
      ggtitle(paste("Random Forest Result:", biodiv_index))
  }
  return(rf_plot)
}
