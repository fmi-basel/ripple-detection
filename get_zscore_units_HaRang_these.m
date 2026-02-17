clear all
close all

% before starting add main folder in the path! 

files1 = {'m330TEST1.mat','m331TEST1.mat','m332TEST1.mat','m334TEST1.mat','m335TEST1.mat','m336TEST1.mat',...
          'm337TEST1.mat','m338TEST1.mat','m339TEST1.mat','m340TEST1.mat','m341TEST1.mat','m342TEST1.mat',...
          'm343TEST1.mat','m344TEST1.mat','m345TEST1.mat','m346TEST1.mat','m347TEST1.mat','m348TEST1.mat',...
          'm349TEST1.mat','m350TEST1.mat','m351TEST1.mat','m352TEST1.mat','m353TEST1.mat','m354TEST1.mat',...
          'm355TEST1.mat','m356TEST1.mat','m357TEST1.mat','m358TEST1.mat','m359TEST1.mat','m360TEST1.mat','m361TEST1.mat',};
files2 = {'m331TEST2.mat','m332TEST2.mat','m334TEST2.mat','m335TEST2.mat','m336TEST2.mat','m337TEST2.mat',...
          'm338TEST2.mat','m339TEST2.mat','m340TEST2.mat','m341TEST2.mat','m342TEST2.mat','m343TEST2.mat',...
          'm344TEST2.mat','m345TEST2.mat','m346TEST2.mat','m347TEST2.mat','m348TEST2.mat','m349TEST2.mat',...
          'm350TEST2.mat','m351TEST2.mat','m352TEST2.mat','m353TEST2.mat','m354TEST2.mat','m355TEST2.mat',...
          'm356TEST2.mat','m357TEST2.mat','m358TEST2.mat','m359TEST2.mat','m360TEST2.mat','m361TEST2.mat'};


files={files1,files2}; %files1,files2,files3, files4;
BcellPL={'pfc_Bcells_t1_CI95','pfc_Bcells_t2_CI95'};    % 'pfc_Bcells_t1_CI.mat','pfc_Bcells_t2.mat'
BcellBL={'bla_Bcells_t1_CI95','bla_Bcells_t2_CI95'};    % 'bla_Bcells_t1.mat','bla_Bcells_t2.mat'
clus={'clust_test1.mat','clust_test2.mat'};
discri={'disc_gene_pfc.mat','disc_gene_bla.mat'};

stringfile={'test1','test2'};

for g=2:numel(files)
    
    clearvars -except files stringfile clus g BcellPL BcellBL discri
     %%% loads Spikes and freezing events (file), discrimination ID(discri), clustering ID (clus), context cell ID (Bcells)%%%
    file=files{1,g};
    load(clus{g},'cPN','cIN','rPN','rIN')    % 'c' = PFC ; 'r' = BLA
   
    load(BcellPL{g},'C1_activated')
    BcellsPL=find(C1_activated);
    
    load(BcellBL{g},'C1_activated')
    BcellsBL=find(C1_activated);
    
    load(discri{1},'disc_t1', 'disc_t2', 'dnr_t1', 'dnr_t2', 'gene_t1', 'gene_t2', 'disc_dnr_t1', 'disc_dnr_t2')
    PLdiscricells={disc_t1, disc_t2};
    PLdnrcells= {dnr_t1, dnr_t2};
    PLgenecells={gene_t1, gene_t2};
    PLalldisccells={disc_dnr_t1, disc_dnr_t2};
   
    load(discri{2},'disc_t1', 'disc_t2', 'dnr_t1', 'dnr_t2','gene_t1', 'gene_t2', 'disc_dnr_t1', 'disc_dnr_t2')
    BLdiscricells={disc_t1, disc_t2};
    BLdnrcells= {dnr_t1, dnr_t2};
    BLgenecells={gene_t1, gene_t2};
    BLalldisccells={disc_dnr_t1, disc_dnr_t2};

    %%% creates subcategories of neuron type(IN PN) coupled with neuron ID (discri,Bcell etc.), for PL and BLA %%%
    
    BcellPL_discri= intersect(PLdiscricells{g},BcellsPL);    % PFC disc
    BcellPL_dnr= intersect(PLdnrcells{g},BcellsPL);          % PFC gene
    BcellPL_gene= intersect(PLgenecells{g},BcellsPL);        % PFC gene
    BcellPL_alldisc= intersect(PLalldisccells{g},BcellsPL);  % PFC disc

%     
%     PLPN_Bdiscri= intersect(cPN,BcellPL_discri);           %PFC PN disc
%     PLPN_Bgene= intersect(cPN,BcellPL_gene);               %PFC PN gene
%     
%     PLIN_Bdiscri= intersect(cIN,BcellPL_discri);           %PFC IN disc
%     PLIN_Bgene= intersect(cIN,BcellPL_gene);               %PFC IN disc
%     
    BcellBL_discri= intersect(BLdiscricells{g},BcellsBL);     %BLA gene
    BcellBL_dnr= intersect(BLdnrcells{g},BcellsBL);        %BLA gene
    BcellBL_gene= intersect(BLgenecells{g},BcellsBL);         %BLA disc
    BcellBL_alldisc= intersect(BLalldisccells{g},BcellsBL);    %BLA gene
