function WriteAltimetryData(VS,Filter)

%level 2: these are the level 2 data from the platforms... not archived here
%level 3: these are the actual elevations being output by Chan's scripts,
%            on a footprint-by-footprint basis
%level 4: these are the timeseries of averaged products

fname=['DataProduct/' VS.ID '.nc'];

%% 1 extract dimensions from altimetry data
nt=length(VS.AltDat.t); %number of measurement times
ntAll=length(VS.AltDat.tAll); %total number of measurements

%% 2 definitions
ncid=netcdf.create(fname,'NETCDF4');      

%2.0 define groups
tGroupID=netcdf.defGrp(ncid,'Timeseries');
sGroupID=netcdf.defGrp(ncid,'Sampling');
l3GroupID=netcdf.defGrp(ncid,'Level3');
fGroupID=netcdf.defGrp(ncid,'Filter');

%2.1 define coordinate variables
vIDs.Lon=netcdf.defVar(ncid,'lon','NC_DOUBLE',[]);
vIDs.Lat=netcdf.defVar(ncid,'lat','NC_DOUBLE',[]);

%2.2 other root group items
%2.2.1 text string ids
iddimid = netcdf.defDim(ncid,'id',netcdf.getConstant('NC_UNLIMITED'));
satdimid = netcdf.defDim(ncid,'sat',netcdf.getConstant('NC_UNLIMITED'));

%2.2.2 define items
vIDs.ID=netcdf.defVar(ncid,'ID','NC_CHAR',iddimid);
vIDs.sat=netcdf.defVar(ncid,'sat','NC_CHAR',satdimid);
%vIDs.SRTMh=netcdf.defVar(ncid,'SRTMh','NC_DOUBLE',[]);
vIDs.rate=netcdf.defVar(ncid,'rate','NC_DOUBLE',[]);
vIDs.pass=netcdf.defVar(ncid,'pass','NC_INT',[]);

%2.3 sampling 
%2.3.1 dimensions
SceneDimId = netcdf.defDim(sGroupID,'scene',netcdf.getConstant('NC_UNLIMITED'));
cDimId = netcdf.defDim(sGroupID,'coordinates',5);
%2.3.2 definitions
vIDs.LandsatSceneID=netcdf.defVar(sGroupID,'scene','NC_CHAR',SceneDimId);
vIDs.SampX=netcdf.defVar(sGroupID,'lonbox','NC_DOUBLE',cDimId);
vIDs.SampY=netcdf.defVar(sGroupID,'latbox','NC_DOUBLE',cDimId);
vIDs.Island=netcdf.defVar(sGroupID,'island','NC_INT',[]);

%2.4 level 3
l3DimId = netcdf.defDim(l3GroupID,'l3',ntAll);
vIDs.L3Lon=netcdf.defVar(l3GroupID,'lon','NC_DOUBLE',l3DimId);
vIDs.L3Lat=netcdf.defVar(l3GroupID,'lat','NC_DOUBLE',l3DimId);
vIDs.L3h=netcdf.defVar(l3GroupID,'h','NC_DOUBLE',l3DimId);
vIDs.L3sig0=netcdf.defVar(l3GroupID,'sig0','NC_DOUBLE',l3DimId);
vIDs.L3pk=netcdf.defVar(l3GroupID,'pk','NC_DOUBLE',l3DimId);
vIDs.L3cyc=netcdf.defVar(l3GroupID,'cycle','NC_INT',l3DimId);
vIDs.L3t=netcdf.defVar(l3GroupID,'time','NC_DOUBLE',l3DimId);
vIDs.heightfilter=netcdf.defVar(l3GroupID,'heightfilter','NC_INT',l3DimId);
vIDs.icefilter=netcdf.defVar(l3GroupID,'icefilter','NC_INT',l3DimId);
vIDs.allfilter=netcdf.defVar(l3GroupID,'allfilter','NC_INT',l3DimId);


