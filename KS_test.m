% set1=[]; copy-paste data from excel (same for set2)

% resample: setting set1 & set2 in the same intervals
ts1=timeseries(s1(:,2),s1(:,1))
rts1=resample(ts1,[-0.025:0.01:1.475])   % put the 2 min and max values 
temp=isnan(rts1.Data(1:10))      % replace 'nan' in the first 59 rows by 0
rts1.Data(temp)=0;
temp=isnan(rts1.Data)            % replace the remaining 'nan' by 1
rts1.Data(temp)=1;

ts2=timeseries(s2(:,2),s2(:,1))
rts2=resample(ts2,[-0.025:0.01:1.475])
temp=isnan(rts2.Data(1:10))
rts2.Data(temp)=0;
temp=isnan(rts2.Data)
rts2.Data(temp)=1;

clear h p
% 2-sample kstest (h= hypothesis, p= p-value)
[h,p,ks2stat]=kstest2(rts1.Data,rts2.Data);

% h=1, rejects the null hypothesis at 5% significance level, 
% there is statiistical significance between the 2 groups
% h=0, NS

figure;
plot(rts1.Data)
hold on
plot(rts2.Data)

%%

cumul1=cumsum(s1(:,2));
serie1=cat(2,s1(:,1),cumul1);

cumul2=cumsum(s2(:,2));
serie2=cat(2,s2(:,1),cumul2);

clear h p 
[h,p,ks2stat]=kstest2(s1(:,2),s2(:,2));

figure;
plot(s1(:,2))
hold on 
plot(s2(:,2));




figure;
plot(diff(set1(:,2)))
hold on
plot(diff(set2(:,2)))

figure;
plot((ts1.Data))
hold on
plot((ts2.Data))