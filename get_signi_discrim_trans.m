%%% concatenation
clearvars -except varlist allanims
%varlist = who('*_10s');              %% change who is varlist according to analyses
%varlist = who('*_0_1s');
varlist = who('*_z_180s_all');

%Join all animals
allanims=eval(varlist{1});    %%%%% attention
% time=allanims(:,1);
allanims(:,1) = [];

for i=2:1:length(varlist)
    tempval = eval(varlist{i});
    [~,st] = size(tempval);
    tempval2(:,[1:st-1])= tempval(:,[2:st]);
    allanims=[allanims tempval2];
    clear tempval2 tempval
end

plotvar=allanims;

%%% separation in contexts
allanims0=allanims(1,:);
allanims02=allanims(2,:);
allanims03=allanims(3,:);


%%%mean of all zscore of context
% allanims0=mean(allanims0,1);
% allanims02=mean(allanims02,1);
% allanims03=mean(allanims03,1);

%%%% finding activated and inhibited cells

[act1.row, act1.col] = find(allanims0 >1.95);
[act2.row, act2.col] = find(allanims02 >1.95);
[act3.row, act3.col] = find(allanims03 >1.95);

[inh1.row, inh1.col] = find(allanims0 <-1.95);
[inh2.row, inh2.col] = find(allanims02 <-1.95);
[inh3.row, inh3.col] = find(allanims03 <-1.95);

%%%% finding cells with 2 conditions for discrimination


[discrim_same posiciondiscrim_same]=intersect(act1.col,act3.col);
[discrim2_same posiciondiscrim2_same]=intersect(inh1.col,inh3.col);

        



