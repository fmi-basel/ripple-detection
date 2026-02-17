LFP_name=input('Channel_1 (use quotes): ');

% channel=input('channel number? use quotes ');
freqband=[6 12];
spike_prefix='Loc';
lfp_prefix='FP';
% freqband=[2 5;6 12;15 35;55 65;70 90];


nneur=input('how many neurons? ');
eval(['LFP=' LFP_name ';']);
eval(['indLFP=' LFP_name '_ind']);
eval(['tsLFP=' LFP_name '_ts']);
eval(['SR=' LFP_name '_ts_step']);
eval(['LFP1=' LFP_name ';']);


%%
indLFP(end+1,1)=size(LFP1,1);
for i=1:size(tsLFP,1)
    LFP(indLFP(i,1):ceil((tsLFP(i,1)*SR))-1,1)=zeros(ceil(tsLFP(i,1)*SR)-indLFP(i,1),1);
    LFP(end+1:end+indLFP(i+1)-indLFP(i,1)+1,1)=LFP1(indLFP(i,1):indLFP(i+1),1);
end

ndeg=18;
timeint=[];
% timeint=CSplusint30;
% timeint=Freeze_Atok;
% LFP=resample(LFP,1,40);
% LFP=downsample(LFP,2);
phaseM=zeros(size(freqband,1),length(LFP));
nshuff=100;
% phaseM_shuff=zeros(size(freqband,1),length(LFP),50);
for i=1:size(freqband,1)
    H=freqband(i,1)*SR*2;
    [h1,h2] = butter(5,H,'high');
    fLFP= filtfilt(h1,h2,LFP);
    if i==1
        figure;plot(fLFP);hold on;plot(LFP,'r')
    end
    L=freqband(i,2)*SR*2;
    [l1,l2] = butter(5,L,'low');
    fLFP = filtfilt(l1,l2,fLFP);
    phaseLFP=angle(hilbert(fLFP));
%     phaseLFP=20*ceil(2*pi*ceil(10*(phaseLFP)/(2*pi)))/200;
    %phaseLFP=5*ceil(2*pi*ceil(10*(phaseLFP)/(2*pi)))/50;
    fpower=abs(hilbert(fLFP));
    tpower=nan(size(fpower));
    tpower(find(fpower>(prctile(fpower,80))))= fpower(find(fpower>(prctile(fpower,80))));
    %     if strcmp(interval,'all')==0
    %         timeint=eval([interval]);
    %         %dummy=zeros(size(fLFP));
    %         for j=1:size(timeint,1)-1
    %             if (timeint(j,2)*1000)<length(phaseLFP)
    %                 phaseLFP(round(timeint(j,1)*1000+1):round(timeint(j,2)*1000),1)=NaN;
    %             end
    %             if (timeint(j,2)*1000)>length(phaseLFP)
    %                 phaseLFP(round(timeint(j,1)*1000+1):end,1)=NaN;
    %             end
    %         end
    %
    %         %phaseLFP(find(dummy==0))=NaN;
    %     end
    % LFPM(i,:)=fLFP;
    phaseM(i,:)=phaseLFP;
end
j=0;
worksp=whos;
for n=1:length(worksp)
    
    nme=worksp(n,1).name(1,:);
    
    if length(nme)>=5
        
        if strcmp(sprintf(spike_prefix),sprintf('%s',nme(1,1:3)))==1;
            j=j+1;
clear neuproshuff diffproneu proneu neu_shuff neu
            for i=1:size(freqband,1)
                
                proneu=eval([num2str(worksp(n,1).name(1,1:end));]);
                diffproneu=diff(proneu);
                neu_shuff=zeros(length(proneu)-1,nshuff);
                for r=1:nshuff;
                    neu_shuff(:,r)=cumsum(diffproneu(randperm(length(diffproneu))));
                end
                neu=proneu;
                if size(timeint,1)>1
                    neu=[];
                    neu_shuff=[];
                    neuproshuff=[];
                    for s=1:size(timeint)
                        neu(end+1:end+length(find(proneu>timeint(s,1) & proneu<timeint(s,2))))=proneu(find(proneu>timeint(s,1) & proneu<timeint(s,2)));
                        diffproneu=cat(2,timeint(s,1),neu(find(neu>timeint(s,1) & neu<timeint(s,2))),timeint(s,2));
                        diffproneu=diff(diffproneu)';
                        for r=1:nshuff;
                            neuproshuff(:,r)=squeeze(cumsum(diffproneu(randperm(length(diffproneu))))+timeint(s,1));
                        end
                        neu_shuff(end+1:end+size(neuproshuff,1),:)=neuproshuff;
                        clear neuproshuff
                    end
                end
                
                phaseneu=phaseM(i,round(neu(find(neu*1000<length(phaseLFP)))*1000));
                [pval,Z]=circTestR(phaseneu(find(isnan(phaseneu)==0)));
                MRL=circResLength(phaseneu(find(isnan(phaseneu)==0)));
