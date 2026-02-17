% Organizator - - - - - - - - - - -

varlist = who('m*');

%Join all animals

allanims=eval(varlist{1});    %%%%% attention
% time=allanims(:,1);
allanims(:,1) = [];

for i=2:1:length(varlist) 
tempval = eval(varlist{i});
[~,st] = size(tempval);
tempval2(:,[1:st-1])= tempval(:,[2:st]);
allanims=[allanims tempval2];
clear tempval2 tempval
end

plotvar=allanims;


change_time_bin=10;         %% magnitude of change of the time bin / ONE FOR NO CHANGE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
time_limits=(0:change_time_bin:size(plotvar,1));
% 
clear plotvar2
for i=1:size(time_limits,2)-1
plotvar2(i,:)=mean(plotvar(time_limits(i)+1:time_limits(i+1),:));
end
% 
% % figure;
% % plot(1:1:540,plotvar(:,1)),hold on
% % plot(1:10:540,plotvar2(:,1))
% 
allanims=plotvar2;



%time1= ((0.2:0.2:17.6)-8.8)';
time=(1:1:74)-30;



% Find activated cells

[r,cc] = size(allanims);
zero=find(time==0)+1;
allanims0=allanims([zero:r],:);
allaniminspre=allanims([1:zero-1],:);

[act.row, act.col] = find(allanims0 >1);

clear actcells
j=1;
c=0;
for i=1:1:max(act.col);
a=find(act.col==i);
b=act.row(a);
c=min(diff(b));
if c==1;  %mais de 3 bins maiores que 1.95 ou se ele tem dois bins seguidos maiores que 1.96
    actcells(j)=i; %position vector of all activated cells after 0
    j=j+1;
else
    end
end

clear a b c



%find inhibited cells

[inh.row, inh.col] = find(allanims0 <-1);
clear inhcells


j=1;
c=0;
for i=1:1:max(inh.col);
a=find(inh.col==i);
b=inh.row(a);
c=min(diff(b));
if  c==1;  %se ele tem dois bins seguidos menores que -1.96
    inhcells(j)=i; %position vector of all inhibited cells after 0 
    j=j+1;
else
%     inhcells=0;
    end
end

clear a b c

%find non responsive cells

%[non.row, non.col] = find(allanims0 <-1.95);
 clear noncells
 
 
% j=1;
%  c=0;
%  for i=1:1:max(non.col);
%  a=find(non.col==i);
%  b=non.row(a);
%  c=min(diff(b));
%  if  c==1;  %se ele tem dois bins seguidos menores que -1.96
%      noncells(j)=i; %position vector of all inhibited cells after 0 
%      j=j+1;
%  else
%      %inhcells=0;
%     end
%  end

%mean activated cells
actall=allanims(:,actcells); %all data of bins after 0 of activated cells only
[sact,~] = size(actall); 

for i=1:1:sact
    actmean(i)=mean(actall(i,:));
    actsem(i)=std(actall(i,:))/sqrt(length(actall));
   
end

%mean of inhibited cell

%     if inhcells~=0 %eliminates error when inhibited cells are not present
 inhall=allanims(:,inhcells);
[sinh,~] = size(inhall);

 for i=1:1:sinh
        inhmean(i)=mean(inhall(i,:));
        inhsem(i)=std(inhall(i,:))/sqrt(length(inhall));  
 end
     
%mean of non responsive cells

%  nonall=allanims(:,noncells);
%  [snon,~] = size(nonall);
% 
%   for i=1:1:snon
%          nonmean(i)=mean(nonall(i,:));
%          nonsem(i)=std(nonall(i,:))/sqrt(length(nonall));  
%  end

% 
% %%%%% during transition 1
allanims_t1=allanims 
actall_t1=actall
actcells_t1=actcells
actmean_t1=actmean
actsem_t1=actsem
inhall_t1=inhall
inhcells_t1=inhcells
inhmean_t1=inhmean
inhsem_t1=inhsem

clear allanims actall actcells actmean actsem inhall inhcells inhmean inhsem

% %%%%%  during transition 2  
allanims_t2=allanims; 
actall_t2=actall;
actcells_t2=actcells;
actmean_t2=actmean;
actsem_t2=actsem;
inhall_t2=inhall;
inhcells_t2=inhcells;
inhmean_t2=inhmean;
inhsem_t2=inhsem;

clear allanims actall actcells actmean actsem inhall inhcells inhmean inhsem



%%
%FIND MEAN OF RESPONSIVE CELLS DURING OTHER CONDITIONS 
% z should be equal to the position vector of the responsive cells on other
% behaviors

t2_in_t1=allanims_t2(:,actcells_t1);
[sct2_in_t1,~] = size(t2_in_t1);

for i=1:1:sct2_in_t1
       actmean_t2_in_t1(i)=mean(t2_in_t1(i,:));
       actsem_t2_in_t1(i)=std(t2_in_t1(i,:))/sqrt(length(t2_in_t1));  
end
 
