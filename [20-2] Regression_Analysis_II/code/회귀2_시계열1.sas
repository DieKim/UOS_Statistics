/* ����1 1�� �ڱ��������� ���� ���� - AR(1) */

/* (1) ������ �Է� */
data ex1;
	ul=0; /* 1. ul; ������(t-1) */
	phi=0.6; /* 2. phi= -1.5, -1, -0.6, -0.3, 0, 0.3, 0.6, 1, 1.5 */
	do time=10 to 50; /* 3. time */
		u = phi*ul + 2*rannor(12345); /* 4. u; ������(t) */
		y0 = 10+0.5*time; /* 5. y0; ��������(������x) */
		y=y0+u; /* 6. y; Ȯ������(������o) */
		if time>0 then output;
			ul=u; 
	end;
run;
proc print; run;

/* (2) 1���ڱ����� ���� ���� Ȯ�� */
/* y*time=1; Ȯ�����(������)�� ������ ������� �߻� Ȯ�� ���� */
/* y0*time=2; Ȯ�����(������)�� ������ ������� ���� ������ �׷��� */
proc gplot data=ex1;
	plot y * time=1 y0*time=2/ haxis=axis1 vaxis=axis2 overlay legend=legend;
	axis1 w=4 major=(w=3) minor=none label=(h=3) value=(h=2);
	axis2 w=4 major=(w=2) minor=none label=(A=90 R=0 h=3) value=(h=2);
	symbol1 c=blue v=dot h=1 i=join ;
	symbol2 c=red v=star h=1 i=join;
	title h=4 "First-order Autoregressive model : phi=0.6";
run ; quit;

/* ����2 2�� �ڱ��������� ���� ���� - AR(2) */ 

/* (1) 2���ڱ����� �����ϴ� ������ ���� */
data ex2;
	ul = 0; ull = 0; 
	do time = -10 to 36;
		u = + 1.3 * ul - .5 * ull + 2*rannor(12346);
		y = 10 + .5 * time + u;
		if time > 0 then output;
			ull = ul; ul = u;
	end;
run;
proc print; run;

/* (2) �׷����� �ڱ������谡 ������ Ȯ�� */
proc sgplot data=ex2 noautolegend;
series x=time y=y /markers ;/* ������ */
reg x=time y=y/ lineattrs=(color=black); /* �߼��� */
title ��Autocorrelated Time Series��;
run; quit;

/* (3) �Ϲ��ּ�������(OLSE)�� �̿��� ���� */
proc autoreg data=ex2;
model y=time; /* ������ �ڱ��� ���� */
run; quit;

/* (4) �ڱ������� ����(AR)���� ���� */
proc autoreg data=ex2;
model y=time / nlag=2 method=ml; /* AR(2), ȸ�Ͱ�� ���� by ML */
output out=ex2_out1 p=yhat pm=trendhat;
run ;quit;
proc sgplot data=ex2_out1;
scatter x=time y=y / markerattrs=(color=blue); /* ���� ������ ������ */
series x=time y=yhat / lineattrs=(color=blue); /* ������ ȸ������ */
series x=time y=trendhat / lineattrs=(color=black); /* ������ �������� �� �߼����� ��? */
title ��Predictions for Autocorrelation Model��;
run; quit;

/* (5) ������ ���� ���� t=37~40�� �������� �� ������ �߰� */
data ex2_new;
	y = . ; /* y�� ����� */
	do time = 37 to 40; /* ����  t=37~40 �߰� */
		output; 
	end;
run;
data ex2_update;
merge ex2 ex2_new;
by time; /* �ð��� �������� ������ ��ġ�� */
run;
proc print; run;

/* (6) �ٽ� AR(2) ������ �����ؼ� ������ ���ϱ� */
proc autoreg data=ex2_update;
model y = time / nlag=2 method=ml;
output out=p p=yhat pm=ytrend lcl=lcl ucl=ucl; /* ������ ����(ucl) ����(lcl) */
run; quit;
proc print; run;
proc sgplot data=p;
band x=time upper=ucl lower=lcl; /* ������ �ŷڱ��� */
scatter x=time y=y; /* ���� �������� ������ */
series x=time y=yhat; /* �������� ������ ������ */
series x=time y=ytrend / lineattrs=(color=black); /* �߼���=ȸ������ */
title ��Forecasting Autocorrelated Time Series��;
run; quit;

/* (7) DW���� for �������� �ڱ����� ���� Ȯ�� */
proc autoreg data=ex2;
model y = time / dw=4 dwprob; /* 4-���������� �ڱ������� ���� */
run; quit;

/* ����3 ����װ� �Ǹž� ������ */
/* �����(x)�� ����  �Ǹž�(y)�� ��Ÿ�� �ð迭������ */

