%% flood height filter
%returns the indices of heights that are outside flood boundaries (DEM +
%maximum flood level
%
% by Steve T, Feb 2015
% rev Mike D, Mar 2015

function [Altimetry] = HeightFilter(Altimetry,FilterData,varargin)

if nargin>2
    DoPlots=varargin{1};
    if nargin>3,
        ShowBad=varargin{2};
    end
else
    DoPlots=false;
end

Altimetry.iGood=Altimetry.h <=FilterData.AbsHeight+FilterData.MaxFlood & Altimetry.h >= ...
    FilterData.AbsHeight-FilterData.MinFlood; 

Altimetry.fFilter=sum(~Altimetry.iGood)/length(Altimetry.tAll);

if DoPlots    
    figure;
    plot(Altimetry.tAll(Altimetry.iGood),Altimetry.h(Altimetry.iGood),'o');
    set(gca,'FontSize',14)
    if ShowBad,
        hold on;
        plot(Altimetry.tAll,Altimetry.h,'r.');            
        hold off;   
        legend('Filtered','All','Location','best');
    end
    datetick
    ylabel('elevation, m');    
    line1=['Station #' num2str(FilterData.ID)];
    fMiss=sum(Altimetry.GDRMissing)/length(Altimetry.GDRMissing);
    line2=[num2str(fMiss*100,'%.1f') '% missing from the GDR'];
    line3=[ num2str(Altimetry.fFilter*100,'%.1f') '% thrown out.' ];    
    title({line1,line2,line3})
    
end

return