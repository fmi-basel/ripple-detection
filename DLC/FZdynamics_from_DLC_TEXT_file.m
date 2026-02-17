clear all
filename=['D:\HERRYTEAM Dropbox\Ha-Rang K\DLC - analysed & results\M329-M389 BEHAV\BEHAV results (.txt)\m_fz_nk_editor_M383_Test2.txt'] ;
data=load(filename);

TimeEpisode=data(:,2)-data(:,1);
DeleteFreez=TimeEpisode<0.5;        %% 0.5 to take all FZ epi or 1sec 

data_sorted=data;
data_sorted(find(DeleteFreez),:)=[];

total_time_freezing=sum(data_sorted(:,2)-data_sorted(:,1));

FreezTotal=[];
for i=1:length(data_sorted)
   
    CurrentFreez=(data_sorted(i,1):1/30:data_sorted(i,2)+1/30)';
    FreezTotal=vertcat(FreezTotal,CurrentFreez);
    
end

sizebin=0.0333333;                       %%%   bin size in sec
edges=(0:sizebin:540);
PercFreezing_1=transpose((histcounts(FreezTotal,edges))./(sizebin*30))*100;  %%% *100 =already in %FZ


sizebin2=30;                       %%%   bin size in sec
edges2=(0:sizebin2:540);
PercFreezing_2=transpose((histcounts(FreezTotal,edges2))./(sizebin2*30))*100;  %%% *100 =already in %FZ

sizebin3=60;                       %%%   bin size in sec
edges3=(0:sizebin3:540);
PercFreezing_3=transpose((histcounts(FreezTotal,edges3))./(sizebin3*30))*100;  %%% *100 =already in %FZ

sizebin4=180;                       %%%   bin size in sec
edges4=(0:sizebin4:540);
PercFreezing_4=transpose((histcounts(FreezTotal,edges4))./(sizebin4*30))*100;  %%% *100 =already in %FZ



% sizebin=10;                      %%%  bin size in sec
% edges=(0:sizebin:540);
% DynamicFreezing_10=transpose(histcounts(FreezTotal,edges))./(sizebin*30);

% xtime=(10:sizebin:540);
% figure;
% plot(xtime,DynamicFreezing)
% 
% 
% a=FreezTotal(find(FreezTotal>180&FreezTotal<190));
% length(a)/(sizebin*30)