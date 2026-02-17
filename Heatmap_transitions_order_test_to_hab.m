%%% concatenation

clear allanims plotvar varlist

alltest10 = who('*_z_10s_all');              %% change who is varlist according to analyses
alltest01 = who('*_z_0_1s_all');
% alltest10 = who('*_Frq_10s')
% alltest01 = who('*_Frq_0_1s')
transi1 = who('*ns1');
% transi2 = who('*ns2');
transi2 = who('*_norm_t1')

var={alltest10, alltest01,transi1,transi2};

for j=1:size(var,2)
        clear allanims
        varstr=  {'test10','test01','transi1','transi2'};
        varlist=var{j};
        allanims = eval(varlist{1});
        %time=allanims(:,1);
        allanims(:,1) = [];
        
       %[allanims]= miceConcatFromNexNoTimeBin(varlist)
        for i=2:1:length(varlist)
            tempval = eval(varlist{i});
            [~,st] = size(tempval);
            tempval2(:,[1:st-1])= tempval(:,[2:st]);
            allanims=[allanims,tempval2];
            clear tempval2 tempval
        end
        
        eval(strcat('allanims',varstr{j},'= allanims'));
end

%% pour analyse ENTIRE SESSION 

plotvar=allanimstest10hab;  
plotvar2=allanimstest10test;
timex=(1:1:54)
fa=1;
from=20;%/change_time_bin;        %%% tronçon order trans 1 
to=34;%change_time_bin;

