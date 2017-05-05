Mean_Measured_1_wood=[-63.5630 -63.7956 -72.2497 -69.9351 -60.0755];
Mean_Measured_2_wood=[-63.9861 -67.9477 -79.8489 -78.1006 -75.7905];

Mean_Measured_1_brick=[-68.7480 -76.1121 -79.1446];
Mean_Measured_2_brick=[-68.0030 -81.7999 -82.1420 -85.9236 -70.0032];

Var_Measured_2_wood=[0.0126 0.2082 0.3838 0.4932 0.1559];
Var_Measured_1_wood=[0.3071 0.1788 1.7012 0.3490 0.0714];

Var_Measured_2_brick=[0.0126 0.2082 0.3838 0.4932 0.1559];


errorbar([1 2 3 4 5],Mean_Measured_2_wood, Var_Measured_2_wood, '-s','MarkerFaceColor','b')
hold on
errorbar([1 2 3 4 5],Mean_Measured_2_brick, Var_Measured_2_brick, '-rv','MarkerFaceColor','r')
hold on
%plot([1 2 3 4 5],Mean_Measured_3_wood,'-gx','MarkerFaceColor','g')
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTickLabel',{'Rx1','Rx2','Rx3','Rx4','Rx5'})
xlabel('Receivers')
ylabel('RSS [dBm]')
legend('wood','brick')
%title('Measured Mean Values, WOOD')
hold off
%saveas(gcf,'Measured Mean Values, WOOD.jpg')

