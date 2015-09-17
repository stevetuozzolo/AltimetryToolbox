%% Process program for measures
%Written by M. Durand
%Edited by S. Tuozzolo 9/2015 
%Requires raw data extracted from GDR, Rivernames & Satellite names, and
%ice data (optional). Options to create NetCDFs, plots of individual
%virtual stations, and overall statistics are available. See Readme.txt
%file for more information on script & associated functions.

clear all; close all; clc;
%% Create a list of rivers you want to run
NorthAmerica={'Columbia','Mackenzie','StLawrence','Susquehanna', 'Yukon','Mississippi'};
SouthAmerica={'Amazon','Tocantins','Orinoco','SaoFrancisco','Uruguay','Magdalena','Parana','Oiapoque','Essequibo','Courantyne'};
CurrRiv={'SaoFrancisco'}; %if you want to do a single river, use this
Americas=[NorthAmerica SouthAmerica];
RunRiv=Americas; %you can switch this to CurrRiv if you only want to run one river.
Satellite={'Jason2','Envisat'}; %either Envi or Jason2 or both, need a cell with 1 or more strings

for iriv=1:length(RunRiv)
    clearvars -except RunRiv Satellite iriv jsat J2 Env; %keep these on each loop. get rid of each river's data when moving to the next river
    for jsat=1:length(Satellite)
        %% uselib('altimetry')
        %set the datapath and input values for river data analysis
        datapath='C:\Users\Tuozzolo.1\Documents\MATLAB\measures\Process_Data';
        library='C:\Users\Tuozzolo.1\Documents\MATLAB\measures\Process_Data\Altimetry_Toolbox_GitHub\Altimetry_Toolbox';
        addpath(genpath(datapath))%this is the path to the raw data (GDR outputs + shapefiles + misc data)
        addpath(genpath(library)) %this is the path to the altimetry toolbox
        rivername=RunRiv{iriv}; satellite=Satellite{jsat}; stations=0; %set current river, satellite, and # of stations (0 is default)
        [DoIce,icefile]=IceCheck(rivername); %check rivername to see if ice
        %% Read in virtual station metadata & shapefiles
        [VS, Ncyc,S,stations] = ReadPotentialVirtualStations(rivername,satellite,stations); %get VS data from shapefile
        if size(VS,1)>0
            DEM=zeros(length(stations),3);
            for i=stations
                [VS(i).AltDat, DEM(VS(i).Id+1,:), Gdat(i)]= GetAltimetry(VS(i),Ncyc); %get all raw data, place in VS structure
            end
            stations=Gdat+1;
            stations(stations==0)=[]; %remove stations from list with bad data
            %% Create filter data using SRTM -> GMTED -> ASTER (?)
            FilterData=struct([]);
            FilterData=CreateFilterData(VS,DEM,FilterData,stations);
            %% Read the icefile for the relevant river with freeze/that dates for the years 2000-2015
            %all icefiles should be 'icebreak_rivername.xlsx'
            if DoIce
                IceData=ReadIceFile(icefile); %read in ice file for freeze/thaw dates
            else IceData=[];
            end
            %% Run through the data and analyze / store
            % HeightFilter.m runs IceFilter.m when necessary. CalcAvgHeights.m is creates an average pass height
            % WriteAltimetrydData.m writes VS metadata, raw data, and filtered data to a .nc file, one for each virtual station.
            DoPlotsFilt=false; ShowBad=true; DoPlotsIce=false; DoPlotsAvg=false; DoNetCDF=false;
            for i=stations,
                [VS(i).AltDat] = HeightFilter(VS(i).AltDat,S(i),FilterData(i),IceData,DoIce,VS(i).ID,DoPlotsFilt,ShowBad);
                VS(i).AltDat = CalcAvgHeights(VS(i).AltDat,VS(i).ID,DoPlotsAvg);
                if VS(i).AltDat.Write && DoNetCDF
                   WriteAltimetryData(VS(i),FilterData(i),IceData);
                end
            end
            %% Generate overall statistics for river
%             genRivStats(VS,rivername,stations,iriv,RunRiv)
%             if jsat==1 && size(VS,1)>0 %put in the jason 2 category
%                 J2(iriv)=genRivStats(VS,rivername,stations,iriv,RunRiv);
%             else if size(VS,1)>0 %put in the envisat category
%                     Env(iriv)=genRivStats(VS,rivername,stations,iriv,RunRiv);
%                 end
%             end
        end
    end
end
%% See how the bulk river data performs
%
%[totmat,j2prop,envprop]=DoMetaPlots(RunRiv,J2,Env);