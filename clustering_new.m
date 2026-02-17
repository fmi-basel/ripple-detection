%%
clear all 
close all
% get AUC & Half spike width 
%neu=0;
files1 = {'m330-test1_all.mat','m331-test1_all.mat','m332-test1_all.mat','m334-test1_all.mat','m335-test1_all.mat','m336-test1_all.mat','m337-test1_all.mat','m338-test1_all.mat','m339-test1_all.mat','m340-test1_all.mat','m341-test1_all.mat','m342-test1_all.mat','m343-test1_all.mat','m344-test1_all.mat',...
          'm345-test1_all.mat','m346-test1_all.mat','m347-test1_all.mat','m348-test1_all.mat','m349-test1_all.mat','m350-test1_all.mat','m351-test1_all.mat','m352-test1_all.mat','m353-test1_all.mat','m354-test1.mat','m355-test1_all.mat','m356-test1.mat','m357-test1_all.mat','m358-test1_all.mat','m359-test1_all.mat','m360-test1_all.mat','m361-test1_all.mat',};
files2 = {'m331-test2_all.mat','m332-test2_all.mat','m334-test2_all.mat','m335-test2_all.mat','m336-test2_all.mat','m337-test2_all.mat','m338-test2_all.mat','m339-test2_all.mat','m340-test2_all.mat','m341-test2_all.mat','m342-test2_all.mat','m343-test2_all.mat','m344-test2_all.mat','m345-test2_all.mat','m346-test2_all.mat',...
          'm347-test2_all.mat','m348-test2_all.mat','m349-test2_all.mat','m350-test2_all.mat','m351-test2_all.mat','m352-test2_all.mat','m353-test2_all.mat','m354-test2.mat','m355-test2_all.mat','m356-test2_all.mat','m357-test2_all.mat','m358-test2_all.mat','m359-test2_all.mat','m360-test2_all.mat','m361-test2_all.mat'};

%% suzana pl-dlpag paper


files={files1,files2,files3}; %files1,files2,files3, files4;
 bstring={'BLA','PL'}; 
 %bstring={'all'};
 sessstring={'test1','test2'}; %'test1', 'test2'
 

 for j=1:size(sessstring,2)
     clearvars -except file files4 files1 files2 files3 files6 bstring sessstring j  files
     file=files{j};
     for k=1:size(bstring,2)
         
         fqall=[];
         aucall=[];
         hswall=[];
         for p = 1:numel(file)  [auc hsw fq ] = aucHswFq(file,p,k);
             
             fqall=[fqall fq]; aucall=[aucall auc']; hswall=[hswall hsw'];
         end
         fqrc.(bstring{k})=fqall;
         aucrc.(bstring{k})=aucall;
         hswrc.(bstring{k})=hswall;
         
     end
     dat(:,1)=hswrc;
     dat(:,2)=aucrc;
     dat(:,3)=fqrc;


%%% Organize the data entered into a single matrix   

% datc=[dat(1).Caudal; dat(2).Caudal; dat(3).Caudal]';
% datr=[dat(1).Rostral; dat(2).Rostral; dat(3).Rostral]';
% datall=[[dat(1).Rostral dat(1).Caudal]; [dat(2).Rostral dat(2).Caudal]; [dat(3).Rostral dat(3).Caudal]]';

datall=[dat(1).All; dat(2).All; dat(3).All]';

%%  K-means Clustering %%
numclust=2; %insert number of clusters
%rostral caudal clustering
%[cridx,cmeans]=kmeans(datr,numclust,'dist','sqeuclidean');
%[ccidx,cmeans]=kmeans(datc,numclust,'dist','sqeuclidean');%%  K-means Clustering
[cidx,cmeans]=kmeans(datall,numclust,'dist','sqeuclidean');%%  K-means Clustering

%% find PPN and PIN

%rIN=find(cridx==2);
%rPN=find(cridx==1);
%cIN=find(ccidx==2);
%cPN=find(ccidx==1);
PN=find(cidx==1);
IN=find(cidx==2);

datPN=datall(PN,:);
datIN=datall(IN,:);
%datcPN=datc(cPN,:);
%datrPN=datr(rPN,:);
%datcIN=datc(cIN,:);
%datrIN=datr(rIN,:);
%save(sessstring{j},'rPN','cPN','rIN','cIN','datcPN','datcIN','datrPN','datrIN','PN','IN','datPN','datIN')
save(sessstring{j},'PN','IN','datPN','datIN')

