library(dplyr)
library(ggplot2)
library(GGally)
library(glmnet)
library(broom)

FEATURES <- "../data/output/PH2003_features.csv"
nightlights <- read.csv(FEATURES)
nightlights$wealthscore <- nightlights$wealthscore/10000

# Plot for Nightlight vs. Wealth Score
ggplot(nightlights, aes(x = wealthscore, y = nl_mean)) + 
  geom_point(color='blue', alpha=0.4) + 
  geom_smooth(method='loess', color='black') +
  ggtitle("Wealth Score vs. Nightlight Intensity per Cluster (Philippines 2008)") + 
  xlab("Wealth Index Factor Score") +
  ylab("Nightlight Intensity")

# Regression on Nightlight Intensity Features
linear_reg <- lm(wealthscore ~ nl_mean + nl_max + nl_sd, 
           data = nightlights)
summary(linear_reg)

df <- augment(linear_reg)
ggplot(df, aes(x = wealthscore, y = .fitted)) + 
  geom_point(color='purple', alpha=0.4) + 
  geom_abline() +
  ggtitle(paste("Nightlight Intensity (Philippines 2003); Adj R2 = ", signif(summary(linear_reg)$adj.r.squared, 4))) + 
  xlab("Observed Wealth Index Factor Score") +
  ylab("Predicted Wealth Index Factor Score")

ggplot(df, aes(x = .fitted, y = .resid)) + 
  geom_point(color='red', alpha=0.4) + 
  xlab("Fitted Wealth Index Factor Score") +
  ylab("Linear Regression Residuals") +
  ggtitle("Nightlights Regression Residuals (Philippines 2003)")
