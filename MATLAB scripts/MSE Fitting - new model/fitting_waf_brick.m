dBP= 2.16;

d1=1.9;
d2=3.5;

dWALL1=[1.738 1.5 1.738]; % 30 0 30
dWALL2=[3.26 2.657 2.3 2.657 3.26]; % 45 30 0 30 45

PLd0=29.676;

d=[(68.7480 -25 -PLd0 -10*log10(dWALL1(1)) - 10*3*log10(d1/dWALL1(1)))
   (76.1121 -25 -PLd0 -10*log10(dWALL1(2)) - 10*3*log10(d1/dWALL1(2)))
   (70.1446 -25 -PLd0 -10*log10(dWALL1(3)) - 10*3*log10(d1/dWALL1(3)))
   (68.0030 -25 -PLd0 -10*log10(dBP) -10*2*log10(dWALL2(1)/dBP) -10*5.5*log10(d2/dWALL2(1)))
   (81.7999 -25 -PLd0 -10*log10(dBP) -10*2*log10(dWALL2(2)/dBP) -10*5.5*log10(d2/dWALL2(2)))
   (82.1420 -25 -PLd0 -10*log10(dBP) -10*2*log10(dWALL2(3)/dBP) -10*5.5*log10(d2/dWALL2(3)))
   (85.9236 -25 -PLd0 -10*log10(dBP) -10*2*log10(dWALL2(4)/dBP) -10*5.5*log10(d2/dWALL2(4)))
   (70.0032 -25 -PLd0 -10*log10(dBP) -10*2*log10(dWALL2(5)/dBP) -10*5.5*log10(d2/dWALL2(5)))];

c1=1/cos(pi/4);
c2=1/cos(pi/6);
c3=1;

C=[c2
   c3
   c2
   c1
   c2
   c3
   c2
   c1];

 LB= -Inf;
 UB= Inf;
 X=lsqlin(C,d,[],[],[],[],LB,UB)
 
 %11.2540