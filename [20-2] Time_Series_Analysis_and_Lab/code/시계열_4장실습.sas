/* 4�� ���ع��� �������� */

/* ����1 �߼������� ���� ���ع� */

/* (1) ������ �ҷ����� �� ���� ���� */
data food; /* ���� ���Ĺ� �������� �ڷ� */
infile "C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\food.txt";
input food @@; 
date = intnx('month', '1jan80'd, _n_-1); /* date ���� ����; 1980�� 1������ ���� */
format date monyy.; t+1; /* date ������ ���� ���� */
mon = month(date); /* mon ���� ���� for �������� */
if mon=1 then i1=1; else i1=0;  if mon=2 then i2=1; else i2=0;
if mon=3 then i3=1; else i3=0;  if mon=4 then i4=1; else i4=0;
if mon=5 then i5=1; else i5=0;  if mon=6 then i6=1; else i6=0;
if mon=7 then i7=1; else i7=0;  if mon=8 then i8=1; else i8=0;
if mon=9 then i9=1; else i9=0;  if mon=10 then i10=1; else i10=0;
if mon=11 then i11=1; else i11=0;  if mon=12 then i12=1; else i12=0;
run;
proc print data=food; run;

/* (2) �ð迭�� Ȯ��; �����߼�+������+�̺л꼺 Ȯ�� with �¹����� */
proc sgplot data=food;
series x=date y=food; /* �ð迭�� */
reg x=date y=food; /* �߼��� */
run;

/* (3) ���ð迭 {Zt}���� �߼����� ����; �����߼����� ���� */
proc reg data=food;
model food=t/dw dwprob; /* ������ �ڱ����� �����ϴ� �� */
output out=trendata p=trend; /* �߼����� ���� */
id date; run; quit;
data adtrdata; /* ���ð迭���� �߼����� �����ϱ� */
set trendata; 
adjtrend=food/trend; /* �¹������̹Ƿ�; {Zt/Tt} */
run;

/* (4) �����ð迭 {Zt/Tt}���� �������� ����; �ڱ�ȸ�Ϳ������� ���� */
proc autoreg data=adtrdata;
model adjtrend=i1-i12/noint nlag=13 dwprob backstep;
output out=seasdata p=seasonal;
run; quit;

/* (5) �ұ�Ģ���� ���� */
data all;
set seasdata; 
keep t date food trend seasonal irregular fitted;
irregular=adjtrend/seasonal; /* �ұ�Ģ����; I = Z/(T*S) */
fitted=trend*seasonal; /* ���հ�; Z_hat=T_hat*S_hat */
run;
proc arima data=all;
identify var=irregular nlag=12; /* 12���������� �ڱ������ Ȯ��; �� ���յǾ��� */
run; quit;

/* (6) �߼������� �̿��� ���ذ�� Ȯ�� */
proc print data=all; /* t, date(x), food(Z), T, S, I, Z_hat */ 
var t date food trend seasonal irregular fitted; run;
proc sgplot data=all; /* �߼����� ���� */
series x=date y=food/lineattrs=(pattern=1 color=blue); /* ���ð迭 */
series x=date y=trend/lineattrs=(pattern=2 color=red); /* �߼����� */
run; quit;
proc sgplot data=all; /* �������� ���� */
series x=date y=seasonal; run; quit;
proc sgplot data=all; /* �ұ�Ģ���� ���� */
series x=date y=irregular; run; quit;
proc sgplot data=all; /* ���� */
series x=date y=food/lineattrs=(pattern=1 color=blue); /* ���ð迭 */
series x=date y=fitted/lineattrs=(pattern=2 color=red); /* ������(����) */
run; quit;

/* ����2 �̵���չ� */

/* (1) �����ͺҷ����� �� ���� ���� */
data mindex; /* �߰��� �������� �ڷ� */
infile "C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\mindex.txt";
input mindex @@;
date = intnx('month','1jan86'd,_n_-1);
format date monyy.; t+1; run;
proc print data=mindex; run;

