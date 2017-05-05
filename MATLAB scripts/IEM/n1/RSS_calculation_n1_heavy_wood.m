%% RSS calculation for different n1, WOOD

% Book parameters:
n1= [1 2 3 4];
n2= 2;
WAF_wood=7.3284;


d=[1.9 3.5]; % wood wall

d0=1;
dbp = 2.16;

theta_rad=[pi/4 pi/6 0 pi/6 pi/4];
theta = [315 330 1 30 45]; % because K(1)=1;  -matlab indexing starts from 1, not 0

% Path loss in [dBm]
% Before the breakpoint path loss is 10.*log10((d/d0).^n1).*(d < dbp)
% After the breakpoint: 10.*( log10((dbp/d0).^n1) + log10((d/dbp).^n2) ) - only one of these 2 terms will be calculated

PL=zeros(size(d,2),size(n1,2));

DOI=0.247;

for i=1:size(d,2) %d,n1
    for j=1:size(n1,2)
        PL(i,j)= 10.*log10((d(i)/d0).^n1(j)).*(d(i) < dbp) + 10.*( log10((dbp/d0).^n1(j)) + log10((d(i)/dbp).^n2) ).*(d(i) > dbp);
    end   
end

% RIM, mean and variance for 500 packets

RSS=zeros(2,5,size(n1,2),500);

K=zeros(1,331);
K(1,1)=1;

sign=1;

for n=1:500
    if mod(n,100)==0
       disp(['n']); 
       disp(n);
    end
    
    
    for k=1:size(n1,2) %n1
        
        for i=1:2 %d
            
            for j=2:331 %angle
                K(1,j) = K(1,j-1) + sign*wblrnd(0.0513, 1.1212)*DOI;
                sign=sign*(-1);
            end
            
            for l=1:5 %theta
                % RSS = P(Tx) - PL;  P(Tx)= -25 dBm
                RSS(i,l,k,n)= -25 - (PL(i,k).*K(1,theta(l)+1) + WAF_wood/cos(theta_rad(l)));
            end
            
        end
        
    end

end
        



Mean_RSS=mean(RSS,4);
Var_RSS=var(RSS,0,4);


%% Measured values

Mean_Measured_1=[-63.5630 -63.7956 -72.2497 -69.9351 -60.0755]; %d1
Mean_Measured_2=[-63.9861 -67.9477 -79.8489 -78.1006 -75.7905]; %d2

Var_Measured_2=[0.0126 0.2082 0.3838 0.4932 0.1559];
Var_Measured_1=[0.3071 0.1788 1.7012 0.3490 0.0714];

%% RSS values simulated vs measured

Mean_Sim_1=zeros(size(n1,2),5);
Mean_Sim_2=Mean_Sim_1;
Var_Sim_1=Mean_Sim_1;
Var_Sim_2=Mean_Sim_1;


% Mean and Var
    for i=1:size(n1,2)
        Mean_Sim_1(i,:)=squeeze(Mean_RSS(1,:,i));
        Mean_Sim_2(i,:)=squeeze(Mean_RSS(2,:,i));
        Var_Sim_1(i,:)=squeeze(Var_RSS(1,:,i));
        Var_Sim_2(i,:)=squeeze(Var_RSS(2,:,i));
    end


%% Percentage difference

   n11_percent=abs(Mean_Sim_1(1,:)-Mean_Measured_1)./abs((Mean_Sim_1(1,:)+Mean_Measured_1)/2)*100
   n12_percent=abs(Mean_Sim_1(2,:)-Mean_Measured_1)./abs((Mean_Sim_1(2,:)+Mean_Measured_1)/2)*100
   n13_percent=abs(Mean_Sim_1(3,:)-Mean_Measured_1)./abs((Mean_Sim_1(3,:)+Mean_Measured_1)/2)*100
   n14_percent=abs(Mean_Sim_1(4,:)-Mean_Measured_1)./abs((Mean_Sim_1(4,:)+Mean_Measured_1)/2)*100
   
   n21_percent=abs(Mean_Sim_2(1,:)-Mean_Measured_2)./abs((Mean_Sim_2(1,:)+Mean_Measured_2)/2)*100
   n22_percent=abs(Mean_Sim_2(2,:)-Mean_Measured_2)./abs((Mean_Sim_2(2,:)+Mean_Measured_2)/2)*100
   n23_percent=abs(Mean_Sim_2(3,:)-Mean_Measured_2)./abs((Mean_Sim_2(3,:)+Mean_Measured_2)/2)*100
   n24_percent=abs(Mean_Sim_2(4,:)-Mean_Measured_2)./abs((Mean_Sim_2(4,:)+Mean_Measured_2)/2)*100
   
% n11_percent =   49.8525   55.0471   69.0855   63.4439   44.5571
% 
% n12_percent =   43.2149   48.2615   62.1910   56.7525   37.7838
% 
% n13_percent =   36.6739   41.5346   55.6490   50.3226   31.2505
% 
% n14_percent =   30.4915   35.2660   49.4429   44.1003   24.9983
% 
% n21_percent =   29.8925   39.9763   57.4675   53.4278   46.3684
% 
% n22_percent =   23.1632   33.1818   50.6177   46.6778   39.8183
% 
% n23_percent =   16.5035   26.3860   44.1156   40.4259   33.6390
% 
% n24_percent =   10.6831   20.4883   37.9990   34.4163   27.8476


