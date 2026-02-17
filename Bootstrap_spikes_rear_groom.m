clear all
clearvars -except Spike_TS MouseID MouseID_new groom_346 groom_350 rear_346 rear_350

filename2=('C:\Users\HARANG\HERRYTEAM Dropbox\Ha-Rang K\PAPER 2024\data ephys\bootstrap\final_nex_mat\test2\Mat data\TimeStamps.mat');
load(filename2,'Spike_TS','MouseID','MouseID_new')

number_it=1000;
nboot=100;

MouseID_new=MouseID(:,2);
clear filename2

% enter the intervals for each behavior 
S1= groom_383;
C1= rear_383;

bin=0.033333;           %%% bin size in sec

for s=1:size(Spike_TS,2)
    
    [s]
    current_spike=Spike_TS{1,s};
    current_ISI=diff([0;current_spike]);
    
    edges=(0:bin:540);
    current_binned=histcounts(current_spike,edges);
    total_binned(:,s)=current_binned;
    
    % get the spike trains in each context (S1, C1, S2)
    S1_spikes=length(find(current_spike>S1(1)&current_spike<S1(2)));
    C1_spikes=length(find(current_spike>C1(1)&current_spike<C1(2)));
    
    clear New_ISI New_TS Shuffle_S1_spikes Shuffle_C1_spikes Shuffle_S2_spikes
    for r=1:number_it
        
        % shuffle spike trains
        New_order=randperm(length(current_ISI));            % shuffling original ISI over 9 min
        New_ISI(:,r)=current_ISI(New_order);
        New_TS(:,r)=cumsum(current_ISI(New_order));         % new created ISI randomly dist. in 9min
        Shuffle_S1_spikes(r)=length(find(New_TS(:,r)>S1(1)&New_TS(:,r)<S1(2))); % shuffled ISI occuring in ctxA (position of each new TS, and total number)
        Shuffle_C1_spikes(r)=length(find(New_TS(:,r)>C1(1)&New_TS(:,r)<C1(2))); % shuffled ISI occuring in ctxB
       % Shuffle_S2_spikes(r)=length(find(New_TS(:,r)>S2(1)&New_TS(:,r)<S2(2))); % shuffled ISI occuring in ctxA'
     
% shuffle_current_binned(:,r)=histcounts(New_TS(:,r),edges);

    end
    
%     figure;
%     plot(edges(1:end-1),current_binned),hold on
%     plot(edges(1:end-1),mean(shuffle_current_binned,2)),hold on


    %%% CI calculation for each context %%%
%     ci_C1=mean(Shuffle_C1_spikes)+3.3*std(Shuffle_C1_spikes)/sqrt(length(Shuffle_C1_spikes));
%     ci_S1=mean(Shuffle_S1_spikes)+3.3*std(Shuffle_S1_spikes)/sqrt(length(Shuffle_S1_spikes));     %CI calculation
%     ci_S2=mean(Shuffle_S2_spikes)+3.3*std(Shuffle_S2_spikes)/sqrt(length(Shuffle_S2_spikes));   
%     % mean(Shuffle_C1_spikes)+2.58*std(Shuffle_C1_spikes)/sqrt(length(Shuffle_C1_spikes))
    
    %%% geting the margin with percentile %% confidence of interval
    ci_C1_act=prctile(Shuffle_C1_spikes,95);   %97.5  when activated, 2.5 inhibited
    ci_S1_act=prctile(Shuffle_S1_spikes,95);
    
    ci_C1_inh=prctile(Shuffle_C1_spikes,5);   % 95 when activated, 5 inhibited
    ci_S1_inh=prctile(Shuffle_S1_spikes,5);
    
  
%     edges2=(0:10:1000);
%     current_c1=histcounts(Shuffle_C1_spikes,edges2);
% 
%     figure;
%     bar(edges2(1:end-1),current_c1),hold on
%     plot([ci_C1 ci_C1],[0 max(current_c1)+max(current_c1)/5])
%     
    
%     ci_C1=100;
    
%     ci_C1=max(Shuffle_C1_spikes);
    
    C1_activated(s)=C1_spikes>ci_C1_act;    % >ci_C1; for activated
    S1_activated(s)=S1_spikes>ci_S1_act;
    C1_inhibited(s)=C1_spikes<ci_C1_inh;    % <ci_C1; for inhibited
    S1_inhibited(s)=S1_spikes<ci_S1_inh;
    
    
    C1_dif_a(s)=C1_spikes-ci_C1_act;
    S1_dif_a(s)=S1_spikes-ci_S1_act;
    
    C1_dif_i(s)=C1_spikes-ci_C1_inh;
    S1_dif_i(s)=S1_spikes-ci_S1_inh;

    
    All_New_ISI{s}=New_ISI;
    All_New_TS{s}=New_TS;
      
    
end

%%
%find neurones that has number of spikes >100
% C1_activated2=C1_dif>100;
% S1_activated2=S1_dif>100;
% S2_activated2=S2_dif>100;

