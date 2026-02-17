clear all 
%close all
% get AUC & Half spike width 
%neu=0;

files1 = {'m330-test1_all.mat','m331-test1_all.mat','m332-test1_all.mat','m334-test1_all.mat','m335-test1_all.mat','m336-test1_all.mat','m337-test1_all.mat','m338-test1_all.mat','m339-test1_all.mat','m340-test1_all.mat','m341-test1_all.mat','m342-test1_all.mat','m343-test1_all.mat','m344-test1_all.mat',...
          'm345-test1_all.mat','m346-test1_all.mat','m347-test1_all.mat','m348-test1_all.mat','m349-test1_all.mat','m350-test1_all.mat','m351-test1_all.mat','m352-test1_all.mat','m353-test1_all.mat','m354-test1.mat','m355-test1_all.mat','m356-test1.mat','m357-test1_all.mat','m358-test1_all.mat','m359-test1_all.mat','m360-test1_all.mat','m361-test1_all.mat',};
files2 = {'m331-test2_all.mat','m332-test2_all.mat','m334-test2_all.mat','m335-test2_all.mat','m336-test2_all.mat','m337-test2_all.mat','m338-test2_all.mat','m339-test2_all.mat','m340-test2_all.mat','m341-test2_all.mat','m342-test2_all.mat','m343-test2_all.mat','m344-test2_all.mat','m345-test2_all.mat','m346-test2_all.mat',...
          'm347-test2_all.mat','m348-test2_all.mat','m349-test2_all.mat','m350-test2_all.mat','m351-test2_all.mat','m352-test2_all.mat','m353-test2_all.mat','m354-test2.mat','m355-test2_all.mat','m356-test2_all.mat','m357-test2_all.mat','m358-test2_all.mat','m359-test2_all.mat','m360-test2_all.mat','m361-test2_all.mat'};

%files3 = {'m330-test1_all.mat','m331-test1_all.mat','m332-test1_all.mat','m334-test1_all.mat','m335-test1_all.mat','m336-test1_all.mat','m337-test1_all.mat','m338-test1_all.mat','m339-test1_all.mat','m340-test1_all.mat','m341-test1_all.mat','m342-test1_all.mat','m343-test1_all.mat','m344-test1_all.mat',...
         % 'm345-test1_all.mat','m346-test1_all.mat','m347-test1_all.mat','m348-test1_all.mat','m349-test1_all.mat','m350-test1_all.mat','m351-test1_all.mat','m352-test1_all.mat','m353-test1_all.mat','m354-test1.mat','m355-test1_all.mat','m356-test1.mat','m357-test1_all.mat','m358-test1_all.mat','m359-test1_all.mat','m360-test1_all.mat','m361-test1_all.mat'...
         % 'm331-test2_all.mat','m332-test2_all.mat','m334-test2_all.mat','m335-test2_all.mat','m336-test2_all.mat','m337-test2_all.mat','m338-test2_all.mat','m339-test2_all.mat','m340-test2_all.mat','m341-test2_all.mat','m342-test2_all.mat','m343-test2_all.mat','m344-test2_all.mat','m345-test2_all.mat','m346-test2_all.mat',...
         % 'm347-test2_all.mat','m348-test2_all.mat','m349-test2_all.mat','m350-test2_all.mat','m351-test2_all.mat','m352-test2_all.mat','m353-test2_all.mat','m354-test2.mat','m355-test2_all.mat','m356-test2_all.mat','m357-test2_all.mat','m358-test2_all.mat','m359-test2_all.mat','m360-test2_all.mat','m361-test2_all.mat'};
% files4 = {''}; 

%%
files={files1,files2}; %files1,files2,files3, files4;
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
    for p = 1:numel(file)
    clear SPK* wave fq hsw auc fqspk
    load(file{p},'SPK*')
    %b=who('SPK*');
   clear *template_ts *wf *template *wf_ts
    b={who('SPK01*','SPK02*','SPK03*','SPK04*','SPK05*','SPK06*','SPK07*','SPK08*','SPK09*','SPK10*','SPK11*','SPK12*','SPK13*','SPK14*','SPK15*','SPK16*'),...
        who('SPK33*','SPK34*','SPK35*','SPK36*','SPK41*','SPK42*','SPK43*','SPK44*','SPK45*','SPK46*','SPK47*','SPK48*')};
    load(file{p},'SPK*')
    temp = who('*template');
    waveb=[];
    for i =1:length(b{1})
        clear waveneu
        waveneu = eval(temp{i});
        waveb= [waveb waveneu];
    end
    
    wavep=[];
    for i =length(b{1})+1:length(temp)
        clear waveneu
        waveneu = eval(temp{i});
        wavep= [wavep waveneu];
    end
    waveb= waveb';
    wavep=wavep';
    clear *template_ts *wf *template *wf_ts
    
    wa={waveb,wavep};
        spikes=b{k};
        wave=wa{k};
        Num_spikes_mice=length(spikes);
        for f=1:Num_spikes_mice, current_spike=eval(spikes{f}); edges=(1:1:200);  fqspk(f,:)= histcounts(current_spike,edges); fq=(mean(fqspk,2))'; end  
