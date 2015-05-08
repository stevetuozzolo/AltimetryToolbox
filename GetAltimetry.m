function Altimetry = GetAltimetry(VS,Ncyc)
    
%2.1) Read in height & sigma0 data
fname=[VS.ID '_20hz' ];
delimiterIn = ' ';
fid=fopen(fname);
datah = textscan(fid,'%f %f %f %f %f %f %f','headerlines',1,'CollectOutput',true);
fclose(fid);
datah=cell2mat(datah);
Altimetry.c=datah(:,1);
Altimetry.h=datah(:,2);

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

return
