/* 3�� ��Ȱ�� */

/* ����1 �ܼ�������Ȱ�� ���� ���� */

/* (1) ������ �ҷ�����; mindex.txt */
data mindex;
infile "C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\mindex.txt";
input mindex @@; 
date=intnx('month','1jan86'd,_n_-1); 
format date monyy.; run; 

/* (2) �ð迭�� Ȯ��; ��� ������ �ð��뺰�� �ٸ� -> �ܼ�������Ȱ�� */
proc sgplot data=mindex;
series x=date y=mindex;
run; quit;

/* (3) w=0.6�� �� ����������Ȱ��; w ���� by SSE �ּ� */
proc forecast data=stock
interval=month method=expo out=out1 outest=est1
weight=0.6 trend=2 lead=6 outfull outresid;
id date; var stock; run; quit;
proc print data=out1; run; /* ������ */
proc print data=est1; run; /* ��跮 */
proc sgplot data=out1; /* ����������Ȱ�� �ð迭�� */
series x=date y=stock/group=_type_;
where _type_^='RESIDUAL'; 
refline '01jan92'd/axis=x;
yaxis values=(100 to 1100 by 100); run; quit;
data out11; set out1; /* �������� */ 
  if _type_='RESIDUAL'; error=stock; run;
proc sgplot data=out11; /* ���������� �ð迭�� */
  series x=date  y=error;
  refline  0 / axis=y; 
  yaxis values=(-100 to 150 by 50); run;
proc arima data=out11; identify var=error; run; /* ������ �ڱ����� Ȯ�� */
proc univariate data=out11; var error; run; /* ������ �����跮 Ȯ�� */

/* �ܼ�������Ȱ�� �ð迭�� + ���������� �ð迭�� ���� ���� w=0.89 > w=0.2�� ��� */

/* ����2 ����������Ȱ�� ���� ���� */

/* (1) ������ �ҷ�����; stock.txt */
data stock;
infile "C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\stock.txt";
input stock @@; 
date=intnx('month','1jan84'd,_n_-1); 
format date monyy.; run; 

/* (2) �ð迭�� Ȯ��; �߼��� �ð��뺰�� �ٸ� -> ����������Ȱ�� */
proc sgplot data=stock;
series x=date y=stock;
run; quit;

/* (3) w=0.89�� �� �ܼ�������Ȱ��; w ���� by SSE �ּ� */
proc forecast data=mindex
interval=month method=expo out=out3 outest=est3
weight=0.89 trend=1 lead=6 outfull outresid;
id date; var mindex; run; quit;
proc print data=out3; run; /* ������ */
proc print data=est3; run; /* ��跮 */
proc sgplot data=out3; /* �ܼ�������Ȱ�� �ð迭�� */
series x=date y=mindex/group=_type_;
where _type_^='RESIDUAL'; 
refline '01may94'd/axis=x;
yaxis values=(0 to 30 by 5); run; quit;
data out33; set out3; /* �������� */ 
  if _type_='RESIDUAL'; error=mindex; run;
proc sgplot data=out33; /* ���������� �ð迭�� */
  series x=date  y=error;
  refline  0 / axis=y; 
  yaxis values=(-6 to 5 by 1);run;
proc arima data=out33; identify var=error; run; /* ������ �ڱ����� Ȯ�� */
proc univariate data=out33; var error; run; /* ������ �����跮 Ȯ�� */

/* �ܼ�������Ȱ�� �ð迭�� -> �� ���յ� ���ϴ� */
/* ���������� �ð迭�� -> �̺л꼺 ����, ���� �ʿ� */

/* ����3 Winters�� ����������Ȱ�� ���� ���� with �¹����� */ 

/* (1) ������ �ҷ�����; koreapass.txt */
data koreapass;
infile "C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\koreapass.txt";
input pass @@; 
date=intnx('month','1jan81'd,_n_-1); 
format date monyy.; run; 

/* (2) �ð迭�� Ȯ��; ��ȭ�ϴ� �����߼�+�����߼�+�̺л꼺 */
proc sgplot data=koreapass;
series x=date y=pass;
run; 

/* (3) ��������������Ȱ��; �񱳸� ���� */
proc forecast data=koreapass
  interval=month method=addwinters out=out4 outest=est4 /* ����; addwinters */
  weight=0.4 weight=0.1 weight=0.7 lead=12 seasons=12 /* w=(0.4, 0.1, 0.7) */
  outfull outresid;
  id date; var pass; run; 
proc print data=est4; run;
proc print data=out4; run;   
proc sgplot data=out4; /* ��������������Ȱ�� �ð迭�� */
  series x=date y=pass / group=_type_;
  where _type_^= 'RESIDUAL';
  refline '01jan90'd / axis=x; run; 
data out44; set out4;  
  if _type_='RESIDUAL'; error=pass;  run;
proc sgplot data=out44; /* ���������� �ð迭�� */
  series x=date  y=error;
  refline  0 / axis=y;  run;
proc arima data=out44; identify var=error; run; 
proc univariate data=out44; var error; run; 

/* (4) �¹�����������Ȱ�� */
proc forecast data=koreapass
  interval=month method=winters out=out5 outest=est5 /* �¹�; winters */
  weight=0.5 weight=0.1 weight=0.4 lead=12 seasons=12
  outfull outresid;
  id date; var pass; run;
proc print data=est5; run;
proc print data=out5; run; 
proc sgplot data=out5; /* �¹�����������Ȱ�� �ð迭�� */
  series x=date y=pass / group=_type_;
  where _type_^= 'RESIDUAL';
  refline '01jan90'd / axis=x; run; 
data out55; set out5;  
  if _type_='RESIDUAL'; error=pass;  run;
proc sgplot data=out55; /* ���������� �ð迭��; �������� ������ ������ ���� �Ҿ��� */
  series x=date y=error;
  refline 0 / axis=y; run;
proc arima data=out55; identify var=error; run; 
proc univariate data=out55; var error; run;  
