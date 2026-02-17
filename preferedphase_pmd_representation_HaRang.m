close all
clear all

%All sessions analysis 
files1 = {'m330TEST1_pfc.mat','m331TEST1_pfc.mat','m332TEST1_pfc.mat','m334TEST1_pfc.mat','m335TEST1_pfc.mat',...
          'm336TEST1_pfc.mat','m337TEST1_pfc.mat','m338TEST1_pfc.mat','m339TEST1_pfc.mat','m340TEST1_pfc.mat',...
          'm341TEST1_pfc.mat','m342TEST1_pfc.mat','m343TEST1_pfc.mat','m344TEST1_pfc.mat','m345TEST1_pfc.mat',...
          'm346TEST1_pfc.mat','m348TEST1_pfc.mat','m349TEST1_pfc.mat','m350TEST1_pfc.mat','m351TEST1_pfc.mat',...
          'm352TEST1_pfc.mat','m353TEST1_pfc.mat','m355TEST1_pfc.mat','m357TEST1_pfc.mat','m358TEST1_pfc.mat',...
          'm359TEST1_pfc.mat','m360TEST1_pfc.mat','m361TEST1_pfc.mat'};
files2 = {'m331TEST2_pfc.mat','m332TEST2_pfc.mat','m334TEST2_pfc.mat','m335TEST2_pfc.mat','m336TEST2_pfc.mat',...
          'm337TEST2_pfc.mat','m338TEST2_pfc.mat','m339TEST2_pfc.mat','m340TEST2_pfc.mat','m341TEST2_pfc.mat',...
          'm342TEST2_pfc.mat','m343TEST2_pfc.mat','m344TEST2_pfc.mat','m345TEST2_pfc.mat','m346TEST2_pfc.mat',...
          'm348TEST2_pfc.mat','m349TEST2_pfc.mat','m350TEST2_pfc.mat','m351TEST2_pfc.mat','m352TEST2_pfc.mat',...
          'm353TEST2_pfc.mat','m355TEST2_pfc.mat','m356TEST2_pfc.mat','m357TEST2_pfc.mat','m358TEST2_pfc.mat',...
          'm359TEST2_pfc.mat','m360TEST2_pfc.mat','m361TEST2_pfc.mat'};
files3 = {'m330TEST1_bla.mat','m332TEST1_bla.mat','m334TEST1_bla.mat','m335TEST1_bla.mat','m337TEST1_bla.mat',...
          'm338TEST1_bla.mat','m342TEST1_bla.mat','m343TEST1_bla.mat','m344TEST1_bla.mat','m345TEST1_bla.mat',...
          'm346TEST1_bla.mat','m347TEST1_bla.mat','m348TEST1_bla.mat','m349TEST1_bla.mat','m350TEST1_bla.mat',...
          'm351TEST1_bla.mat','m352TEST1_bla.mat','m353TEST1_bla.mat','m357TEST1_bla.mat','m359TEST1_bla.mat',...
         'm361TEST1_bla.mat'}; % 'm360TEST1_bla.mat',
files4 = {'m332TEST2_bla.mat','m334TEST2_bla.mat','m335TEST2_bla.mat','m337TEST2_bla.mat','m338TEST2_bla.mat',...
          'm342TEST2_bla.mat','m343TEST2_bla.mat','m344TEST2_bla.mat','m345TEST2_bla.mat','m346TEST2_bla.mat',...
          'm347TEST2_bla.mat','m348TEST2_bla.mat','m349TEST2_bla.mat','m350TEST2_bla.mat','m351TEST2_bla.mat',...
          'm352TEST2_bla.mat','m353TEST2_bla.mat','m356TEST2_bla.mat','m357TEST2_bla.mat','m359TEST2_bla.mat',...
          'm361TEST2_bla.mat'}; % 'm360TEST2_bla.mat',
      
%% free trapped analysis %%

varstring= {'T1 PFC','T2 PFC', 'T1 BLA', 'T2 BLA'};

files= {files1,files2,files3,files4}; %,
for i=1:numel(files)
    
    file=files{1,i};
    phistnorm_all=[];    
    pphi_all=[];
    pmrl_all=[];
    sig_all=[];
    
    for p =1:numel(file)
        
        clear phistnorm phistnorm_sig phistnorm_RAI phistnorm_RAIsig...
            pphi pmrl ppval pphi_sig pmrl_sig  pmrl_RAIsig pphi_RAIsig pmrl_RAI pphi_RAI sig RAIsig
       
        load(file{p},'phistnorm', 'pphi','pmrl');
        load(file{p},'ppval');
       
        pphi=pphi';
        ppval=ppval';
        pmrl=pmrl';
        
        sig = find(ppval < 0.05);
         sig=sig';
        ppval(sig)=nan;
        pphi_all=[pphi_all pphi];
        sig_all=[sig_all ppval];
        pmrl_all=[pmrl_all pmrl];
        
        phistnorm=(cat(2,squeeze(phistnorm),squeeze(phistnorm)));
       
        phistnorm_all=[phistnorm_all; phistnorm];
       
        
    end
    
    signeu=find(isnan(sig_all));      
    [b order]=(sort(pphi_all,2,'descend'));
    [c order_pmrl]=(sort(pmrl_all,2,'descend'));
    phistnorm_allsess{i,1}=phistnorm_all;
    pphi_allsess{i,1}=pphi_all;
    pmrl_allsess{i,1}=pmrl_all;
    order_pmrl_sess{i,1}=order_pmrl;
    order_sess{i,1}=order;
    sig_sess{i,1}=signeu;
  
end
clearvars -except phistnorm_sig_allsess phistnorm_RAI_allsess phistnorm_allsess pphi_sig_allsess pphi_RAI_allsess pphi_allsess ...
       order_sig_sess order_sess pmrl_allsess pmrl_RAI_allsess order_pmrl_sess order_RAI_sess sig_sess RAI_sess signeumice nsigneumice varstring
%%

close all

[b order]=(sort(pphi_allsess{1,1}(sig_sess{1,1}),2,'descend'));
order_sig = intersect(order,sig_sess{1,1});
sig_sess1=phistnorm_allsess{1,1}(sig_sess{1,1},:);
%sig_sess2=phistnorm_allsess{2,1}(sig_sess{1,1},:);

figure;
for i=1:size(phistnorm_allsess)
    
subplot(1,2,1)
imagesc(sig_sess1(order,:))
title(varstring{1})
load('MyColormap')
colormap(mymap2)
colorbar
xlabel('Phase °')
ylabel('# neurons')

subplot(1,2,2)
imagesc(sig_sess2(order,:))
title(varstring{1})
load('MyColormap')
colormap(mymap2)
colorbar
xlabel('Phase °')
ylabel('# neurons')

end
 suptitle('significantly phase locked Pmd neurons 8-12Hz')
 clear i

 
for i=1:size(pmrl_allsess,1)
figure;
subplot(1,2,1)
plot(pmrl_allsess{i,1}(sig_sess{i,1}))
ylim([0 0.5])
xlim([1 size(pmrl_allsess{i,1}(sig_sess{i,1}),2)])
subplot(1,2,2)
polarhistogram(pphi_allsess{i,1}(sig_sess{i,1}),36,'Facecolor',[0.8 0.7 0.2],'FaceAlpha',.7) %rose

title(varstring{i})

end
suptitle('MRL of phase locked RAI neurons 8-12Hz')
