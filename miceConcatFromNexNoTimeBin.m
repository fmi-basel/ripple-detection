
function [allanims]= miceConcatFromNexNoTimeBin(varlist)


for i=2:1:length(varlist)
    tempval = eval(varlist{i});
    [~,st] = size(tempval);
    tempval2(:,[1:st-1])= tempval(:,[2:st]);
    allanims=[allanims,tempval2];
    clear tempval2 tempval
end

