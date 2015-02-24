function Altimetry = CalcAvgHeights(Altimetry)

Altimetry.nNODATA=0;
Altimetry.NDcyc=[];
Altimetry.NDflag=[];

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
            ERRORCODE=-9998; %all records filtered out
            Altimetry.NDcyc=[Altimetry.NDcyc 0];        %need to work on this more
        end
        Altimetry.hbar(j)=ERRORCODE;
        Altimetry.hstd(j)=ERRORCODE;
        Altimetry.N(j)=0;
        Altimetry.hwbar(j)=ERRORCODE;
        Altimetry.sig0Avg(j)=ERRORCODE;
        Altimetry.pkAvg(j)=ERRORCODE;
    else
        hc=Altimetry.h(ic);    
        sc=Altimetry.sig0(ic);
        pk=Altimetry.PK(ic);

        Altimetry.hbar(j)=mean(hc);
        Altimetry.hstd(j)=std(hc);    
        Altimetry.N(j)=sum(ic);        

        Altimetry.hwbar(j)=sum(hc.*10.^(.1.*sc))./sum(10.^(.1.*sc));

        Altimetry.sig0Avg(j)=mean(sc);

        Altimetry.pkAvg(j)=mean(pk);        
    end    
end
