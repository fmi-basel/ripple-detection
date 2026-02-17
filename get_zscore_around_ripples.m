%% Get all ripples timestamps.

% get mPFC unit numbers list and import as a string: ch_mpfc in the
% workspace. Get data from .NEX files HPCrbRipples, Unit timestamps,
% HPCrbLocF.

% ch_HPC = [55]; % HPC channels analyzed for ripples.
% for i = 1:size(ch_HPC, 1)
%     temp{i,1} = eval(sprintf('FP%d_LocRipples', ch_HPC(i,1)));
% end
% HPCrbLocF_all = vertcat(temp{:});
% clear temp

HPCrbLocF_all = FP55_HPCLoc;

% % % %%
% % % 
% % % HPCrbLocF_all = CH3_FiltratedRipplePicTime_Day2b;
% % % %save('ch_mpfc.mat', 'ch_mpfc')
% % % 
% % % 


%% Get Counts per bin and zscore for every channels.

% load('pfc_timestamp.mat')
clear alldata_countsbin alldata_zscorebin alldata i j c 
c = who('SPK*');
for i = 1:size(c,1) % for each channels.
    temp = eval(c{i});
%     temp = eval(strcat('sig0',ch_mpfc(i,1)));
    for j = 1:size(HPCrbLocF_all, 1) % for each ripples.
        edges = linspace(HPCrbLocF_all(j,1) - 0.5, HPCrbLocF_all(j,1) + 0.5, 100);
        [n(j,:) ,~] = histcounts(temp, edges); % 10 ms bins
    end
    %zscore based on a baseline 
    nsum = sum(n, 1);
    avg = mean(nsum(1,1:20), 2); % 20 bins = 200ms.
    SD = std(nsum(1,1:20), 0, 2);
    nz = (nsum - avg)./SD;
%     figure; plot(sum(n, 1))
%     title(eval('ch_mpfc(i,1)'))
%     figure; plot(nz)
%     title(eval('ch_mpfc(i,1)'))
    figure; plot(zscore(sum(n,1), 1)) 
    title(eval('c{i}'))
    alldata_countsbin{i,1} = n;
    alldata_zscorebin{i,1} = nz;
    clear temp n temp2 edges nz avg SD nsum D
end

for i = 1:size(c,1)
    alldata_countsbin{i,2}(1,1) = c{i};
    alldata_zscorebin{i,2}(1,1) = c{i};
end

alldata=cell2mat(alldata_zscorebin(:,1))

%Add Firing rate analysis
% save('unitzscore_aroundripplesCH3_Day2b.mat', 'alldata_countsbin', 'alldata_zscorebin')
% 
% writecell(alldata_zscorebin, 'unitzscore_aroundripplesCH3_Day2b.xlsx')

%% for the PPC

load('C:\Users\HARANG\Documents\MATLAB\workspace\m334-pfc-timestamp.mat')
c = who('-file','PPC_UnitsTimestampsConc.mat');
for p = 1:length (c)
    h=regexp(c,'\w*l+\d*+.','match');
    l = vertcat(h{:});
    m = unique(l(:));
end
load('HPC_Data_Ripplesrb.mat', 'HPCrbLocF_allF')

for i = 1:size(m,1) % for each channels.
    temp = eval(strcat(m{i,1},'_PPC_Conc'));
    for j = 1:size(HPC_AllRipplesF, 1) % for each ripples.
        edges = linspace(HPC_AllRipplesF(j,1) - 0.5, HPC_AllRipplesF(j,1) + 0.5, 100); % 500 before and after ripples
        [n(j,:) ,~] = histcounts(temp, edges); % 10 ms bins
    end
    %zscore based on a baseline 
    nsum = sum(n, 1);
    avg = mean(nsum(1,1:20), 2); % 20 bins = 200ms.
    SD = std(nsum(1,1:20), 0, 2);
    nz = (nsum - avg)./SD;
%     figure; plot(sum(n, 1))
%     title(eval('ch_mpfc(i,1)'))
    figure; plot(nz)
    title(eval('m{i,1}'))
%     figure; plot(zscore(sum(n,1), 1))
%     title(eval('ch_mpfc(i,1)'))
    alldata_countsbin{i,1} = n;
    alldata_zscorebin{i,1} = nz;
    clear temp n temp2 edges nz avg SD nsum
end
all_zscore = vertcat(cell2mat(alldata_zscorebin));

figure;
imagesc(all_zscore)
colormap(redblue)
set(gca, 'TickDir', 'out')
caxis([-5 5])

% [valmax, ~] = max(all_zscore(:,30:50));
% [~, I] = sort(valmax, 'ascend');
% all_zscoresort = all_zscore(I,:);
% figure;
% imagesc(all_zscoresort)
% colormap(redblue)
% set(gca, 'TickDir', 'out')
% caxis([-5 5])

figure;
plot(mean(all_zscore,1), 'k')

for i = 1:size(m,1)
    alldata_countsbin{i,2}(1,1) = m(i,1);
    alldata_zscorebin{i,2}(1,1) = m(i,1);
end

save('unitzscore_PPC_aroundripples_restD_1.mat')

% % 2 ms bins
% for i = 1:size(m,1) % for each channels.
%     temp = eval(strcat(m{i,1},'_PPC_Conc'));
%     for j = 1:size(HPC_AllRipplesF, 1) % for each ripples.
%         edges2 = linspace(HPC_AllRipplesF(j,1) - 0.5, HPC_AllRipplesF(j,1) + 0.5, 500); % 500 before and after ripples
%         [n(j,:) ,~] = histcounts(temp, edges2); % 2 ms bins
%     end
%     %zscore based on a baseline 
%     nsum = sum(n, 1);
%     avg = mean(nsum(1,1:100), 2); % 100 bins = 200ms.
%     SD = std(nsum(1,1:100), 0, 2);
%     nz = (nsum - avg)./SD;
% %     figure; plot(sum(n, 1))
% %     title(eval('ch_mpfc(i,1)'))
%     figure; plot(nz)
%     title(eval('m{i,1}'))
% %     figure; plot(zscore(sum(n,1), 1))
% %     title(eval('ch_mpfc(i,1)'))
%     alldata_countsbin2{i,1} = n;
%     alldata_zscorebin2{i,1} = nz;
%     clear temp n temp2 edges nz avg SD nsum
% end
% all_zscore2 = vertcat(cell2mat(alldata_zscorebin2));
% 
% figure;
% imagesc(all_zscore2)
% colormap(redblue)
% caxis([-5 5])


