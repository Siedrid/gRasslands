#' Plot Alpha Diversity Prediction Maps
#'
#' `plt.diversity` returns a ggplot Prediction Map of the Alpha Diversity
#'
#' @param rst spatial raster (terra) with the masked species richness in grasslands.
#' @param biodiv_ind Alpha diversity indice which was predicted in rst.
#'
#' @return A ggplot object.
#' @export

plt.diversity <- function(rst, biodiv_ind){

  if (biodiv_ind == "specn"){
    biodiv_ind <- "Species Number"
    bar_lims <- c(20,40)
  }
  if (biodiv_ind == "simpson"){
    biodiv_ind <- "Simpson Index"
    bar_lims <- c(0,1)
  }
  if (biodiv_ind == "shannon"){
    biodiv_ind <- "Shannon Index"
    bar_lims <- c(0.5, 4)
  }

  gg <- ggplot2::ggplot()+
    tidyterra::geom_spatraster(data = rst)+
    ggplot2::scale_fill_gradientn(name = biodiv_ind, colours = rev(RColorBrewer::brewer.pal(9, 'Spectral')), na.value = 'white', limits = bar_lims)+
    ggplot2::theme(panel.grid.major = element_line(color = gray(.5), linetype = "dashed",
                                          linewidth = 0.5),
          panel.ontop = T,
          panel.background = element_rect(fill = NA),
          strip.background = element_rect(fill = "white"),
          legend.position = "bottom", legend.key.width = unit(0.5, "inches"), legend.key.height = unit(0.07, "inches"))+ #change scalebar length+
    ggplot2::xlab("Longitude")+
    ggplot2::ylab("Latitude")+
    #geom_sf(data = div.sf, aes(color = "magenta", size = specn))+
    ggplot2::ggtitle("Prediction Map of Alpha Diversity")+
    ggplot2::scale_y_continuous(breaks = seq(48,50, by = 0.01))+
    ggplot2::scale_x_continuous(breaks = seq(11, 12, by = 0.02))+
    #ggspatial::annotation_scale(location = 'bl')+ # falsche Distanz
    ggspatial::annotation_north_arrow(location = 'bl', height = unit(1, "cm"), width = unit(1,"cm"),
                           pad_x = unit(0.2, "cm"), pad_y = unit(0.7, "cm"), style = ggspatial::north_arrow_minimal())

  return(gg)
}
