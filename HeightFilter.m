%% flood height filter
%returns the indices of heights that are outside flood boundaries (DEM +
%maximum flood level
%
% by Steve T, Feb 2015
% rev Mike D, Mar 2015
% rev Steve T, May 2015

function [Altimetry] = HeightFilter(Altimetry,FilterData,IceData,DoIce,varargin)

if nargin>2
    DoPlots=varargin{1};
    if nargin>3,
        ShowBad=varargin{2};
    end
else
    DoPlots=false;
end

Altimetry.iGoodH=Altimetry.h <=FilterData.AbsHeight+FilterData.MaxFlood & Altimetry.h >= ...
    FilterData.AbsHeight-FilterData.MinFlood; 


iH2=Altimetry.h>=prctile(Altimetry.h(Altimetry.iGoodH),5)-2; %filter relative to baseflow (>-2m 5th %tile flow)
Altimetry.iGoodH=Altimetry.iGoodH&iH2; %combine height filters
Altimetry.fFilter=(sum(~Altimetry.iGoodH))/length(Altimetry.h); %determine fraction of retrieved data filtered out

Altimetry=IceFilter(Altimetry,IceData);

if DoIce,
    Altimetry.iGood=Altimetry.iGoodH&Altimetry.IceFlag;
else
    Altimetry.iGood=Altimetry.iGoodH;
end

Altimetry.iFilter=sum(~Altimetry.iGood)/length(Altimetry.h);

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
    ylim([FilterData.AbsHeight-25 FilterData.AbsHeight+25])
    datetick
    ylabel('elevation, m');
    line1=['Station #' num2str(FilterData.ID) 'new polygon'];
    fMiss=sum(Altimetry.GDRMissing)/length(Altimetry.GDRMissing);
    line2=[num2str(fMiss*100,'%.1f') '% missing from the GDR'];
    line3=[num2str(Altimetry.fFilter*100,'%.1f') '% thrown out by height filter.' ];
    line4=[num2str(Altimetry.iFilter*100,'%.1f') '% thrown out by height + ice filter.' ];
    title({line1,line2,line3,line4})
    
end

return
