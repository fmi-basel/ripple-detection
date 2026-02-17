
%[r p]=corr(Perc_Freeze,FR_PFC);

clear r p current_start current_end
freezing=Perc_Freeze;

   current_start=1;
   current_end=0;
   Correlation_total=[];
   Pval_total=[];
   
% correlation real data (all mice)
for k=1:8     % 1:n total of animals
    
     current_end=current_end+neulist(k+1);   % neulist= number of units per mouse
     current_start=current_start+neulist(k+1);

     current_freez=Perc_Freeze(:,k);
     current_neurons=FR_PFC(:,current_start:current_end);
    
    
   [rho, p]=corr(current_freez,current_neurons);
     
   Correlation_total=[Correlation_total rho];

   Pval_total=[Pval_total, p]; 

   edges=(-1:0.1:1);
   this_neuron=histc(rho,edges);
% 
% figure;
% h=bar(edges,this_neuron)
% title('PFC FR vs freezing')
% xlim([-1 1])


end   

% r1 and p1 (for corr of real data)
r1=Correlation_total;
[r,cc] = size(Pval_total);
sig = find(Pval_total <0.05);
nsig=find(Pval_total > 0.05);
rns1=Correlation_total(:,nsig);
rs1= Correlation_total(:,sig);
% hist(r)


clear r p  Correlation_total current_start current_end
   
   current_start=1;
   current_end=0;
   Correlation_total=[];
   Pval_total=[];
   
% make shuffled data 
for k=1
    
    current_end=current_end+neulist(k+1);
    current_freez=Perc_Freeze(:,k);
    
      for i=1:length(FR_PFC)
    
          activity=FR_PFC(:,i);
          Shuffle_activity=activity(randperm(length(activity)));
          
          [r , p]=corr(current_freez,activity);
          
          Correlation_total=[Correlation_total r];
          Pval_total=[Pval_total, p];
          
          current_start=current_start+neulist(k+1);
      end
      
end

% r2 and p2 for shuffled data
r2=Correlation_total;
[r,cc] = size(Pval_total);
sig = find(Pval_total <0.05);
nsig=find(Pval_total > 0.05);
rns2=Correlation_total(:,nsig);
rs2= Correlation_total(:,sig);
edges=(-1:0.1:1);