t1_in_t2=allanims_t1(:,actcells_t2);
[sct1_in_t2,~] = size(t1_in_t2);

for i=1:1:sct1_in_t2
       actmean_t1_in_t2(i)=mean(t1_in_t2(i,:));
       actsem_t1_in_t2(i)=std(t1_in_t2(i,:))/sqrt(length(t1_in_t2));  
end
 



%%
figure(1)
shadedErrorBar(1:length(actmean_t1), actmean_t1, actsem_t1,'lineprops', {'r','markerfacecolor',[0 0 1]},'transparent',1,'patchSaturation',0.3)
hold on
shadedErrorBar(1:length(actmean_t1), actmean_t1_in_t2, actsem_t1_in_t2, 'lineprops','c','transparent',1,'patchSaturation',0.3)
hold off
xlabel('time')
ylabel('z-score')
axis([0 75 -0.5 1.5]) 
figure(2)
shadedErrorBar(1:length(actmean_t2), actmean_t2, actsem_t2, 'lineprops','g','transparent',1,'patchSaturation',0.3)
hold on
shadedErrorBar(1:length(actmean_t2), actmean_t2_in_t1,  actsem_t2_in_t1, 'lineprops','c','transparent',1,'patchSaturation',0.3)
hold off
xlabel('time')
ylabel('z-score')
axis([0 75  -0.5 1.5]) 

%%
figure(3)
shadedErrorBar(time, rPLaactmean, rPLaactsem, 'lineprops','y','transparent',1,'patchSaturation',0.53)
hold on
shadedErrorBar(time, rPLshtactmean, rPLshtactsem, 'lineprops','c','transparent',1,'patchSaturation',0.33)
hold off
xlabel('time')
ylabel('z-score')
axis([-8 8 -1 6])
figure(4)
shadedErrorBar(time, rPLainhmean, rPLainhsem, 'lineprops','g','transparent',1,'patchSaturation',0.33)
hold on
shadedErrorBar(time, rPLshtinhmean, rPLshtinhsem, 'lineprops','c','transparent',1,'patchSaturation',0.33)
hold off
xlabel('time')
ylabel('z-score')
axis([-8 8 -5 2])

%%

figure;
y=cPLavoidinhshuttle; 
x=(1:1:80);
shadedErrorBar(x,cPLshtactmean,cPLshtactsem,'lineprops','b','transparent',1,'patchSaturation',0.33);
hold on
y=actall;
shadedErrorBar(x,cPLaactmean,cPLaactsem,'lineprops','r','transparent',1);
hold off
%%
%Display
clc;
txt.n=['number of animals=',num2str(length(varlist))];
txt.cell=['Total numebr of cells=',num2str(cc)]; 
txt.actcell=['Number of activated cells=', num2str(max(size(actcells_t1)))];
txt.inhcell=['Number of inhibited cells=', num2str(max(size(inhcells_t1)))];
txt.noncell=['Number of noresponsive cells=', num2str(cc-max(size(actcells_t1))-max(size(inhcells_t1)))];
txt.percentact=['% of activated cells=', num2str(max(size(actcells_t1))/cc*100),'%'];
txt.percentinh=['% of inhibited cells=', num2str(max(size(inhcells_t1))/cc*100),'%'];
txt.percentnon=['% of nonresponsive cells=', num2str((cc-max(size(actcells_t1))-max(size(inhcells_t1)))/cc*100),'%'];

clc;
txt.n=['number of animals=',num2str(length(varlist))];
txt.cell=['Total numebr of cells=',num2str(cc)]; 
txt.actcell=['Number of activated cells=', num2str(max(size(actcells_t2)))];
txt.inhcell=['Number of inhibited cells=', num2str(max(size(inhcells_t2)))];
txt.noncell=['Number of noresponsive cells=', num2str(cc-max(size(actcells_t1))-max(size(inhcells_t2)))];
txt.percentact=['% of activated cells=', num2str(max(size(actcells_t2))/cc*100),'%'];
txt.percentinh=['% of inhibited cells=', num2str(max(size(inhcells_t2))/cc*100),'%'];
txt.percentnon=['% of nonresponsive cells=', num2str((cc-max(size(actcells_t2))-max(size(inhcells_t2)))/cc*100),'%'];

disp(txt.n);
disp(txt.cell);
disp(txt.actcell);
disp(txt.percentact);
disp(txt.inhcell);
disp(txt.percentinh);
disp(txt.percentnon);
disp(txt.noncell);



%% 
figure(5)
errorbar(1:length(actmean), actmean, actsem, '-r')
hold on
errorbar(1:length(inhmean), inhmean, inhsem, '-b')
hold off
 %%
 thetasap=flockmean9sap/max(flockmean9sap)
 thetaret=flockmean9ret/max(flockmean9ret)
 thetaexplo=flockmean9expl/max(flockmean9expl)
 
 figure(8)
 rose(thetasap,40)
 hold on
 rose(thetaexplo,40)
 hold on
 rose(thetaret,40)
 hold off
 
 %%
 
