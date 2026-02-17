clear ripwindow spk_all_count mean_all shuffle_all
clear SPK*
% import SPK and rippleLoc first 

%% concatenate all SPK files
who SPK*
C = who('SPK*');

for i=1:length(C)
    Num_spk(i)=length(eval(C{i,1}))
end

Matrix_TS=NaN(max(Num_spk),length(C));

for i=1:length(C)
    Matrix_TS(1:length(eval(C{i,1})),i)=(eval(C{i,1}));
end


%%
spk_all_count=[];
shuffle_all=[];
spk_all=Matrix_TS;
tic

Time_range=0.5; 
Time_bin=0.01;
N_IT=100;           % number of shuffle iteration
N_RI_IT=1000;       % number of shuffle selected

FP55_LocRipples(find(FP55_LocRipples<Time_range))=[];

Ind_it_neurons=cell(1,size(spk_all,2));
Mean_it_neurons=NaN(100,size(spk_all,2));
Normal_mean=NaN(100,size(spk_all,2));

for n=1:size(spk_all,2)
    
    n
    
   current_neuron=spk_all(:,n);
   
   Current_histo=NaN(100,length(FP55_LocRipples));
   for r=1:length(FP55_LocRipples)
       current_ripple=FP55_LocRipples(r,:);
       
%        edges=(current_ripple-Time_range:Time_bin:current_ripple+Time_range);
       
       Number_spikes(r)=length(find(current_neuron>current_ripple-Time_range&current_neuron<current_ripple+Time_range));
       
       Current_diff=current_neuron-current_ripple;
       edges=(-Time_range:Time_bin:Time_range);
       
       Current_histo(:,r)=histcounts(Current_diff,edges);
     
   end
   
   Store_it=NaN(100,N_IT);
   for it=1:N_IT
       Random_rip=randperm(length(FP55_LocRipples),N_RI_IT);
       It_ripple=mean(Current_histo(:,Random_rip),2);
       
       Store_it(:,it)=It_ripple;
       
   end
   
   It_mean=mean(Store_it,2);
   
   Ind_it_neurons{1,n}=Store_it;     % each neuron for mean each shuffle ripples
   Mean_it_neurons(:,n)=It_mean;     % neuron to mean of all shuffle ripple 
   Normal_mean(:,n)=mean(Current_histo,2);   % neuron to mean all normal ripples 
    
end
toc 

figure;
plot(edges(1:end-1),Mean_it_neurons./(0.01)),hold on     % hito of all neurons in FRQ (shuffle ripple)

figure;
plot(edges(1:end-1),Normal_mean./(0.01)),hold on         % hito of all neurons in FRQ (normal ripple)

figure;
plot(It_mean./(0.01)),hold on
plot(mean(Current_histo,2)./(0.01)),hold on

ylim([15.9 21])
