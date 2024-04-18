## code to prepare `refl.df` dataset
setwd("E:/Grasslands_BioDiv/Data/")

library(readxl)
library(openxlsx)
library(vegan)
library(sf)
library(ggplot2)
library(terra)
library(stringr)
library(dplyr)
library(gRasslands)


# Workflow
satpath <- "SatData/"
wb_path <- "S2_Reflectances/reflectances_plot_center-v1.xlsx"
bands <- c("B2", "B3", "B4", "B5", "B6", "B7", "B8", "B8A", "B11", "B12")

df <- read_excel(path = "Field_Data/SUSALPS_samplingData_BT-RB-FE_2022-2023.xlsx")
df_coords <- df[df$Quadrant == 'A' & df$Depth != "2-7", ]
center_coords <- df_coords[c('Plot', 'PlotCenter_x_coord', 'PlotCenter_y_coord')]
colnames(center_coords) <- c('plot_names', 'X', 'Y')

study_area <- get_study_area(center_coords, 'X', 'Y')

for (y_str in c("2022", "2023")){
  for (m in c(1:12)){
    m_str <- sprintf("%02d", m)

    acquisitions <- get_acquisitions(y_str, m_str, satpath)
    for (i in 1:length(acquisitions)){

      df <- data.frame(matrix(nrow = nrow(center_coords), ncol = 12))
      colnames(df) <- c("plot_names", "Date", bands)

      df$plot_names <- center_coords$Plot
      acq <- acquisitions[i]
      mask_path <- get_masks(acq)
      date <- as.Date(str_split(str_split(acq, '_')[[1]][3], '-')[[1]][1], "%Y%m%d")
      message(paste("Processing date", date))
      df$Date <- rep(date,nrow(center_coords))

      for (band in bands){
        if (band %in% c("B2", "B3", "B4", "B8")){
          m <- load_mask(10, mask_path)
        }else{
          m <- load_mask(20, mask_path)
        }

        assign(band, load_band(band, acq, m))
        # vals <- crop_band2plots(get(band), plot_shp)
        vals <- extract(get(band), center_coords[,2:3])[,2]
        df[band] <- vals
        # remove get(band)
      }
      to_wb(wb_path, date, df)
    }
  }
}

refl.df <- wb_to_df(wb_path)
write.csv(refl.df, "data-raw/refl.df.csv", row.names = F) #run
usethis::use_data(refl.df, overwrite = TRUE, compress = 'xz')
