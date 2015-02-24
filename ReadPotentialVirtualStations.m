function [VS] = ReadPotentialVirtualStations(fname)

[~,~,DataAndHeader]=xlsread(fname);

Nsta=size(DataAndHeader,1)-1; % first row is header
Ncol=size(DataAndHeader,2);
for i=1:Nsta,
    for j=1:Ncol,
        Data{i,j}=DataAndHeader{i+1,j};
    end
end

Nsta=length(Data);
for i=1:Nsta,
    VS(i).ID=Data{i,1};
    VS(i).Lat=Data{i,2};
    VS(i).Lon=Data{i,3};
    VS(i).Width=Data{i,4};
    VS(i).Pass=Data{i,5};    
%     VS.Exclude(i)=Data{i,6};
%     VS.MinLat(i)=Data{i,7};
%     VS.MaxLat(i)=Data{i,8};
%     VS.Gage{i}=Data{i,9};
%     VS.Offset(i)=Data{i,10};
end