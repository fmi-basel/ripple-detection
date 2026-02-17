  
function [allmean allsem]= zscoreMeanForSpecificConditionResponse(varlistrep, allanims)
%%% mean of avoidance responsive cells in all conditions %%%

cells=allanims(:,varlistrep); %all data of bins after 0 of activated cells only
[sact,~] = size(cells);
for i=1:1:sact
   
    allmean(i)=mean(cells(i,:));
    allsem(i)=std(cells(i,:))/sqrt(length(cells));
    
end




        
