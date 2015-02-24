%% flood height filter
%returns the indices of heights that are outside flood boundaries (DEM +
%maximum flood level
%
% by Steve T, Feb 2015
% rev Mike D, Feb 2015

function [Altimetry] = HeightFilter(Altimetry,FilterData,varargin)

if nargin>2
    DoPlots=varargin{1};
else
    DoPlots=false;
end

Altimetry.iGood=Altimetry.h <=FilterData.AbsHeight+FilterData.MaxFlood & Altimetry.h >= ...
    FilterData.AbsHeight-FilterData.MaxFlood; 

Altimetry.fFilter=sum(~Altimetry.iGood)/length(Altimetry.tAll);

if DoPlots
    figure;
    plot(Altimetry.tAll,Altimetry.h,'gsq');
    hold on;
    plot(Altimetry.tAll(Altimetry.iGood),Altimetry.h(Altimetry.iGood),'r.');
    datetick
    ylabel('elevation, m');
    legend('All','Filtered');
    title(FilterData.ID)
    hold off;
end

return