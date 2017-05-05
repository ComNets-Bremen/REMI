n1=1;
n2=2;
n3=5.5;
n4=3;
WAF=9.9267;


dBP=2.16;

d=[1.9 3.5];

dWALL1=[1.738 1.5 1.738];
dWALL2=[3.26 2.657 2.3 2.657 3.26];

theta_rad2=[pi/4 pi/6 0 pi/6 pi/4]; 
theta_rad1=[pi/6 0 pi/6];
theta2 = [315 330 1 30 45];
theta1 = [330 1 30];

PLd0=29.676;

PL1 = zeros(1,3);
PL2 = zeros(1,size(theta2,2));

PL1 = PLd0 + 10*n1*log10(dWALL1) +n4*10*log10([d(1) d(1) d(1)]./dWALL1);
PL2 = PLd0 + 10*n1*log10(dBP) +10*n2*log10(dWALL2./[dBP dBP dBP dBP dBP]) +n3*10*log10([d(2) d(2) d(2) d(2) d(2)]./dWALL2);

DOI=0.247;


RSS1=zeros(1,3,500);
RSS2=zeros(1,5,500);

K=zeros(1,331);
K(1,1)=1;

sign=1;

for n=1:500
    if mod(n,100)==0
       disp(['n']); 
       disp(n);
    end
    
                      
            for j=2:331 %angle
                K(1,j) = K(1,j-1) + sign*wblrnd(0.0513, 1.1212)*DOI;
                sign=sign*(-1);
            end
            
            for l=1:3 
                % RSS = P(Tx) - PL;  P(Tx)= -25 dBm
                RSS1(1,l,n)= -25 - (PL1(1,l).*K(1,theta1(l)+1) + WAF/cos(theta_rad1(l)));
            end
            
            for i=1:5 %theta
                 RSS2(1,i,n)= -25 - (PL2(1,i).*K(1,theta2(i)+1) + WAF/cos(theta_rad2(i)));
            end
                   


end
        



Mean_RSS1=mean(RSS1,3);
Mean_RSS2=mean(RSS2,3);
%Var_RSS=var(RSS,0,3);

Mean_Measured_1=[-68.7480 -76.1121 -70.144]; %d1
Mean_Measured_2=[-68.0030 -81.7999 -82.1420 -85.9236 -70.0032]; %d2

Var_Measured_2=[0.0126 0.2082 0.3838 0.4932 0.1559];
%Var_Measured_1=[0.3071 0.1788 1.7012 0.3490 0.0714];

%Var_Measured_2=[0.0126 0.2082 0.3838];
Var_Measured_1=[0.3071 0.1788 1.7012];

   percent_case1=abs(Mean_RSS1(1,:)-Mean_Measured_1)./abs((Mean_RSS1(1,:)+Mean_Measured_1)/2)*100
   percent_case2=abs(Mean_RSS2(1,:)-Mean_Measured_2)./abs((Mean_RSS2(1,:)+Mean_Measured_2)/2)*100

%    percent_case1= 2.0085    8.5978    0.4615
%    percent_case2= 14.1677    4.2248    3.8750    9.6487   10.6550

   
figure
plot([1 2 3],Mean_RSS1(1,:),'-ro','MarkerFaceColor','r')
hold on
plot([1 2 3],Mean_Measured_1,'-k+','MarkerFaceColor','k')
set(gca,'XTick',[1 2 3])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('Simulation','Measurements')
title('Simulated and Measured Mean Values for brick wall, case 1')
hold off


figure
plot([1 2 3 4 5],Mean_RSS2(1,:),'-ro','MarkerFaceColor','r')
hold on
plot([1 2 3 4 5],Mean_Measured_2, '-k+','MarkerFaceColor','k')
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('Simulation','Measurements')
title('Simulated and Measured Mean Values for brick wall, case 2')
hold off