function [auc hsw fq ] = aucHswFq(file,p,k)  %auc hsw fq to_remove


clear SPK* wave fq hsw auc fqspk auc1 liste Indexc Indexr use_spk count
load(file{p},'SPK*','wave')

%b={who('*Cop'),who('*Rop')};
%b={who('*C','*Cop'),who('*R','*Rop')};
c= who ('SPK*');
count=0;
for p = 1:length (c)  
     if ~contains(c{p},'_wf') & ~contains(c{p},'_ts') & ~contains(c{p},'_template')
       count=count+1;
       use_spk{count}=c{p};      
    end
end
liste=use_spk'; 
b={liste};
spikes=b{k};
assert(size(wave,1)==size(liste,1),('Lengths are not equal'));

%Indexc = find(contains(liste,'C')); wavec=wave(Indexc,:);  %%cellfun() apply function to each array
%Indexr = find(contains(liste,'R')); waver=wave(Indexr,:);
%wa={wavec,waver};
wa={wave};
wave=wa{k};

Num_spikes_mice=length(spikes);
for f=1:Num_spikes_mice, current_spike=eval(spikes{f}); edges=(1:1:200);  fqspk(f,:)= histcounts(current_spike,edges); fq=(mean(fqspk,2))'; end

auc1 = zeros(size(wave,1),1);
hsw = zeros(size(wave,1),1);
for c = 1:size(wave,1),
    we = resample(wave(c,:),300,12);
    wf(:,c)=we';
    [xmin,idxmin]=min(we); [xmax,idxmax]=max(we(idxmin:end));
    wf(:,c)=-wf(:,c)./min(we);
    m = max(we(find(we==min(we)):end));
    we=we./m; [m,idx]=min(we); we=we(idx:end); we=we(we>0);
    auc1(c) = trapz(we);
    auc = auc1;
    hsw(c) = idxmax;
end
% figure;
% plot(wave')

end