%% Plots K-means
%close all
figure;
ptsymb = {'k^','k.','gd','g.','mo','c^'};
for i = 1:numclust
    clust = find(cidx==i);
    plot3(datall(clust,1),datall(clust,2),datall(clust,3),ptsymb{i},'Markersize',5);
    hold on
end

% ptsymb = {'o','^'};%,'gd','g.','mo','c^'};
% for i = 1:numclust
%     clust = find(cridx==i);
%     plot3(datr(clust,1),datr(clust,2),datr(clust,3),ptsymb{i},'MarkerEdgeColor','[0.9290 0.6940 0.1250]','Markersize',7,'MarkerFaceColor','[0.9290 0.6940 0.1250]');
%     hold on
% end

% ptsymb = {'kd','kd'};%,'gd','g.','mo','c^'};
% for i = 1:numclust
%     clust = find(cidx==i);
%     plot3(datrINact(clust,1),datrINact(clust,2),datrINact(clust,3),ptsymb{i});%'MarkerEdgeColor','[0.4660 0.6740 0.1880]','Markersize',7,'MarkerFaceColor','[0.4660 0.6740 0.1880]');
%     hold on
% end

% ptsymb = {'bo','bo'};%,'gd','g.','mo','c^'};
% for i = 1:numclust
%     clust = find(cidx==i);
%     plot3(datrINinh(clust,1),datrINinh(clust,2),datrINinh(clust,3),ptsymb{i});%'MarkerEdgeColor','[0.4660 0.6740 0.1880]','Markersize',7,'MarkerFaceColor','[0.4660 0.6740 0.1880]');
%     hold on
% end
hold off
xlabel('Spike half-width (µs)','fontsize',15, 'rotation', -17);
ylabel('Area Under the Curve (mV²)','rotation',25,'fontsize',15);
zlabel('Firing rate (Hz)','fontsize',15);
legend('rPIN(n=13)','rPPN (n=64)','Avoidance Activated(n=16)','fontsize',12);
view(-137,25);
grid on


% figure;
% ptsymb = {'o','^'};%,'gd','g.','mo','c^'};
% for i = 1:numclust
%     clust = find(ccidx==i);
%     plot3(datc(clust,1),datc(clust,2),datc(clust,3),ptsymb{i},'MarkerEdgeColor','[0.4660 0.6740 0.1880]','Markersize',7,'MarkerFaceColor','[0.4660 0.6740 0.1880]');
%     hold on
% end

% ptsymb = {'ro','ro'};%,'gd','g.','mo','c^'};
% for i = 1:numclust
%     clust = find(cidx==i);
%     plot3(datcINinh(clust,1),datcINinh(clust,2),datcINinh(clust,3),ptsymb{i});%'MarkerEdgeColor','[0.4660 0.6740 0.1880]','Markersize',7,'MarkerFaceColor','[0.4660 0.6740 0.1880]');
%     hold on
% end


% ptsymb = {'rd','rd'};%,'gd','g.','mo','c^'};
% for i = 1:numclust
%     clust = find(cidx==i);
%     plot3(datcINact(clust,1),datcINact(clust,2),datcINact(clust,3),ptsymb{i});%'MarkerEdgeColor','[0.4660 0.6740 0.1880]','Markersize',7,'MarkerFaceColor','[0.4660 0.6740 0.1880]');
%     hold on
% end

% hold off
% xlabel('Spike half-width (µs)','fontsize',15, 'rotation', -17);
% ylabel('Area Under the Curve (mV²)','rotation',25,'fontsize',15);
% zlabel('Firing rate (Hz)','fontsize',15);
% legend('cPIN(n=20)','cPPN (n=67)','Avoidance inhibited (n=3)','fontsize',12);
% 
% view(-137,25);
% grid on
% 
% figure;
% subplot(2,1,1)
% pie([size(rPN,1),size(rIN,1)])%,'MarkerFaceColor','[0.4660 0.6740 0.1880]')
% title('rostral','fontsize',15)
% legend('PPN','PIN','fontsize',12)
% subplot(2,1,2)
% pie([size(cPN,1),size(cIN,1)])
% title('caudal','fontsize',15)
% legend('PPN','PIN','fontsize',12)
suptitle(sessstring{j})
 end