%2.5 timeseries 
tdimid = netcdf.defDim(tGroupID,'time',nt);
vIDs.time=netcdf.defVar(tGroupID,'time','NC_DOUBLE',tdimid);
vIDs.cycle=netcdf.defVar(tGroupID,'cycle','NC_INT',tdimid);
vIDs.hbar=netcdf.defVar(tGroupID,'hbar','NC_DOUBLE',tdimid);
vIDs.hwbar=netcdf.defVar(tGroupID,'hwbar','NC_DOUBLE',tdimid);
vIDs.sig0Avg=netcdf.defVar(tGroupID,'sig0bar','NC_DOUBLE',tdimid);
vIDs.pkAvg=netcdf.defVar(tGroupID,'pkbar','NC_DOUBLE',tdimid);


%2.6 filter
yDimId = netcdf.defDim(fGroupID,'years',8);
vIDs.nND=netcdf.defVar(fGroupID,'nNODATA','NC_INT',[]);
vIDs.riverh=netcdf.defVar(fGroupID,'riverh','NC_DOUBLE',[]);
vIDs.maxh=netcdf.defVar(fGroupID,'maxh','NC_DOUBLE',[]);
vIDs.minh=netcdf.defVar(fGroupID,'minh','NC_DOUBLE',[]);
vIDs.icethaw=netcdf.defVar(fGroupID,'icethaw','NC_DOUBLE',yDimId);
vIDs.icefreeze=netcdf.defVar(fGroupID,'icefreeze','NC_DOUBLE',yDimId);

%% 3  attributes
%3.1 global
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'title',['Altimetry Data for virtual station ' VS.ID]);

%3.2 root group
%3.2.1 coordinate units
netcdf.putAtt(ncid,vIDs.Lat,'units','degrees_north');
netcdf.putAtt(ncid,vIDs.Lon,'units','degrees_east');

%3.2.2 other root group
netcdf.putAtt(ncid,vIDs.sat,'long_name','satellite');
netcdf.putAtt(ncid,vIDs.rate,'units','Hz');
netcdf.putAtt(ncid,vIDs.rate,'long_name','sampling rate');
netcdf.putAtt(ncid,vIDs.pass,'long_name','pass number');

%3.3 sampling group
netcdf.putAtt(sGroupID,vIDs.LandsatSceneID,'long_name','Landsat Scene ID');
netcdf.putAtt(sGroupID,vIDs.SampX,'long_name','Longitude Box Extents');
netcdf.putAtt(sGroupID,vIDs.SampY,'long_name','Latitude Box Extents');
netcdf.putAtt(sGroupID,vIDs.SampX,'units','degrees_east');
netcdf.putAtt(sGroupID,vIDs.SampY,'units','degrees_north');
netcdf.putAtt(sGroupID,vIDs.Island,'long_name','Island Flag');

%3.4 level 3
netcdf.putAtt(l3GroupID,vIDs.L3Lon,'units','degrees_east');
netcdf.putAtt(l3GroupID,vIDs.L3Lat,'units','degrees_north');
netcdf.putAtt(l3GroupID,vIDs.L3h,'units','meters');
netcdf.putAtt(l3GroupID,vIDs.L3sig0,'units','dB');
netcdf.putAtt(l3GroupID,vIDs.L3pk,'units','unknown');
netcdf.putAtt(l3GroupID,vIDs.L3t,'units','days since 0000-01-00 00:00:00');
netcdf.putAtt(l3GroupID,vIDs.heightfilter,'units','0 filtered out, 1 included (logical)');
netcdf.putAtt(l3GroupID,vIDs.icefilter,'long_name','0 filtered out, 1 included (logical)');
netcdf.putAtt(l3GroupID,vIDs.allfilter,'long_name','0 filtered out, 1 included (logical)');

%3.5  timeseries 
%3.5.1 units
netcdf.putAtt(tGroupID,vIDs.time,'units','days since 0000-01-00 00:00:00');
netcdf.putAtt(tGroupID,vIDs.cycle,'units','-');
netcdf.putAtt(tGroupID,vIDs.hbar,'units','meters');
netcdf.putAtt(tGroupID,vIDs.hwbar,'units','meters');
netcdf.putAtt(tGroupID,vIDs.sig0Avg,'units','dB');
netcdf.putAtt(tGroupID,vIDs.pkAvg,'units','unknown');


