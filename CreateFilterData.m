%% This program creates the initial filter boundaries
%Written 8/2015 by Steve Tuozzolo

function FilterData=CreateFilterData(VS,DEM,FilterData,stations)

for i=1:1:length(stations)
    DEMt=DEM(stations(i),:);
    FilterData(stations(i)).ID=VS(stations(i)).Id;
    if DEMt(1)>0 %check for SRTM data
        FilterData(stations(i)).AbsHeight=DEMt(1); %use SRTM data 1st
        FilterData(stations(i)).AvgGradient=VS(stations(i)).AltDat.AvgGradient(1);
    else if DEMt(3)>0 %check for GTOPO30/GMTED2010 data
            FilterData(stations(i)).AbsHeight=DEMt(3); %use this data second
            FilterData(stations(i)).AvgGradient=VS(stations(i)).AltDat.AvgGradient(2);
        else if DEMt(2)>0
                FilterData(stations(i)).AbsHeight=DEMt(2); %ASTER data used.
                FilterData(stations(i)).AvgGradient=VS(stations(i)).AltDat.AvgGradient(2);
            else
                if stations(i)>1
                    FilterData(stations(i)).AbsHeight=FilterData(stations(i)-1).AbsHeight; % if all are NaN, assume height=previous height
                else
                    FilterData(stations(i)).AbsHeight=0;
                end
                FilterData(stations(i)).AvgGradient=0;
            end
        end
    end
    
    if isempty(FilterData(stations(i)).AbsHeight)
        if ~isempty(FilterData(stations(i)).AbsHeight)
            FilterData(stations(i)).AbsHeight=FilterData(stations(i)-1).AbsHeight;
        else
            FilterData(stations(i)).AbsHeight=0;
        end
    end
    
    FilterData(stations(i)).MaxFlood=FilterData(stations(i)).AbsHeight+15; %set upper bound of flood - 15m
    FilterData(stations(i)).MinFlood=FilterData(stations(i)).AbsHeight-10; %set lower bound of low flow - 10m
end
end