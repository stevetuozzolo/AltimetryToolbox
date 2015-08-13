%% 
function [J2mat,Envmat,j2prop,envprop]= doRivStats(J2,Env)

counter=0;
allcount=0;
for i=1:length(J2)
tcount=sum((J2(i).Val>.5));
    counter=counter+tcount;
    tallct=sum(length(J2(i).Val));
allcount=allcount+tallct;
J2(i).rat=tcount/tallct;
J2mat(i,3)=tcount/tallct;
J2mat(i,1)=tcount;
J2mat(i,2)=tallct;
%J2mat(i,4)=J2(i).GRAD(3);
%J2mat(i,5)=J2(i).dGRAD(3);
end


counter=0;
allcount=0;
for i=1:length(Env)
tcount=sum((Env(i).Val>.5));
    counter=counter+tcount;
    tallct=sum(length(Env(i).Val));
allcount=allcount+tallct;
Env(i).rat=tcount/tallct;
Envmat(i,3)=tcount/tallct;
Envmat(i,1)=tcount;
Envmat(i,2)=tallct;
%Envmat(i,4)=Env(i).GRAD(3);
%Envmat(i,5)=Env(i).GRAD(3);
end

j2prop.ice=sum(J2mat(:,1))/sum(J2mat(:,2));
envprop.ice=sum(Envmat(:,1))/sum(Envmat(:,2));



Envmat(5,:)=[]; Envmat(2,:)=[];
J2mat(5,:)=[]; J2mat(2,:)=[];
j2prop.noice=sum(J2mat(:,1))/sum(J2mat(:,2));
envprop.noice=sum(Envmat(:,1))/sum(Envmat(:,2));

j2prop
envprop

end
