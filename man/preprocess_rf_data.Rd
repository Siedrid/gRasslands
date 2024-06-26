% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preprocess_rf_data.R
\name{preprocess_rf_data}
\alias{preprocess_rf_data}
\title{Preprocess Random Forest Input Data}
\usage{
preprocess_rf_data(refl_df, div_df, biodiv_index)
}
\arguments{
\item{refl_df}{data frame with the monthly Sentinel-2 reflectances at plot locations.}

\item{div_df}{data frame with the alpha diversity indices at plot locations, predictor variables.}

\item{biodiv_index}{alpha diversity indice which should be used to train and test, either specn (= Species Number),
shannon (= shannon index) or simpson (= simpson index)}
}
\value{
A data frame of the monthly Sentinel-2 Reflectances merged with the alpha diversity at plot locations. Ready to train the Random Forest.
}
\description{
\code{preprocess_rf_data} returns data frame ready for training and testing the random forest model
}
