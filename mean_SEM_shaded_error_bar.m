clear select1 select2
select1=nctx_ordered_trans1(:,1:120)
select2=nctx_ordered_trans1(:,252:371)

clear data x SEM average
data=order_FR;       % enter matrice to calculate mean
x=1:size(data,1);                     % size in row OR column
average= mean(data,2); 
SEM=nanstd(data,0,2)./sqrt(size(data,2));     % SEM calcul (,2)=in row

% clear data x2 SEM2 average2
% data2=select2;       % enter matrice to calculate mean
% x2=1:size(data2,1);                     % size in row OR column
% average2= mean(data2,2); 
% SEM2=nanstd(data2,0,2)./sqrt(size(data2,2)); 

figure;
shadedErrorBar(x,smooth(average),smooth(SEM),'lineProps',{'Color',[0.8 0.2 0.0]},'transparent',1,'patchSaturation',0.33);
%title('BLA 2nd transition','Fontsize',12)
xlabel('time (sec)','Fontsize',12)
ylabel('z-score','Fontsize',12)
ylim([-0.5 2.5])

figure;
shadedErrorBar(x2,average2,SEM2,'lineProps','b','transparent',1,'patchSaturation',0.33);
xlabel('time (sec)','Fontsize',12)
ylabel('z-score','Fontsize',12)
%title('A2 cells','Fontsize',12)
ylim([-1 0.5])