PeriodSelect=mean(plotvar2(from:to,:),1);       %%% variable tronçon
[ordervalue order]=sortrows(PeriodSelect',-1); %% to get in order


figure(1);                                        %%% simple colormap figure ordered by activity at selected period
h=imagesc(plotvar2(:,order)');               
% h=imagesc(plotvar(:,order_trans1)');         % change to 'order_trans1' if want to plot according to ranking of trans 1
set(h,'XData',timex)
xlim([0 54])  %[-1.9 2]
caxis([-4 4])                                  % adapt z score scale window
colormap parula
colorbar
box off

figure(1);                                        %%% simple colormap figure ordered by activity at selected period
h=imagesc(plotvar(:,order)');               
% h=imagesc(plotvar(:,order_trans1)');         % change to 'order_trans1' if want to plot according to ranking of trans 1
set(h,'XData',timex)
xlim([0 54])  %[-1.9 2]
caxis([-4 4])                                  % adapt z score scale window
colormap parula
colorbar
box off



%%  pour analyse autour de transition 1

clear j to from tob fromb timex fa PeriodSelect order ordervalue plotvar

vartrans={allanimshab,allanimstest};

for j=1:size(vartrans,2)
    
    
    varstr={'hab','test'};
    plotvar=vartrans{j}


fa=1;
change_time_bin=10;         %% magnitude of change of the time bin / ONE FOR NO CHANGE
fa=fa*change_time_bin;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
time_limits=(0:change_time_bin:size(plotvar,1));
% 
clear plotvar2
    for i=1:size(time_limits,2)-1
    plotvar2(i,:)=mean(plotvar(time_limits(i)+1:time_limits(i+1),:));
    end
% 
% % figure;
% plot(1:1:540,plotvar(:,1)),hold on
% % plot(1:10:540,plotvar2(:,1))
% 
plotvar=plotvar2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% time bins size  0.1 for FZ
timex=(0.1:0.1:74.9)-30;
% value goes from 0 to 75 sec with 0 starting at +30s

from=0/change_time_bin*100; %%% in seconds (compatabiliser 15 premiers sec) for FZ from 0 to 15
to=15/change_time_bin*100;

fromb=((size(plotvar,1))-45)+from/fa;    %%%% in time bins
tob=((size(plotvar,1))-45)+to/fa;

PeriodSelect=mean(plotvar(fromb:tob,:),1);     %% pour transition
[ordervalue order]=sortrows(PeriodSelect',-1);

 eval(strcat('order_',varstr{j},'= order'));
 eval(strcat('ordervalue',varstr{j},'= ordervalue'));
 eval(strcat('plotvar',varstr{j},'= plotvar'));
 
% clear to from tob fromb timex fa PeriodSelect order ordervalue plotvar 
end

figure(2); %%% simple colormap figure order by activity
subplot(1,2,1)
h=imagesc(plotvartransi1(:,order_transi1)');                 
set(h,'XData',timex)
xlim([-30 45])  %[-1.9 2]
caxis([-1 1])
title('transition 1')
subplot(1,2,2)
h=imagesc(plotvartransi2(:,order_transi2)'); 
set(h,'XData',timex)
xlim([-30 45])
caxis([-1 1])    % adapt from z score window
title('transition 2')
colormap parula
colorbar
box off
suptitle('independent cell response at transition start')

figure(3); %%% simple colormap figure order by activity
subplot(1,2,1)
h=imagesc(plotvartransi1(:,order_transi1)');                 
set(h,'XData',timex)
xlim([-30 45])  %[-1.9 2]
caxis([-1 1])
title('transition 1')
subplot(1,2,2)
h=imagesc(plotvartransi2(:,order_transi1)'); 
set(h,'XData',timex)
xlim([-30 45])
caxis([-1 1])    % adapt from z score window
title('transition 2')
colormap parula
colorbar
box off
suptitle('cell response at transition start ordered from transition 1')

figure(4); %%% simple colormap figure order by activity
subplot(1,2,1)
h=imagesc(plotvartransi1(:,order_transi2)');                 
set(h,'XData',timex)
xlim([-30 45])  %[-1.9 2]
caxis([-1 1])
title('transition 1')
subplot(1,2,2)
h=imagesc(plotvartransi2(:,order_transi2)'); 
set(h,'XData',timex)
xlim([-30 45])
caxis([-1 1])    % adapt from z score window
title('transition 2')
colormap parula
colorbar
box off
suptitle('cell response at transition start ordered from transition 2')

%%  pour analyse 5sec avant apres transition (trans coupé). bin= 200ms

clear j to from tob fromb timex fa PeriodSelect order ordervalue plotvar

vartrans={allanimstransi1,allanimstransi2};

for j=1:size(vartrans,2)
   
   
    varstr={'transi1','transi2'};
    plotvar=vartrans{j}([(1:300) (450:750)],:);


fa=1;
change_time_bin=2;         %% magnitude of change of the time bin / ONE FOR NO CHANGE
fa=fa*change_time_bin;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_limits=(0:change_time_bin:size(plotvar,1));
%
clear plotvar2
    for i=1:size(time_limits,2)-1
    plotvar2(i,:)=mean(plotvar(time_limits(i)+1:time_limits(i+1),:));
    end
%
% % figure;
% plot(1:1:540,plotvar(:,1)),hold on
% % plot(1:10:540,plotvar2(:,1))
%
plotvar=plotvar2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% time bins size  0.1 for FZ
timex=(0.2:0.2:20)-10;
% value goes from 0 to 75 sec with 0 starting at +30s

from=3/change_time_bin*100; %%% in seconds (compatabiliser 15 premiers sec) for FZ from 0 to 15
to=6/change_time_bin*100;

% fromb=((size(plotvar,1)))+from/fa;    %%%% in time bins
% tob=((size(plotvar,1)))+to/fa;

PeriodSelect=mean(plotvar(from:to,:),1);     %% pour transition
[ordervalue order]=sortrows(PeriodSelect',-1);

 eval(strcat('order_',varstr{j},'= order'));
 eval(strcat('ordervalue',varstr{j},'= ordervalue'));
 eval(strcat('plotvar',varstr{j},'= plotvar'));
 
% clear to from tob fromb timex fa PeriodSelect order ordervalue plotvar
end

figure(2); %%% simple colormap figure order by activity
subplot(1,2,1)
h=imagesc(plotvartransi1(:,order_transi1)');                
set(h,'XData',timex)
xlim([-5 5])  %[-1.9 2]
caxis([-2 2])
title('transition 1')
subplot(1,2,2)
h=imagesc(plotvartransi2(:,order_transi2)');
set(h,'XData',timex)
xlim([-5 5])
caxis([-2 2])    % adapt from z score window
title('transition 2')
colormap parula
colorbar
box off
suptitle('independent cell response at transition start')

figure(3); %%% simple colormap figure order by activity
subplot(1,2,1)
h=imagesc(plotvartransi1(:,order_transi1)');                
set(h,'XData',timex)
xlim([-5 5])  %[-1.9 2]
caxis([-2 2])
title('transition 1')
subplot(1,2,2)
h=imagesc(plotvartransi2(:,order_transi1)');
set(h,'XData',timex)
xlim([-5 5])
caxis([-2 2])    % adapt from z score window
title('transition 2')
colormap parula
colorbar
box off
suptitle('cell response at transition start ordered from transition 1')

figure(4); %%% simple colormap figure order by activity
subplot(1,2,1)
h=imagesc(plotvartransi1(:,order_transi2)');                
set(h,'XData',timex)
xlim([-5 5])  %[-1.9 2]
caxis([-2 2])
title('transition 1')
subplot(1,2,2)
h=imagesc(plotvartransi2(:,order_transi2)');
set(h,'XData',timex)
xlim([-5 5])
caxis([-2 2])    % adapt from z score window
title('transition 2')
colormap parula
colorbar
box off
suptitle('cell response at transition start ordered from transition 2')