%%% get identity of neurons activated in rearing/grooming %%
rear_act=MouseID_new(C1_activated);
groom_act=MouseID_new(S1_activated);
rear_inh=MouseID_new(C1_inhibited);
groom_inh=MouseID_new(S1_inhibited);

%%% number of neurons activated in each episode %%
Number_groom_act=sum(S1_activated);
Number_rear_act=sum(C1_activated);
Number_groom_inh=sum(S1_inhibited);
Number_rear_inh=sum(C1_inhibited);

%%% get neurons exclusively activated or inhibited %% 
total_activated=[C1_activated;S1_activated];
rear_act_only_unit=(total_activated(1,:)==1 & total_activated(2,:)==0);
groom_act_only_unit=(total_activated(1,:)==0 & total_activated(2,:)==1);
non_act_unit=(total_activated(1,:)==0 & total_activated(2,:)==0);
total_inhibited=[C1_inhibited;S1_inhibited];
rear_inh_only_unit=(total_inhibited(1,:)==1 & total_inhibited(2,:)==0);
groom_inh_only_unit=(total_inhibited(1,:)==0 & total_inhibited(2,:)==1);
non_inh_unit=(total_inhibited(1,:)==0 & total_inhibited(2,:)==0);

%%% get identity of neurons activated in rearing/grooming %%
rear_act_only =MouseID_new(rear_act_only_unit);
groom_act_only =MouseID_new(groom_act_only_unit);
non_act =MouseID_new(non_act_unit);
rear_inh_only =MouseID_new(rear_inh_only_unit);
groom_inh_only =MouseID_new(groom_inh_only_unit);
non_inh =MouseID_new(non_inh_unit);

%%% number of neurons exclusively activated/inhibited in each episode %%
Nb_rear_act_only=sum(rear_act_only_unit);
Nb_groom_act_only=sum(groom_act_only_unit);
Nb_non_act=sum(non_act_unit);
Nb_rear_inh_only=sum(rear_inh_only_unit);
Nb_groom_inh_only=sum(groom_inh_only_unit);
Nb_non_inh=sum(non_inh_unit);

clearvars -except rear_act rear_inh groom_act groom_inh rear_act_only rear_inh_only groom_act_only groom_inh_only non_act non_inh

%%% find where the '1' is on the list
a1=find(S1_activated_only==1)'   
ab=find(AB_activated==1)'
b1=find(C1_activated_only==1)' 
ba2=find(BA2_activated==1)' 
a2=find(S2_activated_only==1)' 
aa2=find(fear_activated_only==1)' 

FR_Bcell=total_binned(:,C1_activated);
FR_Bonly=total_binned(:,C1_activated_only);
FR_ABcell=total_binned(:,AB_activated);
FR_BA2cell=total_binned(:,BA2_activated);
FR_Aonly=total_binned(:,S1_activated_only);
FR_A2only=total_binned(:,S2_activated_only);
FR_AA2=total_binned(:,fear_activated_only);
FR_non_ctx=total_binned(:,non_ctx);

%% ploting z-score

%'C1 ONLY' activated neurones normalized to context A
clear use_neurons
%use_neurons=total_binned(:,find(BA2_activated));     % change use_neurons (C1, S1, S2)
use_neurons=FR_Bcell_dnr_all;

clear use_neurons_zscored current_neuron basal
for i=1:size(use_neurons,2)
    current_neuron=use_neurons(:,i);
    %basal=current_neuron(1:floor(S1(2)/bin));        %norm to A      % adapt the basal period  
    %basal = current_neuron(floor(S2(1)/bin):end); % norm to BA'
    %basal = current_neuron(1:floor(C1(2)/bin));     % norm to AB
    %basal=current_neuron(1:end);        % normalize to all period    

    use_neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
    
end
clear basal current_neuron i use_neurons
zs_Bcell_dnr_all=use_neurons_zscored
clear use_neurons_zscored

%%% plot z-score 'C1 activated' neurones normalized to context A
clear use_neurons2
use_neurons2=total_binned(:,find(C1_activated));     % change use_neurons (S1_activated C1_activated S2_activated)

use_neurons2=use_neurons_c1
clear use_neurons_zscored2
for i=1:size(use_neurons2,2)
    current_neuron2=use_neurons2(:,i);
    basal=current_neuron2(1:floor(S1(2)/bin));           % change basal period
    %basal = current_neuron(1:floor(C1(2)/bin));
    %basal = current_neuron(floor(C1(1)/bin)-1:end);
    use_neurons_zscored2(:,i)=(current_neuron2-mean(basal))./std(basal);
   
end


%%% normalized to min activity of contA %%
use_neurons=total_binned(:,find(C1_activated_only));
clear use_neurons_zscored
for i=1:size(use_neurons,2)
    current_neuron=use_neurons(:,i);
   basal1=current_neuron(1:floor(S1(2)/bin));
   %basal2=current_neuron(floor(C1(1)/bin)-1:end);
%    basal2=current_neuron(floor(S2(1)/bin)-1:end);
%    basal3=current_neuron(floor(C1(1)/bin)-1:floor(C1(2)/bin));
%    total_basal=[basal1 basal2 basal3];
   total_basal=[basal1 basal2];

   [val ind]=min(mean(total_basal,1));
   basal=total_basal(:,ind);
   use_neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
    
