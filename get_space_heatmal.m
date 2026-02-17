%% load data 

clear all
data=importdata('D:\HERRYTEAM Dropbox\Ha-Rang K\DLC - analysed & results\M329-M389 BEHAV\MOUSE (DLC analysed)\M334\M334-FCDLC_resnet50_FINAL2Oct21shuffle1_1030000filtered.csv');

frames = data.data(:,1);
frames=[frames(2:end);frames(end)+1];
time=[];
time=frames*0.033333;  %converts to seconds

ctr_x = data.data(:,8); 
ctr_y = data.data(:,9);

neck_x = data.data(:,5);
neck_y = data.data(:,6);

nose_x = data.data(:,2);
nose_y = data.data(:,3);

movement_x=diff(ctr_x);
movement_y=diff(ctr_y);

distance=(sqrt(movement_x .^2+movement_y .^2))*0.08;  % 1pix=0.08cm ; 30fps ; 0.08*30=2.4

%% heatmap plotting 

% X = [ctr_x,ctr_y];
% hist3(X,'CDataMode','auto','FaceColor','interp')
% xlabel('ctr_x')
% ylabel('ctr_y')

X = [ctr_x,ctr_y];

figure;
hist3(X,'Nbins',[40 40],'CdataMode','auto')
xlabel('ctr_x')
ylabel('ctr_y')
colorbar
view(2)

hist3(X,'Ctrs',{0:10:50 2000:500:5000})
hist3(X,{0:10:50 2000:500:5000})

x=randn(1000,1);
y=x+randn(1000,1)/3;

x=ctr_x;
y=ctr_y;
nexttile;scatter(x,y,'.');title('scatter')
nexttile;binscatter(x,y);title('binscatter')
nexttile;histogram2(x,y,'DisplayStyle','tile');title('histogram2')
{0:10:600 0:10:600}

figure;
histogram2(x,y,15,'DisplayStyle','tile');title('time spent')
c=colorbar;
c.Label.String='Count';

figure;
plot(ctr_x,ctr_y)


tbl = table(x,y)
h = heatmap(tbl,'x','y','ColorVariable')

t=table(x,y);
table=test;
x=table(:,1);
y=table(:,2);
z=table(:,3);

figure;
heatmap(table);




figure;                                        %%% simple colormap figure ordered by activity at selected period
h=imagesc(z);               
% h=imagesc(plotvar(:,order_trans1)');         % change to 'order_trans1' if want to plot according to ranking of trans 1
set(h,'XData',timex)
xlim([0 54])  %[-1.9 2]
caxis([-4 4])                                  % adapt z score scale window
colormap parula
colorbar
box off
