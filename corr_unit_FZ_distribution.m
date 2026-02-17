Z_pfc_test1=allanims'
clear r p r_sq 
ctx_a=Z_pfc_test1(:,1)
ctx_b=Z_pfc_test1(:,2);
ctx_c=Z_pfc_test1(:,3)

[r p]=corr(ctx_a,ctx_c);
[r p]=corr(ctx_b,ctx_c);
[r p]=corr(test(:,1),test(:,2));
r_sq(i)=r(i)*r(i)


figure;
plot(ctx_a,ctx_b,'o')
color('r');

figure;
plot(ctx_b,ctx_c,'o')
figure;
plot(ctx_a,ctx_c,'o')



FR_pfc_test1=allanims'
ctx_a_fr=FR_pfc_test1(:,1)
ctx_b_fr=FR_pfc_test1(:,2);
ctx_c_fr=FR_pfc_test1(:,3)
[r p]=corr(ctx_a_fr,ctx_b_fr);
[r p]=corr(ctx_a_fr,ctx_c_fr);

%%% FOR PFC %%% 
clear r p r_sq 
freezing=Perc_Freeze;
for i=1:5
    
activity=FR_PFC(:,i);

[r(i) p(i)]=corr(freezing,activity);
r_sq(i)=r(i)*r(i)

end
hist(r_sq)
edges=(0:0.1:1);
histogram(r_sq,edges)
title('PFC FR vs freezing')


%%% shuffle data point %%%

clear shuffle_r shuffle_p shuffle_r_sq
freezing=Perc_Freeze;
for i=1:29
    
activity=FR_PFC_hab_fz(:,i);

Shuffle_activity=activity(randperm(length(activity)));
[shuffle_r(i) shuffle_p(i)]=corr(freezing,Shuffle_activity);

shuffle_r_sq(i)=shuffle_r(i)*shuffle_r(i)

end


%%%%%

[a b]=max(abs(r))

figure;
plot(freezing,FR_PFC(:,:),'o','MarkerFaceColor',[0 0 0])

r(b)
p(b)

%%% FOR BLA %%% 

clear r p
for i=1:24
    
activity=FR_BLA(:,i);

[r(i) p(i)]=corr(freezing,activity);


end
hist(r)
edges=(-1:0.1:1);
histogram(r,edges)
title('BLA FR vs freezing')

%%% FOR ALL UNITS %%% 
clear r p
freezing=Perc_Freeze;
for i=1:28
    
activity=FR_ALL(:,i);

[r(i) p(i)]=corr(freezing,activity);

end
hist(r)
edges=(-1:0.1:1);
histogram(r,edges)
title('BLA FR vs freezing')

%%% shuffle data point %%%

clear shuffle_r shuffle_p
for i=1:28
    
activity=FR_ALL(:,i);
Shuffle_activity=activity(randperm(length(activity)));
[shuffle_r(i) shuffle_p(i)]=corr(freezing,Shuffle_activity);


end


edges=(-1:0.1:1);

r_histo=histcounts(r,edges);
shuffle_r_histo=histcounts(shuffle_r,edges);

figure;
h2=bar(shuffle_r_histo,'FaceColor',[0 0 0]), hold on;
set(h2,'XData',edges(2:end))

h=bar(r_histo);
set(h,'XData',edges(2:end),'FaceColor',[1 0 0],'FaceAlpha',0.8)
xlim([-1 1])

