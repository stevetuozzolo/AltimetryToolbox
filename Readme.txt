%% This is the Readme for ProcessVirtualStations as of 8/2015, authored
by Stephen Tuozzolo.

--- Background ------------------------------------------------------------

The toolbox functions as a data-processing tool for the MEASURES project. It takes raw altimetric height data extracted by the GDR and runs it through a filter before storing it in a NETCDF file.


--- ProcessVirtualStations.m ----------------------------------------------

This is the main program. It takes a river and satellite (or multiple rivers and satellites), finds the raw data files, processes them, and outputs them as NETCDF files.

Input arguments are RunRiv (must be a cell, can be one or multiple rivers) and Satellite (currently set to Jason2 & Envisat data)

 ... Things to note .......................................................
 
1. The option to use the IceFilter is currently hardwired. The IceFilter currently only turns on for the Mackenzie and Yukon Rivers.
2. The code is currently set up to run multiple rivers and virtual stations at one time. this can be changed by removing the two highest-level loops and with some other slight alterations. the other option is to set RunRiv to your preferred river, and change the indices that jsat runs through (jsat=1 is Jason2, jsat=2 is Envisat)

--- Functions -------------------------------------------------------------

1. ReadPotentialVirtualStations.m : reads in shapefile data for each virtual station. Stores in VS struct
2. GetAltimetry.m : takes the Virtual Station name and finds the appropriate raw data file in the directory. Stores altimetry data in VS(i).AltDat struct, where i=1:n is the list of virtual stations on a given river
Also stores DEM data for each virtual station for filtering/analysis purposes.
3. CreateFilterData.m : creates height filter boundaries for each virtual station, based on DEM data provided from GetAltimetry.m. The heirarchy for DEM is as follows: 1. SRTM, 2. GMTED, 3. ASTER/NONE (more needs to be done to understand best option for #3). For each VS, we have a AbsHeight (DEM height), MaxHeight (DEM height + +15m), MinHeight (DEM height -10m). All are stored in the FilterData structure.
4. ReadIceFile.m : reads in IceFile, if DoIce is switched on. the IceFile should be of the form "icebreak_rivername.xlsx" and should include years 2000-2015 (first column), ice breakup/thaw date (second column), ice freeze date (third column).
5. HeightFilter.m : takes one virtual station at a time and applies a height filter, marking returns that are within the range specified by FilterData and with 1 additional requirement (2m below 5th or 10th %tile). Also incorporates IceFilter.m Data can be plotted. Good height & ice (where applicable) data is marked as VS(i).AltDat.iGood; for only good height data, VS(i).AltDat.iGoodh.
6. IceFilter.m : takes data from IceData and marks which Altimetric returns occured during a frozen/non frozen time (operates within HeightFilter.m).
7. CalcAvgHeights.m : takes filtered data and creates pass-averaged height timeseries. Averaged heights are stored in VS(i).AltDat.hbar (unweighted heights) or VS(i).AltDat.hwbar (sig0 weighted heights). VS(i).AltDat.nNODATA gives the # of passes without viable height data.
8. WriteAltimetryData.m : takes all Virtual Station data (raw, filtered, averaged, and metadata) and stores in a NETCDF file with the standard Virtual Station naming scheme (RiverName_Jason2_#.nc).
9. genRivStats.m : optional, takes overall stats from each river to give an overview of the quality of the extracted data for each satellite/river.

--- Further Notes ---------------------------------------------------------

1. Not all rivers have Jason2 and Envisat Virtual Stations. This causes problems if attempting to run ProcessVirtualStations on an entire continent.
2. WriteAltimetryData only runs for Virtual Stations with >30% data coverage for passes.
3. There is no up-to-date functionality for comparing data with in-situ gauge data. USGSread and USGS_Compare both served that function but have not been updated for some time.
