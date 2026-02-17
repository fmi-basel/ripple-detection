clear all

filename2=('C:\Users\h-rkim\Desktop\Kept_neurons.mat');
load(filename2,'Spike_TS_1_kept','Same_neuron_1','Spike_TS_2_kept','Same_neuron_2','New_ID_1','New_ID_2')

number_it=1000;
nboot=100;

S1=[15 179.883900];
C1=[195.345800 359.864700];
S2=[375.352600 539.855600];
% S1=[0 180];
% C1=[180 360];
% S2=[360 540];
C1=[195 360];

Reference_test=Spike_TS_1_kept;             %% change the ref & no ref
No_reference=Spike_TS_2_kept;               %% if following neu in test1 at test2 ref=TS_1, no ref=TS_2

bin=5;                   %%% in sec

for s=1:size(Reference_test,2)
    
    [s]
    current_spike=Reference_test{1,s};
    current_ISI=diff([0;current_spike]);
    
    edges=(0:bin:540);
    current_binned=histcounts(current_spike,edges);
    total_binned(:,s)=current_binned;
    
    current_spike_no_ref=No_reference{1,s};
    current_binned_no_ref=histcounts(current_spike_no_ref,edges);
    total_binned_no_ref(:,s)=current_binned_no_ref;   
    
    
    
    S1_spikes=length(find(current_spike>S1(1)&current_spike<S1(2)));
    C1_spikes=length(find(current_spike>C1(1)&current_spike<C1(2)));
    S2_spikes=length(find(current_spike>S2(1)&current_spike<S2(2)));
    
    clear New_ISI New_TS Shuffle_S1_spikes Shuffle_C1_spikes Shuffle_S2_spikes
    for r=1:number_it
        
        New_order=randperm(length(current_ISI));
        New_ISI(:,r)=current_ISI(New_order);
        New_TS(:,r)=cumsum(current_ISI(New_order));
        Shuffle_S1_spikes(r)=length(find(New_TS(:,r)>S1(1)&New_TS(:,r)<S1(2)));
        Shuffle_C1_spikes(r)=length(find(New_TS(:,r)>C1(1)&New_TS(:,r)<C1(2)));
        Shuffle_S2_spikes(r)=length(find(New_TS(:,r)>S2(1)&New_TS(:,r)<S2(2)));
%         shuffle_current_binned(:,r)=histcounts(New_TS(:,r),edges);
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
    ci_C1=prctile(Shuffle_C1_spikes,97.5);
    ci_S1=prctile(Shuffle_S1_spikes,97.5);
    ci_S2=prctile(Shuffle_S2_spikes,97.5);
  
%     edges2=(0:10:1000);
%     current_c1=histcounts(Shuffle_C1_spikes,edges2);
% 
%     figure;
%     bar(edges2(1:end-1),current_c1),hold on
%     plot([ci_C1 ci_C1],[0 max(current_c1)+max(current_c1)/5])
%     
    
%     ci_C1=100;
    
%     ci_C1=max(Shuffle_C1_spikes);
    
    C1_activated(s)=C1_spikes>ci_C1;
    S1_activated(s)=S1_spikes>ci_S1;
    S2_activated(s)=S2_spikes>ci_S2;
    
    C1_dif(s)=C1_spikes-ci_C1;
    S1_dif(s)=S1_spikes-ci_S1;
    S2_dif(s)=S2_spikes-ci_S2;
    
    All_New_ISI{s}=New_ISI;
    All_New_TS{s}=New_TS;
      
    
end

%%



%%% get neurons exclusively activated in one context %% 
total_activated=[C1_activated;S1_activated;S2_activated];
C1_activated_only=(total_activated(1,:)==1 & total_activated(2,:)==0 & total_activated(3,:)==0);
S1_activated_only=(total_activated(1,:)==0 & total_activated(2,:)==1 & total_activated(3,:)==0);
S2_activated_only=(total_activated(1,:)==0 & total_activated(2,:)==0 & total_activated(3,:)==1);
fear_activated_only=(total_activated(1,:)==0 & total_activated(2,:)==1 & total_activated(3,:)==1);

% %%% plot z-score C1 activated neurones normalized to context A
% use_neurons=total_binned(:,find(S2_activated));
% clear use_neurons_zscored
% for i=1:size(use_neurons,2)
%     current_neuron=use_neurons(:,i);
%    basal=current_neuron(1:floor(S1(2)/bin));
%    use_neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
%     
% end

%%% normalized to min activity of contA %%
use_neurons=total_binned(:,find(C1_activated_only));
clear use_neurons_zscored
for i=1:size(use_neurons,2)
    current_neuron=use_neurons(:,i);
   basal1=current_neuron(1:floor(S1(2)/bin));
   basal2=current_neuron(floor(S2(1)/bin)-1:end);
   basal3=current_neuron(floor(C1(1)/bin)-1:floor(C1(2)/bin));
   total_basal=[basal1 basal2 basal3];
   [val ind]=min(mean(total_basal,1));
   basal=total_basal(:,ind);
   use_neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
    
end

use_neurons_2=total_binned_no_ref(:,find(C1_activated_only));
clear use_neurons_zscored_2
for i=1:size(use_neurons_2,2)
    current_neuron=use_neurons_2(:,i);
   basal1=current_neuron(1:floor(S1(2)/bin));
   basal2=current_neuron(floor(S2(1)/bin)-1:end);
   basal3=current_neuron(floor(C1(1)/bin)-1:floor(C1(2)/bin));
   total_basal=[basal1 basal2 basal3];
   [val ind]=min(mean(total_basal,1));
   basal=total_basal(:,ind);
   use_neurons_zscored_2(:,i)=(current_neuron-mean(basal))./std(basal);
    
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
plot(edges(1:end-1),nanmean(use_neurons_zscored,2)),hold on
plot(edges(1:end-1),nanmean(use_neurons_zscored_2,2));

figure;
subplot(2,1,1)
h=imagesc(use_neurons_zscored')
set(h,'XData',edges(1:end-1))
caxis([-3 3])
xlim([0 540])
subplot(2,1,2)
h=imagesc(use_neurons_zscored_2')
set(h,'XData',edges(1:end-1))
caxis([-3 3])
xlim([0 540])