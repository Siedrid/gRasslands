## code to prepare `div.df` dataset

library(readxl)
library(vegan)
library(gRasslands)

# update plot names
plot_names_2022 <- function(spec_df){
  plot_names <- c("Obernschreez_68_Nord", "Obernschreez_68_Süd", "Obernschreez_726_West", "Obernschreez_726_Ost","Obernschreez_734",
                  "Nördlicher_Deuterweg_1", "Nördlicher_Deuterweg_2","Nördlicher_Deuterweg_3","Nördlicher_Deuterweg_4","Nördlicher_Deuterweg_5","Nördlicher_Deuterweg_6",
                  "Südlich_Deuterweg_1","Südlich_Deuterweg_2","Südlich_Deuterweg_3","Südlich_Deuterweg_4",
                  "Südlich_Deuterweg_5","Südlich_Deuterweg_6","Südlich_Deuterweg_7",
                  "Südlich_Bauhof_1", "Südlich_Bauhof_2","Südlich_Bauhof_3","Südlich_Bauhof_4",
                  "Gubitzmoos_1", "Gubitzmoos_2",
                  "Deuter",
                  "Schobertsberg_1", "Schobertsberg_2","Schobertsberg_3","Schobertsberg_4","Schobertsberg_5")
  spec_df$plot_names <- plot_names
  return(spec_df)
}

get_diversity <- function(spec_path, yr){
  # Function for 2022 and 2023 Data (different formats are considered)

  file_type <- substr(spec_path, nchar(spec_path) - 3, nchar(spec_path))

  if (file_type == ".csv"){
    spec_2022 <- read.csv(spec_path, header = T, sep = ';')
    spec_2022 <- plot_names_2022(spec_2022)

    colnames(spec_2022)[3] <- "Total_cover"
    spec_cols <- grep('\\.', colnames(spec_2022))
    spec_2022[is.na(spec_2022)] <- 0

    shannon_div <- diversity(as.matrix(spec_2022[spec_cols]), index = "shannon")
    simpson_div <- diversity(as.matrix(spec_2022[spec_cols]), index = "simpson")
    spec <- specnumber(as.matrix(spec_2022[spec_cols]))

    div_df <- data.frame(plot_names = spec_2022$plot_names)
    div_df$shannon <- shannon_div
    div_df$simpson <- simpson_div
    div_df$specn <- spec
  }
  if (file_type == "xlsx"){
    plotIDs <- excel_sheets(spec_path)
    plotIDs <- plotIDs[-grep("Tabelle", plotIDs)] # in case there is still an empty table in the excel wb

    div_df <- data.frame(plot_names = plotIDs)
    shannon <- c()
    simpson <- c()
    n <- c()
    i = 1
    for (id in plotIDs){
      spec <- read_excel(path = spec_path, sheet = id) # sheet=
      colnames(spec) <- c("Species", "Cover")
      spec[grep("<1", spec$Cover),2] <- "0.5"

      spec$Cover <- as.numeric(spec$Cover)
      spec <- na.omit(spec)

      shannon[i] <- diversity(spec$Cover, index = "shannon")
      simpson[i] <- diversity(spec$Cover, index = "simpson")
      n[i] <- length(spec$Cover)
      i <- i + 1
    }
    div_df$shannon <- shannon
    div_df$simpson <- simpson
    div_df$specn <- n

    div_df$plot_names[grep("734", div_df$plot_names)] <- "734-1"
  }
  return(div_df)
}

path_2022 <- "E:/Grasslands_BioDiv/Data/Field_Data/Feldkampagne_2022/Artenliste_Hummelgau_Mai2022_transponiert.csv"
path_2023 <- "E:/Grasslands_BioDiv/Data/Field_Data/Vegetationskartierungen Hummelgau 2023.xlsx"

# combine Diversity indices from 2022 and 2023 into one dataframe
div_2022 <- get_diversity(path_2022, 2022)
div_2023 <- get_diversity(path_2023, 2023)

div_df <- rbind(div_2022, div_2023)

df <- readxl::read_excel(path = "E:/Grasslands_BioDiv/Data/Field_Data/SUSALPS_samplingData_BT-RB-FE_2022-2023.xlsx")
df_coords <- df[df$Quadrant == 'A' & df$Depth != "2-7", ]
center_coords <- df_coords[c('Plot', 'PlotCenter_x_coord', 'PlotCenter_y_coord')]
colnames(center_coords) <- c('plot_names', 'X', 'Y')
#center_coords$X <- sub(',', '.', center_coords$X) %>%  as.numeric()
center_coords$X <- as.numeric(center_coords$X)
center_coords$Y <- as.numeric(center_coords$Y)

div.df <- merge(div_df, center_coords, by="plot_names")
div.df <- na.omit(div.df)

write.csv(div.df, "data-raw/div.df.csv", row.names = F)
usethis::use_data(div.df, overwrite = TRUE, compress = "xz")
