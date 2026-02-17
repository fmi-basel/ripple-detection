clear all 

numofmice=4; % put the number of total animals (number of files to analyze)
SpeedDet=NaN(9001,numofmice); % change numbers of frames (here 9001= 5' video)
timebin=300; % bin size, every 10sec (=300frames)
edges=(1:timebin:9001);


mean_per_mouse=[]

for i=1:numofmice
   % filename=['E:\HA-RANG\plexon\video\test\' num2str(i) '.csv'] %% put here the directory of the folder
   filename=['D:\Ha-Rang Plexon analyses\For ploting on mathlab\test1\' num2str(i) '.csv']
T = readtable(filename); %% this opens the excel file 
SpeedDet(:,i)=table2array(T(1:9001,9)); % means it will consider column 7 of each table 
PointsSpeed{i}=find(SpeedDet(:,i));

    mean_per_bin=[]
    for interest_i=edges
        if interest_i==1
            continue
        else index=interest_i-300
            mean_a=mean(SpeedDet(index:interest_i,i))
            mean_per_bin = cat(1,mean_per_bin, mean_a)
        end
    end
    
    mean_per_mouse(:,i)=mean_per_bin
    
         
end

mean_group=mean(mean_per_mouse,2) %mean of all mice for each time bin 

%SEM = std((mean_group)/sqrt(length(mean_group)),2)
%errorbar(mean_group,(nanstd(mean_per_mouse)./sqrt(length(mean_per_mouse))))

figure;
plot(mean_group) % the plot of mean FZ for all mice 
xlabel('Time (sec)');
ylabel('Speed (cm/s)');


figure;
bar(mean_group,'y') % bar graph of mean FZ for all mice

figure;
plot(mean_per_mouse(:,:)) % the plot of each individual animal
