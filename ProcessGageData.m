function g = ProcessGageData(Experiment,site)

%1) Get USGS gage data for comparison (arranged from down to upstream)
i=find(strcmp(Experiment.Name,site));
GageName=Experiment.Gage{i};
hoff=Experiment.Offset(i);


%process to daily
g=load(['GageData/' GageName 'Gage.mat']);  

%units converion
g.hft=g.h;
g.h=g.hft.*.3048+hoff;

t0g=datevec(g.t(1));
t0gd=datenum(t0g(1),t0g(2),t0g(3),0,0,0);
tfg=datevec(g.t(end));
tfgd=datenum(tfg(1),tfg(2),tfg(3),0,0,0);

g.td=t0gd:tfgd +.5;
tgv=datevec(g.td);
tv=datevec(g.t);

for i=1:length(g.td),
    j=tv(:,1) == tgv(i,1) & tv(:,2) == tgv(i,2) & tv(:,3) == tgv(i,3);
    g.hd(i)=mean(g.h(j));
end


return