%         [L, w]=size(wave); x=1:1:w; 
%         for i=1:1:L; auc(i)=abs(trapz(x*0.25,wave(i,:)));end   
%         for i=1:1:L, p=find(wave(i,:)==max(wave(i,:)),1); v=find(wave(i,:)==min(wave(i,:)),1); hsw(i)= abs(v-p)*25;end
 auc1 = zeros(size(wave,1),1);
hsw = zeros(size(wave,1),1);
for c = 1:size(wave,1),
    we = resample(wave(c,:),300,12);
    wf(:,c)=we';
    [xmin,idxmin]=min(we); [xmax,idxmax]=max(we(idxmin:end));
    wf(:,c)=-wf(:,c)./min(we);
    m = max(we(find(we==min(we)):end));
    we=we./m; [m,idx]=min(we); we=we(idx:end); we=we(we>0);
    auc1(c) = trapz(we);
    auc = auc1;
    hsw(c) = idxmax;
end 
        if isempty(wave);
        continue    
        else
            
%             
%         fqall=[fqall fq];
%         aucall=[aucall auc];
%         hswall=[hswall hsw]; 
        fqall=[fqall fq]; aucall=[aucall auc']; hswall=[hswall hsw'];
        end
    end
    fqrc.(bstring{k})=fqall;
    aucrc.(bstring{k})=aucall;
    hswrc.(bstring{k})=hswall;
 end    
dat(:,1)=hswrc;
dat(:,2)=aucrc;
dat(:,3)=fqrc;


%% Organize the data entered into a single matrix   
datc=[dat(1).PL; dat(2).PL; dat(3).PL]';
datr=[dat(1).BLA; dat(2).BLA; dat(3).BLA]';
%datall=[[dat(1).PL' dat(3).BLA']; [dat(2).PL' dat(3).BLA']; [dat(3).PL' dat(3).BLA']]';

%%  K-means Clustering
numclust=2; %insert number of clusters
%PL BLA clustering
[ccidx,cmeans]=kmeans(datc,numclust,'dist','sqeuclidean');
[cridx,cmeans]=kmeans(datr,numclust,'dist','sqeuclidean');%%  K-means Clustering
%[cidx,cmeans]=kmeans(datall,numclust,'dist','sqeuclidean');%%  K-means Clustering

%% find PPN and PIN

rIN=find(cridx==2);
rPN=find(cridx==1);
cIN=find(ccidx==2);
cPN=find(ccidx==1);
%PN=find(cidx==1);
%IN=find(cidx==2);

%datPN=datall(PN,:);
%datIN=datall(IN,:);
datcPN=datc(cPN,:);
datrPN=datr(rPN,:);
datcIN=datc(cIN,:);
datrIN=datr(rIN,:);
save(sessstring{j},'rPN','cPN','rIN','cIN','datcPN','datcIN','datrPN','datrIN')

%% Plots K-means
%close all
figure;

ptsymb = {'o','^'};%,'gd','g.','mo','c^'};
for i = 1:numclust
    clust = find(cridx==i);
    plot3(datr(clust,1),datr(clust,2),datr(clust,3),ptsymb{i},'MarkerEdgeColor','[0.9290 0.6940 0.1250]','Markersize',7,'MarkerFaceColor','[0.9290 0.6940 0.1250]');
    hold on
end

hold off
xlabel('Spike half-width (µs)','fontsize',15, 'rotation', -17);
ylabel('Area Under the Curve (mV²)','rotation',25,'fontsize',15);
zlabel('Firing rate (Hz)','fontsize',15);
legend('PL_PIN(n='')','PL_PPN (n=64)','Avoidance Activated(n=16)','fontsize',12);
view(-137,25);
grid on


figure;
ptsymb = {'o','^'};%,'gd','g.','mo','c^'};
% colpts = {'[0.07 0.25 0.58]','[0.87 0.03 0.03]'};
% for i = 1:numclust
%     clust = find(ccidx==i);
%     plot3(datc(clust,1),datc(clust,2),datc(clust,3),ptsymb{i},'MarkerEdgeColor',colpts{i},'MarkerFaceColor',colpts{i});
%     hold on
% end

for i = 1:numclust
    clust = find(ccidx==i);
    plot3(datc(clust,1),datc(clust,2),datc(clust,3),ptsymb{i},'MarkerEdgeColor','[0.4660 0.6740 0.1880]','Markersize',7,'MarkerFaceColor','[0.4660 0.6740 0.1880]');
    hold on
end

hold off
xlabel('SHW (µs)','fontsize',15, 'rotation', -17);
ylabel('AUC (mV²)','rotation',25,'fontsize',15);
zlabel('FR (Hz)','fontsize',15);
legend('BLA IN','BLA PN','fontsize',12);

view(-137,25);
grid on
%%


figure;
subplot(2,1,1)
pie([size(rPN,1),size(rIN,1)])%,'MarkerFaceColor','[0.4660 0.6740 0.1880]')
title('BLA','fontsize',15)
legend('PPN','PIN','fontsize',12)
subplot(2,1,2)
pie([size(cPN,1),size(cIN,1)])
title('PL','fontsize',15)
legend('PPN','PIN','fontsize',12)
%%
end