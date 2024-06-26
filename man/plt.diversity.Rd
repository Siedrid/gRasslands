% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plt.diversity.R
\name{plt.diversity}
\alias{plt.diversity}
\title{Plot Alpha Diversity Prediction Maps}
\usage{
plt.diversity(rst, biodiv_ind)
}
\arguments{
\item{rst}{spatial raster (terra) with the masked species richness in grasslands.}

\item{biodiv_ind}{Alpha diversity indice which was predicted in rst.}
}
\value{
A ggplot object.
}
\description{
\code{plt.diversity} returns a ggplot Prediction Map of the Alpha Diversity
}
