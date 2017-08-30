rm(list=ls())
library(magrittr)
library(foreign)
library(plyr)
library(raster)
extract <- raster::extract

CLUSTER_DATA <- "../data/output/PH2008_clusters.csv"
NIGHTLIGHTS <- "../data/input/F162008.v4b_web.stable_lights.avg_vis.tif"
OUT_FEATURES <- "../data/output/PH2008_features.csv"

# -------------------------------

get_coords <- function(df){
  df_subset <- subset(df, is.na(lat)==F & is.na(lon)==F & lat !=0 & lon != 0)
  df_subset <- unique(df_subset[,c('lat', 'lon')])
  return(df_subset)
}

get_corners <- function(lat, lon){
  lat.range <- sort(c(lat - (180/pi)*(5000/6378137), lat + (180/pi)*(5000/6378137)))
  lon.range <- sort(c(lon - (180/pi)*(5000/6378137)/cos(lat), lon + (180/pi)*(5000/6378137)/cos(lat)))
  return(c(lon.range, lat.range))
}

gen_features <- function(coords, nl.file){
  nl.raster <- raster(nl.file)
  shape <- extent(c(range(c(coords$lon-0.5, coords$lon+0.5)),
                    range(c(coords$lat-0.5, coords$lat+0.5))))
  nl.cropped <- crop(nl.raster, shape)
  for (i in 1:nrow(coords)){
    corners <- get_corners(coords$lat[i], coords$lon[i])
    nl.vals <- unlist(extract(nl.cropped, extent(corners)))
    nl.vals[nl.vals==255] <- NULL
    coords$nl_mean[i] <- mean(nl.vals, na.rm = T)
    coords$nl_min[i] <- min(nl.vals, na.rm = T)
    coords$nl_max[i] <- max(nl.vals, na.rm = T)
    coords$nl_median[i] <- median(nl.vals, na.rm = T)
    coords$nl_sd[i] <- sd(nl.vals, na.rm = T)
  }
  return(coords)
}

ph.clusters <- read.csv(CLUSTER_DATA)
features <- get_coords(ph.clusters) %>% gen_features(NIGHTLIGHTS) %>% 
                      merge(ph.clusters, by = c('lat', 'lon'))
write.csv(features, file = OUT_FEATURES, row.names=FALSE)
