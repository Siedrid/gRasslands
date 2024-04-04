#' Barplot of the 15 most important predictors
#'
#' `plt.varimp.caret` gives the 15 most important predictors of the random forest model.
#'
#' @param imp.df data frame, with variables and their relative importance.
#'
#' @return A ggplot barplot with the variables on the y-axis and the importance on the x-axis.
#'
#' @export

plt.varimp.caret <- function(imp.df){

  imp.df$variable <- rownames(imp.df)
  imp.df <- imp.df[order(-imp.df$Overall), ]

  top_20 <- imp.df[1:15, ]
  top_20$variable <- factor(top_20$variable, levels = rev(unique(top_20$variable)))

  ImpPlot <- ggplot2::ggplot(top_20, aes(x = variable, y = Overall)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    labs(x = "Variable", y = "Importance") +
    coord_flip()

  return(ImpPlot)
}
