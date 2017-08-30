# Econometrics and National Development from Satellite Data

**Goal:** The objective of this study is to utilize accessible satellite data to create *proxy variables* for economic data that are usually time-consuming and costly to collect, especially in the Philippines. 

This will serve as a repository for various data products/projects and will regularly be updated as new proxy variables are gathered.

For questions and bug reports, please email *Aldre Jota* at aldrejota[at]gmail.com.

## Project 1: Nightlight Intensity for Consumption-based and Asset-based Wealth

* **Location:** ```./nightlights```
* **Programming Language:** R 3.3.2 (should work for newer versions)
* **Required Packages:** rgdal, rgeos, raster, magrittr, foreign, plyr, dplyr, ggplot2, GGally, broom

Regression of Nightlight Intensity Values in a given Cluster/Province/Municipality:

| Wealth   | Year        | Clusters  | Adjusted R2|
| ---------|:-------:| -----:|-----------:|
| Asset-based    | [2003](https://github.com/aldrejota/satellite-econometrics/blob/master/figures/nightlight_regression_2003.png) | 816 |	**0.5015** |
| Asset-based    | [2008](https://github.com/aldrejota/satellite-econometrics/blob/master/figures/nightlight_regression_2008.png) | 789| **0.5321** |
| Consumption | [2009](https://github.com/aldrejota/satellite-econometrics/blob/master/figures/nightlight_regression_2009.png) | 97| **0.7993** |
| Consumption | [2012](https://github.com/aldrejota/satellite-econometrics/blob/master/figures/nightlight_regression_2012.png) | 97 | **0.8758** |

Data Sources:

* Asset-based - Wealth Index Scores from USAID Demographic and Health Survey
* Consumption-based - Average Expenditure from Philippine Statistics Authority 

*Related:* Chen & Nordhaus, 2011, Using luminosity data as a proxy for
economic statistics [[Arxiv]](http://www.econ.yale.edu/~nordhaus/homepage/documents/CN_lumen_PNAS_2011.pdf)

### Instructions for Replication

1. Populate ```data/input/``` folder with the following:
	* Nightlights Data from [NGDC](https://ngdc.noaa.gov/eog/dmsp/downloadV4composites.html)
	* [USAID Demographic Health Surveys](http://dhsprogram.com/data/) on Philippines
	* [Philippine Statistics Authority](https://psa.gov.ph/tags/income-and-expenditure) data on Income and Expenditure
	* Shapefiles or Polygons of each cluster/province/municipality: [PhilGIS](philgis.org) or [OpenStreetMap](https://www.openstreetmap.org)
2. Run the scripts in the following order (💰 - Asset or Consumption):
	* 💰_ExtractData.R
	* 💰_FeatureGenerator.R
	* 💰_Visualization+Regression.R
3. Cross-check your output with the provided output data and figures.

---

## Project 2: TBA

