clear all; close all
% uselib('altimetry')
datapath='C:\Users\Tuozzolo.1\Documents\MATLAB\measures\Process_Data';
library='C:\Users\Tuozzolo.1\Documents\MATLAB\measures\Process_Data\Altimetry_Toolbox_GitHub\Altimetry_Toolbox';
addpath(genpath(datapath))%this is the path to the raw data (GDR outputs + shapefiles + misc data)
addpath(genpath(library)) %this is the path to the altimetry toolbox
rivername='Orinoco'; satellite='Envisat'; stations=0; DoIce=false;
%set river name, satellite name, # of stations to read (if 0, it reads
%all), whether or not to filter according to ice.
%%
[VS, Ncyc,S] = ReadPotentialVirtualStations(rivername,satellite); %get VS data from shapefile
if stations==0; stations=length(VS); end %run all stations unless otherwise specified
%%
DEM=zeros(stations,3);
for i=1:stations
    [VS(i).AltDat, DEM(VS(i).Id+1,:), Gdat(i)]= GetAltimetry(VS(i),Ncyc); %get all raw data, place in VS structure
end
stations=Gdat+1;
stations(stations==0)=[];


figure; plot(DEM(:,3),'b--'); hold on;  plot(DEM(:,1),'r-'); plot(DEM(:,2),'k*'); %show DEM data with virtual stations
%%
for i=stations
    FilterData(i).ID=VS(i).Id;
    if DEM(i,1)>0
        FilterData(i).AbsHeight=DEM(VS(i).Id+1,1);
    else if DEM(i,3)>0
            FilterData(i).AbsHeight=DEM(VS(i).Id+1,3);
        else if DEM(i,2)>0
                FilterData(i).AbsHeight=0;%DEM(VS(i).Id+1,2);
            else
                FilterData(i).AbsHeight=0;
            end
        end
    end
    FilterData(i).MaxFlood=150;
    FilterData(i).MinFlood=100;
end
%%
if DoIce
    icefile = 'icebreak_mackenzie';
    IceData = ReadIceFile(icefile); %read in ice file for freeze/thaw dates
else
    IceData=[];
end
%%
DoPlotsFilt=false; ShowBad=true; DoPlotsIce=false; DoPlotsAvg=true;
stations=23:29;
for i=stations,
    [VS(i).AltDat] = HeightFilter(VS(i).AltDat,FilterData(i),IceData,DoIce,VS(i).ID,DoPlotsFilt,ShowBad);
    VS(i).AltDat = CalcAvgHeights(VS(i).AltDat,VS(i).ID,DoPlotsAvg);
    if VS(i).AltDat.Write 
    %WriteAltimetryData(VS(i),FilterData(i),IceData);
    end
end




%%
for i=stations
    figure;
    subplot(2,1,1)
    scatter(VS(i).AltDat.lon-360,VS(i).AltDat.lat,10,VS(i).AltDat.sig0); hold on; plot(S(i).X,S(i).Y,'g');% hold off;
    subplot(2,1,2)
    plot(VS(i).AltDat.tAll,VS(i).AltDat.h); hold on;
    plot(VS(i).AltDat.tAll,FilterData(i).AbsHeight.*(ones(length(VS(i).AltDat.tAll),1)),'r--');
    pause;
end


% sta=6;
% USGS=USGS_Compare(VS(sta).ID,VS(sta).AltDat,USGS);
% USGSwrite(USGS,VS(sta).ID);
% 
% 
ncdisp(['DataProduct/' rivername '_' satellite '_0' '.nc']) %example
%ncdisp('USGS.nc'); %other example