function WriteVirtualStations(Experiment,Navg,ErrorStats)

nSta=length(Experiment.Name);

fid=fopen('VirtualStationsResults.csv','w');

fprintf(fid,'name,lat,lon,width,pass,exclude,min-lat,max-lat,Gage,HeightOffset[m],');
fprintf(fid,'Navg,R (Avg), R(WghtAvg),RMSE,NSE \n');

for i=1:nSta,
    fprintf(fid,'%s,',Experiment.Name{i});
    fprintf(fid,'%f,',Experiment.Lat(i));
    fprintf(fid,'%f,',Experiment.Lon(i));
    fprintf(fid,'%f,',Experiment.Width(i));
    fprintf(fid,'%f,',Experiment.Pass(i));
    fprintf(fid,'%f,',Experiment.Exclude(i));

    if Experiment.Exclude(i),
        fprintf(fid,'\n');
        continue
    end
    
    fprintf(fid,'%f,',Experiment.MinLat(i));
    fprintf(fid,'%f,',Experiment.MaxLat(i));
    fprintf(fid,'%s,',Experiment.Gage{i});
    fprintf(fid,'%f,',Experiment.Offset(i));    
    
    fprintf(fid,'%f,',Navg(i));
    fprintf(fid,'%f,',ErrorStats{i}.R_Avg);
    fprintf(fid,'%f,',ErrorStats{i}.R_WAvg);
    fprintf(fid,'%f,',ErrorStats{i}.RMSE);
    fprintf(fid,'%f',ErrorStats{i}.NSE);
    fprintf(fid,'\n');
end

fclose(fid);

return