clear all 

numofmice=10; % put the number of total animals (number of files to analyze)
FreezDet=NaN(16201,numofmice); % change numbers of frames (here 9001= 5' video)
timebin=5400; % bin size in frame, (ex: 10sec=300frames)
edges=(1:timebin:16201);
fr=1/30;

for i=1:numofmice
   % filename=['E:\HA-RANG\plexon\video\test\' num2str(i) '.csv'] %% put here the directory of the folder
   filename=['D:\HERRYTEAM Dropbox\Ha-Rang K\BEHAVIOR - groups & analyses\M260-269\D4-test2\' num2str(i) '.csv']
T = readtable(filename); %% this opens the excel file 
FreezDet(:,i)=table2array(T(1:16201,7)); % means it will consider column 7 of each table 
PointsFreez{i}=find(FreezDet(:,i));

% 
[FreezInBin(:,i) b]=histcounts(PointsFreez{i},edges);

end

% % fz_int=[FreezDet;PointsFreez(i),PointsFreez(i+1)]



% [B, N, Ind] = RunLength(FreezDet);
% Ind         = [Ind, length(FreezDet)+1];
% Multiple    = find(N = 1);
% Start       = Ind(Multiple);
% Stop        = Ind(Multiple + 1) - 1;
% 
% figure;
% plot(mean(FreezDet,2))
% ylim([-0.1 1.1])
% 
xtime=((edges(1:end-1)*fr));

FreezPerc=FreezInBin./timebin;

%
figure;
plot(xtime,mean(FreezPerc(:,:),2)) % the plot of mean FZ for all mice 
xlabel('Time (sec)');
ylabel('Freezing (%)'); ylim([0 1])

MEANCURVE=mean(FreezPerc(:,:),2);

clear ERRORSEM
for i=1:size(FreezPerc,1)
ERRORSEM(i,1)=(nanstd(FreezPerc((i),:),1))./(sqrt(size(FreezPerc,2)));
end

xtime2(xtime./60)+1;
figure;
errorbar(xtime,MEANCURVE,ERRORSEM,'color',[0.8 1 0.8],'LineWidth',15),hold on % "hold on" to fusion the two graphs
plot(xtime,mean(FreezPerc(:,:),2))% line graph of mean FZ for all mice + fused w/ SEM
ylim([0 1])
xlim([0.5 9.5])
box off
bar(xtime2,(mean(FreezPerc(:,:),2)),'y') % bar graph of mean FZ for all mice + fused w/ SEM (run the script without the line above)

% errorbar(MEANCURVE,(nanstd(PLOTEDCURVE')./sqrt(length(excelFile))),'color',[0.8 1 0.8],'capsize',0,'LineWidth',15),hold on
% plot(MEANCURVE,'color',[0.2 1 0.2],'LineWidth',5)
% hold
xtime2=xtime;
figure;
bar(xtime,(mean(FreezPerc(:,:),2)),'y') % bar graph of mean FZ for all mice

mouseofchoice=1;  % FZ dynamic plot of ONE animal:enter the name of mouse I want
figure;
plot(xtime,FreezPerc(:,mouseofchoice)) 
ylim([0 1])

figure; % the plot of each individual animal in gray scale
imagesc(FreezPerc(:,:)')
colormap gray
caxis([0 1])
colorbar

figure; % bar graph of mean FZ + gray scale of each mouse 
subplot(8,1,1:4)
bar(xtime,(mean(FreezPerc(:,:),2)),'y') % bar graph of mean FZ for all mice
xlim([-3 538])
xticks([])
subplot(8,1,5:8)
imagesc(FreezPerc(:,:)')% the plot of each individual animal
colormap gray
caxis([0 1])

figure; % bar graph of mean FZ + gray scale of each mouse 
subplot(8,1,1:4)
bar(xtime,(mean(FreezPerc(:,:),2)),'y'),hold on % bar graph of mean FZ for all mice
subplot(8,1,5:8)
imagesc(FreezPerc(:,:)')% the plot of each individual animal
colormap gray
caxis([0 1])
colorbar

% figure;
% subplot(8,1,1:4)
% errorbar(xtime,MEANCURVE,ERRORSEM,'color',[0.8 1 0.8],'LineWidth',15),hold on % "hold on" to fusion the two graphs
% plot(xtime,mean(FreezPerc(:,:),2))% line graph of mean FZ for all mice + fused w/ SEM
% ylim([0 1]), hold on
% subplot(8,1,5:8)
% imagesc(FreezPerc(:,:)')% the plot of each individual animal
% colormap gray
% caxis([0 1])
% colorbar