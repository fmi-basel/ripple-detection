clear all

filename2=('C:\Users\hrkim\Desktop\final_nex_mat\test2\Mat data\TimeStamps.mat');
load(filename2,'Spike_TS','MouseID_new','MouseID');

number_it=1000;
nboot=100;
% 
S1=[15 179.883900];
C1=[195.345800 359.864700];
S2=[375.352600 539.855600];

% CONTROL (context specificity)
%C1= [15 90];
%S1=[90 270];
%S2=[270 450];

% S1=[15 300];        % for FC
% C1=[300 540];

% S1=[0 180];
% C1=[180 360];
% S2=[360 540];

bin=5;                   %%% in sec

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
    S2_spikes=length(find(current_spike>S2(1)&current_spike<S2(2)));
    
    clear New_ISI New_TS Shuffle_S1_spikes Shuffle_C1_spikes Shuffle_S2_spikes
    for r=1:number_it
        
        % shuffle spike trains
        New_order=randperm(length(current_ISI));
        New_ISI(:,r)=current_ISI(New_order);
        New_TS(:,r)=cumsum(current_ISI(New_order));
        Shuffle_S1_spikes(r)=length(find(New_TS(:,r)>S1(1)&New_TS(:,r)<S1(2)));
        Shuffle_C1_spikes(r)=length(find(New_TS(:,r)>C1(1)&New_TS(:,r)<C1(2)));
        Shuffle_S2_spikes(r)=length(find(New_TS(:,r)>S2(1)&New_TS(:,r)<S2(2)));
     
% shuffle_current_binned(:,r)=histcounts(New_TS(:,r),edges);
    end
    
%     figure;
%     plot(edges(1:end-1),current_binned),hold on
%     plot(edges(1:end-1),mean(shuffle_current_binned,2)),hold on


    %%% bootstrap CI %%%
%     ci_S1=bootci(nboot,{@mean,(Shuffle_S1_spikes)},'alpha',0.01,'type','stud');
%     ci_C1=bootci(nboot,{@mean,(Shuffle_C1_spikes)},'alpha',0.01,'type','stud');
%     ci_S2=bootci(nboot,{@mean,(Shuffle_S2_spikes)},'alpha',0.01,'type','stud');


    %%% CI calculation for each context %%%
%     ci_C1=mean(Shuffle_C1_spikes)+3.3*std(Shuffle_C1_spikes)/sqrt(length(Shuffle_C1_spikes));
%     ci_S1=mean(Shuffle_S1_spikes)+3.3*std(Shuffle_S1_spikes)/sqrt(length(Shuffle_S1_spikes));     %CI calculation
%     ci_S2=mean(Shuffle_S2_spikes)+3.3*std(Shuffle_S2_spikes)/sqrt(length(Shuffle_S2_spikes));   
%     % mean(Shuffle_C1_spikes)+2.58*std(Shuffle_C1_spikes)/sqrt(length(Shuffle_C1_spikes))
    
    %%% geting the margin with percentile %%
    ci_C1=prctile(Shuffle_C1_spikes,95);   %97.5  when activated, 2.5 inhibited
    ci_S1=prctile(Shuffle_S1_spikes,95);
    ci_S2=prctile(Shuffle_S2_spikes,95);
  
%     edges2=(0:10:1000);
%     current_c1=histcounts(Shuffle_C1_spikes,edges2);
% 
%     figure;
%     bar(edges2(1:end-1),current_c1),hold on
%     plot([ci_C1 ci_C1],[0 max(current_c1)+max(current_c1)/5])
%     
    
%     ci_C1=100;
    
%     ci_C1=max(Shuffle_C1_spikes);
    
    C1_activated(s)=C1_spikes>ci_C1;    % >ci_C1; for activated
    S1_activated(s)=S1_spikes>ci_S1;
    S2_activated(s)=S2_spikes>ci_S2;
    
    C1_dif(s)=C1_spikes-ci_C1;
    S1_dif(s)=S1_spikes-ci_S1;
    S2_dif(s)=S2_spikes-ci_S2;
    
    All_New_ISI{s}=New_ISI;
    All_New_TS{s}=New_TS;
      
    
end

%%
%find neurones that has number of spikes >100
% C1_activated2=C1_dif>100;
% S1_activated2=S1_dif>100;
% S2_activated2=S2_dif>100;

% number of neurons activated in each context
Number_S1=sum(S1_activated);
Number_C1=sum(C1_activated);
Number_S2=sum(S2_activated);

%%% get identity of neurons activated in C1 %%
cneurons=MouseID_new(C1_activated);
s1neurons=MouseID_new(S1_activated);
s2neurons=MouseID_new(S2_activated);

%%% get neurons exclusively activated in one context %% 
total_activated=[C1_activated;S1_activated;S2_activated];
C1_activated_only=(total_activated(1,:)==1 & total_activated(2,:)==0 & total_activated(3,:)==0);
S1_activated_only=(total_activated(1,:)==0 & total_activated(2,:)==1 & total_activated(3,:)==0);
S2_activated_only=(total_activated(1,:)==0 & total_activated(2,:)==0 & total_activated(3,:)==1);
fear_activated_only=(total_activated(1,:)==0 & total_activated(2,:)==1 & total_activated(3,:)==1);
C1_S2_act=(total_activated(1,:)==1 & total_activated(2,:)==0 & total_activated(3,:)==1);
S1_C1_act=(total_activated(1,:)==1 & total_activated(2,:)==1 & total_activated(3,:)==0);
non_ctx=(total_activated(1,:)==0 & total_activated(2,:)==0 & total_activated(3,:)==0);

