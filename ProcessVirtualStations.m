%% Process program for measures
clear all;
%% Create a list of rivers you want to run
NorthAmerica={'Columbia','Mackenzie','StLawrence','Susquehanna', 'Yukon','Mississippi'};
SouthAmerica={'Amazon','Tocantins','Orinoco','SaoFrancisco','Uruguay','Magdalena','Parana','Oiapoque','Essequibo','Courantyne'};
CurrRiv={'Courantyne'}; %if you want to do a single river, use this
Americas=[NorthAmerica SouthAmerica];
RunRiv=Americas; %you can switch this to CurrRiv if you only want to run one river.
Satellite={'Jason2','Envisat'};
for iriv=1:length(RunRiv)
    clearvars -except RunRiv Satellite iriv jsat J2 Env;
    for jsat=2:2
        %% uselib('altimetry')
        %set the datapath and input values for river data analysis
        datapath='C:\Users\Tuozzolo.1\Documents\MATLAB\measures\Process_Data';
        library='C:\Users\Tuozzolo.1\Documents\MATLAB\measures\Process_Data\Altimetry_Toolbox_GitHub\Altimetry_Toolbox';
        addpath(genpath(datapath))%this is the path to the raw data (GDR outputs + shapefiles + misc data)
        addpath(genpath(library)) %this is the path to the altimetry toolbox
        rivername=RunRiv{iriv}; satellite=Satellite{jsat}; stations=0;
        if strcmp(rivername,'Yukon') || strcmp(rivername,'Mackenzie')
            DoIce=true;
        else
            DoIce=false;
        end
        icefile = ['icebreak_' rivername];
        %set river name, satellite name, # of stations to read (if 0, it reads
        %all), whether or not to filter according to ice.
        %% Read in virtual station metadata & shapefiles
        [VS, Ncyc,S] = ReadPotentialVirtualStations(rivername,satellite); %get VS data from shapefile
        if stations==0; stations=1:length(VS); end %run all stations unless otherwise specified
        DEM=zeros(length(stations),3);
        for i=stations
            [VS(i).AltDat, DEM(VS(i).Id+1,:), Gdat(i)]= GetAltimetry(VS(i),Ncyc); %get all raw data, place in VS structure
        end
        stations=Gdat+1;
        stations(stations==0)=[];
        %% Create filter data using SRTM -> GMTED -> ASTER (?)
        for i=stations
            FilterData(i)=CreateFilterData(VS(i).Id,DEM);
        end
        %% Read the icefile for the relevant river with freeze/that dates for the years 2000-2015
        %all icefiles should be 'icebreak_rivername.xlsx'
        if DoIce
            IceData=ReadIceFile(icefile); %read in ice file for freeze/thaw dates
        else IceData=[];
        end
        %% Run through the data and analyze / store
        % Heightfilter includes the icefilter, which is automatically turned on/off
        % if the river is considered 'ice-covered'. Calc Avg Heights does a
        % pass-by-pass analysis of river heights and creates an average pass height
        % WriteAltimetrydData.m writes VS metadata, raw data, and filtered data to
        % a .nc file, one for each virtual station.
        DoPlotsFilt=false; ShowBad=true; DoPlotsIce=false; DoPlotsAvg=false; DoNetCDF=false;
        for i=stations,
            [VS(i).AltDat] = HeightFilter(VS(i).AltDat,S(i),FilterData(i),IceData,DoIce,VS(i).ID,DoPlotsFilt,ShowBad);
            VS(i).AltDat = CalcAvgHeights(VS(i).AltDat,VS(i).ID,DoPlotsAvg);
            if VS(i).AltDat.Write && DoNetCDF
                WriteAltimetryData(VS(i),FilterData(i),IceData);
            end
        end
        %% Generate overall statistics for river
        if jsat==1 %put in the jason 2 category
            J2(iriv)=genRivStats(VS,rivername,stations,iriv,RunRiv);
        else %put in the envisat category
            Env(iriv)=genRivStats(VS,rivername,stations,iriv,RunRiv);
        end
    end
end

totmat=zeros(1,2);
for i=1:length(RunRiv)
    figure;
    plot(J2(i).Width,J2(i).Val,'r*'); hold on;
    plot(Env(i).Width,Env(i).Val,'r*'); hold off;
    totmat=[totmat; J2(i).Width' J2(i).Val'; Env(i).Width' Env(i).Val'];
end
%hold off; figure; plot(totmat(:,1),totmat(:,2),'r.','MarkerSize',15); hold on
%xlabel('River width')
%title('Virtual Stations with >50% coverage vs. river width')
%ylabel('Fraction of passes with good data')
%    print('-dpng','-r400',['AmericasWidth'])

%%
  %  [J2mat,Envmat,j2prop,envprop]=doRivStats(J2,Env);