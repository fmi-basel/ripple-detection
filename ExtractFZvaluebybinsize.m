% open the excel file with excel and save it as text file
% open the text file in excel, a dialog window appears click next and then
% write ":" in the "other box".
% save the file as an excel file
clear all;


%define folder containing excel files
myFolder = 'C:\Users\h-rkim\Desktop\AnalyseFZ\Matlab analysed';

%create first file name (fullFileName) cell array before import
filePattern=fullfile(myFolder, '*.xlsx');
excelFile=dir(filePattern);


for k = 1:length(excelFile)
baseFileName{k} = excelFile(k).name;
fullFileName{k} = fullfile(myFolder, baseFileName{k});
end


% recursively load file and process script

for hh = 1 :  length(fullFileName)
T = readtable(fullFileName{hh});   
%T(:,3) = [];
T = table2array(T)

test=[];
test2=[];
freezingval=[];
length(T);
r=0;
lt=0;
i=0;
tt=0;
rr=0;
vv=0;
zz=0;

test= T(1);

for i= 1 : test-1  
 freezingval(i,1)=0;   
end
    
    

for tt = 1 :  length(T)  
 lt=length(freezingval); 
 rr=0;
 vv=0;
 zz=0;
 diff= T(tt,2)-T(tt,1)       
             for zz= 1 : diff
             freezingval(lt+zz,1)=1; 
             end 
 lt1=length(freezingval);          
      
 if tt ~= length(T)
 diff1= T(tt+1,1)-T(tt,2)  
 if diff1 ~= 0
     for rr= 1 : diff1
     freezingval(lt1+rr,1)=0; 
     end 
     
 else
 end
 else
end
end    
    
binsize= 20; % bin size to change in second
binsizeok=binsize*1000;
long=length(freezingval)/(1000);
longok=round(long);
tr=longok*1000;
dgf=tr-length(freezingval);
if dgf > 0
freezingval = padarray(freezingval,dgf,nan,'post');
else
end
curve=[];
gt=1

for ff=1 : longok/binsize
   
    curve (ff,1)= sum (freezingval(gt:gt+(binsizeok-1)));

    gt=gt+(binsizeok-1)
    
end
curve=curve/(binsize*10)
plot (curve);
hold
xlabel('Time (sec)');
ylabel('Freezing (%)');
set(gca,'XTickLabel',0:100:900); %maximum time scale to be changed, HR


filename = char (baseFileName(hh));
xlswrite(filename,curve);

if length(filename)<12
filename2=filename(1:6);
else
filename2=filename(1:7);
end
save(filename2,'curve');
%winopen(filename);

saveas(figure(1),[filename '.pdf']);
clearvars -except fullFileName baseFileName k;
close;
end
close;
