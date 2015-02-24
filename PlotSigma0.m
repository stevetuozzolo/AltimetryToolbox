function PlotSigma0(AltimeterData,fnum1,fnum2,fnum3,fnum4)

sig0Min=min(AltimeterData.sig0);
sig0Max=max(AltimeterData.sig0);

Cmap=colormap;
sig0Interp=linspace(sig0Min,sig0Max,64);

figure(fnum1)
for i=1:length(AltimeterData.sig0),
    plot(AltimeterData.lon(i)-360,AltimeterData.lat(i),'s',...
        'Color',interp1(sig0Interp,Cmap,AltimeterData.sig0(i),'linear',1));
    hold on;
end
hold off;
set(gca,'FontSize',14)
title('Map of sigma0')

colorbar
set(gca,'CLim',[sig0Min sig0Max])

figure(fnum2)
hist(AltimeterData.sig0)
set(gca,'FontSize',14)
title('Sigma 0 histogram')
xlabel('Sigma0')
ylabel('Count')

figure(fnum3)
plot(AltimeterData.h,AltimeterData.sig0,'s')
set(gca,'FontSize',14)
xlabel('Elevation')
ylabel('sig0')
title('Sigma0 vs Height scatterplot')

figure(fnum4)
plot(AltimeterData.t,AltimeterData.sig0Avg,'o-','LineWidth',2)
datetick
set(gca,'FontSize',14)
ylabel('sigma0 [dB]')
title('Sigma0 timeseries')

return