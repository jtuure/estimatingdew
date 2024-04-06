# estimatingdew
Empirical model for estimating dew from FMI meteorological data. The model is presented in Beysens, D., 2016. Estimating dew yield worldwide from a few meteo data. Atmospheric Research 167, 146–155. [https://doi.org/10.1016/j.atmosres.2015.07.018](https://doi.org/10.1016/j.atmosres.2015.07.018).


### Scripts (useful to run in this specific order)
- fmiWeatherdataloader.m - reads datafiles from downloaded FMI website and extracts necessary parameters and saves them as .mat workspace variables.
- interpolateData.m - Interpolates, re-times, etc. missing data scans over the studied time period.
- BeysensModel.m - This one runs the model presented by Beysens (2016), and filters out rain events and saves the output data (condensed dew amounts) as workspace variables .mat and also as .xlsx spreadsheet. 
- plotter.m - This one plots the modelled dew outputs.

### Functions
- convertToDoubleArray.m - converts an array from cell to double format
- dailyMin.m - extracts the smallest value per day in a timeseries for a given timestep
- dailySum.m - calculates the sum of e.g. daily dew accumulation from a timeseries
- dewBeysens.m - Function for dew model as presented by Beysens (2016)
- tdew.m - Function for calculating the dew point temperature

### Elevations used in the calculations (acquired from Google Earth)  
- Elevation of Kumpula 43 m.a.s.l
- Elevation of Hki-Vantaa 50 m.a.s.l
