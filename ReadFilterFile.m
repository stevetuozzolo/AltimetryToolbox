function [FilterData] = ReadFilterFile(fname)

f =load(fname); %VS #, Avg DEM, est. max flood (m)

for i=1:size(f,1),    
    FilterData(i).ID=f(i,1); %dem average elevation in the polygon
    FilterData(i).AbsHeight=f(i,2); %threshold of above dem level for all points
    FilterData(i).MaxFlood=f(i,3); %
    FilterData(i).MinFlood=f(i,4); %
end

return