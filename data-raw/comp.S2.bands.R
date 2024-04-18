# Calculate monthly S-2 band reflectance composites

# define extent of prediction map!
# create an extent file from study region
study_area <- get_study_area(div.df, "X", "Y")


comp.S2.bands <- function(yrs, ms, comp.stat, study_area, satpath, comp_path){
  # comp_path rauslassen? einfach ins current directory speichern
  bands <- c("B2", "B3", "B4", "B5", "B6", "B7", "B8", "B8A", "B11", "B12")
  for (y_str in yrs){
    for (m in ms){
      m_str <- sprintf("%02d", m)
      if (file.exists(paste0(comp_path,"S2-", comp.stat, "Comp-", y_str, "_", m_str, ".tif"))){
        message(paste0("File ","S2-", comp.stat, "Comp-", y_str, "_", m_str, ".tif", " already exists"))
      }else{
        acquisitions <- get_acquisitions(y_str, m_str, satpath)
        b = 1
        band_lst <- list()
        for (band in bands){
          message(paste("Processing band", band))
          monthly_band_stack <- list()
          for (i in 1:length(acquisitions)){
            acq <- acquisitions[i]
            mask_path <- get_masks(acq)
            date <- acq_date(acq)
            message(paste("Processing date", date))

            if (band %in% c("B2", "B3", "B4", "B8")){
              m <- load_mask(10, mask_path, study_area)
              b2 <- load_band(band, acq, m, study_area)
              b2.crp <- terra::crop(b2.crp, ext)
              bd <- b2
            }else{
              m <- load_mask(20, mask_path, study_area)
              b11 <- load_band(band, acq, m, study_area)
              b11.crp <- terra::crop(b11, ext)
              b.resampled <- terra::resample(b11.crp, b2, method = 'bilinear')
              bd <- b.resampled
            }
            monthly_band_stack[[i]] <- bd
          }
          # maximize stack
          message("Calculate Maximum Band Composite")
          max.bd.st <- terra::rast(monthly_band_stack) %>% comp_fct(., comp.stat)
          # add to list of maximum stacks
          band_lst[[b]] <- max.bd.st

          b <- b+1
          gc()
        }
        # write to hard drive
        message("Write...")
        monthly_stack <- terra::rast(band_lst)
        terra::names(monthly_stack) <- bands
        terra::writeRaster(monthly_stack, paste0(comp_path,"S2-", comp.stat, "Comp-", y_str, "_", m_str, ".tif"), overwrite = F)
        gc()
      }
    }
  }
}

comp.S2.bands(yrs = c("2022", "2023"), ms = c(3:9), comp.stat = "min", study_area = study_area, comp_path = "E:/Grasslands_BioDiv/Data/S2_min_composites")

