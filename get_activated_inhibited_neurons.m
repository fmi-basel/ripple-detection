%% get the cell responses %%%
% load z-scored matrices /R events 

act_sig= 1.95;  
inh_sig= -1.5;

bstring={'All'};     % all or 'BLA', 'PFC'
varstring={'ctxB'};  %name of events  'FZ','ctxA','ctxB','ctxA2'
stringfile={'sess1'};    % if several session
g=1;

% alltest_PFC_FZ(isnan(alltest_PFC_FZ))=0;
% alltest_PFC_FZ_ctxA(isnan(alltest_PFC_FZ_ctxA))=0;
alltest_zscored_noFZ_ctxB(isnan(alltest_zscored_noFZ_ctxB))=0;
% alltest_PFC_FZ_ctxA2(isnan(alltest_PFC_FZ_ctxA2))=0;
% 
% alltest_PFC_FZ(isinf(alltest_PFC_FZ))=0;
% alltest_PFC_FZ_ctxA(isinf(alltest_PFC_FZ_ctxA))=0;
alltest_zscored_noFZ_ctxB(isinf(alltest_zscored_noFZ_ctxB))=0;
% alltest_PFC_FZ_ctxA2(isinf(alltest_PFC_FZ_ctxA2))=0;
% 
% zscored_all_varcr.(bstring{1}).(varstring{1})=alltest_PFC_FZ;%(:,alltest_PFC_gene);   % add if segregate by behav type
% zscored_all_varcr.(bstring{1}).(varstring{2})=alltest_PFC_FZ_ctxA;%(:,alltest_PFC_gene);
zscored_all_varcr.(bstring{1}).(varstring{1})=alltest_zscored_noFZ_ctxB(:,alltest_disc_dnb);
% zscored_all_varcr.(bstring{1}).(varstring{4})=alltest_PFC_FZ_ctxA2;%(:,alltest_PFC_gene);

limi=[-1 2];    %  CHANGE TIME LIMITS!!! time limits (-2 1 for FZ; -1 2 for noFZ)
bin=0.1;     
edges=(-1:bin:2);   

clear j k f
for k=1:size(bstring,2)
    varstring= fieldnames(zscored_all_varcr.(bstring{1}))';  
    for j=1:size(varstring,2)
        clear act inh 
        time= edges';
%         p = 0.95; % on cherche le quantile a 95%;
%         CI = norminv(p,mean(zscored_all_varcr.(bstring{k}).(varstring{j})),std(zscored_all_varcr.(bstring{k}).(varstring{j})));
%         act_sig=CI;
%         inh_sig=-(CI);
        [r,cc] = size(zscored_all_varcr.(bstring{k}).(varstring{j}));
        zero=find(time==0);
        shift=find(time==0)+10;
        %zscored_all0=zscored_all_varcr.(bstring{k}).(varstring{j})([zero:shift],:);
        zscored_all0=zscored_all_varcr.(bstring{k}).(varstring{j})([zero:r],:);
        %zscored_all0=zscored_all_varcr.(bstring{k}).(varstring{j})([shift:r],:);
        [act.row, act.col] = find(zscored_all0>act_sig);
        [inh.row, inh.col] = find(zscored_all0<inh_sig);
        [actcells inhcells]= findCellResponse(act,inh);
        
        actcells_all.(varstring{j})=actcells;
        inhcells_all.(varstring{j})=inhcells;
    end
    actcells_allcr.(bstring{k})=actcells_all;
    inhcells_allcr.(bstring{k})= inhcells_all;
end
% %%  zscore mean %%
%close all

for p=1:size(bstring,2)
    for j=1:size(varstring,2)
        clear allanims varlistrep actmean actsem
        varlistrep = actcells_allcr.(bstring{p}).(varstring{1});   % change number of 'varstring{1}' = reference
        allanims = zscored_all_varcr.(bstring{p}).(varstring{j});  
        [actmean actsem]= zscoreMeanForSpecificConditionResponse(varlistrep, allanims);
        clear allanims varlistrep inhmean inhsem
        varlistrep = inhcells_allcr.(bstring{p}).(varstring{1});
        allanims = zscored_all_varcr.(bstring{p}).(varstring{j});  
        [inhmean inhsem]= zscoreMeanForSpecificConditionResponse(varlistrep, allanims);
        actmeanall.(varstring{j})=actmean;
        inhmeanall.(varstring{j})=inhmean;
        actsemall.(varstring{j})=actsem;
        inhsemall.(varstring{j})=inhsem;
    end
    actmeanall_varcr.(bstring{p})=actmeanall;
    inhmeanall_varcr.(bstring{p})=inhmeanall;
    actsemall_varcr.(bstring{p})=actsemall;
    inhsemall_varcr.(bstring{p})=inhsemall;
    
end

%% comparison act same CSP activated cells per var response %%
 
figure('Name','Activated','NumberTitle','off');
for p=1:size(bstring,2)
    subplot(1,2,p)
    shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{1})), smooth(actsemall_varcr.(bstring{p}).(varstring{1})),'lineprops',{'Color',[0.8 0.2 0.0]},'transparent',1,'patchSaturation',0.33)
