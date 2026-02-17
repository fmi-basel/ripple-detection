function  [percentage]=heatmapResponsivenessMatriceOfEvents(zscored_all_varcr,varstring,bstring,stringfile,actcells_allcr,inhcells_allcr,g,varargin)

size(varargin)
%varstring = {'approach','retreat','stretchx','stretchy','distshock','speed','orientation','RAI'};
for k=1:size(bstring,2)
 modmat=zeros((size(zscored_all_varcr.(bstring{1}).(varstring{1}),2)),(size(varstring,2)));
         for j=1:size(varstring,2)
            
             modmat(actcells_allcr.(bstring{k}).(varstring{j}),j)=2;
             modmat(inhcells_allcr.(bstring{k}).(varstring{j}),j)=1;
         end
         

[a index]=sortrows(modmat,[1 2],'descend'); %(1:length(varstring)),
percentage=modmat;

figure;
imagesc(a)
%imagesc(modmat)
% map = [0.3 0.3 0.3
%       0.282352954149246 0.670588254928589 0.529411792755127
%        0.911384403705597,0.340161353349686,0.391416460275650];
map = [0.3 0.3 0.3
      0.282352954149246 0.670588254928589 0.8
       0.911384403705597,0.340161353349686,0.391416460275650];

colormap(map)
colorbar off
ylabel('# neurons')
xticks(1:1:length(varstring))
xticklabels(varstring)
suptitle([bstring{k} ' ' stringfile{g}])


end
end