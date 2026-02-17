clear all
close all
files1 = {'m330TEST1.mat','m331TEST1.mat','m332TEST1.mat','m334TEST1.mat','m335TEST1.mat','m336TEST1.mat',...
          'm337TEST1.mat','m338TEST1.mat','m339TEST1.mat','m340TEST1.mat','m341TEST1.mat','m342TEST1.mat',...
          'm343TEST1.mat','m344TEST1.mat','m345TEST1.mat','m346TEST1.mat','m348TEST1.mat',...
          'm349TEST1.mat','m350TEST1.mat','m351TEST1.mat','m352TEST1.mat','m353TEST1.mat','m354TEST1.mat',...
          'm355TEST1.mat','m356TEST1.mat','m357TEST1.mat','m358TEST1.mat','m359TEST1.mat','m360TEST1.mat','m361TEST1.mat',};
files2 = {'m331TEST2.mat','m332TEST2.mat','m334TEST2.mat','m335TEST2.mat','m336TEST2.mat','m337TEST2.mat',...
          'm338TEST2.mat','m339TEST2.mat','m340TEST2.mat','m341TEST2.mat','m342TEST2.mat','m343TEST2.mat',...
          'm344TEST2.mat','m345TEST2.mat','m346TEST2.mat','m348TEST2.mat','m349TEST2.mat',...
          'm350TEST2.mat','m351TEST2.mat','m352TEST2.mat','m353TEST2.mat','m354TEST2.mat','m355TEST2.mat',...
          'm356TEST2.mat','m357TEST2.mat','m358TEST2.mat','m359TEST2.mat','m360TEST2.mat','m361TEST2.mat'};



files={files1,files2}; %files1,files2,files3, files4;
Bcell={'Bcells_t1.mat','Bcells_t2.mat'};
clus={'clust_test1','clust_test2'};
discri={'disc_gene_alltest.mat'};

stringfile={'test1','test2'};
for g=1:numel(files)
   clearvars -except files stringfile clus g Bcell discri
    file=files{1,g};
    load(clus{g},'cPN','cIN','rPN','rIN')
    load(Bcell{g},'C1_activated')
    load(discri{1},'disc_t1', 'disc_t2', 'gene_t1', 'gene_t2')
    discricells={disc_t1, disc_t2};
    Bcells=find(C1_activated);
    N_type= {'cPN','cIN'};%'rPN','rIN' , 

total_counts_mean_var=struct();
total_counts_mean=struct();
listeall=[];
for p = 1:numel(file)
    clear SPK* FZ_B no_FZ_B
    load(file{p},'SPK*','FZ_B', 'no_FZ_B')

    b={who('*P')};
    bstring={'PL'}; %'BLA',
    %bstring={'All'};    
    var3d={FZ_B, no_FZ_B}; %,
    varstring={'Freezing','noFreezing'}; 
    bin=0.1;         %% time bin to change
    
    edges=(-2:bin:2);
   
    limi=[-2 2]; 
    
  
    [total_counts_mean_var total_counts_mean_var_norm]= freqVar(var3d,varstring,b,bstring,p,file,edges,bin);
    mice{p,1}=total_counts_mean_var;
    normice{p,1}=total_counts_mean_var_norm;
  %listeall=[listeall; liste];
    end
    
