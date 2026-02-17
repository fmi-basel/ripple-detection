%clear all

% MoveStart=[1;3.3;5;8];
% MoveEnd=[1.5;3.5;7;15];

RippleTS=FP56_HPCLocRipples;

RipplesDirtyPosition=[];

for i=1:length(Start)
   CurrentStart=Start(i);
   CurrentEnd=End(i);
   
   InRangeRipples=(find(RippleTS>=CurrentStart&RippleTS<=CurrentEnd));
   RipplesDirtyPosition=[RipplesDirtyPosition;InRangeRipples];

end

RipplesClean=RippleTS;
RipplesClean(RipplesDirtyPosition)=[];