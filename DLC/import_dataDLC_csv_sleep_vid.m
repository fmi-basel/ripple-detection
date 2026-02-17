clear all
data=importdata('D:\HERRYTEAM Dropbox\Ha-Rang K\DLC - analysed & results\M329-M389 SLEEP\MOUSE (DLC analysed)\M379\M379-FC-sleepDLC_resnet50_SleepMay10shuffle1_1030000filtered.csv');

filepath='C:\Users\hrkim\Desktop\DLC_result_Sleep\';  % define where to save results
groupmousedate='M384_TEST2_sleep'; % give the file name (#mouse and test type)

frames = data.data(:,1);
frames=[frames(2:end);frames(end)+1];
time=[];
time=frames*0.033333;  %converts to seconds

nkx = data.data(:,2);   %neck X&Y
nky = data.data(:,3);
lhnk = data.data(:,4);  %likelihoood neck

ctrx = data.data(:,5);   % center X&Y
ctry = data.data(:,6);
lhctr = data.data(:,7);   %likelihoood center


%%%% to plot trajectories of CENTER & NECK coordinates & likelihood  
subplot(2,2,1), plot(ctrx,ctry)
subplot(2,2,2), plot(nkx,nky)
subplot(2,2,3), plot(lhctr)
subplot(2,2,4), plot(lhnk)

length_session=length(frames);
duration_session=time(end);

dlmwrite(strcat(filepath,'length_session_',groupmousedate,'.txt'),length_session);
dlmwrite(strcat(filepath,'duration_session_',groupmousedate,'.txt'),duration_session,'precision',10);

