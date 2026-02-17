%code to calculate the speed of the center of the animal
%detect fz (fz_1s) and immob (fz_immob)events

clear a b c i j wrg_ns int_wrg_ns;

%%%% 1. Smoothing of CENTER and NOSE positions %%%
ctrx=smooth(ctrx,5,'moving');
ctry=smooth(ctry,5,'moving');
nsx=smooth(nsx,5,'moving');
nsy=smooth(nsy,5,'moving');

clear distctrx;
clear distctry;
clear i_speed;
clear s_speed;
clear a_speed;

%%%% 1.a. instant speed calculation for CENTER  
distctrx=[0;diff(ctrx)];   
distctry=[0;diff(ctry)];

i_speed=sqrt((distctrx.^2)+(distctry.^2));  % instant speed (center)
    % i_speed=((sqrt((distctrx.^2)+(distctry.^2)))/(1/30))
s_speed=i_speed;
pos_ctr=[ctrx,ctry];

%convert to cm/s
%cms_speed=s_speed*2.4; % 1pix=0.08cm ; 30fps ; 0.08*30=2.4
%s_speed=cms_speed;

dlmwrite(strcat(filepath,'s_speed_ctr_',groupmousedate,'.txt'),s_speed);  % .txt file to be created in the path
dlmwrite(strcat(filepath,'pos_ctr_',groupmousedate,'.txt'),pos_ctr);

clear distnsx;
clear distnsy;
clear i_speed_ns;
clear s_speed_ns;
clear a_speed_ns;

%%%% 1.b. instant speed calculation for NOSE  

distnsx=[0;diff(nsx)];      
distnsy=[0;diff(nsy)];

i_speed_ns=sqrt((distnsx.^2)+(distnsy.^2)); % instant speed (nose)
    % i_speed=((sqrt((distnsx.^2)+(distnsy.^2)))/(1/30))
s_speed_ns=i_speed_ns;
pos_ns=[nsx,nsy];

dlmwrite(strcat(filepath,'s_speed_ns_',groupmousedate,'.txt'),s_speed_ns);
dlmwrite(strcat(filepath,'pos_ns_',groupmousedate,'.txt'),pos_ns);



%%%% 2. Freezing and immob detection FOR CENTER %%
clear a
clear i
clear fz_speed
clear intervals_fz
clear int_fz

a=length(s_speed);
fz_speed=[];
                    % adapt threshold value 
threshold=0.65;     % here 0.65=1.56cm/s (for CENTER)
                    % speed threshold in pix/frame
                    % speed threshold in cm/s (pix/frame x 2.4)

for i=2:a                    
    if s_speed(i)<threshold              % Detect times when speed is inferior to threshold
       fz_speed=[fz_speed;frames(i)];  % write the #frame satisfying the condition
    end;
end

% 2.a. Put 1st value as START of first fz interval
intervals_fz=[fz_speed(1)];


% 2.b. Detect switch from 1 fz frame to another, when increment is > 1
clear i
clear a
a=length(fz_speed);

for i=2:a
    if (fz_speed(i))-(fz_speed(i-1))>1
        intervals_fz=[intervals_fz;fz_speed(i-1);fz_speed(i)];
    end
end

% 2.c. Add last value as END of last fz episode
int_fz=[intervals_fz;fz_speed(end)];
clear intervals_fz;


    % fz intervals with frames/time to calculate duration and condition >0.5s
    % and >1s to only extract those events (if not then too long)

% 2.d. Create matrix with fz intervals beg/end frames, time, duration, average speed
clear i fz
time_th=1;
fz=[];

for i=1:2:size(int_fz)
   if  (time(int_fz(i+1))-time(int_fz(i)))>=time_th
       fz=[fz;int_fz(i),int_fz(i+1),time(int_fz(i)),time(int_fz(i+1)),time(int_fz(i+1))-time(int_fz(i)),mean(s_speed(int_fz(i):int_fz(i+1)))];
   end
end


%%%% 3. Condition to check that s_speed_nose < 0.5 during center_fz events
clear i 
clear a
a=length(fz);
threshold_ns=0.5;   %%% (0.5pix/fr => 1.2cm/s)