%     
%     BPN_Bdiscri= intersect(rPN,BcellBL_discri);             %BLA PN disc
%     BPN_Bgene= intersect(rPN,BcellBL_gene);                 %BLA PN gene
%     
%     BIN_Bdiscri= intersect(rIN,BcellBL_discri);             %BLA IN disc
%     BIN_Bgene= intersect(rIN,BcellBL_gene);                 %BLA IN gene
%     

   N_type= {BcellPL_dnr,BcellBL_dnr};     %% variable where to put the chosen subcategory in the loop
                                            % tjs par 2!
    for p = 1:numel(file)
        clear SPK* FZ_B no_FZ_B AllFile fear_safe_start safe_fear_start
        load(file{p},'SPK*', 'AllFile', 'FZ_B', 'no_FZ_B') %,'FZ_B', 'no_FZ_B', 'safe_fear_start', 'fear_safe_start')
       
        Start=AllFile;
        FZ_Bctxt=FZ_B;
        no_FZ_Bctxt=no_FZ_B;
        clear FZ_B no_FZ_B AllFile
       
        b={who('*P'),who('*B')};
        bstring={'PL','BLA'}
        %bstring={'All'};
        %var3d= {Start};
        %varstring={'allfile'};
        
        var3d={FZ_Bctxt, no_FZ_Bctxt};           % c'est ici variable des events!  
        varstring={'Freezing','noFreezing'};     % toujours changer les noms associés aux events
        % var3d= {fear_safe_start, safe_fear_start};
        % varstring= {'trans1', 'trans2'};
       
        bin=0.1;         %% time bin to change
        edges=(-1:bin:1);
        %limi=[-1 1];
       
        
        [total_counts_mean_var total_counts_mean_var_norm]= freqVar(var3d,varstring,b,bstring,p,file,edges,bin);
        mice{p,1}=total_counts_mean_var;
        normice{p,1}=total_counts_mean_var_norm;
    end
    
%save(['zscoredall' stringfile{g}],'mice','normice)
clearvars -except mice edges bstring files PN IN clus stringfile g limi normice varstring listeall N_type cIN cPN...
    C1_activated discricells BcellsBL BcellBL BcellsPL BcellPL discri


%% get the z-score to the basal period %%% 

    % go to 'zscoreVar' function and change baseline!
    
[zscored_all_varcr, basal] = zscoreVar(varstring,bstring,mice,N_type);   
    % "zscored_all_varcr" give all zscore table 


%% heatmap - ranking neurons from more activated to inhibited %%
varstring= fieldnames(zscored_all_varcr.(bstring{1}))';  

for i=1:size(bstring,2),varorder=zscored_all_varcr.(bstring{i}).(varstring{1}); end 
% 
[order]=heatMapZscore(zscored_all_varcr,bstring,varstring,stringfile,varorder,g,edges,limi);
% 
%heatMapNorm(normice,order,bstring,varstring, stringfile,edges,limi,g,N_type);

%%
%%% get the cell responses %%%

act_sig= 1.95; 
inh_sig= -1.95;      % threshold for significance to change if needed

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

%% 
%%% comparison act same CSP activated cells per var response %%%
 
figure('Name','Activated','NumberTitle','off');
for p=1:size(bstring,2)
    subplot(1,2,p)
    shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{1})), smooth(actsemall_varcr.(bstring{p}).(varstring{1})),'lineprops',{'Color',[0.8 0.2 0.0]},'transparent',1,'patchSaturation',0.33)
    hold on
    shadedErrorBar(edges(1:end-1), smooth(actmeanall_varcr.(bstring{p}).(varstring{2})), smooth(actsemall_varcr.(bstring{p}).(varstring{2})), 'lineprops',{'Color',[0.3 0.7 0.2]},'transparent',1,'patchSaturation',0.33)
   title(bstring{p},'Fontsize',12)
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
    title(bstring{p},'Fontsize',12)
    xlabel('time (sec)','Fontsize',16)
    ylabel('z-score','Fontsize',16)
    legend(varstring{1},varstring{2},'Fontsize',12)
    axis([limi -4 3])
    suptitle(stringfile{g})
end

%%
%%% comparative matrice of cell responsiveness for all variables
% 
 [percentage]=heatmapResponsivenessMatriceOfEvents(zscored_all_varcr,varstring,bstring,stringfile,actcells_allcr,inhcells_allcr,g)
%  
[perc_actvarrc perc_inhvarrc]= pieChartPercActInh(actcells_allcr, inhcells_allcr,zscored_all_varcr,varstring,bstring,g,stringfile)
end