%3.5.2 timeseries long names
netcdf.putAtt(tGroupID,vIDs.hbar,'long_name','Average Height');
netcdf.putAtt(tGroupID,vIDs.hwbar,'long_name','Weighted Average Height');
netcdf.putAtt(tGroupID,vIDs.sig0Avg,'long_name','Average Sigma0');
netcdf.putAtt(tGroupID,vIDs.pkAvg,'long_name','Peakiness');

%3.6 filter
netcdf.putAtt(fGroupID,vIDs.nND,'long_name','Number of Cycles without Data');
netcdf.putAtt(fGroupID,vIDs.riverh,'long_name','River elevation from filter file');
netcdf.putAtt(fGroupID,vIDs.maxh,'long_name','Maximum elevation allowed by filter');
netcdf.putAtt(fGroupID,vIDs.minh,'long_name','Minimum elevation allowed by filter');
netcdf.putAtt(fGroupID,vIDs.icethaw,'long_name','Thaw dates for river');
netcdf.putAtt(fGroupID,vIDs.icefreeze,'long_name','Freeze dates for river');

netcdf.endDef(ncid);


%% 4 variables
%4.1 root group
netcdf.putVar(ncid,vIDs.Lon,VS.Lon);
netcdf.putVar(ncid,vIDs.Lat,VS.Lat);
netcdf.putVar(ncid,vIDs.ID,0,length(VS.ID),VS.ID);
% netcdf.putVAR(ncid,vIDs.SRTMh, %to be completed...
netcdf.putVar(ncid,vIDs.sat,0,length(VS.Satellite),VS.Satellite);
netcdf.putVar(ncid,vIDs.rate,VS.Rate);
netcdf.putVar(ncid,vIDs.pass,VS.Pass);

%4.2 sampling
% netcdf.putVar(sGroupID,vIDs.LandsatSceneID %to be completed
netcdf.putVar(sGroupID,vIDs.SampX,VS.X(1:end-1));
netcdf.putVar(sGroupID,vIDs.SampY,VS.Y(1:end-1));
% netcdf.putVar(sGroupID,vIDs.Island %to be completed

%4.3 level 3
netcdf.putVar(l3GroupID,vIDs.L3Lon,VS.AltDat.lon);
netcdf.putVar(l3GroupID,vIDs.L3Lat,VS.AltDat.lat);
netcdf.putVar(l3GroupID,vIDs.L3h,VS.AltDat.h);
netcdf.putVar(l3GroupID,vIDs.L3sig0,VS.AltDat.sig0);
netcdf.putVar(l3GroupID,vIDs.L3pk,VS.AltDat.PK);
netcdf.putVar(l3GroupID,vIDs.L3cyc,VS.AltDat.c);
netcdf.putVar(l3GroupID,vIDs.L3t,VS.AltDat.tAll);
netcdf.putVar(l3GroupID,vIDs.heightfilter,VS.AltDat.iGoodH+0);
netcdf.putVar(l3GroupID,vIDs.icefilter,VS.AltDat.IceFlag+0);
netcdf.putVar(l3GroupID,vIDs.allfilter,VS.AltDat.iGood+0);

%4.4 timeseries 
netcdf.putVar(tGroupID,vIDs.time,VS.AltDat.t);
netcdf.putVar(tGroupID,vIDs.cycle,VS.AltDat.ci);
netcdf.putVar(tGroupID,vIDs.hbar,VS.AltDat.hbar);
netcdf.putVar(tGroupID,vIDs.hwbar,VS.AltDat.hwbar);
netcdf.putVar(tGroupID,vIDs.sig0Avg,VS.AltDat.sig0Avg);

%4.5 filter
netcdf.putVar(fGroupID,vIDs.nND,VS.AltDat.nNODATA);
netcdf.putVar(fGroupID,vIDs.riverh,Filter.AbsHeight);
netcdf.putVar(fGroupID,vIDs.maxh,Filter.AbsHeight+Filter.MaxFlood);
netcdf.putVar(fGroupID,vIDs.minh,Filter.AbsHeight-Filter.MinFlood);
netcdf.putVar(fGroupID,vIDs.icethaw,Ice(:,2));
netcdf.putVar(fGroupID,vIDs.icefreeze,Ice(:,3));


% close 
netcdf.close(ncid);

return
