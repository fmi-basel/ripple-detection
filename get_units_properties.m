% %% Get single waveforms and average. 
% 
% for i = 1:size(ch_mpfc,1)
% %     temp = eval(strcat('Channel',ch_mpfc(i,1),'_wf'));
%     temp = eval(strcat('sig0',ch_mpfc(i,1),'_wf'));
%     temp2 = mean(temp, 2);
%     Unitswaveform(i,:) = temp2';
%     clear temp temp2
% end
% Unittime = linspace(16.66, 1049.66, 32);


%% when getting waveforms from nex.

c = who ('SPK*');
count=0;
for p = 1:length (c)   
    if contains(c{p},'_wf') & ~contains(c{p},'_ts')       % to get all waveforms
       count=count+1;
       use_wf{count}=c{p};      
    end
end

c= who ('SPK*','sSPK*','ssSPK*');
count=0;
for p = 1:length (c)   
     if ~contains(c{p},'_wf') & ~contains(c{p},'_ts') & ~contains(c{p},'_template') 
    %if contains (c{p},'*B') & contains (c{p},'*P')      % to get all units
       count=count+1;
       use_spk{count}=c{p};      
    end
end

for i = 1:size(use_wf,2)
    current_wf = eval(use_wf{i});
    mean_current_wf = mean(current_wf,2);               
    Unitswaveform(i,:) = mean_current_wf;      % calculate mean waveforms
    clear current_wf mean_current_wf
end 

 for i = 1:size(use_spk,2)
     current_spk=eval(use_spk{i});
    last_spike(i)=current_spk(end);
    number_spikes(i)=length(current_spk);      % calculate total nb of spikes per unit
end

figure;
plot(Unitswaveform')                           % mean waveform of each unit


figure;
plot(Unitswaveform(1,:)')


%% Import mean waveform as string. 1st line is Unit timestamp.

SR=40; % in ms
FR_use=1/40000;
time_use=(1:1:size(Unitswaveform,2)).*(FR_use*1000);

for i = 1:size(Unitswaveform,1)  %size(ch_mpfc,1) % ch_mpfc is a single column of string containing unit numbers. Remove empty rows.
    
FR_use=1/40000;
    temp =Unitswaveform(i,:);
%     temp = (temp*0.000305)*1000; % convert to microV.
    tsout = temp;
   
    
    
    [a1(i,1), I1] = min(tsout);                          % unit min in microvolts
    ta1(i,1) = I1*(FR_use*1000); % in miliseconds
   
    tsout_after_min=tsout(I1:end);
    
    [a2(i,1), I2] = max(tsout_after_min);                 % unit max AHP in microvolts
    ta2(i,1) = (I1+I2)*(FR_use*1000); % in miliseconds
    
        
    TP(i,1) = I2*FR_use*1000;                             % trough to peak in microseconds
                                                          % TP = distance btw the lowest and highest value
        
    
    ind1 = find(time_use < ta1(i,1));
    if isempty(ind1) == 0
        indd1 = find(tsout(ind1) >= a1(i,1)/2, 1, 'last' );
        ind1b = find(tsout(ind1) >= 0, 1, 'last' );
        tind1 = time_use(ind1b);
        tw1 = time_use(indd1);
        ind2 = find(time_use > ta1(i,1));
        ind2b = find(tsout(ind2) >= 0, 1, 'first' );
        indd2 = find(tsout(ind2) >= a1(i,1)/2, 1, 'first' );
        tind2 = time_use(ind2(ind2b));
        tw2 = time_use(ind2(indd2));
        HW(i,1) = tw2 - tw1;                        % half width in microsenconds.
    else
        HW(i,1) = NaN;
    end
    
    
    if exist('tind2')
        if isempty(ind2) == 0
            tauc1 = find(time_use > tind2);
            tv = time_use(tauc1);
            temp = tsout(tauc1);
            td(:,1) = temp(:,:,:);
            AUC(i,1) = trapz(tv, td);            %area under the curve in microsenconds/mV.
        else
            AUC(i,1) = NaN;
        end
    else
        AUC(i,1) = NaN;
    end
    clear temp
    
 
    FR(i,1) = number_spikes(1,i) / last_spike(i); % firing rate in Hz.

    
    clear idx temp ts I1 I2 ind1 ind1b tind1 ind2 ind2b tind2 tw1 tw2 indd1 indd2 tauc1 tv td tsout
end

clear i

recap = table(a1, a2, TP, HW, AUC, FR);

%% SAVING

filepath='C:\Users\h-rkim\Documents\MATLAB\workspace\units properties\'; 
mouse_session='units_properties_M352_HAB_sleep'; 

filename=[filepath mouse_session '.xlsx'];          % saving waveforms
writetable(recap, filename);

filename2=[filepath mouse_session 'units.xlsx']      % saving units identity
units=transpose(use_spk);
writecell(units, filename2);

save('units_properties_M352_HAB_sleep.mat');           % saving workspace

%% 

figure;
plot3(TP,AUC,FR,'o','MarkerFaceColor',[0 0 0])

figure;
plot(TP,FR,'o','MarkerFaceColor',[0 0 0])

figure;
plot(Unitswaveform(find(TP>0.7),:)')

















