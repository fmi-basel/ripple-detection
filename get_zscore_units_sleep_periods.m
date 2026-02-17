clear all
filename1=['C:\Users\h-rkim\Desktop\units_FZ\BLA_vs_FZ\fz_onset_hab2_all.mat'];   %path for mouse ID and FZ onset
load(filename1,'Mouse_ID_rem','rem_onset')

filename2=('C:\Users\h-rkim\Desktop\unit_hab_sleep_pfc\Mat data\TimeStamps.mat');    %path for spike timestamp, mouse ID
load(filename2,'Spike_TS','MouseID')

bin=0.5;         %% time bin to change 


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
for m=1:length(Mouse_ID_rem)
   current(m)=str2num(regexp(Mouse_ID_rem{m,1},'\d*','Match'));   %looking for the mouse with matching ID
end

Mice_use=unique(current);    %% mice to be used (having same name with FZ episodes)


edges=(-5:bin:10); %% egdes before and after 0


clear total_counts_mean
total_counts_mean=[];
for m=1:length(Mice_use)
        
    Use_rem=rem_onset(current==Mice_use(m));
    Use_Spike=Spike_TS(New_ID==Mice_use(m));
    
    clear Counts_mean
    for s=1:length(Use_Spike)
        
        current_neuron=Use_Spike{s};
        
        clear Binned
        for f=1:length(Use_rem)
            
            Rel=current_neuron-Use_rem(f);
            Binned(:,f)=histcounts(Rel,edges);
            
        end
        
        
        Counts_mean(:,s)=mean(Binned,2);
        
    end
    
    total_counts_mean=horzcat(total_counts_mean,Counts_mean);
    
    
end

% total_counts_mean gives the mean spike counts per time bin for each neuron

%%% get the z-score to the basal period
clear zscored 
for i=1:size(total_counts_mean,2)
    basal=total_counts_mean(1:floor(size(total_counts_mean,1)/2)-1,i);
    zscored(:,i)=(total_counts_mean(:,i)-mean(basal))./std(basal);
end

%%% ranking neurons from more activated to inhibited
effect=mean(zscored((size(total_counts_mean,1)/2)-1:end,:),1);
[a index]=sort(effect,2,'descend');
ordered=zscored(:,index)'

figure;
h=imagesc(zscored(:,index)')
set(h,'XData',edges(1:end-1))
caxis([-3 3])
xlim([-5 10])


