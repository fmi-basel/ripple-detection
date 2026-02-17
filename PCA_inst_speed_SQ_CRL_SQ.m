%%% generalizer
figure
plot(speedPCA(:,11));  %M261-test1

figure
plot(speedPCA(:,27));  %M269-test1

plot(smooth(speedPCA(:,11),300,'moving'))

% 280,282,283, 284, 285-test 1 , 341-test1, 342-test1, 343-test1 


%%% low freezing 

plot(speedPCA(:,23))  
% M267-test1, 338-test1, 338-test2, 300-test1, 307-test2, 287-test2 

%%% discriminator  

%M273-test1, M270-test1, 313 test2, 320-test1, 317-test2
%334-test2, 335-test2, 339-test1, 312- test1, 310-test1



%%%%% SMOOTHING %%%%%%%%%
clear speed_smooth
for i=1:148
    
speed_smooth(:,i)=smooth(speed_all_frame(:,i),300);   % change the value of smooth (in frame)

end
figure;
plot(mean(speed_smooth,2))             % plot of the mean of all PCs

clear coeff score latent tsquared explained mu 
[coeff,score,latent,tsquared,explained,mu] = pca(speed_smooth);
figure;
plot(score(:,1:3))



%%%% PCA with different timebin %%%%%%
clear coeff score latent tsquared explained mu 
variable_to_run=FZ_10sec_6min(:,:);
[coeff,score,latent,tsquared,explained,mu] = pca(variable_to_run);

clear coeff score latent tsquared explained mu 
variable_to_run=FZ_10s_test2(9:21,:)                             % make TIME sectioning
[coeff,score,latent,tsquared,explained,mu] = pca(variable_to_run);

x_to_use=(90:10:210)
figure;
plot(x_to_use,score(:,1:3),'LineWidth',3)
xlim([90 210])
box off
set(gca,'TickDir','out')

clear coeff score latent tsquared explained mu 
variable_to_run=FZ_10s_test2(25:37,:)                             % make TIME sectioning
[coeff,score,latent,tsquared,explained,mu] = pca(variable_to_run);

x_to_use=(250:10:370)
figure;
plot(x_to_use,score(:,1:3),'LineWidth',3)
xlim([250 370])
box off
set(gca,'TickDir','out')

figure;
plot(score(:,1:3),'LineWidth',3)
figure;
plot(score(:,4:5))

figure;
plot(explained,'-o')                      % plot distribution of variance


%%%
maxspeed=max(variable_to_run,[],1);
speed_10s_relative=variable_to_run./maxspeed;      % take out "max SPEED" datapoints 

clear coeff score latent tsquared explained mu 
[coeff,score,latent,tsquared,explained,mu] = pca(speed_10s_relative);
figure;
plot(score(:,1:3),'LineWidth',3)

maxFZ=max(variable_to_run,[],1);
FZ_10s_relative=variable_to_run./maxFZ;             % take out "max FZ" datapoints 

clear coeff score latent tsquared explained mu 
[coeff,score,latent,tsquared,explained,mu] = pca(FZ_10s_relative);
figure;
plot(score(:,1:3))



% created_score=speed_10s*coeff(:,1);
% figure;
% plot(score(:,1)),hold on
% plot(created_score-(mean(created_score)))




% threshold=0.05;
% 
% figure;
% plot(variable_to_run(:,find(coeff(:,1)>threshold)),'color',[0.8 0.8 0.8]),hold on
% plot(mean(variable_to_run(:,find(coeff(:,1)>threshold)),2),'color',[0 0 0])




%%%%%% correlation between ALL MICE and PC of choice %%%%%%%%%
PC_to_plot=1;
clear r p sig_p  
for i=1:size(variable_to_run,2)
    
    [r(i) p(i)]=corr(variable_to_run(:,i),score(:,PC_to_plot));
       
end

sig_p=find(p<0.05 & r>0);              % finding all mice positively correlated and significant
% sig_p=find(p<0.05 & r<0);

figure;                                % plot of mice correlated with PC of choice
plot(variable_to_run(:,sig_p),'color',[0.8 0.8 0.8]),hold on
plot(mean(variable_to_run(:,sig_p),2),'color',[0 0 0])

clear j k
j=variable_to_run(:,sig_p);
k=FZ_3min_test2(:,sig_p);

figure;
plot(mean(j));
figure;
plot(mean(k));
% figure;
% plot(variable_to_run(:,:),'color',[0.8 0.8 0.8]),hold on
% plot(mean(variable_to_run(:,:),2),'color',[0 0 0])

NonSig=(1:1:size(variable_to_run,2));         %finding mice that are other than significantly correlated ones
NonSig(sig_p)=[];

figure;
plot(variable_to_run(:,NonSig),'color',[0.8 0.8 0.8]),hold on
plot(mean(variable_to_run(:,NonSig),2),'color',[0 0 0])

NON_HIG=find(mean(variable_to_run(:,NonSig),1)>0.3);
NON_LOW=find(mean(variable_to_run(:,NonSig),1)<=0.3);

figure;
plot(variable_to_run(:,NonSig(NON_HIG)),'color',[0.8 0.8 0.8]),hold on
plot(mean(variable_to_run(:,NonSig(NON_HIG)),2),'color',[0 0 0])

figure;
plot(variable_to_run(:,NonSig(NON_LOW)),'color',[0.8 0.8 0.8]),hold on
plot(mean(variable_to_run(:,NonSig(NON_LOW)),2),'color',[0 0 0])

%%%%%%%%% bullshit
clear Bullshit
timebin=10;
Bullshit=[zeros(180/timebin,1); ones(180/timebin,1) ; zeros(180/timebin,1) ];


Bullshit=[ones(180/timebin,1); ones(180/timebin,1)./2 ; zeros(180/timebin,1) ];  % progressive extinction going up
Bullshit=[zeros(180/timebin,1); ones(180/timebin,1)./2 ; ones(180/timebin,1) ];  % progressive extinction going down

Bullshit=[zeros(180/timebin,1) ; zeros(180/timebin,1) ;ones(180/timebin,1)];
Bullshit=[ones(180/timebin,1) ; ones(180/timebin,1) ;zeros(180/timebin,1)];
Bullshit=[ones(180/timebin,1) ; zeros(180/timebin,1) ;ones(180/timebin,1)];

Bullshit=[ones(150/timebin,1) ; zeros(160/timebin,1) ;ones(160/timebin,1)];


figure;
plot(Bullshit) 

clear r p
clear sig_p2
for i=1:size(variable_to_run,2)
    
    [r(i) p(i)]=corr(variable_to_run(:,i),Bullshit);
       
end

sig_p2=find(p<0.05 & r>0);

figure;
plot(variable_to_run(:,sig_p2),'color',[0.8 0.8 0.8]),hold on
plot(mean(variable_to_run(:,sig_p2),2),'color',[0 0 0])

clear n m
n=variable_to_run(:,sig_p2);
m=FZ_3min_test1(:,sig_p2);


[C,ia,ib]=intersect(sig_p2,sig_p);
