rm(list=ls())
library(plyr)
library(magrittr)
library(foreign)

HR.dataset.file <- "../data/input/PHHR52FL.DTA"
GPS.dataset.file <- "../data/input/PHGE52FL.dbf"
OUT_CLUSTERS <- "../data/output/PH2008_clusters.csv"

# -------------------------------

cluster <- function(df){
  for (i in 1:nrow(df)){
    sub <- subset(df, lat == df$lat[i] & lon == df$lon[i])
    df$n[i] <- nrow(sub)
  }
  df <- ddply(df, .(cluster, lat, lon), summarise,
              wealthscore = mean(wealthscore),
              n = mean(n))
  return(df)
}

# DHS Cluster Data
vars <- c(paste0('hv', c('001', 271)))
ph.wealth <- read.dta(HR.dataset.file, convert.factors = NA) %>% subset(select = vars)
names(ph.wealth) <- c('cluster', 'wealthscore')

# Cluster Coordinates
ph.coords <- read.dbf(GPS.dataset.file)[,c('DHSCLUST', 'LATNUM', 'LONGNUM')]
names(ph.coords) <- c('cluster', 'lat', 'lon')

ph.data <- merge(ph.wealth, ph.coords, by = 'cluster') %>% cluster()
write.csv(ph.data, file = OUT_CLUSTERS, row.names=FALSE)
