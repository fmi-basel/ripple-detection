
function [actcells inhcells]= findCellResponse(act,inh)
t=1;
c=0;
for i=1:1:max(act.col);
    a=find(act.col==i);
    b=act.row(a);
    c=min(diff(b));
    if c==1;  %que 1.95 ou se ele tem dois bins seguidos maiores que 1.96
        actcells(t)=i; %position vector of all activated cells after 0
        t=t+1;
    else
    end
end
if ~exist('actcells')
    actcells=[];
end
clear a b c t

t=1;
c=0;
for i=1:1:max(inh.col);
    a=find(inh.col==i);
    b=inh.row(a);
    c=min(diff(b));
    if  c==1;  %se ele tem dois bins seguidos menores que -1.96
        inhcells(t)=i; %position vector of all inhibited cells after 0
        t=t+1;
    else
        
    end
end

if ~exist('inhcells')
    inhcells=[];
end
end