Number_S1_only=sum(S1_activated_only);
Number_C1_only=sum(C1_activated_only);
Number_S2_only=sum(S2_activated_only);
Number_fear=sum(fear_activated_only);
Number_C1_S2=sum(C1_S2_act);
Number_S1_C1=sum(S1_C1_act);
Number_non_ctx=sum(non_ctx);

C1_only_unit=MouseID_new(C1_activated_only);
S1_only_unit=MouseID_new(S1_activated_only);
S2_only_unit=MouseID_new(S2_activated_only);
fear_unit=MouseID_new(fear_activated_only);
C1_S2_unit=MouseID_new(C1_S2_act);
C1_S1_unit=MouseID_new(S1_C1_act);
non_ctx_unit=MouseID_new(non_ctx);


%% plot z-score 'C1 ONLY' activated neurones normalized to context A
clear use_neurons
use_neurons=total_binned(:,find(C1_activated));     % change use_neurons (C1, S1, S2)

use_neurons=use_neurons_c1only
clear use_neurons_zscored
for i=1:size(use_neurons,2)
    current_neuron=use_neurons(:,i);
    basal=current_neuron(1:floor(S1(2)/bin));           % adapt the basal period  
    %basal = current_neuron(1:floor(C1(2)/bin));
    use_neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
    
end


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
   basal2=current_neuron(floor(C1(1)/bin)-1:end);
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
plot(edges(1:end-1),nanmean(use_neurons_zscored,2));

figure;
h=imagesc(alltest_c1_only_zscored')
set(h,'XData',edges(1:end-1))
caxis([-3 3])
xlim([0 540])
colormap parula
colorbar
box off
suptitle('all tests B only neurons')

max(Shuffle_C1_spikes)
%     figure;
%     plot(current_spike,ones(size(current_spike)),'o'),hold on
%     plot(New_TS,ones(size(New_TS))*1.5,'o')
%     xlim([1 10])
%     ylim([0 2])


figure;
plot(edges(1:end-1),use_neurons_zscored(:,12));

%% heatmap (ranked)
clear t1 t2 plotvar timex fa from to name ordered order orderCopy PeriodSelect ordervalue

t1_PN=neurons_zscored_t1_noFZ(:,t1_PFC_PN);   
t2_PN=neurons_zscored_t2_noFZ(:,t2_PFC_PN);  

t1_IN=neurons_zscored_t1_noFZ(:,t1_PFC_IN);   
t2_IN=neurons_zscored_t2_noFZ(:,t2_PFC_IN);

plotvar=t1_PN+t2_PN;  %% change variable 


timex=(1:1:30)
fa=1;
from=11;%/change_time_bin;        %%% tronçon order trans 1 
to=20;  %change_time_bin;

PeriodSelect=mean(plotvar(from:to,:),1);       %%% variable tronçon
[ordervalue order]=sortrows(PeriodSelect',-1); %% to get in order
ordered=plotvar(:,order);

figure;                                        %%% simple colormap figure ordered by activity at selected period
h=imagesc(plotvar(:,orderCopy)');               
set(h,'XData',timex)
xlim([0 30])  %[-1.9 2]
caxis([-3 4])                                  % adapt z score scale window
colormap parula
colorbar
box off
suptitle('B cells noFZ in ctxB disc (n=125)')

% to get identity of neurons in ranking order
name = alltest_c1_only_neurons(order)

% mean of all plotvar + sem + shadedSEM
clear mean sem 
mean= nanmean(plotvar,2)';
sem=nanstd(plotvar')/sqrt(length(plotvar));

edges=(1:1:30)  % length of plotvar
figure;
shadedErrorBar(edges, smooth(mean), smooth(sem),'lineprops',{'Color',[0.8 0.2 0.0]},'transparent',1,'patchSaturation',0.33)

%% heatmap with only bootstraped neurons /R FZ bouts
% first load zscore to FZ bouts 
clear use_neurons
use_neuron=neurons_zscored(:,find(C1_activated));  %neurons_zscored = zscore to FZ   

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
suptitle('T2 PFC B cells during mobility in ctxA2')

%figure;
%plot(edges(1:end-1),nanmean(use_neuron,2));  

clear use_neurons2
use_neuron2=neurons_zscored(:,find(C1_activated_only));  %neurons_zscored = zscore to FZ   

figure;
h=imagesc(use_neuron2')
set(h,'XData',edges)
caxis([-3 4])
xlim([-1 2])
colormap parula
colorbar
box off
suptitle('T2 PFC B only during mobility in ctxA2')


%% Heatmap per behavior types 
% load before in the workspace *unit numbers* per behav groups
clear use_neurons 
clear behav_neu behav_neu_name
use_neurons=total_binned(:,find(C1_activated));     % change use_neurons (C1, S1, S2)


behav_neu=use_neurons; %(:,disc_t2_bla);     % select from context neurons, behavioral type 
%behav_neu_name=cneurons(disc_t1);           % give neuon names 

clear use_neurons_zscored
for i=1:size(behav_neu,2)
    current_neuron=behav_neu(:,i);
    basal=current_neuron(1:floor(S1(2)/bin));           % adapt the basal period  
    use_neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
    
end

figure;
plot(edges(1:end-1),nanmean(use_neurons_zscored,2));

figure;
h=imagesc(use_neurons_zscored')
set(h,'XData',edges(1:end-1))
caxis([-3 3])
xlim([0 540])
colormap parula
colorbar
box off
suptitle('Test2 low fear B cells')
