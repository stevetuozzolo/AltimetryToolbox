function [VS] = ReadPotentialVirtualStations(fname)

S=shaperead(fname);

for i=1:length(S)
VS(i).ID=S(i).Station_ID;
Str=VS(i).ID;
VS(i).Id=sscanf(Str(14:end),'%g');
VS(i).Lat=nanmean(S(i).Y);
VS(i).Lon=nanmean(S(i).X);
VS(i).Width=S(i).RivWidth;
VS(i).Pass=S(i).Pass_Num;
end

end
