rm(list=ls())
library(magrittr)
library(foreign)
library(plyr)
library(raster)
library(rgdal)
library(rgeos)

# Helper Functions
get.PH.raster <- function(file){
  ph_bounds <- create.spPolygon(file)
  return(crop(nl.raster, ph_bounds))
}

list.wrapper <- function(dir){
  return(list.files(dir, include.dirs = FALSE, full.names=TRUE))
}

polyFromFile <- function(file){
  poly.df <- read.table(file)
  poly.m <- data.matrix(poly.df, rownames.force = NA)
  return(poly.m)
}

create.spPolygon <- function(object){
  if (length(object) == 1) {
    poly <- polyFromFile(object)
  } else {
    poly <- lapply(object, polyFromFile)
  }
  return(spPolygons(poly))
}

get.nightlights <- function(shp){
  nl <- extract(PH.raster, shp) %>% unlist()
  return(nl)
}

read.shp <- function(file){
  shp <- readOGR(dsn = paste0(SHAPEFILE_DIR, file), layer = file)
  shp.t <- spTransform(shp, crs(nl.raster))
  return(shp.t)
}

# ------------------------------------------
# Once helper functions are loaded, 
# change the input and output data,
# then re-run script from here with:
# Cmd + Option + E
# ------------------------------------------

# Directories and Input/Output Data
POLYGON_DIR <- "../data/input/Polygons/"
SHAPEFILE_DIR <- "../data/input/Shapefiles/"
PH_BOUNDARY <- "../data/input/PH_boundary.txt"
NIGHTLIGHTS <- "../data/input/F162009.v4b_web.stable_lights.avg_vis.tif"
SHAPE_OUT <- "../data/output/ShapePerProvince_PH.RData"
OUTPUT_DATA <- "../data/output/PH2009_nightlights.RData"

# Global Variables
nl.raster <- raster(NIGHTLIGHTS)
PH.raster <- get.PH.raster(PH_BOUNDARY)

poly.dir.names <- list.dirs(POLYGON_DIR, recursive=FALSE, full.names=FALSE)
f <- list.files(POLYGON_DIR)
poly.files <- f[!f %in% poly.dir.names]

# Single Polygon
list.spatial1 <- lapply(poly.files, function(x){
                        return(paste0(POLYGON_DIR,x))
                      }) %>% 
                  lapply(create.spPolygon)

# Multi-Polygon
list.spatial2 <- list.dirs(POLYGON_DIR, recursive=FALSE) %>%
                  lapply(list.wrapper) %>%
                  lapply(create.spPolygon)

# Shapefiles
shp.dir.names <- list.dirs(SHAPEFILE_DIR, recursive=FALSE, full.names=FALSE)
list.shp <- lapply(shp.dir.names, read.shp)

poly.names <- lapply(poly.files, function(x){
                      return(substr(x, 1, nchar(x)-4))
                    })
place_names <- c(poly.names, poly.dir.names, shp.dir.names)
list.shp.complete <- c(list.spatial1, list.spatial2, list.shp)
PH_shapes <- mapply(c, place_names, list.shp.complete)
save(PH_shapes, file=SHAPE_OUT)

# To-do: Separate Major Cities from their Provinces

# Extract Nightlights data from Raster
list.nl <- lapply(list.shp.complete, get.nightlights)
nl.data <- mapply(c, place_names, list.nl)

save(nl.data, file=OUTPUT_DATA)
