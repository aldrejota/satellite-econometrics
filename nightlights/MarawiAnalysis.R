rm(list=ls())
library(magrittr)
library(foreign)
library(plyr)
library(raster)
library(rgdal)
library(rgeos)
library(ggplot2)
library(RColorBrewer)

APRIL <- "../data/input/SVDNB_npp_20170401-20170430_75N060E_vcmcfg_v10_c201705011300.avg_rade9.tif"
MAY <- "../data/input/SVDNB_npp_20170501-20170531_75N060E_vcmcfg_v10_c201706021500.avg_rade9.tif"
JUNE <- "../data/input/SVDNB_npp_20170601-20170630_75N060E_vcmcfg_v10_c201707021700.avg_rade9.tif"
SHAPEFILE_DIR <- "../data/input/Marawi_Shapefile/"
OUT_DIR <- "../figures/"

# Change Month Here and Re-Run Script
MONTH <- "June"
nl.raster <- raster(JUNE)

shp <- readOGR(dsn = paste0(SHAPEFILE_DIR, "marawi_lanaodelsur"), layer = "marawi_lanaodelsur")

shp.map <- fortify(shp, region = "NAME_3")
a <- SpatialPoints(shp.map[c('long', 'lat')])
b <- extract(nl.raster, a)
max(b)
ggplot(shp.map, aes(x = long, y = lat, group = group, fill = b)) +
  geom_polygon(colour = "black", size = 0.2, aes(group = group)) +
  scale_fill_gradientn(colours= rev(brewer.pal(8, 'Greys')),na.value = "transparent",
                       # breaks=c(0,1,2,3,4),
                       limits=c(0,8)) +
  ggtitle(paste0("Marawi Nightlights (", MONTH," 2017)")) + 
  xlab("Longitude") +
  ylab("Latitude") + 
  labs(fill="attoW/cm2/sr") + 
  theme_bw()
quartz.save(paste0(OUT_DIR,"Marawi_",MONTH,".png"), type = "png")

# Change Analysis
nl.MAY <- raster(MAY)
nl.JUNE <- raster(JUNE)

a <- SpatialPoints(shp.map[c('long', 'lat')])
nl.may.marawi <- extract(nl.MAY, a)
nl.june.marawi <- extract(nl.JUNE, a)
nl.change <- nl.june.marawi - nl.may.marawi
max(nl.change)
ggplot(shp.map, aes(x = long, y = lat, group = group, fill = nl.change)) +
  geom_polygon(colour = "black", size = 0.2, aes(group = group)) +
  scale_fill_gradientn(colours= rev(brewer.pal(8, 'RdBu')),
                       na.value = "transparent",
                       breaks=c(-3,0,3),
                       labels=c("Decrease (-3)","No Change (0)","Increase (3)"),
                       limits=c(-3, 3)) +
  ggtitle(paste0("Marawi Change in Nightlights (May vs. June)")) + 
  xlab("Longitude") +
  ylab("Latitude") + 
  labs(fill="attoW/cm2/sr") + 
  theme_bw()

quartz.save(paste0(OUT_DIR,"Marawi_Change_MayVsJune.png"), type = "png")
