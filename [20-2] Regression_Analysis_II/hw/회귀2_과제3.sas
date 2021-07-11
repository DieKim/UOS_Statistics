/* Q1 */
/* ������ �ҷ����� */
proc import datafile='C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\ȸ��2����\bookstore.xls' 
	dbms=xls replace
	out=ex1;
	namerow=1;
	startrow=2;
	getnames=yes;
run;
/* �ڱ����� ���� by dw ~ 4������  */
proc autoreg data=ex1;
	model Sales=Adver/dw=4 dwprob;
run; quit;
/*1�� �ڱ�ȸ�Ϳ��� ���� -  AR(1) */
proc autoreg data=ex1;
	model Sales=Adver/nlag=1 method=ml dwprob;
	output out=ex1_out1 p=yhat pm=trendhat r=resid;
run; quit;
/*2�� �ڱ�ȸ�Ϳ��� ���� -  AR(2) */
proc autoreg data=ex1;
	model Sales=Adver/nlag=2 method=ml dwprob;
	output out=ex1_out1 p=yhat pm=trendhat r=resid;
run; quit;

/* Q2 */
/* ������ �Է� */
data ex2;
input year sales expenditures population @@;
cards;
1 3083 75 825000 2 3149 78 830445 3 3218 80 838750 4 3239 82 842940
5 3295 84 846315 6 3374 88 852240 7 3475 93 860760 8 3569 97 865925
9 3597 99 871640 10 3725 104 877745 11 3794 109 886520 12 3959 115 894500
13 4043 120 900400 14 4194 127 904005 15 4318 135 908525 16 4493 144 912160
17 4683 153 917630 18 4850 161 922220 19 5005 170 925910 20 5236 182 929610
; run;
/* �ڱ����� ���� by dw ~ 4������  */
proc autoreg data=ex2;
	model sales=expenditures population/dw=4 dwprob;
run; quit;
/*1�� �ڱ�ȸ�Ϳ��� ���� -  AR(1) */
proc autoreg data=ex2;
	model sales=expenditures population/nlag=1 method=ml dwprob;
	output out=ex2_out1 p=yhat pm=trendhat;
run; quit;
/* 2�� �ڱ�ȸ�Ϳ������� - AR(2) */
proc autoreg data=ex2;
	model sales=expenditures population/nlag=2 method=ml;
	output out=ex2_out2 p=yhat pm=trendhat;
run; quit;
/* 3�� �ڱ�ȸ�Ϳ������� - AR(3) */
proc autoreg data=ex2;
	model sales=expenditures population/nlag=3 method=ml;
	output out=ex2_out3 p=yhat pm=trendhat;
run; quit;
/* 4�� �ڱ�ȸ�Ϳ������� - AR(4) */
proc autoreg data=ex2;
	model sales=expenditures population/nlag=4 method=ml;
	output out=ex2_out4 p=yhat pm=trendhat;
run; quit;

/* Q1 ����ġ�� ���� */
data ex1;
	set ex1;
	time=_N_; /* �ð� ������ ��Ÿ���� �ε��� ���� ���� */
run;
proc autoreg data=ex1;
	model Sales=Adver/nlag=1 method=ml dwprob;
	output out=ex1_out1 p=yhat pm=trendhat r=resid;
run; quit;
proc sgplot data=ex1_out1;
	scatter x=Adver y=Sales/markerfillattrs=(color=blue);
	scatter x=Adver y=yhat/markerfillattrs=(color=blue) markerattrs=(symbol=circlefilled size=8);
	series x=Adver y=trendhat/lineattrs=(pattern=1 color=green);
	title 'Sales v.s. Adver';
run; quit;
proc sgplot data=ex1_out1;
	series x=time y=Sales/lineattrs=(pattern=1 color=red);
	series x=time y=yhat/lineattrs=(pattern=1 color=blue);
	series x=time y=trendhat/lineattrs=(pattern=1 color=green);
	title 'Prediction of Sales';
run; quit;

/* Q2 ����ġ�� ���� */
data ex2;
	set ex2;
	time=_N_; /* �ð� ������ ��Ÿ���� �ε��� ���� ���� */
run;
proc autoreg data=ex2;
	model sales=expenditures population/nlag=1 method=ml dwprob;
	output out=ex2_out1 p=yhat pm=trendhat;
run; quit;
proc sgplot data=ex2_out1;
	scatter x=expenditures y=sales/markerfillattrs=(color=blue);
	scatter x=expenditures y=yhat/markerfillattrs=(color=blue) markerattrs=(symbol=circlefilled size=8);
	series x=expenditures y=trendhat/lineattrs=(pattern=1 color=green);
	title 'Sales v.s. Expenditures';
run; quit;
proc sgplot data=ex2_out1;
	scatter x=population y=sales/markerfillattrs=(color=blue);
	scatter x=population y=yhat/markerfillattrs=(color=blue) markerattrs=(symbol=circlefilled size=8);
	series x=population y=trendhat/lineattrs=(pattern=1 color=green);
	title 'Sales v.s. Population';
run; quit;
proc sgplot data=ex2_out1;
	series x=time y=sales/lineattrs=(pattern=1 color=red);
	series x=time y=yhat/lineattrs=(pattern=1 color=blue);
	series x=time y=trendhat/lineattrs=(pattern=1 color=green);
	title 'Prediction of Sales';
run; quit;

	
