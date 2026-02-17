%%%% 1. Code to remove CENTER coordinate points where likelihood <0.9 %%
clear i;
clear wrg_ctr;
wrg_ctr=[];

for i=1:length(ctrx);
    if lhctr(i)<0.9;
        wrg_ctr=[wrg_ctr;frames(i)]; %means if likelihood <0.9, writes the beginning frame numbers
    end;
end;

%%% 2. Detect switch from 1 wrong ctr frame to another, when increment is > 1 (for CENTER)
clear i;
clear a;
clear int_wrg_ctr;
a=length(wrg_ctr);
int_wrg_ctr=[wrg_ctr(1)];

for i=2:a;
    if (wrg_ctr(i))-(wrg_ctr(i-1))>2;
          int_wrg_ctr=[int_wrg_ctr;wrg_ctr(i-1);wrg_ctr(i)];
    end;
end;

%%%% 3. Add last value of wrg_ctr as end of last episode (for CENTER)
int_wrg_ctr=[int_wrg_ctr;wrg_ctr(end)];

clear i j a b c
j=length(int_wrg_ctr);

for i=2:2:j;
    a=int_wrg_ctr(i-1);
    b=int_wrg_ctr(i);
    c=(b-a);
%     disp(c)
    if c<6;
        ctrx((a)-1:(b)+1)=linspace(ctrx((a)-1),ctrx((b)+1),c+3);
        ctry((a)-1:(b)+1)=linspace(ctry((a)-1),ctry((b)+1),c+3);
        lhctr(a:b)=NaN;
    end;
    if  c>=6;
        ctrx(a:b)=NaN;
        ctry(a:b)=NaN;
        lhctr(a:b)=NaN;
    end;
end;           

clear a b c i j;
clear wrg_ctr;
clear int_wrg_ctr;

% 
% %%% 4. to detect points for NOSE where likelihood <0.9
% clear wrg_ns;
% wrg_ns=[];
% 
% for i=1:length(nsx);
%     if lhns(i)<0.9;
%         wrg_ns=[wrg_ns;frames(i)];
%     end;
% end;
% 
% %%% HR: don't think need to run this ? (why not for center?)
% for i=1:length(wrg_ns);
%     nsx(wrg_ns(i))=NaN;
%     nsy(wrg_ns(i))=NaN;
%     lhns(wrg_ns(i))=NaN;
% end;
%  
% %%%  5. Detect switch from 1 wrong NOSE frame to another, when increment is > 1
% clear i;
% clear a;
% clear int_wrg_ns;
% a=length(wrg_ns);
% int_wrg_ns=[wrg_ns(1)];
% 
% for i=2:a;
%     if (wrg_ns(i))-(wrg_ns(i-1))>2;
%           int_wrg_ns=[int_wrg_ns;wrg_ns(i-1);wrg_ns(i)];
%     end;
% end;
% 
% %%%  6. Add last value of wrg_ns as end of last episode
% int_wrg_ns=[int_wrg_ns;wrg_ns(end)];
% 
% 
% clear i j a b c
% j=length(int_wrg_ns);
% 
% for i=2:2:j 
%     a=int_wrg_ns(i-1);
%     b=int_wrg_ns(i);
%     c=(b-a);
%     if c<6;
%         nsx((a)-1:(b)+1)=linspace(nsx((a)-1),nsx((b)+1),c+3);
%         nsy((a)-1:(b)+1)=linspace(nsy((a)-1),nsy((b)+1),c+3);
%         lhns(a:b)=NaN;
%     end;
%     if  c>=6;
%         nsx(a:b)=NaN;
%         nsy(a:b)=NaN;
%         lhns(a:b)=NaN;
%     end;
% end;           

%%% FOR NECK!!! %%%%

%%% 7. to detect points for NECK where likelihood <0.9
clear wrg_nk;
wrg_nk=[];

for i=1:length(nkx);
    if lhnk(i)<0.9;
        wrg_nk=[wrg_nk;frames(i)];
    end;
end;

%%% HR: don't think need to run this ? (why not for center?)
for i=1:length(wrg_nk);
    nkx(wrg_nk(i))=NaN;
    nky(wrg_nk(i))=NaN;
    lhnk(wrg_nk(i))=NaN;
end;
 
%%%  8. Detect switch from 1 wrong NECK frame to another, when increment is > 1
clear i;
clear a;
clear int_wrg_nk;
a=length(wrg_nk);
int_wrg_nk=[wrg_nk(1)];

for i=2:a;
    if (wrg_nk(i))-(wrg_nk(i-1))>2;
          int_wrg_nk=[int_wrg_nk;wrg_nk(i-1);wrg_nk(i)];
    end;
end;

%%%  9. Add last value of wrg_nk as end of last episode
int_wrg_nk=[int_wrg_nk;wrg_nk(end)];


clear i j a b c
j=length(int_wrg_nk);

for i=2:2:j 
    a=int_wrg_nk(i-1);
    b=int_wrg_nk(i);
    c=(b-a);
    if c<6;
        nkx((a)-1:(b)+1)=linspace(nkx((a)-1),nkx((b)+1),c+3);
        nky((a)-1:(b)+1)=linspace(nky((a)-1),nky((b)+1),c+3);
        lhnk(a:b)=NaN;
    end;
    if  c>=6;
        nkx(a:b)=NaN;
        nky(a:b)=NaN;
        lhnk(a:b)=NaN;
    end;
end;           

clear a b c i j wrg_nk int_wrg_nk;
