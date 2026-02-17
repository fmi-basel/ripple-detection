clear all
close all
%%% X is the assay of behavioral variables and Y is the neural data %%

%%% Normalization and PCA %%%



%'36825ctxt1.mat',,'37558ctxt1.mat''36825ctxt2free.mat',,'37558ctxt2free.mat','37558ctxt2free.mat''37558hab.mat''36825hab.mat',
files = {'36826ctxt1.mat','37557ctxt1.mat','36825ctxt1.mat','37558ctxt1.mat'};%,'CCK32cont1'}; %,'CCK36cont1','CCK56cont1','CCK54cont1','CCK62cont1'
files2 = {'36826ctxt2free.mat', '37557ctxt2free.mat','36825ctxt2free.mat','37558ctxt2free.mat'};
files3 = {'36826hab.mat', '37557hab.mat','36825hab.mat','37558hab.mat'};
files4 = {'36826ctxt2trap.mat', '37557ctxt2trap.mat','36825ctxt2trap.mat','37558ctxt2trap.mat',};


for p =1:numel(files)
    
    clear SPK* pos* nk* *op posctr posnk spikes distshock orientation away toward A  elem1 elem2 Xall Yall binranges coeff score latent
    
    load(files{p},'SPK*','pos*','nk*','s_speed','s_speed_nk','AllFile');
    %spikes = who('*op');
    spikes = who('SPK*');
    posctr = who('pos*');
    posnk = who('nk*');
    posctr=eval(posctr{1});
    posnk=eval(posnk{1});
    bodystretchx=(posctr(:,1)-posnk(:,1));
    bodystretchy=abs(posctr(:,2)-posnk(:,2));
    distshock=posctr(:,1);%470-posctr(:,1);
    orientation=posnk(:,1)-posctr(:,1);
    %speed_nk=s_speed_nk;
    speed=s_speed;
    away(orientation<0)=1;
    away(orientation>0)=0;
    toward(orientation>0)=1;
    toward(orientation<0)=0;
    away=away';
    toward=toward';
    
    change_time_bin=50;
    binranges=(0:0.03333:(AllFile(:,2)*30)*0.03333)';
    
    clear A
    Yall=[];
    for f=1:length(spikes)
        
        clear fq coeff score latent A
        curr_neu=eval(spikes{f});
        A=histcounts(curr_neu,binranges)';
        if length(A)<length(distshock)
            A= A;
        else
            A=A((1:size(distshock)),:);
        end
        var={A};
        varst={'fq'};
        [tneu]= normVar(var,varst,change_time_bin);
        Yall=horzcat(tneu.fq,Yall);
        
    end
    
    
    
%     
%     [coeff,score,latent]=pca(Yall);
%     coeffY{p,1}=coeff;
%     scoreY{p,1}=score;
%     latentY{p,1}=latent;
%     clear coeff score latent
    
    
    bodystretchx=bodystretchx(1:size(A,1),:);
    bodystretchy=bodystretchy(1:size(A,1),:);
    distshock=distshock(1:size(A,1),:);
    toward=toward(1:size(A,1),:);
    speed=speed(1:size(A,1),:);
    %away=away(1:size(A,1),:);
    %speed_nk=speed_nk(1:size(A,1),:);
    
    var={bodystretchx,bodystretchy,distshock,speed,toward};  %,'away',speed_nk
    varst={'stretchx','stretchy','distshock','speed','toward'}; %'speed_nk',
    
    [bev]= normVar(var,varst,change_time_bin);
    bev.speed=abs(bev.speed-1);
    bev.distshock=abs(bev.distshock-1);
        
    Ymice{p,1}=Yall;
     
    clear RAI_perm 
    
    [Xall]= permutVarlistForVarMatrices(varst, bev)
    
    Xmice{p,1}=Xall;

end 

clearvars -except Xmice Ymice varst
% for j=1:size(Xmice,1)
%    
%     test=mean(Xmice{j,:}(:,:),2); %Xmice{j,:}(:,:)
%     for i=1:size(Ymice{j,1},2)
%         figure;
%         plot(test)
%         hold on
%         plot(Ymice{j,1}(:,i))
%         hold off
%     end
% end
 %%   