/* (1) ���� ����װ� �Ǹž� ������ �Է� */
data ex3;
input month Sales Adver@@;
cards;
1 12 15 2 20.5 16 3 21 18
4 15.5 27 5 15.3 21 6 23.5 49
7 24.5 21 8 21.3 22 9 23.5 28
10 28 36 11 24 40 12 15.5 3
13 17.3 21 14 25.3 29 15 25 62
16 36.5 65 17 36.5 46 18 29.6 44
19 30.5 33 20 28 62 21 26 22
22 21.5 12 23 19.7 24 24 19 3
25 16 5 26 20.7 14 27 26.5 36
28 30.6 40 29 32.3 49 30 29.5 7
31 28.3 52 32 31.3 65 33 32.2 17
34 26.4 5 35 23.4 17 36 16.4 1
; run;
proc print; run;

/* (2) �ð迭���������� Ȯ���ϱ� + �������� ���� Ȯ�� by proc gplot */
/* cf. plot�� �ٹ̰� ���� �� ���; �ٵ� ����?
proc gplot data=ex3; �ð��� ���� �Ǹž�(y) ��ȭ -> �ð迭������ 
plot sales * month / vaxis=axis1 haxis=axis2 ; 
axis1 major=(w=2 h=1) minor=(w=1 h=0.5) label =(f=duplex h=3 C=black A=90 R=0 "Sales") value=(h=2) ;
axis2 major=(w=2 h=1) minor=(w=1 h=0.5) label =(f=duplex h=3 C=black "Month") value=(h=2) ;
title f=duplex h=4 c=Black 'Sales in Time Series';
symbol i=join c=red v=dot h=1;
run; quit; */
proc gplot data=ex3; /* �ð��� ���� �Ǹž�(y) ��ȭ -> �ð迭������ */
plot sales * month ; /* plot y��*x�� */
title 'Sales in Time Series';
run; quit;
proc gplot data=ex3; /* �ð��� ���� �����(x) ��ȭ -> �ð迭������ */
plot adver*month; 
title 'Adver in Time Series' ;
run; quit;
proc gplot data=ex3; /* �����(x)�� �Ǹž�(y) -> �ð迭������ */
plot (sales adver)*month;
title " Sales and Adver in Time Series " ;
run; quit;
proc gplot data=ex3; /* �����(x)�� �Ǹž�(y)�� ������ -> ������ ����� */ 
plot sales * adver;
title 'Sales v.s. Adver';
symbol i=none;
run; quit;

/* (3) �ϴ� ���������� �����غ��� */
proc reg data=ex3;
model sales= adver/dw; /* D��跮 ���; 1���ڱ��� ������跮 */
output out=ex3_reg1  r=resid;
run ;
proc gplot data=ex3_reg1;
plot resid * month/vref=0; /* �׳� ������ �� Ŀ�� ���� ���� ��? */
run; quit;
proc reg data=ex3;
model sales= adver;
output out=ex3_reg2 student=s_resid; /* ��Ʃ��Ʈ ���� ���� */
run; quit;
proc gplot data=ex3_reg2;
plot s_resid * month/vref=0; /* �ð�(month)�� ���� ������ ���� �ڱ����� Ȯ�� */
symbol i=join;
run; quit;

/* (4) �ڱ������� Ȯ�������� �ð迭������ ���� */
proc autoreg data=ex3; /* ���� ���� dw�������� �ڱ������� ���� Ȯ�� */
model sales= adver/dw=4 dwprob;
run; quit;
proc autoreg data=ex3 ; /* dw���� ��, AR(1) �������� ���� �����غ��� */
model sales= adver /nlag=1 method =ml dwprob ;
run; quit;
proc autoreg data=ex3 ; /* �̾ AR(2) �������ε� �����غ��� ���ϱ� */
model sales= adver /nlag=2 method =ml dwprob ;
run; quit;

/* (5) AR(1)�� �̿��� �������� ���� �� ��� Ȯ�� */
proc autoreg data=ex3 ; 
model sales= adver /nlag=1 method =ml ;
output out=ex3_auto p=yhat pm=trendhat;
run; quit;
proc print data=ex3_auto; run; /* proc autoreg ��� Ȯ�� */
proc sort data=ex3_auto; by adver; run; /* ���� by ����� */
proc gplot data=ex3_auto;
plot sales * adver=1 yhat *adver=2 trendhat * adver=3 / haxis=axis1 vaxis=axis2 overlay legend=legend;
axis1 w=4 major=(w=3) minor=none label=(h=3) value=(h=2);
axis2 w=4 major=(w=2) minor=none label=(A=90 R=0 h=3) value=(h=2);
symbol1 c=blue v=dot h=1 i=none ;
symbol2 c=red v=star h=1 i=none;
symbol3 c=black v=star h=1 i=join;
title h=4 "Sales v.s Advertisement";
run ; quit;
proc sort data=ex3_auto; by month; run; /* ���� by �ð� */
proc gplot data=ex3_auto;
plot sales * month=1 yhat *month=2 trendhat * month=3 / haxis=axis1 vaxis=axis2 overlay legend=legend;
axis1 w=4 major=(w=3) minor=none label=(h=3) value=(h=2);
axis2 w=4 major=(w=2) minor=none label=(A=90 R=0 h=3) value=(h=2);
symbol1 c=blue v=dot h=1 i=join ;
symbol2 c=red v=star h=1 i=join;
symbol3 c=black v=star h=1 i=join;
title h=4 "Prediction of Sales";
run ; quit;