%save(['zscoredall' stringfile{g}],'mice','normice)
clearvars -except mice edges bstring files PN IN clus stringfile g limi normice varstring listeall N_type cIN cPN...
    C1_activated  disc_t1 disc_t2 gene_t1 gene_t2 discricells Bcells
%%% get the z-score to the basal period %%% heatmap 

Bcell_discri= intersect(discricells{g},Bcells);
PN= intersect(cPN,Bcell_discri);
IN= intersect(cIN,Bcells);
N_type= {'PN', 'IN'};%'rPN','rIN
    
[zscored_all_varcr, basal] = zscoreVar(varstring,bstring,mice,N_type);

%%% ranking neurons from more activated to inhibited
varstring= fieldnames(zscored_all_varcr.(bstring{1}))';  

for i=1:size(bstring,2),varorder=zscored_all_varcr.(bstring{i}).(varstring{1}); end 
% 
[order]=heatMapZscore(zscored_all_varcr,bstring,varstring,stringfile,varorder,g,edges,limi);
% 
%heatMapNorm(normice,order,bstring,varstring, stringfile,edges,limi,g,N_type);

%%
%%% get the cell responses %%%

act_sig= 1.95;  
inh_sig= -1.95;

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
        shift=find(time==0)+2;
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
        varlistrep = actcells_allcr.(bstring{p}).(varstring{1});
        allanims = zscored_all_varcr.(bstring{p}).(varstring{j});  % #15 18 19
        [actmean actsem]= zscoreMeanForSpecificConditionResponse(varlistrep, allanims);
        clear allanims varlistrep inhmean inhsem
        varlistrep = inhcells_allcr.(bstring{p}).(varstring{1});
        allanims = zscored_all_varcr.(bstring{p}).(varstring{j});  % #15 18 19
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

%% %%% comparison act same CSP activated cells per var response %%%
 
figure('Name','Activated','NumberTitle','off');
for p=1:size(bstring,2)
    subplot(1,2,p)
    shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{1})), smooth(actsemall_varcr.(bstring{p}).(varstring{1})),'lineprops',{'Color',[0.8 0.2 0.0]},'transparent',1,'patchSaturation',0.33)
    hold on
    shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{2})), smooth(actsemall_varcr.(bstring{p}).(varstring{2})), 'lineprops',{'Color',[0.3 0.7 0.2]},'transparent',1,'patchSaturation',0.33)
    hold on
%     shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{3})), smooth(actsemall_varcr.(bstring{p}).(varstring{3})), 'lineprops',{'Color',[0.3 0.7 0.8]},'transparent',1,'patchSaturation',0.33)
%     hold on
%     shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{4})), smooth(actsemall_varcr.(bstring{p}).(varstring{4})), 'lineprops',{'Color',[0.3 0 0.2]},'transparent',1,'patchSaturation',0.33)
%     title(bstring{p},'Fontsize',20)
    xlabel('time (sec)','Fontsize',16)
    ylabel('z-score','Fontsize',16)
    legend(varstring{1},varstring{2},'Fontsize',12)
    axis([limi -2 5])
    suptitle(stringfile{g})
end
figure('Name','Inhibited','NumberTitle','off');
for p=1:size(bstring,2)
    subplot(1,2,p)
    shadedErrorBar(edges(1:end-1), smooth(inhmeanall_varcr.(bstring{p}).(varstring{1})), smooth(inhsemall_varcr.(bstring{p}).(varstring{1})),'lineprops',{'Color',[0.8 0.2 0.0]},'transparent',1,'patchSaturation',0.33)
    hold on
    shadedErrorBar(edges(1:end-1), smooth(inhmeanall_varcr.(bstring{p}).(varstring{2})),  smooth(inhsemall_varcr.(bstring{p}).(varstring{2})), 'lineprops',{'Color',[0.3 0.7 0.2]},'transparent',1,'patchSaturation',0.33)
%      hold on
%     shadedErrorBar(edges(1:end-1), smooth(inhmeanall_varcr.(bstring{p}).(varstring{3})),  smooth(inhsemall_varcr.(bstring{p}).(varstring{3})), 'lineprops',{'Color',[0.3 0.7 0.8]},'transparent',1,'patchSaturation',0.33)
%     hold on
%     shadedErrorBar(edges(1:end-1), smooth(inhmeanall_varcr.(bstring{p}).(varstring{4})),  smooth(inhsemall_varcr.(bstring{p}).(varstring{4})), 'lineprops',{'Color',[0.3 0 0.2]},'transparent',1,'patchSaturation',0.33) 
%     title(bstring{p},'Fontsize',20)
%     xlabel('time (sec)','Fontsize',16)
    ylabel('z-score','Fontsize',16)
    legend(varstring{1},varstring{2},'Fontsize',12)
    axis([limi -4 3])
    suptitle(stringfile{g})
end
%%  comparative matrice of cell responsiveness for all variables
% 
 [percentage]=heatmapResponsivenessMatriceOfEvents(zscored_all_varcr,varstring,bstring,stringfile,actcells_allcr,inhcells_allcr,g)
%  
[perc_actvarrc perc_inhvarrc]= pieChartPercActInh(actcells_allcr, inhcells_allcr,zscored_all_varcr,varstring,bstring,g,stringfile)
end


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

