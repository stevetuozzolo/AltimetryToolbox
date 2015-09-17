function [RS]=genRivStats(VS,rivername,stations,iriv,CurrRegion)

for i=stations
tval(i)=VS(i).AltDat.nGood/length(VS(i).AltDat.ci); %number of good passes against total passes
rval(i)=VS(i).Width; %river width
rg(i)=max(VS(i).AltDat.AvgGradient); %DEM gradient
rdg(i)=max(VS(i).AltDat.RMSGradient); %DEM variance
if strcmp(rivername,'Yukon') || strcmp(rivername,'Mackenzie')
tval(i)=VS(i).AltDat.nGood/length(unique(VS(i).AltDat.c(logical(VS(i).AltDat.IceFlag)))); %modify good passes to account for ice
end
end

RS.Val=tval;
RS.ID=CurrRegion(iriv);
RS.GRAD=rg;
RS.dGRAD=rdg;
RS.Width=rval;

end