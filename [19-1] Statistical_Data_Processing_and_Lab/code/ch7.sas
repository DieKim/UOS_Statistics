/* ��7��-1 ppt */

proc options; /* ���� �ý��� �ɼ� �α�â ��� */
run;
options nonumber nodate ls=80 formdlim='-'; /* ��¥X, �� ũ�� 80, '-'�� �������� ������ ���� */

data first;
set old;
proc print; /* data�ܰ�� ������ ������ ����� �ȵ�. run�� ������ ���� �ܰ踦 �����߸� �� ���ܰ� ���� */

title1'Project ? Core Institute of Statistics'; /* titlen -> n�� 1~ 10���� */
title3 'June 14, 2019'; /* LS ����Ʈ �ִ� 132�� */

title1'Project ? Core Institute of Statistics'; /* titlen -> n�� 1~ 10���� */
title3 'June 14, 2019'; /* LS ����Ʈ �ִ� 132�� */
title2 ; /* title3 ���� ���� */
/* footnoten = titlen */

/* filename : �ܺ� �ƽ�Ű ���� �ҷ����� ���� ���� */
/* FILENAME fileref(library ��Ģ, 8����) '���' ; */

filename child 'a:\family\children\eldest.txt'; /* ���ϸ���� ���� */
data teens;
infile child;
input sex age;
run; /* child�� �ҷ��� teens��� �������̸����� ���� */

filename child 'a:\family\children';
data teens;
infile child(eldest.txt); /* ��θ�(���ϸ�.Ȯ���ڸ�) */
input sex age;
run;

filename child 'a:\family\children\eldest.txt';
libname myfolder 'c:\teenage';
data myfolder.teens;
infile child;
input sex age;
run;

/* %include ���� : �ܺ� ������ �״�� �ҷ��� sas ���α׷��� ���� */
/* %include '���' ' */

data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run; /* ���⿡ �ܺ� ���� ������ �غ��� */

/* 1. �׳� �����ؼ� �ֱ� */
data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run;
PROC PLOT;
PLOT y*x;
QUIT;

/*2. %include ���� ��� */
data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run;
%include 'E:\�������\�ǽ�\plot.sas'; /* Ȯ���� ����� ���� */

filename myfolder 'E:\�������\�ǽ�';
data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run;
%include myfolder(plot.sas); /* .Ȯ���ڸ� ������ .sas�� �ν� */

filename myfolder 'E:\�������\�ǽ�\plot.sas';
data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run;
%include myfolder;

/* �߸� ���� ���� */

data scatter;
input x y;
cards;
%include ��c:\work\data.txt��;
run;
/* datalines ������ ���ڿ��� ������ �ڷ�� �����ϹǷ� �߸��� ǥ�� */
/* %include ������ ����ϰ� ������ ������ �ڷῡ datalines ������ �ְ� �ҷ��;��� */

data;
input x $;
datalines;
sung
moon
run;

/* ODS : ������޽ý���. sas��� ���� ���� */ 
ods pdf file = 'c:\�������\test.pdf'; /* pdf ������ ���� */
ods html file = 'c:\�������\test.htm'; /* html ������ ���� */
proc print; /* ����ϰ� ���� ���� */
run;
ods pdf close; /* �ݱ� */
ods html close; /* �ݱ� */

/* ��7��-2 ppt */

/* informat : �ڷ� �Է� ���� */

data one;
input @1 coust_type 4. @6 offer_date MMDDYY8. @15 item $8. @24 discount percent3.;
datalines;
1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%
run;
proc print data = one;
run;

/* ��7��-2 ppt */

/* informat : �ڷ� �Է� ���� */

data one;
input @1 coust_type 4. @6 offer_date MMDDYY8. @15 item $8. @24 discount percent3.;
format offer_date YYMMDD10.; /* data �ܰ迡�� format �����ϸ� ������ fix */
datalines;
1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%
run;
proc print data = one;
run;

/* ��7��-2 ppt */

/* informat : �ڷ� �Է� ���� */

data one;
input @1 coust_type 4. @6 offer_date MMDDYY8. @15 item $8. @24 discount percent3.;
datalines;
1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%
run;
proc print data = one;
format offer_date YYMMDD10.; /* proc �ܰ迡�� ����ϸ� �� �ܰ迡���� ���� */
run;

/* ������ ���� ���� : transpose */
/* proc transpose data = a
                              out = b
                             name = c
                           suf/prefix = d ;
     by ; 
     var ; <- ����Ʈ ���ں��� 
     id ;
     run;   */ 

data original;
input x y z @@;
cards; 
12 19 14
21 15 19
33 27 82
14 32 99
run;
proc transpose data = original out = transposed;
run;
title 'Original DATA';
proc print data = original;
run;
title 'Transposed Data';
proc print data = transposed;
run;

data old;
input subject time x @@;
cards;
1 2 12 1 4 15 1 7 19 2 2 17 2 7 14 3 2 21 3 4 15 3 7 18
run;
proc sort data = old;
by subject;
run;
proc transpose data = old out = new prefix = value; /* ���ο� ������ ���λ�� value ��� */
by subject; /* subject �������� ��ġ. ���� ������ ��ġ �ȵ� */
id time; /* ���ο� ������ time���� ���� �� */
run;
proc print data = old;
run;
proc print data = new;
run;

data origin;
input employee_id qtr1 qtr2 qtr3 qtr4 paid_by $ 20-40;
cards;
120265 . . . 25 Cash or Check
120267 15 15 15 15 Payroll Deduction
120269 20 20 20 20 Payroll Deduction
120270 20 10 5 . Cash or Check
120271 20 20 20 20 Payroll Deduction
run;
proc transpose data = origin out = trans; /* ���ں����� ��ġ �ȵ� */
run;
proc print data = trans noobs;
run;
proc transpose data = origin out = trans2;
var _all_;
run;
proc print data = trans2 noobs;
run;

proc sort data = origin;
by employee_id; /* by ����Ϸ��� sort �ܰ� ���� �ʼ� */
run;
proc transpose data = origin out = trans3;
by employee_id; /* by������ �������� ��ġ��. by������ ��ġ �ȵ� */
run;
proc print data = trans3;
run;

proc transpose data = origin out= trans4;
by employee_id;
var qtr1-qtr4; /* var���忡�� ������ ������ ��ġ */
run;
proc print data = trans4 noobs;
run;

proc transpose data = origin out = rotate2(rename=(col1=amount)) name = period; /* rename : ������ ���� �ɼ�, name : �� ������ �̸� */
by employee_id;
run;
proc print data = rotate2;
run;

proc freq data = rotate2; /* freq : �󵵼� ���� ��Ÿ���� ���ν��� */
tables period; /* period ������ ������ �м� */ 
run; /* _name_�� name �ɼ����� ���������� ����Ʈ label(Name of former variable)�� �״�� */

proc freq data = rotate2;
where amount ^= . ; /* amount�� ������ �ƴ� �� �߿��� freq */
tables period;
label period =''; /* _name_�� ����Ʈ �� ���� */
run;

data orion;
input customer_id order_month sale_amount @@;
label customer_id = "Coustomer ID";
cards;
5 5 478.00 5 6 126.80 5 9 52.50 5 12 33.80 10 3 32.60
10 4 250.80 10 5 79.80 10 6 12.20 10 7 163.29
run;
proc transpose data = orion out = annual_orders;
run;
proc print data = annual_orders noobs;
run;

proc sort data = orion;
by customer_id;
run;
proc transpose data = orion out = out;
by customer_id;
id order_month; /* �������� ���ο� ���������� ��� */
run;
proc print data = out;
run;










