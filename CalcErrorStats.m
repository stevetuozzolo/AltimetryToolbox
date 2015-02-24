function ErrorStats = CalcErrorStats(Comparison)

R=corrcoef(Comparison.Gage,Comparison.Altimetry.WAvg);

ErrorStats.R_WAvg=R(1,2);

R=corrcoef(Comparison.Gage,Comparison.Altimetry.Avg);

ErrorStats.R_Avg=R(1,2);

errH=Comparison.Gage-Comparison.Altimetry.WAvg;

ErrorStats.RMSE=sqrt(mean(errH.^2));

D=Comparison.Gage-mean(Comparison.Gage);

ErrorStats.NSE=1-sum(errH.^2)/sum(D.^2);

return