% Parsing of RSSI values in .txt file
txt = fileread('circle.txt');
out=regexp(txt,'rssi=0x(\w+)','tokens');
rssi=zeros(1,length(out));
for i=1:length(out)
	rssi(i)=typecast(uint8(hex2dec(out{i})),'int8')-45;
end

% RSS plot
degree=0:359;
subplot(2,1,1);
plot(degree, rssi)
axis tight
xlabel('Degrees')
ylabel('RSS')

% DOI calculation
rssi_shift=[rssi(2:end) rssi(1)]; %rotating the vector of RSSI before substracting (in order to find the difference)
doi_values=(abs(rssi_shift-rssi)./100);
DOI=max(doi_values); % DOI=0.2

% Weibull distribution parameters
index=find(doi_values==0);
doi_values(index)=0.001; %removig all zeros from doi vector (wblfit doesn't accept 0 value)
wblfit(doi_values) %generates a and b parameters for wblrnd: a=0.0513 b=1.1212

% "Irregularity circle"
subplot(2,1,2)
theta=0:2*pi/360:2*pi-2*pi/360;
polar(theta,rssi)