%     hold on
%     shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{2})), smooth(actsemall_varcr.(bstring{p}).(varstring{2})), 'lineprops',{'Color',[0.3 0.7 0.2]},'transparent',1,'patchSaturation',0.33)
%     hold on
%     shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{3})), smooth(actsemall_varcr.(bstring{p}).(varstring{3})), 'lineprops',{'Color',[0.3 0.7 0.8]},'transparent',1,'patchSaturation',0.33)
%     hold on
%     shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{4})), smooth(actsemall_varcr.(bstring{p}).(varstring{4})), 'lineprops',{'Color',[0.3 0 0.2]},'transparent',1,'patchSaturation',0.33)
    title(bstring{p},'Fontsize',20)
    xlabel('time (sec)','Fontsize',16)
    ylabel('z-score','Fontsize',16)
    legend(varstring{1},'Fontsize',12)
    %legend(varstring{1},varstring{2},varstring{3},varstring{4},'Fontsize',12)
    axis([limi -1 4])
    suptitle(stringfile{g})
end
figure('Name','Inhibited','NumberTitle','off');
for p=1:size(bstring,2)
    subplot(1,2,p)
    shadedErrorBar(edges(1:end-1), smooth(inhmeanall_varcr.(bstring{p}).(varstring{1})), smooth(inhsemall_varcr.(bstring{p}).(varstring{1})),'lineprops',{'Color',[0.8 0.2 0.0]},'transparent',1,'patchSaturation',0.33)
%     hold on
%     shadedErrorBar(edges(1:end-1), smooth(inhmeanall_varcr.(bstring{p}).(varstring{2})),  smooth(inhsemall_varcr.(bstring{p}).(varstring{2})), 'lineprops',{'Color',[0.3 0.7 0.2]},'transparent',1,'patchSaturation',0.33)
%      hold on
%     shadedErrorBar(edges(1:end-1), smooth(inhmeanall_varcr.(bstring{p}).(varstring{3})),  smooth(inhsemall_varcr.(bstring{p}).(varstring{3})), 'lineprops',{'Color',[0.3 0.7 0.8]},'transparent',1,'patchSaturation',0.33)
%     hold on
%     shadedErrorBar(edges(1:end-1), smooth(inhmeanall_varcr.(bstring{p}).(varstring{4})),  smooth(inhsemall_varcr.(bstring{p}).(varstring{4})), 'lineprops',{'Color',[0.3 0 0.2]},'transparent',1,'patchSaturation',0.33) 
    title(bstring{p},'Fontsize',20)
    xlabel('time (sec)','Fontsize',16)
    ylabel('z-score','Fontsize',16)
    legend(varstring{1},'Fontsize',12)
    %legend(varstring{1},varstring{2},varstring{3},varstring{4},'Fontsize',12)
    axis([limi -3 1])
    suptitle(stringfile{g})
end

%%  comparative matrice of cell responsiveness for all variables

% heatmapResponsivenessMatriceOfEvents : function, go in and change the number of variables 

[percentage]=heatmapResponsivenessMatriceOfEvents(zscored_all_varcr,varstring,bstring,stringfile,actcells_allcr,inhcells_allcr,g)

[perc_actvarrc perc_inhvarrc]= pieChartPercActInh(actcells_allcr, inhcells_allcr,zscored_all_varcr,varstring,bstring,g,stringfile)

%% get names
% actcells_all.FZ inhcells_all.FZ actcells_all.noFZ inhcells_all.noFZ
name=alltest_names(alltest_PFC_gene);
name_act= name(actcells_all.noFZ);
name_inh= name(inhcells_all.noFZ);

name_act= name(actcells_all.noFZ);
name_inh= name(inhcells_all.noFZ);

clear name_act name_inh
name_act=alltest_names(actcells_all.ctxB);   % ACTIVE
name_inh=alltest_names(inhcells_all.ctxB);   % INHIBITED

clear FZ_act FZ_inh
FZ_act=alltest_zscored_noFZ_ctxB(:,actcells_all.ctxB);      % ACTIVE
FZ_inh=alltest_zscored_noFZ_ctxB(:,inhcells_all.ctxB);      % INHIBITED

clear bef_FZ at_FZ
bef_FZ=nanmean(FZ_inh(11:20,:))';
at_FZ=nanmean(FZ_inh(21:30,:))';


% figure('Name','Inhibited','NumberTitle','off');
% 
%     subplot(2,2,1)
%     bar(edges(1:end-1),mice{4, 1}.Caudal.DOavoid(:,1),'k')
%     title(bstring{1},'Fontsize',20)
%     xlabel('time (sec)','Fontsize',16)
%     ylabel('Frenqency(Hz)','Fontsize',16)
%     axis([-2 2 0 2])
%     subplot(2,2,2)
%     bar(edges(1:end-1),mice{3, 1}.Rostral.DOavoid(:,2),'k')  
%     title(bstring{2},'Fontsize',20)
%     xlabel('time (sec)','Fontsize',16)
%     axis([-2 2 0 2])
%     subplot(2,2,3)
%     bar(edges(1:end-1),mice{4, 1}.Caudal.DOshuttle(:,1),'k')
%     axis([-2 2 0 2])
%     xlabel('time (sec)','Fontsize',16)
%     ylabel('Frenqency(Hz)','Fontsize',16)
%     subplot(2,2,4)
%     bar(edges(1:end-1),mice{3, 1}.Rostral.DOshuttle(:,2),'k')
%     axis([-2 2 0 2])
%     xlabel('time (sec)','Fontsize',16)

