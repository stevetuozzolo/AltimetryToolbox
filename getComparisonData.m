function Comparison = getComparisonData(Altimetry,Gage)

%one-to-one comparison
for i=1:length(Altimetry.hbar),
    [dt,j]=min(abs(Altimetry.t(i)-Gage.td));
    if dt<1,
        Comparison.Gage(i)=Gage.hd(j);
    else
        Comparison.Gage(i)=nan;
    end
end

%set up one-to-one line
igood=~isnan(Comparison.Gage);

Comparison.Altimetry.Avg=Altimetry.hbar(igood);
Comparison.Altimetry.WAvg=Altimetry.hwbar(igood);
Comparison.Gage=Comparison.Gage(igood);


return