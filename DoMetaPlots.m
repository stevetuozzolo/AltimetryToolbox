function [totmat j2prop envprop]= DoMetaPlots(RunRiv,J2,Env)
totmat=zeros(1,4);
for i=1:length(RunRiv)-2
    figure;
    plot(J2(i).Width,J2(i).Val,'r*'); hold on;
    plot(Env(i).Width,Env(i).Val,'r*'); hold off;
    title([RunRiv(i) ' Width vs Val'])
    xlabel('Width,m')
    ylabel('% of stations w/ >50% coverage')
    totmat=[totmat; J2(i).Width' J2(i).Val' J2(i).GRAD' J2(i).dGRAD'; Env(i).Width' Env(i).Val' ...
        Env(i).GRAD' Env(i).dGRAD'];
    triv=strcat('MetaPlots/',RunRiv(i));
%    print('-dpng' ,'-r400',[triv])
    close
end
hold off; figure; plot(totmat(:,1),totmat(:,2),'r.','MarkerSize',15); hold on
xlabel('River width, m')
title('Virtual Stations coverage vs. river width')
ylabel('Fraction of passes with good data')
print('-dpng','-r400',['MetaPlots/AmericasWidth'])
[J2mat,Envmat,j2prop,envprop]=doRivStats(J2,Env);

figure
plot(totmat(:,3),totmat(:,2),'r.','MarkerSize',15); hold on
xlabel('Gradient, Top metric 1, m')
title('Virtual Stations coverage vs. Top metric')
ylabel('Fraction of passes with good data')

figure
plot(totmat(:,4),totmat(:,2),'r.','MarkerSize',15); hold on
xlabel('dGradient, Top metric 2, m')
title('Virtual Stations coverage vs. Top metric')
ylabel('Fraction of passes with good data')


end