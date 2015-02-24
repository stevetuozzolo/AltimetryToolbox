function PlotScatter(Comparison,fnum)

hmin=min([min(Comparison.Altimetry.WAvg) min(Comparison.Gage)]);
hmax=max([max(Comparison.Altimetry.WAvg) max(Comparison.Gage)]);

figure(fnum)
plot(Comparison.Gage,Comparison.Altimetry.WAvg,'o',[hmin hmax],[hmin hmax],'LineWidth',2)
set(gca,'FontSize',14)
xlabel('Gaged height, m')
ylabel('Altimeter height, m')
title('Gage vs. Altimetry Scatterplot')

return