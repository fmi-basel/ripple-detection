function [order]=heatMapZscore(zscored_all_varcr,bstring,varstring,stringfile,varorder,g,edges,limi)

for i=1:1:size(bstring,2)    
clear varorder
varorder=zscored_all_varcr.(bstring{i}).(varstring{1});
effect=mean(varorder((size(varorder,1)/2)-1:(size(varorder,1)),:),1);
[a index]=sort(effect,2,'descend');
order.(bstring{i})=index;
end
  
%load('Mycolormap')
for i=1:size(bstring,2)
figure;%('Name','Heatmap','NumberTitle','off');
subplot(1,length(varstring),1)
h1=imagesc(zscored_all_varcr.(bstring{i}).(varstring{1})(:,order.(bstring{i}))')
set(h1,'XData',edges(1:end-1))
caxis([-4 4])
xlim(limi)
%colorbar
title(varstring{1})
ylabel('# neurons')
xlabel('time (sec)')
subplot(1,length(varstring),2)
h2=imagesc(zscored_all_varcr.(bstring{i}).(varstring{2})(:,order.(bstring{i}))')
set(h2,'XData',edges(1:end-1))
caxis([-4 4])
xlim(limi)
%colorbar
title(varstring{2})
xlabel('time (sec)')
% subplot(1,length(varstring),3)
% h3=imagesc(zscored_all_varcr.(bstring{i}).(varstring{3})(:,order.(bstring{i}))')
% set(h3,'XData',edges(1:end-1))
% caxis([-3 3])
% xlim(limi)
% %colorbar
% title(varstring{3})
% xlabel('time (sec)')
% subplot(1,length(varstring),4)
% h4=imagesc(zscored_all_varcr.(bstring{i}).(varstring{4})(:,order.(bstring{i}))')
% set(h4,'XData',edges(1:end-1))
% caxis([-4 4])
% xlim(limi) 
% %colorbar
% title(varstring{4})
% xlabel('time (sec)')
% subplot(1,length(varstring),5)
% h5=imagesc(zscored_all_varcr.(bstring{i}).(varstring{5})(:,order.(bstring{i}))')
% set(h5,'XData',edges(1:end-1))
% caxis([-4 4])
% xlim(limi)
% %colormap(mymap2)
% colormap('parula') 
% %colorbar
% title(varstring{5})
% xlabel('time (sec)')
% %suptitle(stringfile{g})
% subplot(1,length(varstring),6)
% h6=imagesc(zscored_all_varcr.(bstring{i}).(varstring{6})(:,order.(bstring{i}))')
% set(h6,'XData',edges(1:end-1))
% caxis([-4 4])
% xlim(limi)
%colormap(mymap2)
colormap('parula') 
colorbar
% title(varstring{6})
% xlabel('time (sec)')
suptitle([bstring{i} ' ' stringfile{g}])

end
end