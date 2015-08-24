function DoMetaPlots(RunRiv,J2,Env)

totmat=zeros(1,2);
for i=1:length(RunRiv)-2
    figure;
    plot(J2(i).Width,J2(i).Val,'r*'); hold on;
    plot(Env(i).Width,Env(i).Val,'r*'); hold off;
    title([RunRiv(i) ' Width vs Val'])
    xlabel('Width,m')
    ylabel('% of stations w/ >50% coverage')
    totmat=[totmat; J2(i).Width' J2(i).Val'; Env(i).Width' Env(i).Val'];
end
hold off; figure; plot(totmat(:,1),totmat(:,2),'r.','MarkerSize',15); hold on
xlabel('River width')
title('Virtual Stations with >50% coverage vs. river width')
ylabel('Fraction of passes with good data')
print('-dpng','-r400',['AmericasWidth'])
[J2mat,Envmat,j2prop,envprop]=doRivStats(J2,Env);
end