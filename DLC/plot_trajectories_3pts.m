figure
xlim([min(ctrx(:,1)) max(ctrx(:,1))])
ylim([min(ctry(:,1)) max(ctry(:,1))])
hold on
clear i

for i=8190:8210;
    plot(ctrx(i,1),ctry(i,1),'o-r')
    hold on
    plot(nsx(i,1),nsy(i,1),'x-k')
%     hold on
%     plot(tbx(i,1),tby(i,1),'+-b')
    pause(0.033333)
    disp(i)
end;



figure
xlim([min(s_speed_ns(:,1)) max(s_speed_ns(:,1))])
ylim([min(s_speed_ns(:,1)) max(s_speed_ns(:,1))])
hold on
clear i;


%%%%% to plot when you want to check the speed from frame interval!! %%%
plot(s_speed(21840:21870)) % center speed
hold on
plot(s_speed_ns(21840:21870)) % nose speed


plot(ctrx(22200:22310),ctry(22200:22310)) % plots center coordinate position from 2 defined frames
hold
Current plot held
plot(nsx(22200:22310),nsy(22200:22310))
hold
Current plot released
plot(nsx(22200:22310),nsy(22200:22310))


for i=3400:3600; 
    plot(ctrx(i,1),ctry(i,1),'o-r')      % from given frame interval, dynamic plot of   
    hold on                               % center position (in o) and nose (in x)
    plot(nsx(i,1),nsy(i,1),'x-k')
%      hold on
%     plot(rex(i,1),rey(i,1),'+-b')
    pause(0.033333)
    disp(i)
end;


%%%% Plot trajectories of ctr from 10sec before 5 Loom onset to 20 sec after
clear i j
plots_s_speed=[];


for i=1:length(framesfiveloom);
    plots_s_speed=[plots_s_speed,s_speed(framesfiveloom(i,1)-300:framesfiveloom(i,2)+300)];
end;
        

clear i r p
[r,p]=size(plots_s_speed)
mean_plots_s_speed=[linspace(-10,20,r)',zeros(r,1)];

for i=1:r
    mean_plots_s_speed(i,2)=nanmean(plots_s_speed(i,1:20));
end;

figure
xlim([-10 20])
ylim([0 50])
hold on
clear i

plot(mean_plots_s_speed(:,1),plots_s_speed(:,1:20))


figure
xlim([-10 20])
ylim([0 20])
hold on
clear i
plot(mean_plots_s_speed(:,1),mean_plots_s_speed(:,2))


figure
xlim([-10 20])
ylim([0 50])
for i=1:p;
    plot(mean_plots_s_speed(:,1),plots_s_speed(:,i));
    pause(0.75)
end;


%%%% Attempt to bin speed for 5 values and plot
figure
xlim([-10 20])
ylim([0 50])
clear i k m
av_plots=zeros(180,20);


for i=1:p
    k=1;
    m=1;
    for m=1:5:r
        av_plots(k,i)=nanmean(plots_s_speed(m:m+4,i));
        k=k+1;
    end;
end;

