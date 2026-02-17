function [total_counts_mean_var total_counts_mean_var_norm]= freqVar(var3d,varstring,b,bstring,p,file,edges,bin,varargin)

size(varargin)

%results=struct();

load(file{p},'SPK*')
for k=1:size(b,2)
    
    spikes=b{k};
    
    Num_spikes_mice=length(spikes);
    
    if Num_spikes_mice==0;
        continue
    else
        for j=1:size(var3d,2)
%             if j==3 | j==4
%                 bin=1;         %% time bin to change         %% egdes before and after 0
%                 edges=(-15:bin:60);
%             end
            varlist=var3d{j};
            Yall=[];
            if isempty(varlist);
                continue
            else
                
                clear Counts_mean varnorm
                for f=1:Num_spikes_mice
                    
                    current_spike=eval(spikes{f});
                    binrange=(0:bin:current_spike(end));
                    binned_spike=histcounts(current_spike,binrange);
                    maxvar=max(binned_spike);
                    minvar=min(binned_spike);
                    clear Binned var Allsess
                    for m=1:length(varlist), Rel=current_spike-varlist(m); Binned(:,m)=histcounts(Rel,edges); end
                    Counts_mean(:,f)=mean(Binned,2);
                    varnorm=Counts_mean(:,f);
                    elem1=varnorm-minvar;
                    elem2= maxvar-minvar;
                    varnorm=elem1./elem2;
                    Yall=horzcat(Yall,varnorm);
                    
                end
                
                total_counts_mean.(varstring{j})=Counts_mean;
                total_counts_mean_norm.(varstring{j})=Yall;
            end
        end
        
    end
    total_counts_mean_var.(bstring{k})= total_counts_mean;
    total_counts_mean_var_norm.(bstring{k})=total_counts_mean_norm;
end
