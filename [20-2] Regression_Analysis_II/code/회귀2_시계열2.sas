/* ����1 ex1 ������ */
/* ������ ��Ÿ���� ���� t�� 2�� �ڱ����� ���� y���� ���� */

/* (1) ������ �ҷ����� */
proc import datafile="C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\ex1.csv" 
dbms=csv replace out=ex1;
getnames=yes;
run; quit;

/* (2) �ð迭�� Ȯ���ϱ� */
proc sgplot data=ex1;
series x=t y=y;
run; quit;

/* (3) ����ȸ�͸��� ���� */
proc reg data=ex1;
model y=t/dw spec;
output out=out1 p=pred r=resid;
run; quit;

/* (4) ������ �ð迭�� */
proc sgplot data=out1;
series x=t y=resid;
refline 0/axis=y;
run; quit;

/* (5) ������ �ڱ����� ���� */
proc autoreg data=ex1;
model y=t/ dw=3 dwprob;
run; quit;

/* (6) AR(2)���� ���� */
proc autoreg data=ex1;
model y=t/nlag=2 method=ml dw=2 dwprob;
output out=out2 p=pred pm=trendhat;
run; quit;
/* cf */
proc autoreg data=ex1;
model y=t/backstep nlag=3 method=ml dwprob;
output out=out2 p=pred pm=trendhat;
run; quit;

/* (7) ������ ������ �̿��Ͽ� ���� */
proc sgplot data=out2;
series x=t y=pred;
series x=t y=trendhat/lineattrs=(color=red);
run; quit;

/* ����2 lakelevel ������ */
/* ������ ũ��(x)�� ����(t)�� ���� ȣ���� ����(y) ������ */

/* (1) ������ �ҷ����� */
proc import datafile="C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\lakelevel.txt"
dbms=dlm replace out=ex2;
getnames=yes; delimeters=",";
run; quit;

/* (2) �������� �ð迭�� �׸��� */
proc sgplot data=ex2; /* ������; �����߼� */
scatter x=sunspt y=lakelev;
run; quit;
proc sgplot data=ex2; /* �ð迭��; �ڱ��� */
series x=year y=lakelev;
refline 0/axis=y;
run; quit;

/* (3) �������� vs �ڱ������� */
proc reg data=ex2; /* �������� */
model lakelev=year sunspt/dw spec;
run; quit;
proc autoreg data=ex2; /* �ð迭����; AR���� ���� X */
model lakelev=year sunspt/method=ml nlag=2 dw=2 dwprob;
run ;quit;

/* ����3 salesadvert ������ */
/* ���� �����(x)�� �Ǹŷ�(y) ������ */

/* (1) ������ �Է� */
proc import datafile="C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\salesadvert.txt"
dbms=dlm replace out=ex3;
getnames=yes; delimeter=",";
run; quit;

/* (2) ����ȸ�͸������� */
proc reg data=ex3; /* ������ �������� DW ��跮 Ȯ�� */
model sales=adver/dw dwprob;
run; quit;
proc autoreg data=ex3; /* 5 ���������� ������ �ڱ����� DW ��跮 Ȯ�� */
model sales=adver/method=ml nlag=5 dw=5  dwprob;
run; quit;

/* (3) ������ ���� ���� */
data ex3_2; /* for model 2, 3 */
set ex3;
ym=lag(sales); /* y_(t-1) */
xm=lag(adver); /* x_(t-1) */
run ;quit;
/* Model 1; AR(1) */
proc autoreg data=ex3;
model sales=adver/nlag=1 method=ml dw=5 dwprob;
run; quit;
/* Model 2 */
proc autoreg data=ex3_2;
model sales=ym adver xm/dw=5 dwprob;
run; quit;
/* Model 3 */
proc autoreg data=ex3_2;
model sales=ym adver/dw=5 dwprob;
run; quit;

/* (4) Cochran-Orcutt ����� ���� AR(1)������ ��� ���� */
/* step1; OLSE */
proc autoreg data=ex3 outest=outest;
model sales=adver/method=ml;
output out=out r=resid;
run; quit;
/* step2; OLSE�� ���� */
proc autoreg data=out outest=outest2;
model resid= /method=ml nlag=1 noint;
run; quit;
/* step 3 */
data CO;
if _n_=1 then set outest;
if _n_=1 then set outest2;
set out;
ym=lag(sales);
xm=lag(adver);
ystar=sales+_A_1*ym;
xstar=adver+_A_1*xm;
run; quit;
proc autoreg data=CO outest=outest3;
model ystar=xstar/method=ml dw=5 dwprob;
run; quit;
/* step 4 */
data final;
set outest;
set outest2;
set outest3;
b0_hat = Intercept/(1+_A_1);
run; quit;
proc print data=final; run;
