function PlotHeightTimeseries(AltimeterData,g,fnum1,fnum2)

figure(fnum1)
plot(AltimeterData.tAll,AltimeterData.h,'co',AltimeterData.t,AltimeterData.hbar,'r-',...
    AltimeterData.t,AltimeterData.hwbar,'g-',g.td,g.hd,'b-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('Elevation, m')
legend('20 Hz points','Average 20 Hz height','Power-weighted average 20 Hz height','Gage',0)
datetick

figure(fnum2)
plot(AltimeterData.tAll,AltimeterData.h,'co','LineWidth',2); hold on;
errorbar(AltimeterData.t,AltimeterData.hbar,AltimeterData.hstd,'r',...
    'LineStyle','none','LineWidth',2); 
plot(AltimeterData.t,AltimeterData.hwbar,'g-','LineWidth',2); hold off;
set(gca,'FontSize',14)
datetick
ylabel('Elevation, m')


return