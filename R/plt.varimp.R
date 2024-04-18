#' Summary of the variable importance
#'
#' `plt.varimp` summarizes the variable importance in four plots, by grouping the variables and suming the importance
#' by A) Band, B) Year, D) Month and by visualizing the 15 most important variables.
#'
#' @param forest Random Forest Train Object.
#'
#' @return A ggplot with four subplots.
#'
#' @export

plt.varimp <- function(forest){

  imp.df <- caret::varImp(forest, scale = F)$importance

  imp.sep <- imp.df %>% tibble::rownames_to_column(var = "band.date") %>%
    tidyr::separate(band.date, into = c("Band", "Year", "Month"), sep = "_|\\.")

  top20 <- plt.varimp.caret(imp.df)

  band.plot <- imp.sep %>% dplyr::group_by(Band) %>%
    ggplot2::ggplot(aes(x=Band, y=Overall))+
    geom_bar(stat = "identity", show.legend = F)

  year.plot <- imp.sep %>% dplyr::group_by(Year) %>%
    ggplot2::ggplot(aes(x=Year, y=Overall))+
    geom_bar(stat = "identity", show.legend = F)

  month.plot <- imp.sep %>% dplyr::group_by(Month) %>%
    ggplot2::ggplot(aes(x=Month, y=Overall))+
    geom_bar(stat = "identity", show.legend = F)

  gg <- ggpubr::ggarrange(band.plot, year.plot,
                  top20, month.plot, ncol = 2, nrow = 2, labels = c("A", "B", "C", "D"))
  return(gg)
}
