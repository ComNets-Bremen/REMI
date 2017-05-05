txt = fileread('Tx.txt');
out=regexp(txt,'rssi=0x(\w+)','tokens');
rssi=zeros(1,length(out));
for i=1:length(out)
	rssi(i)=typecast(uint8(hex2dec(out{i})),'int8')-45;
end

max_rssi = max(rssi)
min_rssi = min(rssi)
mean_rssi = mean(rssi)
var_rssi =  var(rssi)