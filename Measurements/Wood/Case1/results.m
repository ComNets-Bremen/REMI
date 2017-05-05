txt1 = fileread('Rx1.txt');
txt2 = fileread('Rx2.txt');
txt3 = fileread('Rx3.txt');
txt4 = fileread('Rx4.txt');
txt5 = fileread('Rx5.txt');

out1=regexp(txt1,'rssi=0x(\w+)','tokens');
out2=regexp(txt2,'rssi=0x(\w+)','tokens');
out3=regexp(txt3,'rssi=0x(\w+)','tokens');
out4=regexp(txt4,'rssi=0x(\w+)','tokens');
out5=regexp(txt5,'rssi=0x(\w+)','tokens');

rssi1=zeros(1,length(out1));
rssi2=zeros(1,length(out2));
rssi3=zeros(1,length(out3));
rssi4=zeros(1,length(out4));
rssi5=zeros(1,length(out5));

for i=1:length(out1)
	rssi1(i)=typecast(uint8(hex2dec(out1{i})),'int8')-45;
end
for i=1:length(out2)
	rssi2(i)=typecast(uint8(hex2dec(out2{i})),'int8')-45;
end
for i=1:length(out3)
	rssi3(i)=typecast(uint8(hex2dec(out3{i})),'int8')-45;
end
for i=1:length(out4)
	rssi4(i)=typecast(uint8(hex2dec(out4{i})),'int8')-45;
end
for i=1:length(out5)
	rssi5(i)=typecast(uint8(hex2dec(out5{i})),'int8')-45;
end

max_rssi1 = max(rssi1)
min_rssi1 = min(rssi1)
mean_rssi1 = mean(rssi1)
var_rssi1 =  var(rssi1)

max_rssi2 = max(rssi2)
min_rssi2 = min(rssi2)
mean_rssi2 = mean(rssi2)
var_rssi2 =  var(rssi2)

max_rssi3 = max(rssi3)
min_rssi3 = min(rssi3)
mean_rssi3 = mean(rssi3)
var_rssi3 =  var(rssi3)

max_rssi4 = max(rssi4)
min_rssi4 = min(rssi4)
mean_rssi4 = mean(rssi4)
var_rssi4 =  var(rssi4)

max_rssi5 = max(rssi5)
min_rssi5 = min(rssi5)
mean_rssi5 = mean(rssi5)
var_rssi5 =  var(rssi5)