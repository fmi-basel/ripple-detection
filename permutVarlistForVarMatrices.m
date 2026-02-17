  
function [Xall]= permutVarlistForVarMatrices(varst, bev)
% varst for string list bev for vector variables  
%return cell array with all combination of variable matrices

for i=1:size(varst,2)
    clear varst_perm RAI_perm
    varst_perm=nchoosek(varst,i);
    for g=1:size(varst_perm,1)
        RAIall=[];
        for f=1:size(varst_perm,2)
            clear RAI
            RAI=bev.(varst_perm{g,f});
            RAIall= [RAIall,RAI];
        end
        RAI_perm{g,1}=RAIall;
    end
    Xall{i,1}=RAI_perm;
end