function Altimetry = CalcAvgHeights(Altimetry,ID,varargin)

if nargin>1,
    ShowPlots=varargin{1};
else
    ShowPlots=false;
end

Altimetry.nNODATA=0;
Altimetry.NDcyc=[];
Altimetry.NDflag=[];

if sum(Altimetry.GDRMissing)==length(Altimetry.GDRMissing)
    
    Altimetry.hbar=0;Altimetry.hstd=0;Altimetry.N=0;Altimetry.hwbar=0;
    Altimetry.sig0Avg=0;Altimetry.pkAvg=0; Altimetry.Write=0;

else


for j=1:length(Altimetry.ci),
    
    ic=Altimetry.c==Altimetry.ci(j);
    ig=Altimetry.iGood;
    icg=ic&ig;
    
    if ~any(icg),
        Altimetry.nNODATA=Altimetry.nNODATA+1;
        Altimetry.NDcyc=[Altimetry.NDcyc Altimetry.ci(j)];
        
        if ~any(ic),
            ERRORCODE=-9999; %no data in the GDR
            Altimetry.NDcyc=[Altimetry.NDcyc 2];        
        else
            ERRORCODE=-9998; %all records filtered out from height/ice filter
            Altimetry.NDcyc=[Altimetry.NDcyc 0];        %need to work on this more
        end
        Altimetry.hbar(j)=ERRORCODE;
        Altimetry.hstd(j)=ERRORCODE;
        Altimetry.N(j)=0;
        Altimetry.hwbar(j)=ERRORCODE;
        Altimetry.sig0Avg(j)=ERRORCODE;
        Altimetry.pkAvg(j)=ERRORCODE;
    else
        hc=Altimetry.h(icg);    
        sc=Altimetry.sig0(icg);
        pk=Altimetry.PK(icg);

        Altimetry.hbar(j)=mean(hc);
        Altimetry.hstd(j)=std(hc);    
        Altimetry.N(j)=sum(icg);        

        Altimetry.hwbar(j)=sum(hc.*10.^(.1.*sc))./sum(10.^(.1.*sc));

        Altimetry.sig0Avg(j)=mean(sc);

        Altimetry.pkAvg(j)=mean(pk);        
    end    
end


Altimetry.nGood=sum(Altimetry.hbar~=-9999 & Altimetry.hbar~=-9998);

if ShowPlots,
    sp3=subplot(2,1,2); 
    hold on;
    hplotAvg=Altimetry.hbar;
    hplotAvg(Altimetry.hbar==-9998 | Altimetry.hbar==-9999)=NaN;
    plot(sp3,Altimetry.t,hplotAvg,'o-'); hold on;
    hplotWavg=Altimetry.hwbar;
    hplotWavg(Altimetry.hwbar==-9998 | Altimetry.hwbar==-9999)=NaN;
    plot(sp3,Altimetry.t,hplotWavg,'x-'); hold off;
    
    set(sp3,'FontSize',14)
    datetick(sp3,'keeplimits')
    line1=['Station #' strrep(ID,'_','-')];
    line2=['Produced ' num2str(Altimetry.nGood) '/' num2str(Altimetry.cmax)];
    title(sp3,{line1,line2})
    
    legend(sp3,'Average','\sigma_0 Weighted Average','Location','Best')
  %   print('-dpng','-r400',[ID])
%close all;
end

if Altimetry.nGood/Altimetry.cmax<=0.33
    Altimetry.Write=0;
else
    Altimetry.Write=1;
end
hold off;    
end