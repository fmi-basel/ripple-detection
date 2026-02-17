%% concatenation

clear allanims plotvar varlist

alltest10 = who('*1s');              %% change who is varlist according to analyses
% alltest10 = who('*_Frq_10s')
% alltest01 = who('*_Frq_0_1s')
%transi1 = who('*ns1');
%transi2 = who('*ns2');
%transi2 = who('*_norm_t1')

%var={alltest10, alltest01,transi1,transi2};
var={alltest10};

for j=1:size(var,2)
        clear allanims
        varstr=  {'test10'};    %'transi1','transi2';'test10'
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
conc=horzcat(alltest10)
%% z-scoring

clear neurons_zscored basal current_neuron
%use_neurons= allanims(:,:)

use_neurons= FR_nctx(:,:)
for i=1:size(use_neurons,2)
    
    basal = use_neurons(1:108,i);   % 4:18 = 30-180s,  1:54 = all
    current_neuron=use_neurons(:,i);
    neurons_zscored(:,i)=(current_neuron-mean(basal))./std(basal);
    %mean_zscore(:,i)=mean(neurons_zscored);
    
end
clear basal i current_neuron
zs_ap_norm_nctx=neurons_zscored
clear use_neurons neurons_zscored
%figure;
%plot(nanmean(mean_zscore,2));  
%% heatmap RANKED
% only "zscored" matrices!!
clear  plotvar PeriodSelect ordervalue order fa from to h timex t order_FR 
plotvar=PFC';
% (:,disc_t1);  %% change variable 

timex=(1:1:100)
fa=1;
from=41;      %/change_time_bin;        %%% tronçon order trans 1 
to=60;        %change_time_bin;

PeriodSelect=mean(plotvar(from:to,:),1);       %%% variable tronçon
[ordervalue order]=sortrows(PeriodSelect',-1); %% to get in order

figure;                                       
h=imagesc(plotvar(:,order)');               
set(h,'XData',timex)
xlim([0 100])  
caxis([-3 3])                                 
colormap parula
colorbar
box off
suptitle('PFC post FC (n=531)')

% to get identity of neurons in ranking order
order_FR=plotvar(:,order);
order_kept=A2_unit(order)



%% follow same neurons test -> hab
% IMPORTANT!!! beforer running, import z-score matrice and rename plotvar

%plotvarhab=allanimshab;              %% put z-score matrice!
plotvartest=zscored_all_test1;    
plotvartest2=zscored_all_test2;

timex=(1:1:54)
fa=1;
from=20;%/change_time_bin;        %%% tronçon order trans 1 
to=34;  %change_time_bin;

% PeriodSelect=mean(plotvarhab(from:to,:),1);       %%% for hab
% [ordervalue order]=sortrows(PeriodSelect',-1);    %% to get in order

PeriodSelect2=mean(plotvartest(from:to,:),1);       %%% for test1
[ordervalue2 order2]=sortrows(PeriodSelect2',-1);     

PeriodSelect3=mean(plotvartest2(from:to,:),1);       %%% for test2
[ordervalue3 order3]=sortrows(PeriodSelect3',-1);  


% order_hab=order
% ordervalue_hab=ordervalue
order_test1=order2
ordervalue_test1=ordervalue2
order_test2=order3
ordervalue_test2=ordervalue3
clear order ordervalue order2 ordervalue2 order3 ordervalue3

% get heatmap of HAB ordered to TEST1
figure;                                
h=imagesc(plotvartest(:,order_test2)');     %change plotvat % order_test1            
set(h,'XData',timex)
xlim([0 45])  
caxis([-2.5 2.5])
title('test1 ranked to test2')
colormap parula
colorbar
box off

%simple heatmap
figure;                                       
h=imagesc(plotvartest2(:,neurons_zscored)');               
set(h,'XData',timex)
xlim([0 54])  
caxis([-2.5 2.5])                                 
colormap parula
colorbar
box off

%%
% beforer running, import all concatenated spike count, get the z-score and rename

clear i j to from timex fa PeriodSelect order ordervalue plotvar change_time_bin varstr vartrans time_limits

vartrans={allanimshab,allanimstest1};

for j=1:size(vartrans,2)
    
    
    varstr={'hab','test1'};
    plotvar=vartrans{j}


fa=1;
change_time_bin=1;         %% magnitude of change of the time bin / ONE FOR NO CHANGE
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

timex=(1:1:54);
from=20; 
to=34;

% fromb=((size(plotvar,1))-45)+from/fa;    %%%% in time bins
% tob=((size(plotvar,1))-45)+to/fa;

PeriodSelect=mean(plotvar(from:to,:),1);     %% pour transition
[ordervalue order]=sortrows(PeriodSelect',-1);

 eval(strcat('order_',varstr{j},'= order'));
 eval(strcat('ordervalue',varstr{j},'= ordervalue'));
 eval(strcat('plotvar',varstr{j},'= plotvar'));
 
% clear to from tob fromb timex fa PeriodSelect order ordervalue plotvar 
end


figure; %%% simple colormap figure order by activity
subplot(1,2,1)
h=imagesc(plotvartest1(:,order_test1)');                 
set(h,'XData',timex)
xlim([0 45])  
caxis([-2 2])
title('test 1')
subplot(1,2,2)
h=imagesc(plotvarhab(:,order_hab)'); 
set(h,'XData',timex)
xlim([0 54])
caxis([-2 2])    % adapt from z score window
title('habituation')
colormap parula
colorbar
box off
suptitle('cell response at transition start ordered from transition 1')
 