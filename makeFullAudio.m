clear all
% first sound
filename='D:\CRL_SQ_15s_final.wav';

[y,Fs] = audioread(filename);

xtime=(1/Fs:1:length(y))./Fs;

[aa a]=min(abs(xtime-16.5),[],2);
b=a+(30*Fs);

figure;
plot(xtime,y(:,2))
figure;
plot(xtime(a:b),y(a:b,2))

CtoS=y(a:b,:);

% second sound
clear y Fs a b xtime
filename='D:\SQ_CRL_15s_final.wav';
[y,Fs] = audioread(filename);

xtime=(1/Fs:1:length(y))./Fs;
[aa a]=min(abs(xtime-10.22),[],2);
b=a+(30*Fs);

figure;
plot(xtime,y(:,2))
figure;
plot(xtime(a:b),y(a:b,2))

StoC=y(a:b,:);

TotalTime=540;

y2=zeros(TotalTime*Fs,2);

SCtimes=[30 300 420];
CStimes=[90 240 480];
SCtimes=SCtimes*Fs;
CStimes=CStimes*Fs;

for i=1:length(SCtimes)
   
    y2(SCtimes(i):SCtimes(i)+length(StoC)-1,:)=StoC;
    y2(CStimes(i):CStimes(i)+length(CtoS)-1,:)=CtoS;
end


xtime2=(1/Fs:1:TotalTime*Fs)./Fs;
figure;
plot(xtime2,y2)

filename='D:\HAB_SQ_CRL_SQ.wav';
audiowrite(filename,y2,Fs)


y2=zeros(TotalTime*Fs,2);

CStimes=[30 300 420];
SCtimes=[90 240 480];
SCtimes=SCtimes*Fs;
CStimes=CStimes*Fs;

for i=1:length(SCtimes)
   
    y2(SCtimes(i):SCtimes(i)+length(StoC)-1,:)=StoC;
    y2(CStimes(i):CStimes(i)+length(CtoS)-1,:)=CtoS;
end


xtime2=(1/Fs:1:TotalTime*Fs)./Fs;
figure;
plot(xtime2,y2)

filename='D:\HAB_CRL_SQ_CRL.wav';
audiowrite(filename,y2,Fs)

