clear ripwindow spk_all_count mean_all shuffle_all
clear SPK*

TB=0.01;
spk_all_count=[];
shuffle_all=[];
spk_all=Matrix_TS;
tic

for i=1:50 %number of shuffles
index=randperm(size(FP55_LocRipples,1),1000); %get 1000 random indexes from 1 to size of ripples
randrip=FP55_LocRipples(index); %use the index to get timestamps

for r=1:length(randrip)
    ripwindow(r,:)=(randrip(r)-0.5:TB:randrip(r)+0.49); %1s window around ripple
end


mean_all=[];

    for n=1:size(spk_all,2) %loop through neurons
        curr_neu=spk_all(:,n);
        
        clear spkcount
        for  m=1:size(ripwindow,1) %rows (different ripples)
            ct=0;
            for y=ripwindow(m,1:end) %timebins(10 ms bins of one ripple)
                ct=ct+1;
                Tbin=[y y+TB];
                spkcount(m,ct)=length(curr_neu(curr_neu>y & curr_neu<(y+TB))); %spikes  per timebin
            end
         end
         spk_all_count=cat(3,spk_all_count,spkcount); %spike counts for all neurons (3rd dim). ripples x timebins x neurons
         spk_fq=spkcount*100;
         mean_spk=mean(spk_fq,1);
         mean_all=cat(3,mean_all,mean_spk);
    end  
    
shuffle_all=cat(1,shuffle_all,mean_all); %save shuffle results. Shuffle x timebins x neurons


end

toc

shmean_all=[];
for n=1:size(shuffle_all,3) %loop through neurons to average the shuffles
    currneu=shuffle_all(:,:,n);
    shmean=mean(currneu,1);
    
    shmean_all=cat(1,shmean_all,shmean); %neurons x timebins
    
end


edges=(1:1:100);
figure; %spike histogram.
for n=1:size(shuffle_all,3)
subplot(1,size(shuffle_all,3),n)
histogram(shmean_all(n,:),edges)
end

% s= who('SPK*')
% 
% spikeTimes = [0.9 1.1 1.2 2.5 2.8 3.1];
% stimTimes = [1 2 3 4 5];        
% preStimTime = 0.5;
% postStimTime = 0.5;
% for iStim = 1:length(stimTimes)
%     % find spikes within time window
%     inds = find((spikeTimes > (stimTimes(iStim) - preStimTime)) & (spikeTimes < (stimTimes(iStim) + postStimTime)));
%     % align spike times to stimulus onset
%     stimONtimes = spikeTimes(inds) - stimTimes(iStim);
%     % store times in array for plotting
%     PSTH_array(iStim,1:length(stimONtimes)) = stimONtimes;
% end

