% get heatmaps per behavioral types (from zscored matrices)

clear behav_neu behav_neu_name
behav_neu=alltest_BLA_noFZ_ctxA2(:,alltest_BLA_low);     % select from context neurons, behavioral type 
behav_neu_name=alltest_names(alltest_BLA_low);           % give neuon names 

bin=0.1;     
edges=(-1:bin:2);            %% egdes before and after 0

figure;
h=imagesc(behav_neu')
set(h,'XData',edges)
caxis([-3 4])
xlim([-1 2])
colormap parula
colorbar
box off
suptitle('BLA B cells no learners during mobility ctxA2')

