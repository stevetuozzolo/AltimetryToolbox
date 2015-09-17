function [VS,Ncyc,S,stations] = ReadPotentialVirtualStations(fname,satellite,stations)
fname=[fname '_' satellite];

if satellite(1)=='E'
filecheck=fopen([fname '_0_18hz']);
else
    filecheck=fopen([fname '_0_20hz']);
end
if filecheck==-1
    VS=[];
    Ncyc=[];
    S=[];
else
    S=shaperead(fname);
    
    for i=1:length(S)
        VS(i).ID=S(i).Station_ID;
        VS(i).Lat=nanmean(S(i).Y);
        VS(i).Lon=nanmean(S(i).X);
        VS(i).Width=S(i).RivWidth;
        VS(i).Pass=S(i).Pass_Num;
        ID=strsplit(VS(i).ID,'_');
        VS(i).Id=str2num(cell2mat(ID(3)));
        VS(i).LSID=S(i).Landsat_ID;
        VS(i).Satellite=satellite;
        VS(i).X=S(i).X;
        VS(i).Y=S(i).Y;
        if satellite(1)=='E'
            Ncyc=94;
            VS(i).Rate=18; %Hz
            
        else if satellite(1)=='J'
                Ncyc=250;
                VS(i).Rate=20; %Hz
            end
        end
    end
end
if stations==0;
    stations=1:length(VS);
end %run all stations unless otherwise specified
end