clear all

% filename='Z:\Ha-Rang\Plexon\video\20191218\M221-D3-TesDat.csv';
% filename='Z:\Ha-Rang\Plexon\video\20200116\M234-D3-testDat.csv';
filename='C:\Users\h-rkim\Desktop\behavior\M313-320\hab2\8.csv';
T = readtable(filename)

FreezDet=table2array(T(:,7));

% figure;
% plot(FreezDet)
% ylim([-0.1 1.1])  %% figure to plot if needed


DiffFreez=diff(FreezDet);


starts=find(DiffFreez==1);
ends=find(DiffFreez<0);
% duration=ends-starts;

(length(find(FreezDet))*0.03333)
(length(find(FreezDet))*0.03333)+(length(starts))

starts2=starts;

if length(starts)>length(ends)
   IFI=[ends-starts2(2:end)];
else

  IFI=[ends(1:end-1)-starts2(2:end)];
end

IFI2=abs(IFI)-30;

addthing=(sum(IFI2(find(IFI2<15)))+length(IFI2(find(IFI2<15))))*0.03333;
(length(find(FreezDet))*0.03333)+(length(starts))+addthing

for cell_interest=1:size(starts,1)
    value= starts(cell_interest,1)
    FreezDet(value-29:value,1)=1
end
