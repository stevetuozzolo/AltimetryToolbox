%% This program creates the initial filter boundaries 
%Written 8/2015 by Steve Tuozzolo

function FilterData=CreateFilterData(VSid,DEM)
    FilterData.ID=VSid;
    DEM=DEM(FilterData.ID+1,:);
    if DEM(1)>0 %check for SRTM data
        FilterData.AbsHeight=DEM(1); %use SRTM data 1st
    else if DEM(3)>0 %check for GTOPO30/GMTED2010 data
            FilterData.AbsHeight=DEM(3); %use this data second
        else if DEM(2)>0 
                FilterData.AbsHeight=0;%DEM(VS(i).Id+1,2); %ASTER data is unused.             
            else
                FilterData.AbsHeight=0; % if all are NaN, assume height=sea level
            end
        end
    end
    FilterData.MaxFlood=FilterData.AbsHeight+15; %set upper bound of flood - 15m
    FilterData.MinFlood=FilterData.AbsHeight-10; %set lower bound of low flow - 10m
end