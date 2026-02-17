

lines_add=[1];

a=phistnorm;
b=NaN(1,4,20);

count1=0;
count2=0;
for i=1:4
     
   if max(i==lines_add)==0
       count1=count1+1;
       count2=count2+1;   
       b(:,count2,:)=a(:,count1,:);
    
   else
       count2=count2+1;       
   end 

end