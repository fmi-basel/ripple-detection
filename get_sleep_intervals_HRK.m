%%Individuation of SWS/REM intervals during Sleep 


%% Pre-treatment of data 

%load from nex the lfp and instantaneous velocity of interest
CH_of_interest=55;               %modify in case of different denomination of hippocampal channels
temp=eval(sprintf('FP%d',CH_of_interest));
ts=eval(sprintf('FP%d_ts',CH_of_interest));
step=eval(sprintf('FP%d_ts_step',CH_of_interest));

%create variable 'lfp': column 1: timestamps; column 2: lfp
lfp=zeros(length(temp),2);
lfp(:,2)=temp;
lfp(:,1) = linspace(ts(1), (length(temp)*step)+ts(1), length(temp));

%create variable for instantaneous velocity ('v'): column 1: timestamps;
%column 2: instantatneous velocity
v=zeros(length(Motion),2);    %% get mobility from 'Motion'
v(:,2) = smoothdata(Motion, 'movmedian', 10);
fill_sec=linspace(0,length(Motion)/30,length(Motion)+1);
v(:,1)=fill_sec(2:end);

figure; plot(v(:,1),v(:,2),'k'); %plot v to check for correct thresholding of quiescence periods

clear temp ts step fill_sec

%filename=('C:\Users\h-rkim\Documents\MATLAB\workspace\IINS MEETING\Sleep_periods\sleep_analysis.mat');
save('sleep_analysis')

%% Extraction of quiescence periods

threshold_rest=60; %minimal lenght of periods to be considered as quiet (in s)
threshold_motion=0.8; %maximal value of instantaneous velocity to be considered as a moment of immobility
[periods,quiescence] = QuietPeriods(v,threshold_motion,threshold_rest); %'periods' is a matrix of timestamps of start and end of each quiet period

figure; hold on %plot motion index and quietness intervals on the same graph
plot(v(:,1),v(:,2), 'k')
for i = 1:size(periods, 1)
    line([periods(i,1) periods(i,2)],[1 1], 'Color', 'red')
end
hold off

clear i

save('sleep_analysis')

%% Individuation of SWS/REM periods

%generate and plot the spectrogram from lfp data
[s,t,f] = MTSpectrogram(lfp, 'frequency', 1000, 'window', 1, 'range', [0 20], 'pad', 3, 'cutoffs', [0 0.05], 'tapers', [3 5], 'show', 'on');

%generate logical tables for sws, rem and exploration 
[exploration,sws,rem] = BrainStates(s, t, f, quiescence, [], 'nClusters', 2, 'method', 'hippocampus');

%generate intervals for Exploration.
te = find(exploration == 1);
time_exploration = t(te,1);
clear te
[idx, ~] = find(diff(time_exploration) > 0.6);
idx=[idx;size(time_exploration,1)];

int_exploration = zeros(size(idx,1),2);
int_exploration(1,1)=time_exploration(1);
int_exploration(1,2)=time_exploration(idx(1));
for i=2:size(idx,1)
    int_exploration(i,1)=time_exploration(idx(i-1)+1,1);
    int_exploration(i,2)=time_exploration(idx(i));
end
clear idx

%generate intervals for REM.
tr = find(rem == 1);
time_REM = t(tr,1);
clear tr
[idx, ~] = find(diff(time_REM) > 0.6);
idx=[idx;size(time_REM,1)];

int_REM = zeros(size(idx,1),2);
int_REM(1,1)=time_REM(1);
int_REM(1,2)=time_REM(idx(1));
for i=2:size(idx,1)
    int_REM(i,1)=time_REM(idx(i-1)+1);
    int_REM(i,2)=time_REM(idx(i));
end

clear idx

%generate intervals for SWS.
ts = find(sws == 1);
time_SWS = t(ts,1);
clear ts
[idx, ~] = find(diff(time_SWS) > 0.6);
idx=[idx;size(time_SWS,1)];

int_SWS = zeros(size(idx,1),2);
int_SWS(1,1)=time_SWS(1);
int_SWS(1,2)=time_SWS(idx(1));
for i=2:size(idx,1)
    int_SWS(i,1)=time_SWS(idx(i-1)+1);
    int_SWS(i,2)=time_SWS(idx(i));
end
   
clear idx


% plot exploration/REM/SWS with motion index.
figure; hold on
plot(v(:,1),v(:,2), 'k')
for i = 1:size(int_exploration, 1)
    line([int_exploration(i,1) int_exploration(i,2)],[4 4], 'Color', 'red', 'Linewidth', 10)
 end
for i = 1:size(int_REM, 1)
    line([int_REM(i,1) int_REM(i,2)],[3.5 3.5], 'Color', 'b', 'Linewidth', 10)
end
for i = 1:size(int_SWS, 1)
    line([int_SWS(i,1) int_SWS(i,2)],[3 3], 'Color', 'k', 'Linewidth', 10)
end
for i = 1:size(periods, 1)
    line([periods(i,1) periods(i,2)],[4.5 4.5], 'Color', 'red')
end
hold off

clear i


% save('intervalexpREMSWS_mPFC.mat','int_exploration', 'int_REM', 'int_SWS')
% 
% filename=('C:\Users\h-rkim\Documents\MATLAB\workspace\IINS MEETING\Sleep_periods\sleep_analysis.mat');
% save('sleep_analysis.mat') 

save('intervalexpREMSWS_mPFC.mat', 'int_exploration', 'int_REM', 'int_SWS')
save('sleep_analysis.mat') 