%% Plots
figure
plot([1 2 3 4 5],Mean_Sim_1(1,:),'-s','MarkerFaceColor','b')
hold on
plot([1 2 3 4 5],Mean_Sim_1(2,:),'-rv','MarkerFaceColor','r')
plot([1 2 3 4 5],Mean_Sim_1(3,:),'-gx','MarkerFaceColor','g')
plot([1 2 3 4 5],Mean_Sim_1(4,:),'-mo','MarkerFaceColor','m')
plot([1 2 3 4 5],Mean_Measured_1,'-k+','MarkerFaceColor','k')
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('n1=1','n1=2','n1=3','n1=4','Measured')
title('Measured and Simulated Mean Values for different n1, case 1, WOOD')
hold off
%saveas(gcf,'Case1_Mean_Sim_vs_Measured_n1.fig')
%saveas(gcf,'Case1_Mean_Sim_vs_Measured_n1.jpg')


figure
plot([1 2 3 4 5],Mean_Sim_2(1,:),'-s','MarkerFaceColor','b')
hold on
plot([1 2 3 4 5],Mean_Sim_2(2,:),'-rv','MarkerFaceColor','r')
plot([1 2 3 4 5],Mean_Sim_2(3,:),'-gx','MarkerFaceColor','g')
plot([1 2 3 4 5],Mean_Sim_2(4,:),'-mo','MarkerFaceColor','m')
plot([1 2 3 4 5],Mean_Measured_2,'-k+','MarkerFaceColor','k')
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('n1=1','n1=2','n1=3','n1=4','Measured')
title('Measured and Simulated Mean Values for different n1, case 2, WOOD')
hold off
%saveas(gcf,'Case2_Mean_Sim_vs_Measured_n1.fig')
%saveas(gcf,'Case2_Mean_Sim_vs_Measured_n1.jpg')


% all 3 ceses in 1 figure
% figure
% plot([1 2 3 4 5],Mean_Sim_1(1,:),'-s','MarkerFaceColor','b')
% hold on
% plot([1 2 3 4 5],Mean_Sim_1(2,:),'-rv','MarkerFaceColor','r')
% plot([1 2 3 4 5],Mean_Sim_1(3,:),'-gx','MarkerFaceColor','g')
% plot([1 2 3 4 5],Mean_Sim_1(4,:),'-mo','MarkerFaceColor','m')
% plot([1 2 3 4 5],Mean_Measured_1,'-k+','MarkerFaceColor','k')
% plot([6 7 8 9 10],Mean_Sim_2(1,:),'-s','MarkerFaceColor','b')
% plot([6 7 8 9 10],Mean_Sim_2(2,:),'-rv','MarkerFaceColor','r')
% plot([6 7 8 9 10],Mean_Sim_2(3,:),'-gx','MarkerFaceColor','g')
% plot([6 7 8 9 10],Mean_Sim_2(4,:),'-mo','MarkerFaceColor','m')
% plot([6 7 8 9 10],Mean_Measured_2,'-k+','MarkerFaceColor','k')
% plot([11 12 13 14 15],Mean_Sim_3(1,:),'-s','MarkerFaceColor','b')
% plot([11 12 13 14 15],Mean_Sim_3(2,:),'-rv','MarkerFaceColor','r')
% plot([11 12 13 14 15],Mean_Sim_3(3,:),'-gx','MarkerFaceColor','g')
% plot([11 12 13 14 15],Mean_Sim_3(4,:),'-mo','MarkerFaceColor','m')
% plot([11 12 13 14 15],Mean_Measured_3,'-k+','MarkerFaceColor','k')
% set(gca,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15])
% set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5','Rx1','Rx2','Rx3','Rx4','Rx5','Rx1','Rx2','Rx3','Rx4','Rx5'})
% xlabel('Receivers')
% ylabel('RSS [dBm]')
% legend('n1=1','n1=2','n1=3','n1=4','Measured')
% title('Measured and Simulated Mean Values for different n1, all 3 cases, WOOD')
% hold off

%--------------------------------------------------------------------------------------------------------------------------
figure
plot([1 2 3 4 5],Var_Sim_1(1,:),'-s','MarkerFaceColor','b')
hold on
plot([1 2 3 4 5],Var_Sim_1(2,:),'-rv','MarkerFaceColor','r')
plot([1 2 3 4 5],Var_Sim_1(3,:),'-gx','MarkerFaceColor','g')
plot([1 2 3 4 5],Var_Sim_1(4,:),'-mo','MarkerFaceColor','m')
plot([1 2 3 4 5],Var_Measured_1,'-k+','MarkerFaceColor','k')
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('n1=1','n1=2','n1=3','n1=4','Measured')
title('Measured and Simulated Values of Variance for different n1, case 1, WOOD')
hold off
%saveas(gcf,'Case1_Var_Sim_vs_Measured_n1.fig')
%saveas(gcf,'Case1_Var_Sim_vs_Measured_n1.jpg')
% 
% 
figure
plot([1 2 3 4 5],Var_Sim_2(1,:),'-s','MarkerFaceColor','b')
hold on
plot([1 2 3 4 5],Var_Sim_2(2,:),'-rv','MarkerFaceColor','r')
plot([1 2 3 4 5],Var_Sim_2(3,:),'-gx','MarkerFaceColor','g')
plot([1 2 3 4 5],Var_Sim_2(4,:),'-mo','MarkerFaceColor','m')
plot([1 2 3 4 5],Var_Measured_2,'-k+','MarkerFaceColor','k')
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('n1=1','n1=2','n1=3','n1=4','Measured')
title('Measured and Simulated Values of Variance for different n1, case 2, WOOD')
hold off
% saveas(gcf,'Case2_Var_Sim_vs_Measured_n1.fig')
% saveas(gcf,'Case2_Var_Sim_vs_Measured_n1.jpg')
 
