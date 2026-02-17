

for i=1:size(FR_PFC,2)
   
    scatter(FR_PFC(:,i),PercFreeze);
    hold on
end

cocoPFC=corr(VarName1,BLA);
cocoBLA=corr(PercFreeze,FR_BLA);

figure
hist(cocoPFC)
xlabel('correlation'),ylabel('count');

figure 
hist(cocoBLA)
xlabel('correlation'),ylabel('count');