close all
inc_idx=0;
for j=1:size(Xmice,1)
    clear CROSScombiall   pvalCROSScombiall signeuall nsigneuall rnsneuall rsneuall
    
    for k=1:size(Xmice{j,1},1)
         clear CROSScombi pvalCROSScombi signeu nsigneu rnsneu rsneu
        for i=1:size(Xmice{j,1}{k,1},1)
            clear r2 rs2 rsn2 sig nsig CROSSall pvalCROSSall r cc test
            pvalCROSSall=[];
            CROSSall=[];
            test=mean(Xmice{j,1}{k,1}{i,1}(:,:),2);
           for m=1:size(Ymice{j,1},2)
               [R,P]=corrcoef(Ymice{j,1}(:,m),test);
               CROSS=R(1,2);
               pvalCROSS=P(1,2);
%                 figure;
%                 plot(test)
%                 hold on
%                 plot(Ymice{j,1}(:,i))
%                 hold off
% 
%                 figure;
%                 scatter(Ymice{j,1}(:,i),test)
%                 axis([0 1 0 1])
                pvalCROSSall=horzcat(pvalCROSS,pvalCROSSall);
                CROSSall=horzcat(CROSS,CROSSall);
           end
           
           r2=CROSSall;
           [r,cc] = size(pvalCROSSall);
           sig = find(pvalCROSSall <0.05);
           nsig=find(pvalCROSSall > 0.05);
           rns2=r2(:,nsig);
           rs2= r2(:,sig);
           edges=(-1:0.1:1);
           
           
           figure(k+inc_idx);
           subplot(2,6,i)
           histogram(rs2,edges(2:end));
           hold on
           histogram(rns2,edges(2:end));
           %color('r')
           xlim([-1 1])
           ylim([0 15])
           title('x')
           hold on
           hold off
           inc_idx= inc_idx+size(size(Xmice{j,1},1));
           
           
        CROSScombi{i,1}=CROSSall;
        pvalCROSScombi{i,1}=pvalCROSSall;
        signeu{i,1}=sig;
        nsigneu{i,1}=nsig;
        rnsneu{i,1}=rns2;
        rsneu{i,1}=rs2;
        
        
        end
        CROSScombiall{k,1}=CROSScombi;
        pvalCROSScombiall{k,1}=pvalCROSScombi;
        signeuall{k,1}=signeu;
        nsigneuall{k,1}=nsigneu;
        rnsneuall{k,1}=rnsneu;
        rsneuall{k,1}=rsneu;
       
    end
    CROSSmice{j,1}=CROSScombiall;
    pvalCROSSmice{j,1}=pvalCROSScombiall;
    signeumice{j,1}=signeuall;
    nsigneumice{j,1}=nsigneuall;
    rnsneumice{k,1}=rnsneuall;
    rsneumice{k,1}=rsneuall;
    
end
clear rs2 rns2


rns2=r2(:,nsig);
rs2= r2(:,sig);


edges=(-1:0.1:1);
figure;
histogram(rs2,edges(2:end));
hold on
histogram(rns2,edges(2:end));
%color('r')
xlim([-1 1])
ylim([0 100])
title('x')
hold on
hold off


%%
r2=CROSSall;
[r,cc] = size(pvalCROSSall);
sig = find(pvalCROSSall <0.05);
nsig=find(pvalCROSSall > 0.05);
rns2=r2(:,nsig);
rs2= r2(:,sig);



edges=(-1:0.1:1);
figure;
histogram(rs2,edges(2:end));
hold on
histogram(rns2,edges(2:end));
%color('r')
xlim([-1 1])
ylim([0 100])
title('x')
hold on
hold off

% 
% [coeff,score,latent]= pca(RAI); %pca(bev.varst(f)));
%     coeffX{p,1}=coeff;
%     scoreX{p,1}=score;
%     latentX{p,1}=latent;