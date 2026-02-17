%code to calculate the speed of the center of the animal
%detect fz (fz_1s) and immob (fz_immob)events

clear a b c i j wrg_nk int_wrg_nk;

%%%% 1. Smoothing of CENTER and NECK positions %%%
ctrx=smooth(ctrx,5,'moving');
ctry=smooth(ctry,5,'moving');
nkx=smooth(nkx,5,'moving');
nky=smooth(nky,5,'moving');

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
cms_speed=s_speed*2.4;      % 1pix=0.08cm ; 30fps ; 0.08*30=2.4
s_speed_cms=cms_speed;

dlmwrite(strcat(filepath,'s_speed_ctr_fr_pix_',groupmousedate,'.txt'),s_speed);  % .txt file to be created in the path
dlmwrite(strcat(filepath,'s_speed_ctr_cm_s_',groupmousedate,'.txt'),s_speed_cms); 
dlmwrite(strcat(filepath,'pos_ctr_',groupmousedate,'.txt'),pos_ctr);

% dlmwrite(strcat(filepath,'speed_time_vit_',groupmousedate,'.csv'),[time,s_speed]);
% dlmwrite(strcat(filepath,'speed_time_vit_cm_s_',groupmousedate,'.csv'),[time,s_speed_cms]);
dlmwrite(strcat(filepath,'speed_time_vit_',groupmousedate,'.csv'),s_speed);
dlmwrite(strcat(filepath,'speed_time_vit_cm_s_',groupmousedate,'.csv'),s_speed_cms);

clear distnkx;
clear distnky;
clear i_speed_nk;
clear s_speed_nk;
clear a_speed_nk;

%%%% 1.b. instant speed calculation for NECK  

distnkx=[0;diff(nkx)];      
distnky=[0;diff(nky)];

i_speed_nk=sqrt((distnkx.^2)+(distnky.^2)); % instant speed (neck)
    % i_speed=((sqrt((distnkx.^2)+(distnky.^2)))/(1/30))
s_speed_nk=i_speed_nk;
pos_nk=[nkx,nky];

%convert to cm/s
cms_speed_nk=s_speed_nk*2.4;      % 1pix=0.08cm ; 30fps ; 0.08*30=2.4
s_speed_nk_cms=cms_speed_nk;

dlmwrite(strcat(filepath,'s_speed_nk_fr_pix_',groupmousedate,'.txt'),s_speed_nk);
dlmwrite(strcat(filepath,'s_speed_nk_cm_s_',groupmousedate,'.txt'),s_speed_nk_cms); 
dlmwrite(strcat(filepath,'pos_nk_',groupmousedate,'.txt'),pos_nk);

% dlmwrite(strcat(filepath,'s_speed_nk_time_vit_',groupmousedate,'.csv'),[time,s_speed_nk]);
% dlmwrite(strcat(filepath,'s_speed_nk_time_vit_cm_s',groupmousedate,'.csv'),[time,s_speed_nk_cms]);
dlmwrite(strcat(filepath,'speed_nk_time_vit_',groupmousedate,'.csv'),s_speed_nk);
dlmwrite(strcat(filepath,'speed_nk_time_vit_cm_s_',groupmousedate,'.csv'),s_speed_nk_cms);



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


%%%% 3. Condition to check that s_speed_neck < 0.5 during center_fz events
clear i 
clear a
a=length(fz);

threshold_nk = 0.5;   %%% (0.5pix/fr => 1.2cm/s)

% Detect times when NECK speed is < to "threshold_nk" (detection w/ double condition)
% neck times will be counted among the times where CENTER speed is below threshold
clear i j k fz_speed_nk
fz_speed_nk=[];
m=length(fz);

for i=1:m
    a=fz(i,1);
    b=fz(i,2);
    speed_nk_fz=s_speed_nk(a:b);
    k=(b-a)+1;
    for j=1:k
        if speed_nk_fz(j)<threshold_nk
            fz_speed_nk=[fz_speed_nk;frames(a+j-1)];
        end
    end
end

% 3.a. Put 1st value as start of first nk fz interval
intervals_fz_nk=[fz_speed_nk(1)];


% 3.b. Detect switch from 1 nk fz frame to another, when increment is > 1
clear i
clear a
a=length(fz_speed_nk);

for i=2:a
    if (fz_speed_nk(i))-(fz_speed_nk(i-1))>1
          intervals_fz_nk=[intervals_fz_nk;fz_speed_nk(i-1);fz_speed_nk(i)];
    end
end

% 3.c. Add last value as end of last nk fz episode
int_fz_nk=[intervals_fz_nk;fz_speed_nk(end)];
clear intervals_fz_nk;


% 3.d. Create matrix with beg/end of nk fz intervals with frames, time, duration,average speed
clear i
clear fz_nk
fz_nk=[];

for i=1:2:size(int_fz_nk)
   if  (time(int_fz_nk(i+1))-time(int_fz_nk(i)))>= 0.5
       fz_nk=[fz_nk;int_fz_nk(i),int_fz_nk(i+1),time(int_fz_nk(i)),time(int_fz_nk(i+1)),time(int_fz_nk(i+1))-time(int_fz_nk(i)),mean(s_speed_nk(int_fz_nk(i):int_fz_nk(i+1)))];  
   end 
end


%%%% 4. save as text file, matrices for CENTER and NECK : "editor" file gives only beg/end time of each FZ episode  
dlmwrite(strcat(filepath,'m_fz_',groupmousedate,'.txt'),fz,'precision',10);
dlmwrite(strcat(filepath,'m_fz_editor_',groupmousedate,'.txt'),fz(:,3:4),'precision',10);
dlmwrite(strcat(filepath,'m_fz_nk_',groupmousedate,'.txt'),fz_nk,'precision',10);
dlmwrite(strcat(filepath,'m_fz_nk_editor_',groupmousedate,'.txt'),fz_nk(:,3:4),'precision',10);

% fz: data in order, beg&end of FZ (in #frame), beg&end of FZ (in sec), duration of episode, mean speed 

%%%% remove useless variables
clear i j m a b k immob one_sec distctrx distctry immob_sec fz fz_speed fz_speed_nk speed_nk_fz int_fz int_fz_nk intervals_fz threshold threshold_nk
