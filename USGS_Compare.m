%% compare the USGS data with the data at a given VS
%written by steve tuozzolo, 5/2015

function [USGS] = USGS_Compare(ID, Altimetry,USGS)

ind2=find(Altimetry.hbar>-5);
time=Altimetry.t(ind2); 
height=Altimetry.hbar(ind2);
USGSheight=USGS.height+USGS.datum;
for i=1:length(ind2)
[val,ind]=min(abs(time(i)-USGS.time));
diff(i)=(height(i)-USGSheight(ind));
diffsq1(i)=(diff(i)/3.28084)^2;
end
USGS.bias=mean(diff);
height=height-USGS.bias;
%diff=diff-USGS.bias;
%diffsq=diff.^2;
USGS.rmse=sqrt(sum(diffsq1/length(diffsq1)));
USGS.SD=std(diff);
figure; plot(time,height,'rsq'); hold on; plot(USGS.time,USGSheight,'g--'); 
plot(time,diff,'m*')
legend('Altimeter','USGS','Difference','Location','best');
ylabel('Height, ft');
xlabel('time');
datetick('x',10)
line0=['Station ' ID ', m'];
line1=['SD ' num2str(USGS.SD) ' m'];
line2=['Bias ' num2str(USGS.bias) ' m'];
line3=['RMSE ' num2str(USGS.rmse) ' m'];
title({line0,line1,line2,line3});
end

return;
