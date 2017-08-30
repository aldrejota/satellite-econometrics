rm(list=ls())
library(dplyr)
library(broom)

NIGHTLIGHTS <- "../data/output/PH2009_nightlights.RData"
CONSUMPTION <- "../data/input/2009_FIES_clean.csv"
SHAPE_OUT <- "../data/output/ShapePerProvince_PH.RData"
OUT_DATA <- "../data/output/PH2009_features.csv"

# Load Data
load(NIGHTLIGHTS)
cons <- read.table(CONSUMPTION, sep=',', stringsAsFactors=FALSE)
names(cons) <- c("loc", "consumption")

# Helper Functions
get.features <- function(nl){
  df <- data.frame(loc=character(length(nl)), stringsAsFactors=FALSE)
  for (i in 1:length(nl)){
    df$loc[i] <- nl[[i]][1]
    nl.vals <- lapply(nl[[i]][(-1)], as.numeric) %>% unlist()
    nl.vals[nl.vals==255] <- NULL
    df$nl_mean[i] <- mean(nl.vals, na.rm = T)
    df$nl_min[i] <- min(nl.vals, na.rm = T)
    df$nl_max[i] <- max(nl.vals, na.rm = T)
    df$nl_sd[i] <- sd(nl.vals, na.rm = T)
  }
  return(df)
}

# Get Nightlight Features
nl.features <- get.features(nl.data)

nl.features <- merge(nl.features, cons, by='loc', all=FALSE)
nl.features$consumption <- as.numeric(gsub(",","",nl.features$consumption))

write.csv(nl.features, file=OUT_DATA, row.names=FALSE)