% Detect times when NOSE speed is < to "threshold_ns" (detection w/ double condition)
% nose times will be counted among the times where CENTER speed is below threshold
clear i j k fz_speed_ns
fz_speed_ns=[];
m=length(fz);

for i=1:m
    a=fz(i,1);
    b=fz(i,2);
    speed_ns_fz=s_speed_ns(a:b);
    k=(b-a)+1;
    for j=1:k
        if speed_ns_fz(j)<threshold_ns
            fz_speed_ns=[fz_speed_ns;frames(a+j-1)];
        end
    end
end

% 3.a. Put 1st value as start of first ns fz interval
intervals_fz_ns=[fz_speed_ns(1)];


% 3.b. Detect switch from 1 ns fz frame to another, when increment is > 1
clear i
clear a
a=length(fz_speed_ns);

for i=2:a
    if (fz_speed_ns(i))-(fz_speed_ns(i-1))>1
          intervals_fz_ns=[intervals_fz_ns;fz_speed_ns(i-1);fz_speed_ns(i)];
    end
end

% 3.c. Add last value as end of last ns fz episode
int_fz_ns=[intervals_fz_ns;fz_speed_ns(end)];
clear intervals_fz_ns;


% 3.d. Create matrix with beg/end of ns fz intervals with frames, time, duration,average speed
clear i
clear fz_ns
fz_ns=[];

for i=1:2:size(int_fz_ns)
   if  (time(int_fz_ns(i+1))-time(int_fz_ns(i)))>= 0.5
       fz_ns=[fz_ns;int_fz_ns(i),int_fz_ns(i+1),time(int_fz_ns(i)),time(int_fz_ns(i+1)),time(int_fz_ns(i+1))-time(int_fz_ns(i)),mean(s_speed_ns(int_fz_ns(i):int_fz_ns(i+1)))];  
   end
end


% %sort remaining events as immob or fz
% clear i half_sec immob one_sec fz_1sb fz_immob
% immob=[];
% one_sec=[];
% fz_1s=[];
% fz_immob=[];
% 
% %keep only events lasting >0.5s
% clear k
% clear m
% k=0.5; %time threshold to get immob & fz events
% m=1; %time threshold to get fz events (>1s)
% 
% %only select events that last from 0.5s to 1s
% immob=find((fz_ns(:,5)>=k)&(fz_ns(:,5)<m));
% fz_immob=fz_ns(immob,:);
% %only select events whose duration >= 1s
% one_sec=find(fz_ns(:,5)>=m); 
% fz_1s=fz_ns(one_sec,:);
% 
% 
% dlmwrite(strcat(filepath,'m_fz_immob_editor_',groupmousedate,'.txt'),fz_immob(:,3:4),'precision',10);
% dlmwrite(strcat(filepath,'m_fz_1s_editor_',groupmousedate,'.txt'),fz_1s(:,3:4),'precision',10);
% dlmwrite(strcat(filepath,'m_immob_',groupmousedate,'.txt'),fz_immob,'precision',10);
% dlmwrite(strcat(filepath,'m_fz1s_',groupmousedate,'.txt'),fz_1s,'precision',10);




%%%% 4. save as text file, matrices for center and nose. "editor" file gives only beg/end time of each interval 
dlmwrite(strcat(filepath,'m_fz_',groupmousedate,'.txt'),fz,'precision',10);
dlmwrite(strcat(filepath,'m_fz_editor_',groupmousedate,'.txt'),fz(:,3:4),'precision',10);
dlmwrite(strcat(filepath,'m_fz_ns_',groupmousedate,'.txt'),fz_ns,'precision',10);
dlmwrite(strcat(filepath,'m_fz_ns_editor_',groupmousedate,'.txt'),fz_ns(:,3:4),'precision',10);

% fz: data in order, beg&end of FZ (in #frame), beg&end of FZ (in sec), duration of episode, mean speed 

%%%% remove useless variables
clear i j m a b k immob one_sec distctrx distctry immob_sec fz fz_speed fz_speed_ns speed_ns_fz int_fz int_fz_ns intervals_fz threshold threshold_ns