% making figure (subplot with 
figure;
subplot(2,2,1),
histogram(rs2,edges(2:end));
hold on
histogram(rns2,edges(2:end));
color('red')
xlim([-1 1])
title('PFC FR vs freezing ')
hold on
hold off
subplot(2,2,2),
histogram(rs1,edges(2:end));
hold on
histogram(rns1,edges(2:end));
color('red')
xlim([-1 1])
title('PFC FR vs freezing ')
hold off

% h=histogram(r2);
% set(h,'XData',edges(2:end),'FaceColor',[1 0 0],'FaceAlpha',0.8)
% xlim([-1 1])

 %%         
 %%% FOR PFC %%% A1
clear r p r1 r2 Correlation_total current_start current_end
freezing=Perc_Freeze;

   current_start=1;
   current_end=0;
   Correlation_total=[];
   Pval_total=[];
for k=1:8
    
    current_end=current_end+neulist(k+1);
    
     current_freez=Perc_Freeze((1:18),k);
     current_neurons=FR_PFC((1:18),current_start:current_end);
    
    
   [rho p]=corr(current_freez,current_neurons);
   
Correlation_total=[Correlation_total rho];

Pval_total=[Pval_total p]; 

% edges=(-1:0.1:1);
% figure;
% hist(rho,edges)
% title('PFC FR vs freezing')


current_start=current_start+neulist(k+1);

end   

r1=Correlation_total;
[r,cc] = size(Pval_total);
sig = find(Pval_total <0.05);
nsig=find(Pval_total > 0.05);
rns1=Correlation_total(:,nsig);
rs1= Correlation_total(:,sig);


clear r p Correlation_total current_start current_end
   current_start=1;
   current_end=0;
   Correlation_total=[];
   Pval_total=[];
for k=3
    
    current_end=current_end+neulist(k+1);
    
     current_freez=Perc_Freeze((1:18),k);
      for i=1:length(FR_PFC)
    
                activity=FR_PFC((1:18),i);
                Shuffle_activity=activity(randperm(length(activity)));
     
[r  p]=corr(current_freez,activity);

Correlation_total=[Correlation_total r];
   
current_start=current_start+neulist(k+1);
 end
end

r2=Correlation_total;
% hist(r)
edges=(-1:0.1:1);

% figure;
subplot(2,2,2),hist(r2,edges(2:end));
title('PFC FR vs freezing contA1')
xlim([-1 1])
hold on

hist(r1,edges(2:end));
xlim([-1 1])
hold off
%%
 %%% FOR PFC %%% B 
clear r p r1 r2  Correlation_total current_start current_end
current_start=1;
   current_end=0;
   Correlation_total=[];
   Pval_total=[];
for k=1:8
    
    current_end=current_end+neulist(k+1);
    
     current_freez=Perc_Freeze((19:36),k);
     current_neurons=FR_PFC((19:36),current_start:current_end);
    
    
   [rho p]=corr(current_freez,current_neurons);
   
Correlation_total=[Correlation_total rho];

Pval_total=[Pval_total p]; 

% edges=(-1:0.1:1);
% figure;
% hist(rho,edges)
% title('PFC FR vs freezing')


current_start=current_start+neulist(k+1);

end   

r1=Correlation_total;
[r,cc] = size(Pval_total);
sig = find(Pval_total <0.05);
nsig=find(Pval_total > 0.05);
rns1=Correlation_total(:,nsig);
rs1= Correlation_total(:,sig);


clear r p Correlation_total current_start current_end
    current_start=1;
   current_end=0;   
   Correlation_total=[];
   Pval_total=[];

for k=2
    
    current_end=current_end+neulist(k+1);
    
     current_freez=Perc_Freeze((19:36),k)
      for i=1:length(FR_PFC)
    
                activity=FR_PFC((19:36),i);
                Shuffle_activity=activity(randperm(length(activity)));
     
[r  p]=corr(current_freez,activity);

Correlation_total=[Correlation_total r];
  
   
current_start=current_start+neulist(k+1);
 end
end

r2=Correlation_total;
% hist(r)
edges=(-1:0.1:1);
% figure;
subplot(2,2,3),hist(r2,edges(2:end),'MarkerFaceColor',[0 0 1])
title('PFC FR vs freezing contB')
xlim([-1 1])
hold on

hist(r1,edges(2:end));
xlim([-1 1])
hold off
% [a b]=max(abs(r))
% 
% figure;
% plot(freezing,FR_PFC(:,:),'o','MarkerFaceColor',[0 0 0])
% 
% r(b)
% p(b)
%% %%% FOR PFC %%% A2
 
clear r p r1 r2  Correlation_total current_start current_end

   current_start=1;
   current_end=0;
   Correlation_total=[];
   Pval_total=[];
for k=1:8
    
    current_end=current_end+neulist(k+1);
    
     current_freez=Perc_Freeze((37:54),k);
     current_neurons=FR_PFC((37:54),current_start:current_end);
    
    
   [rho p]=corr(current_freez,current_neurons);
   
Correlation_total=[Correlation_total rho];

Pval_total=[Pval_total p]; 

% edges=(-1:0.1:1);
% figure;
% hist(rho,edges)
% title('PFC FR vs freezing')


current_start=current_start+neulist(k+1);

end   

r1=Correlation_total;
[r,cc] = size(Pval_total);
sig = find(Pval_total <0.05);
nsig=find(Pval_total > 0.05);
rns1=Correlation_total(:,nsig);
rs1= Correlation_total(:,sig);


clear r p Correlation_total current_start current_end

   current_start=1;
   current_end=0;
Correlation_total=[];
Pval_total=[];
  
for k=3
    
    current_end=current_end+neulist(k+1);
    
     current_freez=Perc_Freeze((37:54),k)
      for i=1:length(FR_PFC)
    
                activity=FR_PFC((37:54),i);
                Shuffle_activity=activity(randperm(length(activity)));
     
[r  p]=corr(current_freez,activity);

Correlation_total=[Correlation_total r];
   
current_start=current_start+neulist(k+1);
 end
end

r2=Correlation_total;

% hist(r)
edges=(-1:0.1:1);
%figure;
subplot(2,2,4),hist(r2,edges(2:end))
title('PFC FR vs freezing contA2')
xlim([-1 1])
hold on

hist(r1, edges(2:end));
xlim([-1 1])
hold off
% %%
% 
% clear shuffle_r shuffle_p
% 
%    current_start=1;
%    current_end=0;
%    Correlation_total=[];
%    Pval_total=[];
% for k=1:8
%     
%     current_end=current_end+neulist(k+1);
%     
%     current_freez=Perc_Freeze(:,k);
%     activity=FR_PFC(:,:);
% 
% Shuffle_activity=activity(randperm(size(activity,1)));
% [shuffle_r shuffle_p]=corr(current_freez,Shuffle_activity');
% 
% Correlation_total=[Correlation_total shuffle_r];
% 
% Pval_total=[Pval_total shuffle_p]; 
% 
% % edges=(-1:0.1:1);
% % figure;
% % hist(rho,edges)
% % title('PFC FR vs freezing')
% 
% 
% current_start=current_start+neulist(k+1);
% end
% 
% r=Correlation_total;
% 
% figure;
% % hist(r)
% edges=(-1:0.1:1);
% hist(r,edges)
% title('PFC FR vs freezing contA2')
% xlim([-1 1])
% 
% r_histo=histcounts(r,edges);
% shuffle_r_histo=histcounts(shuffle_r,edges);
% 
% figure;
% h2=bar(shuffle_r_histo,'FaceColor',[0 0 0]), hold on;
% set(h2,'XData',edges(2:end))
% 
% h=bar(r_histo);
% set(h,'XData',edges(2:end),'FaceColor',[1 0 0],'FaceAlpha',0.8)
% xlim([-1 1])
% %%
% 
% %%% FOR BLA %%% 
% 
% clear r p
% for i=1:length(FR_PFC)
%     
% activity=FR_PFC(:,i);
% 
% [r(i) p(i)]=corr(Perc_Freeze(:,1),activity);
% 
% 
% end
% hist(r)
% edges=(-1:0.1:1);
% histogram(r,edges)
% title('BLA FR vs freezing')
% 
% %%% FOR ALL UNITS %%% 
% clear r p
% freezing=Perc_Freeze;
% for i=1:28
%     
% activity=FR_ALL(:,i);
% 
% [r(i) p(i)]=corr(freezing,activity);
% 
% end
% hist(r)
% 
% %%% shuffle data point %%%
% 
% clear shuffle_r shuffle_p
% for i=1:28
%     
% activity=FR_ALL(:,i);
% Shuffle_activity=activity(randperm(length(activity)));
% [shuffle_r(i) shuffle_p(i)]=corr(freezing,Shuffle_activity);
% 
% 
% end
% 
% 
% edges=(-1:0.1:1);
% 
% r_histo=histcounts(r,edges);
% shuffle_r_histo=histcounts(shuffle_r,edges);
% 
% figure;
% h2=bar(shuffle_r_histo,'FaceColor',[0 0 0]), hold on;
% set(h2,'XData',edges(2:end))
% 
% h=bar(r_histo);
% set(h,'XData',edges(2:end),'FaceColor',[1 0 0],'FaceAlpha',0.8)
% xlim([-1 1])
% 
