clear all;


%define folder containing excel files 
% Change the directory with the correct folder!! HR
myFolder = 'C:\Users\h-rkim\Desktop\SQ-CRL-CRLcues bin10s new';

%create first file name (fullFileName) cell array before import
filePattern=fullfile(myFolder, '*.mat');
excelFile=dir(filePattern);


for k = 1:length(excelFile)
baseFileName{k} = excelFile(k).name;
fullFileName{k} = fullfile(myFolder, baseFileName{k});
end

TOTALCURVE=NaN(90,length(excelFile))

for hh = 1 :  length(fullFileName) 
 load(fullFileName{hh})
 TOTALCURVE(1:length(curve),hh)=curve;
end

PLOTEDCURVE=TOTALCURVE(1:89,:);  %% change the number after 1: --> number of total line HR
MEANCURVE=nanmean(PLOTEDCURVE,2);
errorbar(MEANCURVE,(nanstd(PLOTEDCURVE')./sqrt(length(excelFile))),'color',[0.8 1 0.8],'capsize',0,'LineWidth',15),hold on
plot(MEANCURVE,'color',[0.2 1 0.2],'LineWidth',5)
hold
xlabel('Time (sec)');
ylabel('Freezing (%)');
set(gca,'XTickLabel',0:100:900);

