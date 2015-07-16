

clear all; close all
% uselib('altimetry')
datapath='C:\Users\Tuozzolo.1\Documents\MATLAB\measures\Process_Data\Columbia_Jason2';
library='C:\Users\Tuozzolo.1\Documents\MATLAB\measures\Process_Data\Altimetry_Toolbox_GitHub\Altimetry_Toolbox';
addpath(genpath(datapath))%this is the path to the raw data (GDR outputs + shapefiles + misc data)
addpath(genpath(library)) %this is the path to the altimetry toolbox
rivername='Columbia'; satellite='Jason2'; stations=0; DoIce=false;
%set river name, satellite name, # of stations to read (if 0, it reads
%all), whether or not to filter according to ice.
%%
[VS, Ncyc,S] = ReadPotentialVirtualStations(rivername,satellite); %get VS data from shapefile
if stations==0; stations=length(VS); end %run all stations unless otherwise specified
%%
DEM=zeros(stations,3);
for i=1:stations
    [VS(i).AltDat, DEM(VS(i).Id+1,:)]= GetAltimetry(VS(i),Ncyc); %get all raw data, place in VS structure
end

figure; plot(DEM(:,3),'b--'); hold on;  plot(DEM(:,1),'r-'); %show DEM data with virtual stations
%%
for i=1:stations
    FilterData(i).ID=VS(i).Id;
    if DEM(1,i)>0
        FilterData(i).AbsHeight=DEM(1,VS(i).Id+1);
    else if DEM(3,i)>0
            FilterData(i).AbsHeight=DEM(3,VS(i).Id+1);
        else if DEM(2,i)>0
                FilterData(i).AbsHeight=0;%DEM(VS(i).Id+1,2);
            else
                FilterData(i).AbsHeight=0;
            end
        end
    end
    FilterData(i).MaxFlood=15;
    FilterData(i).MinFlood=10;
end
%%
if DoIce
    icefile = 'icebreak_pilot';
    IceData = ReadIceFile(icefile); %read in ice file for freeze/thaw dates
else
    IceData=[];
end
%%
DoPlotsFilt=true; ShowBad=true; DoPlotsIce=false; DoPlotsAvg=true;
for i=1:stations,
    [VS(i).AltDat] = HeightFilter(VS(i).AltDat,FilterData(i),IceData,DoIce,VS(i).ID,DoPlotsFilt,ShowBad);
    VS(i).AltDat = CalcAvgHeights(VS(i).AltDat,VS(i).ID,DoPlotsAvg);
    %WriteAltimetryData(VS(i),FilterData(i),IceData);
end


figure;
for i=1:stations
    scatter(VS(i).AltDat.lon,VS(i).AltDat.lat,10,VS(i).AltDat.sig0); hold on; plot(S(i).X+360,S(i).Y,'g');
end


% sta=6;
% USGS=USGS_Compare(VS(sta).ID,VS(sta).AltDat,USGS);
% USGSwrite(USGS,VS(sta).ID);
% 
% 
% ncdisp('DataProduct/yukon_J2_0.nc') %example
% ncdisp('USGS.nc'); %other example
