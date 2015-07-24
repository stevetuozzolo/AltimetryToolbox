function [Altimetry,DEM,GDat] = GetAltimetry(VS,Ncyc)

%2.1) Read in height & sigma0 data
fname=[VS.ID '_' num2str(VS.Rate) 'hz'];
delimiterIn = {' ','  ','   ','    '};
fid=fopen(fname);
    GDat=-1;

if fid==-1
    Altimetry.c=[];
    DEM=0;
else if all(fgetl(fid)~= -1)
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        datah = textscan(fid,formatSpec,'headerlines',3,'CollectOutput',true,'Delimiter', '', 'WhiteSpace', '','ReturnOnError',false);
        fclose(fid);
        datah=datah{1};
       
        Altimetry.c=datah(:,1);
        Altimetry.h=datah(:,2);
        if length(Altimetry.h)>20
            GDat=VS.Id;
        end
        tMJD=datah(:,3);
        
        Altimetry.sig0=datah(:,4);
        Altimetry.lon=datah(:,5);
        Altimetry.lat=datah(:,6);
        Altimetry.PK=datah(:,7);
        
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
        DEM=Altimetry.demDat{1}';
    else
        GDat=-1;
        Altimetry.c=[];
    end
end
return
