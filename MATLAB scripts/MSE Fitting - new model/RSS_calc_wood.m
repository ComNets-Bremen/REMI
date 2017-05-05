% n1=1;
% n2=2;
% n3=4;
% n4=2;
% WAF=9;

n1=1;
n2=2;
n3=6;
n4=3;
WAF=7.3284;


dBP=2.16;

d=[1.9 3.5];

%dWALL1=[2.125 1.734 1.5 1.734 2.125];
dWALL1=[1.419 1.15 1 1.15 1.419];
dWALL2=[3.26 2.657 2.3 2.657 3.26];

theta_rad=[pi/4 pi/6 0 pi/6 pi/4]; 
theta = [315 330 1 30 45];

PLd0=29.676;

PL=zeros(2,size(theta,2));

PL(1,:)= PLd0 + 10*n1*log10(dWALL1) +n4*10*log10([d(1) d(1) d(1) d(1) d(1)]./dWALL1);
PL(2,:)= PLd0 + 10*n1*log10(dBP) +10*n2*log10(dWALL2./[dBP dBP dBP dBP dBP]) +n3*10*log10([d(2) d(2) d(2) d(2) d(2)]./dWALL2);

DOI=0.247;


RSS=zeros(2,5,500);

K=zeros(1,331);
K(1,1)=1;

sign=1;

for n=1:500
    if mod(n,100)==0
       disp(['n']); 
       disp(n);
    end
    
           
        for i=1:2 %d
            
            for j=2:331 %angle
                K(1,j) = K(1,j-1) + sign*wblrnd(0.0513, 1.1212)*DOI;
                sign=sign*(-1);
            end
            
            for l=1:5 %theta
                % RSS = P(Tx) - PL;  P(Tx)= -25 dBm
                RSS(i,l,n)= -25 - (PL(i,l).*K(1,theta(l)+1) + WAF/cos(theta_rad(l)));
            end
            
        end
        


end
        



Mean_RSS=mean(RSS,3);
Var_RSS=var(RSS,0,3);

Mean_Measured_1=[-63.5630 -63.7956 -72.2497 -69.9351 -60.0755]; %d1
Mean_Measured_2=[-63.9861 -67.9477 -79.8489 -78.1006 -75.7905]; %d2

Var_Measured_2=[0.0126 0.2082 0.3838 0.4932 0.1559];
Var_Measured_1=[0.3071 0.1788 1.7012 0.3490 0.0714];

   percent_case1=abs(Mean_RSS(1,:)-Mean_Measured_1)./abs((Mean_RSS(1,:)+Mean_Measured_1)/2)*100
   percent_case2=abs(Mean_RSS(2,:)-Mean_Measured_2)./abs((Mean_RSS(2,:)+Mean_Measured_2)/2)*100

%    percent_case1= 10.5404    9.5880    1.9635    0.6468   16.4983
%    percent_case2= 15.2800   10.8956    3.1282    3.4811    2.0859
   
figure
plot([1 2 3 4 5],Mean_RSS(1,:),'-ro','MarkerFaceColor','r')
hold on
plot([1 2 3 4 5],Mean_Measured_1,'-k+','MarkerFaceColor','k')
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('Simulation','Measurements')
title('Simulated and Measured Mean Values for wooden wall, case 1')
hold off


figure
plot([1 2 3 4 5],Mean_RSS(2,:),'-ro','MarkerFaceColor','r')
hold on
plot([1 2 3 4 5],Mean_Measured_2,'-k+','MarkerFaceColor','k')
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('Simulation','Measurements')
title('Simulated and Measured Mean Values for wooden wall, case 2')
hold off