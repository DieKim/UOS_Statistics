/** EXAMPLE 2.2 : �����Լ��� �̿��� �������� ���� **/ 
data dept;
  infile  'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\depart.txt'; input dept @@;
  lndept=log(dept); t+1; 
  date=intnx('month','1JAN84'D,_n_-1);  format date Monyy.;
     mon=month(date);
     if mon=1  then i1=1;  else i1=0;
     if mon=2  then i2=1;  else i2=0;
     if mon=3  then i3=1;  else i3=0;
     if mon=4  then i4=1;  else i4=0;
     if mon=5  then i5=1;  else i5=0;
     if mon=6  then i6=1;  else i6=0;
     if mon=7  then i7=1;  else i7=0;
     if mon=8  then i8=1;  else i8=0;
     if mon=9  then i9=1;  else i9=0;
     if mon=10 then i10=1; else i10=0;
     if mon=11 then i11=1; else i11=0;
     if mon=12 then i12=1; else i12=0; run; 
proc sgplot; /* �׸� 2-9 */
  series x=date y=dept / markers markerattrs=(symbol=dot); run;
  proc sgplot; /* �׸� 2-10 */
  series x=date y=lndept / markers markerattrs=(symbol=dot); run;
proc reg; /* ������ ���� ���������߼����� ���� with 12���� �����Լ� */
  model lndept=t i1-i12/noint dw;
  output out=deptout r=residual; run; 
proc sgplot data=deptout; /* ������ �ð迭�� */
  series x=date  y=residual / markers  markerattrs=(symbol=circlefilled);
  refline  0 / axis=y; run;
proc arima data=deptout; identify var=residual; run; /* ������ �ڱ������ */ 

/** EXAMPLE 2.4 : �ڱ�ȸ�Ϳ������� ���� **/
proc autoreg data=dept; /* �ڱ�ȸ�Ϳ������� ���� */
  model lndept=t i1-i12/ noint backstep nlag=13  dwprob;
  output out=out1 r=residual; run;
proc sgplot data=out1; /* ������ �ð迭�� */
  series x=date y=residual / markers markerattrs=(symbol=dot);
  refline  0 / axis=y; run;

 /*  �߼����� ���� */
 /* trendata set�� �ִ� 20�� �ð迭 �ڷῡ ���� ������ �������κ��� 12���� 
   �̷� ������ �ϱ� ���� ������ ���� ���� 12�� �ڷḦ ���������� ó���Ͽ��� */
data trendata;
  input z @@; t+1;
datalines;
  23 25 27 34 38 47 49 39 57 59 63 64 69 78 73 89 83 84 86 92
  . . . . . . . . . .  .  . ; run;
proc reg;
  model z=t/ dw;
  output out=out1 p=zhat r=ehat l95=lci95 u95=uci95; run;
proc print; run;
proc sgplot data=out1;
  band x=t Upper=uci95 Lower=lci95 / legendlabel="95% Confidence limits";
  series x=t y=z / legendlabel="actual";  
  scatter x=t y=zhat / markerattrs=(symbol=dot) legendlabel="forecast"; 
  refline  20/ axis=x ;
  yaxis label="Z"; run;
