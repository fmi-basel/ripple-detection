clear all
data=importdata('C:\Users\hrkim\Desktop\DLC result_BEHAV\M381-HABDLC_resnet50_FINAL2Oct21shuffle1_1030000filtered.csv');

filepath='C:\Users\hrkim\Desktop\DLC result_BEHAV\';  % define where to save results
groupmousedate='M381_HAB'; % give the file name (#mouse and test type)

frames = data.data(:,1);
frames=[frames(2:end);frames(end)+1];
time=[];
time=frames*0.033333;  %converts to seconds

nsx = data.data(:,2);  %nose X&Y
nsy = data.data(:,3);
lhns = data.data(:,4);  %likelihoood nose
ctrx = data.data(:,8);   % center X&Y
ctry = data.data(:,9);
lhctr = data.data(:,10);   %likelihoood center

nkx = data.data(:,5);   %neck X&Y
nky = data.data(:,6);
lhnk = data.data(:,7);  %likelihoood neck

%%%% to plot trajectories of center/nose coordinates & likelihood of center and nose 
% subplot(2,2,1), plot(ctrx,ctry)
% subplot(2,2,2), plot(nsx,nsy)
% subplot(2,2,3), plot(lhctr)
% subplot(2,2,4), plot(lhns)

subplot(2,2,1), plot(ctrx,ctry)
subplot(2,2,2), plot(nkx,nky)
subplot(2,2,3), plot(lhctr)
subplot(2,2,4), plot(lhnk)

length_session=length(frames);
duration_session=time(end);

dlmwrite(strcat(filepath,'length_session_',groupmousedate,'.txt'),length_session);
dlmwrite(strcat(filepath,'duration_session_',groupmousedate,'.txt'),duration_session,'precision',10);