end

% %%% plot z-score S2 activated neurones normalized to context A
% use_neurons=total_binned(:,find(S2_activated));
% clear use_neurons_zscored
% for i=1:size(use_neurons,2)
%     current_neuron=use_neurons(:,i);
%    basal=current_neuron(1:floor(S1(2)/bin));
%    use_neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
%     
% end

figure;
plot(nanmean(zs_AA2_kept,2));


figure;
h=imagesc(ranked_zscored')
set(h,'XData',edges(1:end-1))
caxis([-3 3])
xlim([0 108])
colormap parula
colorbar
box off
suptitle('all tests B only neurons')
a=ranked_zscored(:,1)

%heatmap (without ranking)
timex=(1:1:108)
figure;
h=imagesc(zs_Bcell_dnr_all')
set(h,'XData',timex)
caxis([-3 3])
xlim([0 108])
colormap parula
colorbar
box off
suptitle('PFC test1 ranked in same order as test2')

max(Shuffle_C1_spikes)
%     figure;
%     plot(current_spike,ones(size(current_spike)),'o'),hold on
%     plot(New_TS,ones(size(New_TS))*1.5,'o')
%     xlim([1 10])
%     ylim([0 2])


figure;
plot(edges(1:end-1),use_neurons_zscored(:,12));

Bcells_frq=total_binned(:,C1_activated)
Bonly_frq=total_binned(:,C1_activated_only)
Acells_frq=total_binned(:,S1_activated)
Aonly_frq=total_binned(:,S1_activated_only)
A2cells_frq=total_binned(:,S2_activated)
A2only_frq=total_binned(:,S2_activated_only)
name1=cneurons'
name2=C1_only_unit'
%% heatmap (ranked)

clear plotvar timex fa from to name ordered order PeriodSelect ordervalue h name_order
%plotvar=Bcells_frq(:,BLA_t2_Disc);  %(:,c1_low);  %% change variable 
plotvar=zs_Bcell_dnr_all;

timex=(1:1:108)
fa=1;
from=36;%/change_time_bin;        %%% tronçon order context B= 40-72, A=4-36 A'=75-108
to=71;  %change_time_bin;

PeriodSelect=mean(plotvar(from:to,:),1);       %%% variable tronçon
[ordervalue order]=sortrows(PeriodSelect',-1); %% to get in order
ordered=plotvar(:,order);
%ordered_to_t1=plotvar(:,order_trans1);

figure;                                        %%% simple colormap figure ordered by activity at selected period
h=imagesc(plotvar(:,order)');               
%h=imagesc(plotvar(:,order_trans1)');         % change to 'order_trans1' if want to plot according to ranking of trans 1
set(h,'XData',timex)
xlim([0 108])  %[-1.9 2]
caxis([-3 3.5])                                  % adapt z score scale window
colormap parula
colorbar
box off
suptitle('PFC Bcells Disc (n=43)')

% to get identity of neurons in ranking order
name_order = name_Aonly_t2_kept(order)
name_order = C1_only_unit(order)'

PFC_t1_Bcell_name=cneurons(BLA_t2_Disc)
PFC_t2_Bonly_name=cneurons(BLA_t2_DNR)
BLA_t1_Bcell_name=cneurons(BLA_t2_Gall)
BLA_t2_Bonly_name=cneurons(BLA_t2_L)

%% heatmap with only bootstraped neurons 
clear use_neurons
use_neuron=neurons_zscored(:,find(C1_activated));     % change use_neurons (S1_activated C1_activated S2_activated)

bin=0.1;     
edges=(-1:bin:2);            %% egdes before and after 0

figure;
h=imagesc(use_neuron')
set(h,'XData',edges)
caxis([-3 4])
xlim([-1 2])
colormap parula
colorbar
box off
suptitle('TEST2 A2 cells during mobility in ctx A2')

figure;
plot(edges(1:end-1),nanmean(use_neuron,2));  

%% Heatmap per behavior types 
% load before in the workspace *unit numbers* per behav groups

clear use_neurons 
clear behav_neu behav_neu_name
use_neurons=allanims_t2(:,find(C1_activated_only));     % change use_neurons (C1, S1, S2)
behav_neu=use_neurons;

%behav_neu=use_neurons(:,gene_t1);     % select from context neurons, behavioral type 
%behav_neu_name=s1neurons(DNR_t1);           % give neuon names 

clear use_neurons_zscored
for i=1:size(behav_neu,2)
    current_neuron=behav_neu(:,i);
    basal=current_neuron(1:floor(S1(2)/bin));           % adapt the basal period  
    %basal=current_neuron(floor(S1(1)/bin)-1:floor(C1(2)/bin));
    use_neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
    
end

figure;
plot(edges(1:end-1),nanmean(use_neurons_zscored,2));

figure;
h=imagesc(zscored_gene_alltest')
set(h,'XData',edges(1:end-1))
caxis([-3 3])
xlim([0 540])
colormap parula
colorbar
box off
suptitle('Test1 low fear B cells')
