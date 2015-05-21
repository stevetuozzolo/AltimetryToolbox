%%read USGS data from pilot station file (this is less versatile than the previous code used but USGS has a way of making the downloadable format a little tricky to deal with so I'm using this for now.
%written by Steve Tuozzolo 5/2015

function [USGS] = USGSread(filename);
fileid=fopen(filename);
format='%*s %*u32 %s %s %*s %f %*s %*s';
g=textscan(fileid,format);
time=(datenum(g{1}(:))+datenum(g{2}(:))-datenum('01-Jan-2015'));
USGS.time=time(1:length(g{3}));
USGS.height=g{3}/3.28084;
USGS.name=filename;
USGS.datum=20/3.28084;
return