/* (2) �̵���չ��� �̿��� ��Ȱ */
proc expand data=mindex out=out1;
convert mindex=m3/transformout=(cmovave 3 trim 1); /* m=3�� ��, �߽��̵���չ� */ 
convert mindex=m7/transformout=(cmovave 7 trim 3); /* m=7�� ��, �߽��̵���չ� */
run; quit;
proc print data=out1; run; /* ��� ��� */
proc sgplot data=out1; /* m=3�� �� ��Ȱ�׸�; ���� �ΰ� */
series x=date y=mindex/lineattrs=(pattern=1 color=blue); /* ���ð迭 */
series x=date y=m3/lineattrs=(pattern=2 color=black); /* 3�� �ܼ��̵���� */
xaxis values=('1jan86'd to '1jan94'd by year);
run ;quit;
proc sgplot data=out1; /* m=7�� �� ��Ȱ�׸�; ���� �ϸ� */
series x=date y=mindex/lineattrs=(pattern=1 color=blue); /* ���ð迭 */
series x=date y=m7/lineattrs=(pattern=2 color=black); /* 7�� �ܼ��̵���� */
xaxis values=('1jan86'd, to '1jan94'd by year);
run ;quit;

/* ����3 �̵���չ��� ���� ���ع� */ 

/* (1) ������ �ҷ����� �� ���� ���� */
data food;
infile "C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\food.txt";
input food @@; 
date=intnx('month','1jan80'd,_n_-1); format date monyy.;
t+1; mon=month(date); run; quit; 

/* (2) �̵���չ��� ���� ���ع� with �������� */
proc expand data=food out=out2;
convert food=tc/transformout=(cda_tc 12); /* tc; �߼���ȯ���� */
convert food=s/transformout=(cda_s 12); /* s; �������� */
convert food=i/transformout=(cda_i 12); /* i; �ұ�Ģ���� */
convert food=sa/transformout=(cda_sa 12); /* sa; �������� */
run; quit;
proc sgplot data=out2; /* �߼���ȯ����; ��4.1�� �� */
series x=date y=food/lineattrs=(pattern=1 color=purple);
series x=date y=tc/lineattrs=(pattern=2 color=black);
run; quit;
proc sgplot data=out2; /* �������� */
series x=date y=food/lineattrs=(pattern=1 color=purple);
series x=date y=s/lineattrs=(pattern=2 color=black);
run; quit;
proc sgplot data=out2; /* �ұ�Ģ���� */
series x=date y=food/lineattrs=(pattern=1 color=purple);
series x=date y=i/lineattrs=(pattern=2 color=black);
run; quit;
proc sgplot data=out2; /* �������� */
series x=date y=food/lineattrs=(pattern=1 color=purple);
series x=date y=sa/lineattrs=(pattern=2 color=black);
run; quit;

/* ����4 �������� */

/* (1) �����ͺҷ����� �� �������� */
data food;
infile "C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\food.txt";
input food @@; 
date=intnx('month','1jan80'd,_n_-1); format date monyy.;
t+1; mon=month(date); run; quit; 

/* (2) proc X12�� X11����� ���� ���ع� �� �������� */
proc X12 data=food seasons=12 start=jan1980;
var food; x11;
output out=out3 a1 d10 d11 d12 d13;
run ;quit;
proc print data=out3; run;

/* (3) X11�� �̿��� �������� ��� Ȯ�� */
proc sgplot data=out3;
series x=_DATE_ y=food_D10; /* �������� */
run; quit;
proc sgplot data=out3;
series x=_DATE_ y=food_A1; /* ���ð迭 */
series x=_DATE_ y=food_D11; /* �������� */
run; quit;
proc sgplot data=out3; 
series x=_DATE_ y=food_A1; /* ���ð迭 */
series x=_DATE_ y=food_D12; /* �߼���ȯ���� */
run; quit;
proc sgplot data=out3;
series x=_DATE_ y=food_D13; /* �ұ�Ģ���� */
refline 1.0/axis=y; /* �¹�����; ��� 1�� �߽����� �����ϰ� ���� */
run; quit;
proc arima data=out3;
identify var=food_D13 nlag=24; /* �ұ�Ģ������ �ڱ����� Ȯ�� */
run; quit;
