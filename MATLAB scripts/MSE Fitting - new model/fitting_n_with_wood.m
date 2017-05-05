dBP= 2.16;

d1=3.2;
d2=1.9;
d3=3.5;

dWALL1=[2.125 1.734 1.5];
dWALL2=[1.419 1.15 1];
dWALL3=[3.26 2.657 2.3];

PLd0=29.676;

c1=10*log10(dWALL1(1));
c2=10*log10(d1/dWALL1(1));
c3=1/cos(pi/4);
c4=10*log10(dWALL1(2));
c5=10*log10(d1/dWALL1(2));
c6=1/cos(pi/6);
c7=10*log10(dWALL1(3));
c8=10*log10(d1/dWALL1(3));
c9=10*log10(dWALL2(1));
c10=10*log10(d2/dWALL2(1));
c11=10*log10(dWALL2(2));
c12=10*log10(d2/dWALL2(2));
c13=10*log10(dWALL2(3));
c14=10*log10(d2/dWALL2(3));
c15=10*log10(dBP);
c16=10*log10(dWALL3(1)/dBP);
c17=10*log10(d3/dWALL3(1));
c18=10*log10(dWALL3(2)/dBP);
c19=10*log10(d3/dWALL3(2));
c20=10*log10(dWALL3(3)/dBP);
c21=10*log10(d3/dWALL3(3));

C=[c1 0 0 c2 c3
   c4 0 0 c5 c6
   c7 0 0 c8 1
   c4 0 0 c5 c6
   c1 0 0 c2 c3
   c9 0 0 c10 c3
   c11 0 0 c12 c6
   c13 0 0 c14 1
   c11 0 0 c12 c6
   c9 0 0 c10 c3
   c15 c16 c17 0 c3
   c15 c18 c19 0 c6
   c15 c20 c21 0 1
   c15 c18 c19 0 c6
   c15 c16 c17 0 c3
   ];


d=[67.0071-25-PLd0
   70.1657-25-PLd0
   76.5631-25-PLd0
   80.7979-25-PLd0
   68.1930-25-PLd0
   63.5630-25-PLd0
   63.7956-25-PLd0
   72.2497-25-PLd0
   69.9351-25-PLd0
   60.0755-25-PLd0
   63.9861-25-PLd0
   67.9477-25-PLd0
   79.8489-25-PLd0
   78.1006-25-PLd0
   75.7905-25-PLd0];

%X=lsqnonneg(C,d)

%  LB=[1 2 2 2 0];
%  UB=[3 10 10 10 Inf];
 % 1 3 10 5 0
 
 LB=[1 2 2 2 7.3284];
 UB=[3 10 10 10 Inf];
 % 1 2 5 3 7
 X=lsqlin(C,d,[],[],[],[],LB,UB)
 
