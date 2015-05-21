%% Write USGS data to a net cdf
%written by Steve Tuozzolo 5/21/2015

function USGSwrite(USGS,ID)
fname='DataProduct/USGS.nc';
nt=length(USGS.time); %number of values in time group

ncid=netcdf.create(fname,'NETCDF4');

%% create group for actual data
odimid=netcdf.defDim(ncid,'time',nt);

vIDs.datum=netcdf.defVar(ncid,'datum','double',[]);
vIDs.rmse=netcdf.defVar(ncid,'rmse','double',[]);
vIDs.bias=netcdf.defVar(ncid,'bias','double',[]);
vIDs.SD=netcdf.defVar(ncid,'SD','double',[]);
vIDs.height=netcdf.defVar(ncid,'height','double',odimid);
vIDs.time=netcdf.defVar(ncid,'time','double',odimid);


netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'title',['Data for USGS'...
 USGS.name ' gauge compared with ' ID]);
netcdf.putAtt(ncid,vIDs.datum,'long_name','USGS gauge datum, m');
netcdf.putAtt(ncid,vIDs.rmse,'long_name','bias-adjusted rmse, m');
netcdf.putAtt(ncid,vIDs.bias,'long_name','bias between VS and gauge, m');
netcdf.putAtt(ncid,vIDs.SD,'long_name','SD, m');
netcdf.putAtt(ncid,vIDs.height,'long_name','USGS height above datum, m');
netcdf.putAtt(ncid,vIDs.time,'long_name','dyas since 0000-01-00 00:00:00');

netcdf.putVar(ncid,vIDs.datum,USGS.datum);
netcdf.putVar(ncid,vIDs.rmse,USGS.rmse);
netcdf.putVar(ncid,vIDs.bias,USGS.bias);
netcdf.putVar(ncid,vIDs.SD,USGS.SD);
netcdf.putVar(ncid,vIDs.height,USGS.height);
netcdf.putVar(ncid,vIDs.time,USGS.time);

netcdf.close(ncid);
