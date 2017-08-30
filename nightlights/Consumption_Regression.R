rm(list=ls())
library(dplyr)
library(ggplot2)
library(GGally)
library(glmnet)
library(broom)

YEAR <- "2012"
FEATURES <- paste0("../data/output/PH", YEAR, "_features_zero.csv")

nightlights <- read.csv(FEATURES_Z)

# Plot for Nightlight vs. Consumption
ggplot(nightlights, aes(x = consumption, y = nl_mean)) + 
  geom_point(color='blue', alpha=0.4) + 
  geom_smooth(method='loess', color='black') +
  ggtitle(paste0("Consumption-based Wealth vs. Nightlight Intensity (Philippines ", YEAR,")")) + 
  xlab("Average Annual Expenditure (Pesos)") +
  ylab("Nightlight Intensity")

# Regression on Nightlight Intensity Features
linear_reg <- lm(consumption ~ nl_mean + nl_min + nl_max + nl_sd, 
                 data = nightlights)
summary(linear_reg)

df <- augment(linear_reg)
ggplot(df, aes(x = consumption, y = .fitted)) + 
  geom_point(color='purple', alpha=0.4) + 
  geom_abline() +
  ggtitle(paste0("Nightlight Intensity (Philippines ", YEAR,"); Adj R2 = ", signif(summary(linear_reg)$adj.r.squared, 4))) + 
  xlab("Observed Expenditure") +
  ylab("Predicted Expenditure")

ggplot(df, aes(x = .fitted, y = .resid)) + 
  geom_point(color='red', alpha=0.4) + 
  xlab("Fitted Average Expenditure") +
  ylab("Linear Regression Residuals") +
  ggtitle(paste0("Nightlights Regression Residuals (Philippines ",YEAR ,")"))
