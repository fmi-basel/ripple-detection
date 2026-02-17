b=whos;

numberspikes=size(b,1);

 

 

cell_spk=cell(numberspikes,1);


count=0;

 

for nameLOOP=1:numberspikes

   

 

 curr_var= b(nameLOOP,1).name

   

    if strcmp(curr_var(1:3),'SPK')

        count=count+1;

      

        a=eval(curr_var);

       cell_spk{count,1}=a;

    end

end

 

spikes=cell_spk;

 

for f=1:length(spikes)

A(:,f)=histc(spikes{f,1},0.002:0.002:4800);

end

 

for i=1:size(A,2)

for f=1:size(A,2)

[R,P]=corrcoef(A(:,i),A(:,f));

CROSS(i,f)=R(1,2);

end

i

end

 

figure;

imagesc(CROSS)

xticks((1:1:length(CROSS)))

yticks((1:1:length(CROSS)))

caxis([0 0.8])

colorbar

 

[a,b]=find(CROSS>0.5);

DIAG=find(a==b);

a(DIAG)=[];

b(DIAG)=[];

 

c=horzcat(a,b);