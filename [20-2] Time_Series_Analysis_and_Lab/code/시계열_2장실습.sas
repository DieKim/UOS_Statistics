/* 2�� �߼����� */

/* ����1 �߼������� ������ ���� ���� */

/* (1) ������ �ҷ�����; population.txt */
data pop;
  infile 'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\population.txt';
  input pop@@;
  pop=round(pop/10000); /* ���� ���� */
  lnpop=log(pop); /* �л���ȭ; �α׺�ȯ�� ���� �̺л꼺 �ؼ� */
  t+1; t2=t*t; year=1959+t; /* ������ �ڷ�; 1960~1995 */ 
run; 

/* (2) �ð迭�� Ȯ��; �����߼� or 2���߼� */
proc sgplot data=pop;
  series x=year y=pop / markers  markerattrs=(symbol=asterisk);
  xaxis values=(1960 to 1995 by 5); run;

/* (3) �����߼����� ���� */
proc reg data=pop; 
  model pop=t / dw; /* �����߼����� */
  output out=out1 p=pred1 r=residual1; run;
proc sgplot data=out1; /* ������ �ð迭��; 2�� �߼� ���� */
  series x=year  y=residual1/ markers  markerattrs=(symbol=square);
  xaxis values=(1960 to 1995 by 5); 
  refline  0 / axis=y; run;

/* (4) 2���߼����� ���� */
proc reg data=pop; 
  model pop=t t2/ dw; /* 2���߼����� */
  output out=out2 p=pred2 r=residual2; run; 
proc sgplot data=out2;  /* �������� Ȯ��; �� ���յ� ���ϴ� */
  series x=year y=pop/ markers markerattrs=(symbol=circle); /* ���ð迭 */
  scatter x=year y=pred2 / markerattrs=(symbol=plus); /* ���հ� */
  xaxis values=(1960 to 1995 by 5); 
  yaxis label="pop"; run;
proc sgplot data=out2; /* ������ �ð迭��; ���� ������� + �̺л꼺 ���� */ 
  series x=year  y=residual2/ lineattrs=(pattern=1 color=black thickness=1) 
         markers  markerattrs=(symbol=star color=black size=5);
  xaxis values=(1960 to 1995 by 5); 				 
  refline  0 / axis=y;  run;

/* (5) �α׺�ȯ�� �ڷῡ 2���߼����� ����; for �̺л꼺 �ؼ� */
proc reg data=pop;
  model lnpop=t t2/ dw;
  output out=out3 r=residual3; run;
proc sgplot data=out3; /* ������ �ð迭��; �̺л꼺�� �ؼҵǾ����� ������ ������� ���� */
  series x=year y=residual3  / lineattrs=(pattern=1 color=black thickness=1) 
         markers  markerattrs=(symbol=diamondfilled color=black size=5);
  xaxis values=(1960 to 1995 by 5); 
  refline  0 / axis=y; run;

/* ����2 �߼�+���������� ������ ���� ���� */

/* (1) ������ �ҷ�����; depart.txt */
data dept;
  infile  'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\depart.txt'; input dept @@;
  lndept=log(dept); t+1;  /* �α׺�ȯ; �̺л꼺 ���� */
  date=intnx('month','1JAN84'D,_n_-1);  format date Monyy.;
     mon=month(date);
     if mon=1  then i1=1;  else i1=0;  if mon=2  then i2=1;  else i2=0;
     if mon=3  then i3=1;  else i3=0;  if mon=4  then i4=1;  else i4=0;
     if mon=5  then i5=1;  else i5=0;  if mon=6  then i6=1;  else i6=0;
     if mon=7  then i7=1;  else i7=0;  if mon=8  then i8=1;  else i8=0;
     if mon=9  then i9=1;  else i9=0;  if mon=10 then i10=1; else i10=0;
     if mon=11 then i11=1; else i11=0;  if mon=12 then i12=1; else i12=0; 
run; 

/* (2) �ð迭�� Ȯ��; �����߼�+����+�̺л꼺 */
proc sgplot;
  series x=date y=dept / markers markerattrs=(symbol=dot); run;
proc sgplot; /* �α׺�ȯ���� �̺л꼺 �ؼ� */
  series x=date y=lndept / markers markerattrs=(symbol=dot); run;

/* (3) �α׺�ȯ�� �ڷῡ ������ �����Լ��� ����� ���� ���� */
proc reg; 
  model lndept=t i1-i12/noint dw; /* ������ ���� ����; full rank X */
  output out=deptout r=residual; run; 
proc sgplot data=deptout; /* ������ �ð迭��; ������� ���� */
  series x=date  y=residual / markers  markerattrs=(symbol=circlefilled);
  refline  0 / axis=y; run;
