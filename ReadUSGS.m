% [Q,t,h] = ReadUSGS(fname)
%
%  Q ~ cfs 
%  h ~ feet
%  t ~ Matlab datevec
%
%      v0   Written at UNC, originally to look at Sacramento River data, Summer 12
%      v1   Tweaked to allow for both height and discharge, June 13
%      v2   Tweaked to allow either Q only, or Q&h, July 13
%      
% Notes: 
%   Remember to add a "#" to the legend line starting "agency_cd"

function [Q,t,h] = ReadUSGS(fname)

fid=fopen(fname,'r');
n=0;

while ~feof(fid),
    fline=fgetl(fid); %comes in "tab-separated" files, fgetl automatically breaks up for me
    if strcmp(fline(1),'#') || strcmp(fline(1),'a'),
        continue
    elseif strcmp(fline(1),'5'),
        %reading header line... assume either there is only one numeric value
        %given... "5s" corresponds to the string length of the "agency
        %code", or if there is two numeric fields, the first is height, the
        %second is discharge
       
        data=regexp(fline,'\t','split');
        in=false(size(data));
        for i=1:length(in),
            in(i)=strcmp(data{i}(end),'n');
        end
        id=false(size(data));
        for i=1:length(id),
            id(i)=strcmp(data{i}(end),'d');
        end
        jQ=find(in);
        jD=find(id);
        if length(jQ)>2 || length(jD)>1,
            disp('Error! Unexpected header line in USGS file...')
            Q=nan; t=nan;
            return
        end            
    else
        n=n+1;
        data=regexp(fline,'\t','split');
        
        t(n)=datenum(data(jD));
        
        if length(jQ)==1,
            Q(n)=str2double(data(jQ(1)));
        elseif length(jQ)==2,
            h(n)=str2double(data(jQ(1)));
            Q(n)=str2double(data(jQ(2)));
        end
    end
end

fclose(fid);

% Correct for "future" dates, since Matlab assumes e.g. "28" == "2028"
% only comes into play if there are early dates
i=t>(datenum(date)+1);
v=datevec(t);
v(i,1)=v(i,1)-100;
t=datenum(v);

disp(['Finished with ' fname '.'])

return