%% Determine whether to use the IceFilter
% Written by S. Tuozzolo, 8/2014
% This can be updated in the future with more rivers... and maybe a better
% way for checking about ice. A latitude check?

function [DoIce,icefile] = IceCheck(rivername);
        if strcmp(rivername,'Yukon') || strcmp(rivername,'Mackenzie')
            DoIce=true;
        else
            DoIce=false;
        end
        icefile = ['icebreak_' rivername];
end