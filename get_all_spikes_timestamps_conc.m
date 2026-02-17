clear all
filename=('D:\HERRYTEAM Dropbox\Ha-Rang K\PAPER 2024\data behavior\bootstrap_rearing_grooming_TEST\m346 m350\');
a=dir([filename,'*.mat']);

count=0;
for f=1:size(a,1)

direct=([filename a(f).name]);
b=load(direct);

name_units=whos('-file',direct);
Unit_number(f)=size(name_units,1);


    for s=1:size(name_units,1)
         count=count+1;
         MouseID{count,1}=a(f).name;
         MouseID{count,2}=name_units(s).name;
         Spike_TS{count}=(b.(name_units(s).name));
      
         
    end
end


filename=('D:\HERRYTEAM Dropbox\Ha-Rang K\PAPER 2024\data ephys\bootstrap\final_nex_mat\test1\Mat data\TimeStamps.mat');
load(filename,'Spike_TS','MouseID')