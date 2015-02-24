clear all

%0) set info to use
site='M4';
exp='';

[~,~,Data]=xlsread('MississippiExperiment.xlsx','Sheet1','A2:D13');
Nexp=length(Data);
for i=1:Nexp,
    Experiment.Name{i}=Data{i,1};
    Experiment.Pass(i)=Data{i,2};
    Experiment.Gage{i}=Data{i,3};
    Experiment.Offset(i)=Data{i,4};
end

%1) Get USGS gage data for comparison (arranged from down to upstream)
i=find(strcmp(Experiment.Name,site));
GageName=Experiment.Gage{i};
hoff=Experiment.Offset(i);
pass=Experiment.Pass(i);

%process to daily
g=load([GageName 'Gage.mat']);  

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

%2) Process altimetry info

%2.1) Read in height data
fh=['data/' site '_20hz'];
datah=load(fh);
c=datah(:,1);
h=datah(:,2);
tMJD=datah(:,3);
sig0=datah(:,4);
lon=datah(:,5);
lat=datah(:,6);
offdate =datenum(2000, 1, 1, 0, 0, 0) -51544;
tAll=tMJD+offdate;

%2.2) Process heights cycle & time info
[ci,i]=unique(c);
t=tAll(i);

% %2.3) Read in backscatter data
% fs=[site 'sig0' exp];
% datas=load(fs);
% lon=datas(:,1);
% lat=datas(:,2);
% sig0=datas(:,3);
% c=datas(:,4);
    
%2.4) Calculate power-weighted average height, average height, for each pass
for j=1:length(ci),
    hc=h(c==ci(j));    
    hbar(j)=mean(hc);
    hstd(j)=std(hc);
    N(j)=sum(c==ci(j));
    
    sc=sig0(c==ci(j));
    
    hwbar(j)=sum(hc.*10.^(.1.*sc))./sum(10.^(.1.*sc));
    
    sig0Avg(j)=mean(sc);
end

%3) Plotting 
figure(1)
plot(tAll,h,'co',t,hbar,'r-',t,hwbar,'g-',g.td,g.hd,'b-','LineWidth',2)
datetick
set(gca,'FontSize',14)
ylabel('Elevation, m')

figure(2)
plot(tAll,h,'ro'); hold on;
errorbar(t,hbar,hstd); hold off;
datetick

Cmap=colormap;
sig0Interp=linspace(15,55,64);

figure(3)
for i=1:length(sig0),
    plot(lon(i)-360,lat(i),'s','Color',interp1(sig0Interp,Cmap,sig0(i),'linear',1));
    hold on;
end
hold off;

colorbar
set(gca,'CLim',[15 55])

figure(4)
hist(sig0)
title('Sigma 0 histogram')
xlabel('Sigma0')
ylabel('Count')

%one-to-one comparison
for i=1:length(hbar),
    [dt,j]=min(abs(t(i)-g.td));
    if dt<1,
        hgdComp(i)=g.hd(j);
    else
        hgdComp(i)=nan;
    end
end

%set up one-to-one line
igood=~isnan(hgdComp);

hmin=min([min(hgdComp(igood)) min(hwbar(igood))]);
hmax=max([max(hgdComp(igood)) max(hwbar(igood))]);

figure(5)
plot(hgdComp,hwbar,'o',[hmin hmax],[hmin hmax],'LineWidth',2)
xlabel('Gaged height, m')
ylabel('Altimeter height, m')
legend('20 Hz points','Average 20 Hz height','Power-weighted average 20 Hz height','Gage')

%4) Error stats
R=corrcoef(hgdComp(igood),hwbar(igood));

R0=corrcoef(hgdComp(igood),hbar(igood));

errH=hgdComp(igood)-hwbar(igood);
RMSE=sqrt(mean(errH.^2));
NSE=1-sum(errH.^2)/sum(  ( hgdComp(igood)-mean(hgdComp(igood)) ).^2  );

figure(6)
stem(N)

figure(7)
plot(h,sig0,'s')
xlabel('Elevation')
ylabel('sig0')

figure(8)
plot(t,sig0Avg,'o-')