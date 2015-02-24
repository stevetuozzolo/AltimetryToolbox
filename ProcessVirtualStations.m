%this version handles separate Excel sheet and shapefile. The next
%iteration should require that all data currently stored in the Excel sheet
%be added into the shapefile database.

clear all
% uselib('altimetry')
addpath '/Users/MTD/Library/Matlab/Altimetry/AltimetryToolbox'  %this is the path to the toolbox

VS = ReadPotentialVirtualStations('VirtualStations.xlsx');
S=shaperead('GIS/yukon crossings.shp');
FilterData = ReadFilterFile('yukonheights.txt');

%this part should eventually get included in the shapefile, and we'll do
%away with the excel file
for i=1:length(VS),
    VS(i).Satellite='Jason-2';
    VS(i).Rate=20; %Hz
    VS(i).X=S(i).X;
    VS(i).Y=S(i).Y;
end

% for i=1:length(VS),
for i=1:length(VS)-1,
    VS(i).AltDat = GetAltimetry(VS(i)); 
    VS(i).AltDat = HeightFilter(VS(i).AltDat,FilterData(i));
    VS(i).AltDat = CalcAvgHeights(VS(i).AltDat);
    WriteAltimetryData(VS(i),FilterData(i));
end

ncdisp('DataProduct/yukon_J2_0.nc') %example