/* ����1  ���� �� ���� ������ */
/* ��ǰ ���� �� ����ð�(x)�� ���� ���� ���ҳ�(y)�� ��Ÿ�� ������ */

/* (1) ���ҳ�(y)�� ����ð�(x) ���� ������ Ȯ�� */
proc import datafile="C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\chlorine.txt" dbms= dlm replace
out = ex1;
getnames = yes; /* ���̸� */
delimiter = ","; /* ������; �ݷ�(,) */
run;
proc sgplot data=ex1;
scatter x=Age Y=Chlor;
run; quit;

/* (2) ����, ����ȸ�͸��� ���� */
proc reg data=ex1;
model chlor=age;
output out=ex1_reg p=pred r=resid;
run; quit;
proc sgplot data=ex1_reg;
scatter X=age Y=chlor; /* ���� �������� ������ */
series X=age Y=pred/ lineattrs=(color=red); /* ������ ȸ������ */
run; quit;
proc sgplot data=ex1_reg;
series X=age Y=resid/ lineattrs=(color=blue); /* �����׸� with �������� */refline 0/axis=y; /* ����; y=0 */
run; quit;

/* (3) �����м� ���, ���������� ���� */
proc nlin data=ex1 method=newton; /* or method=gauss(����Ʈ) */
model chlor=a+(0.49-a)*exp(-b*(age-8));
parms a=0.35 b=0.034;
output out=ex1_nlin1 p=pred r=resid;
run; quit;
proc sgplot data=ex1_nlin1;
scatter X=age Y=chlor;
series X=age Y=pred/lineattrs=(color=red); /* ������������ �ξ� �� ���յ� */
run; quit;
proc sgplot data=ex1_nlin1;
scatter X=age Y=resid; /* �����׸��� ���� �� ���յ� ��? */
refline 0/axis=y;
run; quit;

/* (4) �� ���յǾ�����, �ʱⰪ�� �ٲ㼭 �ѹ��� �������� �����غ��� */
proc nlin data=ex1 method=newton; /* or method=gauss(����Ʈ) */
model chlor=a+(0.49-a)*exp(-b*(age-8));
parms a=1 b=1; /* �ʱⰪ�� �ٲ���� ���� X; �ʱⰪ�� �߿伺 */
output out=ex1_nlin2 p=pred r=resid;
run; quit;

/* (5) �������� ���� �� �������� */
proc nlin data=ex1 method=newton plots=(fit diagnostics); /* proc sgplot �ܰ� ���� ���� */
model chlor=a+(0.49-a)*exp(-b*(age-8));
parms a=0.35 b=0.034;
output out=ex1_nlin1 p=pred r=resid; /* ��� ��; plots �ɼ��� �����ϱ� */
run; quit;

/* ����2 nitrate ������ */
/* ����(x)�� ���� �ν����� ���꿰 Ȱ���ġ(y)�� ��Ÿ�� ������ */

/* (1) �����͸� �ҷ����� ������ Ȯ�� */
proc import datafile="C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\nitrate.txt" dbms=dlm replace
out = ex2; 
getnames = yes;
delimeter = ",";
run; quit; 
proc sgplot data=ex2;
scatter X=Light Y=NitDay1; /* ���� �������� Ȯ�� ���� */
run; quit;

/* (2) �ΰ��� ���������� ���� �� ��� �� */
proc nlin data=ex2 method=newton plots=(fit diagnostics);
model nitday1=(b1*light)/(b2+light); /* Michaelis-Menton model */
parms b1=1 b2=1;
run; quit;
proc nlin data=ex2 method=newton plots=(fit diagnostics); 
model nitday1=b1*(1-exp(-b2*light)); /* Exponential rise model */
parms b1=20000 b2=0.01;
run; quit;

/* ����3 puromycin ������ */
/* �׻���ó��(x)�� ���� ȿ�ҹ����ӵ�(y)�� ��Ÿ�� ������ */

/* (1) �����͸� �ҷ��ͼ� treated �׷츸 ������ �м��ϱ� */
proc import datafile="C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\puromycin.csv" dbms=csv replace
out=ex3_raw;
getnames=yes;
run; quit;
data ex3;
set ex3_raw(where=(state="treated")); /* ���� state�� ���� "treated"�� �����͸� �����ؼ� ���ο� �����ͼ� ���� */
run; quit;

/* (2) ������ �׸��� */
proc sgplot data=ex3;
scatter X=conc Y=rate; /* ������������ Ȯ�� */
run; quit;

/* (3) conc*=1/conc, rate*=1/rate�� ��ȯ�� �� �������� */
data ex3_t; /* ��ȯ */
set ex3;
conc_t = 1/conc; /* conc*=1/conc */
rate_t = 1/rate; /* rate*=1/rate */
run; 
proc sgplot data=ex3_t; /* ������ */
scatter X=conc_t Y=rate_t;
reg X=conc_t Y=rate_t; /* ȸ������; ������� ���������� ������� ��  */
run; quit;
proc reg data=ex3_t; /* ������������ */
model rate_t = conc_t;
output out=ex3_reg p=pred_t; /* pred_t = 1/pred(y_hat) */
run; quit;

/* (4) ���յ� ������ �ؼ��ϱ� ���� �ٽ� ��ȯ �� Ȯ�� */
data ex3_r; /* �ؼ��ϰ��� �ϴ� pred(y_hat)���� ��ȯ */
set ex3_reg;
pred = 1/pred_t;
run; 
proc sgplot data=ex3_r; /* �������� ��� Ȯ�� */
scatter X=conc Y=rate;
series X=conc Y=pred/lineattrs=(color=purple); /* ���� ������ ������ ���� �Ϸ� */
run; quit;

/* (5) ��ȯ ��ſ�, �����Լ��� �̿��� �ٷ� ���� ���� */
proc nlin data=ex3 method=newton plots=(fit diagnostics);
model rate=(t1*conc)/(conc+t2);
parms t1=0.02 t2=0.02;
output out=ex3_nlin p=pred r=resid;
run; quit;
proc sgplot data=ex3_nlin;
scatter X=conc Y=resid; /* �����׸� with �������� */
run; quit;
proc sgplot data=ex3_nlin;
scatter X=pred Y=resid; /* �����׸� with ���հ� */
run ;quit;

/* (6) Q-Q plot & �������� Ȯ�� */
proc univariate data=ex3_nlin;
qqplot resid/normal(mu=0 sigma=10.93161); /* sigma = ��Ʈ MSE */
run; quit; 
