clear all

filename1=['C:\Users\h-rkim\Desktop\units_FZ\BLA_vs_FZ\fz_onset_hab2_all.mat'];   %path for mouse ID and FZ onset
load(filename1,'Mouse_ID_FZ','FZ_onset')

filename2=('C:\Users\h-rkim\Desktop\units_bla_hab1-2\Mat data\TimeStamps_hab2.mat');    %path for spike timestamp, mouse ID
load(filename2,'Spike_TS','MouseID')

%%
bin=0.1;         %% time bin to change 


 MouseID_num = regexp(MouseID(:,1),'\d*','Match');
 MouseID_P=   strfind(MouseID(:,2),'P');
 
 
 %%% rename the mouse ID with only numbers (for spike mouse)
 clear New_ID
 for i=1:size(MouseID_num,1)  
     current_mouse=MouseID_num{i}(2);
     New_ID(i,1)=str2num(current_mouse{1,1});   % get the name of ID mouse
%      MID=MouseID{i,2};                        % get neuron name 
%      New_ID{i,2}=MID(1:MouseID_P{i}(2)-1);   
 end

 %%% rename mouse ID w/ numbers (for FZ mouse)
clear current
for m=1:length(Mouse_ID_FZ)
   current(m)=str2num(regexp(Mouse_ID_FZ{m,1},'\d*','Match'));   %looking for the mouse with matching ID
end

Mice_use=unique(current);    %% mice to be used (having same name with FZ episodes)

edges=(-2:bin:2);            %% egdes before and after 0

total_counts_mean=[];

for m=1:length(Mice_use)
        
    Use_fz=FZ_onset(current==Mice_use(m));
    Use_Spike=Spike_TS(New_ID==Mice_use(m));
    
    clear Counts_mean
    for s=1:length(Use_Spike)
        
        current_neuron=Use_Spike{s};
        
        clear Binned
        % counting all spikes that occur around each FZ_onset at edges (-2; +2sec)
        for f=1:length(Use_fz)
            
            Rel=current_neuron-Use_fz(f);
            Binned(:,f)=histcounts(Rel,edges);
            
        end
        
        % make mean of all spike count around FZ bout at each time bin
        Counts_mean(:,s)=mean(Binned,2);
        
    end
    
    % total_counts_mean gives the mean spike counts per neurons at each time bin
    total_counts_mean=horzcat(total_counts_mean,Counts_mean);
    
    
end


%%% get the z-score to the basal period
clear zscored 
for i=1:size(total_counts_mean,2)
    basal=total_counts_mean(1:floor(size(total_counts_mean,1)/2)-1,i);
    zscored(:,i)=(total_counts_mean(:,i)-mean(basal))./std(basal);
end


%%
%%% ranking neurons from more activated to inhibited
effect=mean(zscored((size(total_counts_mean,1)/2)-1:end,:),1);
[a index]=sort(effect,2,'descend');

effect=mean(a_only((size(a_only,1)/2)-1:end,:),1);
[a index]=sort(effect,2,'descend');

figure;
h=imagesc(zscored(:,index)')
set(h,'XData',edges(1:end-1))
caxis([-1.5 1.5])
xlim([-2 2])


%% ranking with only A cells (or B cells)
clear plotvar t timex to from fa order ordervalue PeriodSelect
plotvar=a_only;

timex=(0.1:0.1:4)-1.9;         % when ploting from -2 to +2
fa=1;
from=21;%/change_time_bin;        %%% tronçon order 
to=30;%change_time_bin;            %% from 21-40 = from 0 to 2

PeriodSelect=mean(plotvar(from:to,:),1);       %%% variable tronçon
[ordervalue order]=sortrows(PeriodSelect',-1); %% to get in order

figure;                                        %%% simple colormap figure ordered by activity at selected period
h=imagesc(plotvar(:,order)');               
set(h,'XData',timex)
xlim([-2 1])  %[-1.9 2]
caxis([-3 3])                                  % adapt z score scale window
colormap parula
colorbar
box off

t=plotvar(:,order);