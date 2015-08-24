function [RS]=genRivStats(VS,rivername,stations,iriv,CurrRegion)

for i=stations
tval(i)=VS(i).AltDat.nGood/length(VS(i).AltDat.ci);
rval(i)=VS(i).Width;
if strcmp(rivername,'Yukon') || strcmp(rivername,'Mackenzie')
tval(i)=VS(i).AltDat.nGood/length(unique(VS(i).AltDat.c(logical(VS(i).AltDat.IceFlag))));
end
end

RS.Val=tval;
RS.ID=CurrRegion(iriv);
RS.GRAD=VS(i).AltDat.AvgGradient;
RS.dGRAD=VS(i).AltDat.RMSGradient;
RS.Width=rval;

end