function [Altimetry,DEM] = GetAltimetry(VS,Ncyc)
    
%2.1) Read in height & sigma0 data
fname=[VS.ID '_20hz' ];
delimiterIn = {' ','  ','   ','    ','     '};
fid=fopen(fname);
if all(fgetl(fid)~= -1)
    datah = textscan(fid,'%f %f %f %f %f %f %f %f','headerlines',3,'CollectOutput',true,'Delimiter',delimiterIn);
    fclose(fid);
 datah=cell2mat(datah);
    Altimetry.c=datah(:,2);
    Altimetry.h=datah(:,3);
    
    tMJD=datah(:,4);
    
    Altimetry.sig0=datah(:,5);
    Altimetry.lon=datah(:,6);
    Altimetry.lat=datah(:,7);
    Altimetry.PK=datah(:,8);
    
    offdate =datenum(2000, 1, 1, 0, 0, 0) -51544; %from Chan email 3 Apr 2014
    Altimetry.tAll=tMJD+offdate;
    
    %2.2) Process heights cycle & time info
    [Altimetry.ci,i]=unique(Altimetry.c);
    Altimetry.t=Altimetry.tAll(i);
    
    Altimetry.cmax = Ncyc;
    Altimetry.call=1:Altimetry.cmax;
    Altimetry.GDRMissing=false(size(Altimetry.call)); %initiate
    


for i=1:length(Altimetry.call),
    if ~any(Altimetry.ci==Altimetry.call(i)),
        Altimetry.GDRMissing(i)=true;
    end
end

 %% read DEM data
    delimiter = {' ','  ','   '};
    endRow = 3;
    %  formatSpec='%*[#]%d%*f%*f';
    formatSpec = '%*s%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
    
    fid=fopen(fname);
    Altimetry.demDat=textscan(fid,formatSpec, endRow, 'Delimiter',delimiter, ...
        'EmptyValue',NaN,'ReturnOnError', false);
    fclose(fid);
    
else
    Altimetry.c=[];
    
end

DEM=Altimetry.demDat{1}';


return
