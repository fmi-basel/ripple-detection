clear all

filename1=('C:\Users\h-rkim\Desktop\units_pfc_test1\Mat data\TimeStamps.mat');
load(filename1,'Spike_TS','MouseID')

Spike_TS_1=Spike_TS;
MouseID_1=MouseID;

filename2=('C:\Users\h-rkim\Desktop\units_pfc_test2\Mat data\TimeStamps.mat');
load(filename2,'Spike_TS','MouseID')

Spike_TS_2=Spike_TS;
MouseID_2=MouseID;



 MouseID_1_num = regexp(MouseID_1(:,1),'\d*','Match');
 MouseID_1_P=   strfind(MouseID_1(:,2),'P');
 
 clear New_ID_1
 for i=1:size(MouseID_1_num,1)    
     New_ID_1{i,1}=MouseID_1_num{i}(2);
     MID=MouseID_1{i,2};
     New_ID_1{i,2}=MID(1:MouseID_1_P{i}(2)-1);   
 end
 
 
 MouseID_2_num = regexp(MouseID_2(:,1),'\d*','Match');
 MouseID_2_P=   strfind(MouseID_2(:,2),'P');
  
 clear New_ID_2
 for i=1:size(MouseID_2_num,1)    
     New_ID_2{i,1}=MouseID_2_num{i}(2);
     MID=MouseID_2{i,2};
     New_ID_2{i,2}=MID(1:MouseID_2_P{i}(2)-1);   
 end
 
 clear Same_neuron_2
 for i=1:size(New_ID_2)
   Current_mouse=New_ID_2{i,1}{1,1};
   Current_neuron=New_ID_2{i,2};
   clear Compare_M
   for j=1:size(New_ID_1);
       
      Test_mouse=New_ID_1{j,1}{1,1};  
      Test_neuron=New_ID_1{j,2};
      Compare_M(j,1)=strcmp(Current_mouse,Test_mouse);
      
      Compare_M(j,2)=strcmp(Current_neuron,Test_neuron);
   end
 
   Same_neuron_2(i)=max(sum(Compare_M,2)==2);
    
 end
 
  clear Same_neuron_1
 for i=1:size(New_ID_1)
   Current_mouse=New_ID_1{i,1}{1,1};
   Current_neuron=New_ID_1{i,2};
   clear Compare_M
   for j=1:size(New_ID_2);
       
      Test_mouse=New_ID_2{j,1}{1,1};  
      Test_neuron=New_ID_2{j,2};
      Compare_M(j,1)=strcmp(Current_mouse,Test_mouse);
      
      Compare_M(j,2)=strcmp(Current_neuron,Test_neuron);
   end
 
   Same_neuron_1(i)=max(sum(Compare_M,2)==2);
    
 end
 
 Spike_TS_1_kept=Spike_TS_1;
 Spike_TS_1_kept(Same_neuron_1==0)=[];
 
 Spike_TS_2_kept=Spike_TS_2;
 Spike_TS_2_kept(Same_neuron_2==0)=[];
 
filename2=('C:\Users\h-rkim\Desktop\Kept_neurons.mat');
save(filename2,'Spike_TS_1_kept','Same_neuron_1','Spike_TS_2_kept','Same_neuron_2','New_ID_1','New_ID_2')

 
 
 
 