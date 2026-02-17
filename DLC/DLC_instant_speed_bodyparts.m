clear all


filename=['E:\DLC\M296-test1001DLC_resnet50_FINAL2Oct21shuffle1_1030000filtered.csv'];

data=importcsv(filename);

nose=data.data(:,[2 3]);
neck=data.data(:,[5 6]);
center=data.data(:,[8 9]);
base=data.data(:,[11 12]);


cmXpixel=0.08;

framesXsecond=30;


nose_speed=sqrt(diff(nose(:,2)).^2+diff(nose(:,1)).^2)*framesXsecond*cmXpixel;
center_speed=sqrt(diff(center(:,2)).^2+diff(center(:,1)).^2)*framesXsecond*cmXpixel;
neck_speed=sqrt(diff(neck(:,2)).^2+diff(neck(:,1)).^2)*framesXsecond*cmXpixel;
base_speed=sqrt(diff(base(:,2)).^2+diff(base(:,1)).^2)*framesXsecond*cmXpixel;

xtime=(1:1:length(nose_speed))/framesXsecond;
figure;
plot(xtime,smooth(nose_speed,5))
hold on
plot(xtime,smooth(center_speed,5))

plot(xtime,smooth(neck_speed)),hold on
plot(xtime,smooth(base_speed))


