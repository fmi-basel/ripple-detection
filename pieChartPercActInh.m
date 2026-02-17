function [perc_actvarrc perc_inhvarrc]= pieChartPercActInh(actcells_allcr, inhcells_allcr,zscored_all_varcr,varstring,bstring,g,stringfile)



for k=1:size(bstring,2)
    figure;
for j= 1:size(varstring,2)
    subplot(1,length(varstring),j)
    actunit = size(actcells_allcr.(bstring{k}).(varstring{j}),2)
    inhunit = size(inhcells_allcr.(bstring{k}).(varstring{j}),2)
    allunits = size(zscored_all_varcr.(bstring{k}).(varstring{j}),2)
    per_act= actunit/allunits*100;
    per_inh= inhunit/allunits*100;

pie([actunit,inhunit,allunits-(actunit+inhunit) ])%,'MarkerFaceColor','[0.4660 0.6740 0.1880]')
title(varstring{j},'fontsize',15)
legend('Activated','Inhibited','nonresponsive','fontsize',10)
suptitle([bstring{k} stringfile{g}])

end
perc_actvar.(varstring{j})=  per_act;
perc_inhvar.(varstring{j})=  per_inh;
end
perc_actvarrc.(bstring{k})=perc_actvar;
perc_inhvarrc.(bstring{k})=perc_inhvar;

end