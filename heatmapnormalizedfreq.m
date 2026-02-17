
function heatMapNorm(normice,order,bstring,varstring, stringfile,edges,g)

Matneunorm=cell2mat(normice);
neunorm1=[];
neunorm2=[];
neunorm3=[];
neunorm3=[];

for i = 1:size(Matneunorm,1), neunorm1=horzcat(neunorm1,Matneunorm(i).All.DOallCSP); end
for i = 1:size(Matneunorm,1), neunorm2=horzcat(neunorm2,Matneunorm(i).All.DOallCSM); end
for i = 1:size(Matneunorm,1), neunorm3=horzcat(neunorm3,Matneunorm(i).All.CSPonset); end
for i = 1:size(Matneunorm,1), neunorm4=horzcat(neunorm4,Matneunorm(i).All.CSMonset); end

neunorm1=neunorm1(:,PN);
neunorm2=neunorm2(:,PN);
neunorm3=neunorm3(:,PN);
neunorm4=neunorm4(:,PN);
%%% ranking neurons from more activated to inhibited
% varorder=neunorm1;
% 
% for i=1:1:size(bstring,2)
% effect=mean(varorder((size(varorder,1)/2)-1:(size(varorder,1)),:),1);
% [a index]=sort(effect,2,'descend');
% order.(bstring{i})=index;
% end
%   
load('Mycolormap')
for i=1:size(bstring,2)
figure;%('Name','Heatmap','NumberTitle','off');
subplot(1,4,1)
h1=imagesc(neunorm1(:,order.(bstring{i}))')
set(h1,'XData',edges(1:end-1))
caxis([0 0.3])
xlim(limi)
colormap bone
%colorbar
title(varstring{1})
ylabel('# neurons')
xlabel('time (sec)')
subplot(1,4,2)
h2=imagesc(neunorm2(:,order.(bstring{i}))')
set(h2,'XData',edges(1:end-1))
caxis([0 0.3])
xlim(limi)
colormap bone
%colorbar
title(varstring{2})
xlabel('time (sec)')
subplot(1,4,3)
h3=imagesc(neunorm3(:,order.(bstring{i}))')
set(h3,'XData',edges(1:end-1))
caxis([0 0.3])
xlim(limi)
colormap bone
colorbar
title(varstring{3})
xlabel('time (sec)')
subplot(1,4,4)
h4=imagesc(neunorm4(:,order.(bstring{i}))')
set(h4,'XData',edges(1:end-1))
caxis([0 0.3])
xlim(limi)
colormap bone
colorbar
title(varstring{4})
xlabel('time (sec)')
%suptitle(stringfile{g})
end
end