%                 kappa = circkappa(phaseneu(find(isnan(phaseneu)==0)));
                for r=1:nshuff
                    phaseneu_shuff=phaseM(i,round(neu_shuff(find(neu_shuff(:,r)*1000<length(phaseLFP)),r)*1000));
                    phist_shuff(i,j,:,r)=hist(phaseneu_shuff,ndeg);
                end
                if length(freqband)>2
                                figure
                    subplot(2,3,i)
                    bar([-180:360/((ndeg-1)):570],cat(2,hist(phaseneu,ndeg),hist(phaseneu,ndeg))); axis tight; hold on
                    plot([-180:360/((ndeg-1)):570],smooth(cat(2,hist(phaseneu,ndeg),hist(phaseneu,ndeg))),'k','linewidth',6); 
                    plot([-180:360/(ndeg-1):570],cat(1,mean(squeeze(phist_shuff(i,j,:,:)),2),mean(squeeze(phist_shuff(i,j,:,:)),2)),'r')
                    plot([-180:360/(ndeg-1):570],cat(1,(mean(squeeze(phist_shuff(i,j,:,:)),2)+std(squeeze(phist_shuff(i,j,:,:))')'/sqrt(50)),(mean(squeeze(phist_shuff(i,j,:,:)),2)+std(squeeze(phist_shuff(i,j,:,:))')'/sqrt(50))),':r')
                    plot([-180:360/(ndeg-1):570],cat(1,(mean(squeeze(phist_shuff(i,j,:,:)),2)-std(squeeze(phist_shuff(i,j,:,:))')'/sqrt(50)),(mean(squeeze(phist_shuff(i,j,:,:)),2)-std(squeeze(phist_shuff(i,j,:,:))')'/sqrt(50))),':r')
                    plot([-180:360/(ndeg-1):570],cat(1,(prctile(squeeze(phist_shuff(i,j,:,:)),95,2)),(prctile(squeeze(phist_shuff(i,j,:,:)),95,2))),'g')
                    plot([-180:360/(ndeg-1):570],cat(1,(prctile(squeeze(phist_shuff(i,j,:,:)),5,2)),(prctile(squeeze(phist_shuff(i,j,:,:)),5,2))),'g')
                    h=hist(phaseneu,20);
                    phi=(find(h==max(max(h)))*360/length(h));
                    axis tight
                    eval(['pha0' num2str(worksp(n,1).name(1,5:end)) '=[pval,phi(1,1)];']);
                    phist(i,j,:)=h;
                    pkappa(i,j)=kappa;
                    ppval(i,j)=pval;
                    pmrl(i,j)=MRL;
                    pZ(i,j)=Z;
                    title(sprintf('%s p=%1.3f \n Ph=%3.0f MRL=%1.2f K=%1.2f',num2str(worksp(n,1).name(1,:)),pval,phi(1,1),MRL,kappa))
                    %             eval(['neu0' num2str(worksp(n,1).name(1,5:end)) '=neu;']);
                end
                if length(freqband)==2
                    figure 
                    bar([-180:360/((ndeg-1)):570],cat(2,hist(phaseneu,ndeg),hist(phaseneu,ndeg))); axis tight; hold on
                    plot([-180:360/((ndeg-1)):570],smooth(cat(2,hist(phaseneu,ndeg),hist(phaseneu,ndeg))),'k','linewidth',6);
                    plot([-180:360/(ndeg-1):570],cat(1,mean(squeeze(phist_shuff(i,j,:,:)),2),mean(squeeze(phist_shuff(i,j,:,:)),2)),'r')
                    plot([-180:360/(ndeg-1):570],cat(1,(mean(squeeze(phist_shuff(i,j,:,:)),2)+std(squeeze(phist_shuff(i,j,:,:))')'/sqrt(50)),(mean(squeeze(phist_shuff(i,j,:,:)),2)+std(squeeze(phist_shuff(i,j,:,:))')'/sqrt(50))),':r')
                    plot([-180:360/(ndeg-1):570],cat(1,(mean(squeeze(phist_shuff(i,j,:,:)),2)-std(squeeze(phist_shuff(i,j,:,:))')'/sqrt(50)),(mean(squeeze(phist_shuff(i,j,:,:)),2)-std(squeeze(phist_shuff(i,j,:,:))')'/sqrt(50))),':r')
                    plot([-180:360/(ndeg-1):570],cat(1,(prctile(squeeze(phist_shuff(i,j,:,:)),95,2)),(prctile(squeeze(phist_shuff(i,j,:,:)),95,2))),'g')
                    plot([-180:360/(ndeg-1):570],cat(1,(prctile(squeeze(phist_shuff(i,j,:,:)),5,2)),(prctile(squeeze(phist_shuff(i,j,:,:)),5,2))),'g')
                    h=hist(phaseneu,20);
                    [peak peakidx]=max(smooth(h));
                    phi=(peakidx*360/length(h))-180;
                    axis tight
                    eval(['pha0' num2str(worksp(n,1).name(1,5:end)) '=[pval,phi(1,1)];']);
                    phist(i,j,:)=h;
                    pphi(i,j)=phi;
                    phistnorm(i,j,:)=(h-min(min(h)))/max(max(h-min(min(h))));
%                     pkappa(i,j)=kappa;
                    ppval(i,j)=pval;
                    pmrl(i,j)=MRL;
                    pZ(i,j)=Z;
                    title(sprintf('%s p=%1.3f \n Ph=%3.0f MRL=%1.2f',num2str(worksp(n,1).name(1,:)),pval,phi(1,1),MRL))
                end
            end
        end
    end
end
figure
imagesc((cat(2,squeeze(phistnorm),squeeze(phistnorm))))
ppval=ppval';
pphi=pphi';
pmrl=pmrl';
pZ=pZ';
% pkappa=pkappa';
clear neu H h1 h2 L l1 l2 angles LFP