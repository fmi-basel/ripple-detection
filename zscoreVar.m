function [zscored_all_varcr, basal] = zscoreVar(varstring,bstring,mice,N_type,PN,IN,varargin);

size(varargin)

for k=1:size(bstring,2)
    for j=1:size(varstring,2)
        zscored_all=[];
        for l=1:size(mice,1)
            %varstring= fieldnames(mice{l}.(bstring{1}))';
            if isfield(mice{l},bstring{k})
                var= mice{l}.(bstring{k}).(varstring{j});                            
            else
                continue    
            end
            clear zscored
            for i=1:size(var,2)
                basal=var(1:floor(size(var,1)/2)-1,i); 
                %basal = var(1:36,i);  
                zscored(:,i)=(var(:,i)-mean(basal))./std(basal);
            end
            zscored_all=[zscored_all zscored];
            zscored_all(isnan(zscored_all))=0;
            zscored_all(isinf(zscored_all))=0;
            
        end
        zscored_all_var.(varstring{j})=zscored_all(:,N_type{k});
        
    end
    zscored_all_varcr.(bstring{k})=zscored_all_var;
    
end
