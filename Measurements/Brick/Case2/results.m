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

% max_rssi = max(rssi)
% min_rssi = min(rssi)
% mean_rssi = mean(rssi)
% var_rssi =  var(rssi)