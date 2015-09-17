function [Altimetry] = IceFilter(Altimetry,IceData)

T=Altimetry.tAll;
Uyears=unique(str2num(datestr((T),10)));
a=zeros(size(T,1));
iceflag=[];
for i=1:length(Uyears),
    curryear=Uyears(i);
    currdata=str2num(datestr(T,10))==curryear;
    iceyr=datestr(IceData(:,2),10);
    iceind=find(str2num(iceyr)==curryear);
    gooddata=T(currdata)>=IceData(iceind,2) & T(currdata)<=IceData(iceind,3);
    iceflag=[iceflag; gooddata];
    clear gooddata currdata curryear
end
Altimetry.IceFlag=iceflag;

return
