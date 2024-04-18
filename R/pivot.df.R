#' Pivots data frame to wide table format needed for Random Forest.
#'
#' `pivot.df` pivots the monthly S-2 data frame.
#'
#' @param df dataframe (interpolated) with the monthly plot reflectance.
#' @param days_since_cut predictor days_since_cut to be included (T/F)
#'
#' @return A data frame of monthly S-2 reflectances.
#'
#' @export

pivot.df <- function(df, days_since_cut = F){
  df <- dplyr::ungroup(df)
  if (days_since_cut){
    max_df_piv <- df  %>%
      dplyr::mutate(variable = month) %>%
      dplyr::select(-month) %>%
      tidyr::pivot_wider(names_from = variable, values_from = c(B11,B12,B2,B3,B4,B5,B6,B7,B8, B8A, days_since))
  }else{
    max_df_piv <- df %>%
      dplyr::mutate(variable = month) %>%
      dplyr::select(-month) %>%
      tidyr::pivot_wider(names_from = variable, values_from = c(B11,B12,B2,B3,B4,B5,B6,B7,B8, B8A))
  }
  return(max_df_piv)
}
