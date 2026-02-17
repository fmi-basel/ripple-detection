% import data table 

for j=1:3    % change according to number of dimensions
for i=1:3
subplot(3,3,i+(j-1)*3)
% scatter(data(:,i+2),data(:,j+2),15,data(:,2),'filled')    % for ploting my data table 
scatter(data(:,i+2),data(:,j+2),15,IDX,'filled')            % for kmeans plot 

colormap jet
end
end

[IDX, C, SUMD, D] = kmeans(data(:,3:5),4);  %from what col to col, and in how many clusters

% IDX = cluster indices
% C = centroide location 
% SUMD = within cluster sums of point to centroid distances 
% D = distance from each point to every centroid 


%% actual data  

figure;
for j=1:3    % change according to number of dimensions
for i=1:3
subplot(3,3,i+(j-1)*3)
scatter(data2(:,i+2),data2(:,j+2),15,data2(:,2),'filled')       % for ploting my data table 

colormap jet
end
end

%% k-means clustering 

clear IDX C SUMD D i j 
[IDX, C, SUMD, D] = kmeans(data2(:,3:4),3);  %from what col to col, and in how many clusters 

% figure;
% for j=1:2    % change according to number of dimensions
% for i=1:2
% subplot(2,2,i+(j-1)*2)
% scatter(data2(:,i+1),data2(:,j+1),15,IDX,'filled')             % for k-means plot 
% 
% colormap jet
% end
% end
% 
figure
scatter(data2(:,4),data2(:,3),15,IDX,'filled')


 figure;
for j=1:2    % change according to number of dimensions
for i=1:2
subplot(2,2,i+(j-1)*3)
scatter(data2(:,i+2),data2(:,j+2),15,IDX,'filled')             % for k-means plot 

colormap jet
end
end
