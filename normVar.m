
function [results]= normVar(var,varst,change_time_bin,p,maxvar,minvar,varargin)

size(varargin)

results=struct();


for m=1:size(var,2)
    clear varnorm2 elem1 elem2 varnorm
    varnorm=var{m};
    
    time_limits=(0:change_time_bin:size(varnorm,1));
    for i=1:size(time_limits,2)-1
        varnorm2(i,:)=mean(varnorm(time_limits(i)+1:time_limits(i+1),:));
    end
    
    varnorm=varnorm2;
    if exist('maxvar')  
        maxvar1=cell2mat(maxvar{1,m}(p,1));
    else
    maxvar1=max(varnorm);
    end
    if exist('minvar')
        minvar1=cell2mat(minvar{1,m}(p,1));
    else
    minvar1=min(varnorm);
    end
    
    elem1=varnorm-minvar1;
    elem2= maxvar1-minvar1;
    varnorm=elem1./elem2;
    
    eval([ 'results.' varst{m} '=varnorm']);
    
end