proc arima data=deptout; identify var=residual; run; /* �������� �ڱ������; �� ũ�� */
proc univariate data=deptout; var residual; run; /* ������ �����跮 Ȯ�� */

/* ����3 �������� ���� */

/* (1) �����ͺҷ�����; catv.txt */
data catv;
  infile 'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\catv.txt'; input catv @@;
  t+1; year=1969+t; k=70000000; /* ������ �ڷ�; 1970~1993 */
  lncatv=log(k/catv -1); /* �α׺�ȯ for ���������� ����ȭ */
run;

/* (2) �ð迭�� Ȯ��; S-curve */
proc sgplot; /* S-curve ����� ����� Ȯ�� -> ����ȭ by �α׺�ȯ */
  series x=year y=catv  / markers markerattrs=(symbol=asterisk); 
  xaxis values=(1970 to 1995 by 5); run;
proc sgplot; /* �α׺�ȯ �� ������ ������� */
  series x=year y=lncatv  / markers markerattrs=(symbol=asterisk);
  xaxis values=(1970 to 1995 by 5); 
  yaxis values=(-2 to 3 by 1); run;

/* (3) �����߼����� ����; �α׺�ȯ�� ���� �� ������� �������� �ؼ� */
proc reg data=catv ;
  model lncatv=year/ dw; /* �α׺�ȯ �� ���� */
  output out=out1 pred=p; run; 
data out1; set out1; /* �α׺�ȯ���� ���� ���� �ٽ� �������ƾ� �� */
  p1=k/(exp(p)+1); /* ���� ������ �°� ��ȯ �� �ؼ� */
  residual=catv-p1; run;
proc sgplot; /* �������� �������� �ð迭�� */
  series x=year y=catv  / lineattrs=(pattern=1 color=black) /* ���ð迭 */
         markers markerattrs=(symbol=circlefilled color=black)
         legendlabel="catv"; 
  series x=year y=p1  / lineattrs=(pattern=2 color=blue) /* ���հ� */
         markers  markerattrs=(symbol=starfilled color=blue)
         legendlabel="forecast"; 
  xaxis values=(1970 to 1995 by 5); run; 
  proc sgplot data=out1; /* ������ �ð迭��; �ڱ��� ���� */
  series x=year y=residual/ markers markerattrs=(symbol=circlefilled);
  xaxis values=(1970 to 1995 by 5);
  yaxis values=(-4000000 to 3000000 by 1000000);
  refline  0 / axis=y; run;

/* (4) �������� ����; �α׺�ȯ���� ����������ü�� ���� */
proc nlin data=catv method=gauss noitprint;
  parms k=70000000 b0=2 b1=0; /* �ʱⰪ ���� �߿� */
  temp=exp(b0+b1*t);
  model catv=k/(1+temp); /* �̹� �־��� ���� ���� */
  output out=tvout p=pred r=residual; run;  
proc sgplot; /* �������� �������� �ð迭�� */
	series x=year y=catv;
	series x=year y=pred; run;
proc sgplot; /* ������ �ð迭��; ������ ������� ���� */
	series x=year y=residual; 
    refline  0 / axis=y; run;

/* ����4 �ڱ�ȸ�Ϳ������� ���� */

/* (1) ������ �ҷ�����; depart.txt */
data dept;
  infile  'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\depart.txt'; input dept @@;
  lndept=log(dept); t+1;  /* �α׺�ȯ; �̺л꼺 ���� */
  date=intnx('month','1JAN84'D,_n_-1);  format date Monyy.;
     mon=month(date);
     if mon=1  then i1=1;  else i1=0;  if mon=2  then i2=1;  else i2=0;
     if mon=3  then i3=1;  else i3=0;  if mon=4  then i4=1;  else i4=0;
     if mon=5  then i5=1;  else i5=0;  if mon=6  then i6=1;  else i6=0;
     if mon=7  then i7=1;  else i7=0;  if mon=8  then i8=1;  else i8=0;
     if mon=9  then i9=1;  else i9=0;  if mon=10 then i10=1; else i10=0;
     if mon=11 then i11=1; else i11=0;  if mon=12 then i12=1; else i12=0; 
run; 

/* (2) �ڱ�ȸ�Ϳ������� ����; ������ �ڱ����� �ؼ� */
proc autoreg data=dept; /* backstep���� ���� ����; ���� 1, 3 */
  model lndept=t i1-i12/ noint backstep nlag=13  dwprob;
  output out=out1 r=residual; run;
proc sgplot data=out1; /* ������ �ð迭��; �ڱ��� �ؼ� */
  series x=date y=residual / markers markerattrs=(symbol=dot);
  refline  0 / axis=y; run;
