clear all
data=importdata('D:\HERRYTEAM Dropbox\Ha-Rang K\DLC - analysed & results\M329-M389 BEHAV\MOUSE (DLC analysed)\M383\M383-FCDLC_resnet50_FINAL2Oct21shuffle1_1030000filtered.csv');

frames = data.data(:,1);
frames=[frames(2:end);frames(end)+1];
time=[];
time=frames*0.033333;                       %converts to seconds

ctr_x = data.data(:,8); 
ctr_y = data.data(:,9);

movement_x=diff(ctr_x);
movement_y=diff(ctr_y);

distance=(sqrt(movement_x .^2+movement_y .^2))*0.08;  % converts in cm 
                                                      % 1pix=0.08cm ; 30fps ; 0.08*30=2.4


% figure;
% plot(time(2:end),distance);
% 
% %%% for TEST %%% 
% pos180=find(round(time)==180,1);
% pos360=find(round(time)==360,1);
% pos540=find(round(time)==540,1);
% 
% Distance_bars=[sum(distance(1:pos180)) sum(distance(pos180+1:pos360)) sum(distance(pos360+1:pos540)) ];
% 
% %%%  for HABITUATION %%% 
% pos300=find(round(time)==300,1);
% Distance_bars=[sum(distance(1:pos180))];
% 
% 
% figure;
% bar(Distance_bars)
% title('Distance travelled')
% 
% figure;
% bar(Distance_bars./Distance_bars(1))
% title('Distance travelled relative to the first 180 s')


%%%%%%%%%% now 'binned'
clear bin_time bin ctr_x_binned ctr_y_binned movement_x_binned movment_y_binned distance_binned time_binned

bin_time=1;                     % put bin size in seconds
bin=round(bin_time/0.033333);   % converts in sec

ctr_x_binned = data.data(1:bin:end,8); 
ctr_y_binned = data.data(1:bin:end,9);

movement_x_binned=diff(ctr_x_binned);
movement_y_binned=diff(ctr_y_binned);

distance_binned=(sqrt(movement_x_binned .^2+movement_y_binned .^2))*0.08;   % dist converted in cm

time_binned=time(1:bin:end);

figure;
plot(time_binned(2:end),distance_binned);


%%%% distance travaled in each context 
pos180_binned=find(round(time_binned)==180,1);
pos360_binned=find(round(time_binned)==360,1);
pos540_binned=find(round(time_binned)==539,1); %%% doesnt reach 540 because is binned for one second

Distance_bars_binned=[sum(distance_binned(1:pos180_binned)) sum(distance_binned(pos180_binned+1:pos360_binned)) sum(distance_binned(pos360_binned+1:end)) ];
figure;
bar(Distance_bars_binned)

figure;
bar(Distance_bars_binned)

% pour FC - 5 miin explo + 4 min post-US
clear Distance_bars_binned
pos300fc_binned=find(round(time_binned)==300,1);
pos540_binnedfc=find(round(time_binned)==539,1);
Distance_bars_binned=[sum(distance_binned(1:pos300fc_binned)) sum(distance_binned(pos300fc_binned+1:end)) ];

figure;
bar(Distance_bars_binned)

figure;
bar(Distance_bars_binned./Distance_bars_binned(1))


%%%%% real bining for Ha-Rang

realbin_time=20; % in seconds

realbin=round(realbin_time/0.033333);

time_points=[(1:realbin:(size(distance,1))) length(distance)];

clear distance_real_binned

for i=1:round(size(time_points,2))-1

distance_real_binned(i)=sum(distance(time_points(i):time_points(i+1)));

end

x_binned=(1:round(size(time_points,2))-1)*realbin_time;

figure;
plot(x_binned,distance_real_binned)
