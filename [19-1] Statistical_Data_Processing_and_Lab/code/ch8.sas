/* ��8�� ppt */

/* ��ũ�� ��� : ��ũ�� ���� ����, ���� 
    sas���α׷� ������ ��ũ�� ������ �����ϰ� ����� �� �ִ�.
    ���ϴ� sas code�� �����ϱ����� ��ũ�����α׷��� ����� �� �ִ�. */

/* ��ũ���� ���� : �ڵ� ��ũ�� ����, ����� ���� ��ũ�� ���� */

data order_fact;
input customer_id @4 order_date DATE9.
@14 delivery_date DATE9. order_id order_type product_id
total_retail_price DOLLAR7.;
format order_date date9. delivery_date data9.; /* data�ܰ迡���� format������ ������ fix */
cards;
63 11JAN2003 11JAN2003 1230058123 1 220101300017 $16.50
5 15Jan2003 19JAN2003 1230080101 2 230100500026 $247.50
45 20JAN2003 22JAN2003 1230106883 2 240600100080 $28.30
41 28JAN2003 28JAN2003 1230147441 1 240600100010 $32.00
run;
footnote1 " Created &systime &sysday &sysdate9." ;
footnote2 " on the &sysscp System Using Release &sysver "; /* ���ڿ� �ȿ��� ��ũ�� ������ ����Ϸ��� �����ǥ ����ؾ� �� */
proc print data = order_fact noobs;
run;

/* ����� ���� ��ũ�� ���� ���� �� �� : %let variable = value ;
    1. �̹� �����ϴ� ������� ���� ������ ������ ��ü
    2. ���ڵ� ���ڷ� ���� 
    3. ��ҹ��� ���� 
    4. ����ǥ�� ����
    5. �յ� ���� ����
    6. ���Ŀ��� �״�� ����. ��� x  */

options validvarname = any;
options symbolgen; /* ��ũ�� ���� ������ �α�â�� ��� */
%LET year=2006; /* 2006 */
%LET city=Dallas, TX; /* Dallas, TX */
%LET fname= Marie ; /* Marie */
%LET name = ' Marie Budson '; /* ' Marie Budson ' */
%LET total=10+2; /* 10+2 */
TITLE "&year, &city, &fname, &name, &total" ;

%put _automatic_; /* �ڵ� ��ũ�� ������ ���� ���� �α�â ��� */
%put _user_; /* ����� ���� ��ũ�� ������ ���� ���� �α�â ��� */
%put _all_; /* ��� ��ũ�� ������ ���� ���� �α�â ��� */

/* proc plot */
data one;
do x=-3 to 3 by 0.1;
y = x**2;
output; /* y = x**2 ���� ������ ��� */
end;
run;
proc plot data = one; /* �׷��� �׷��ִ� ���ν��� �� �ϳ� */
title "Plot of Y=X**2";
plot y*x; /* �׷��� ��� */
run;

%macro draw(lower=, upper=, incr=, func=); /* ��ũ�� ���� �ڵ� �ۼ� */
data one;
do x = &lower to &upper by &incr;
y = &func;
output;
end;
run;
proc plot data = one;
title " Plot of Y=&func" ;
plot y*x;
run;
%mend draw; /* macro�� �����س��� �����鿡 ���� ��������. %mend�� �ᵵ �� */
%draw(lower = -3, upper = 3, incr = 0.1, func = x**2) );

/* proc reg */
data one;
input y x @@;
cards;
3 9 1 8 3 12
run;
data two;
input z x1 x2 @@;
cards;
16 3 8 12 5 3 20 4 6 17 7 9
run;
proc reg data = one ; /* ȸ�ͺм� ���ν��� */
model y = x ; 
run;
quit;
proc reg data = two;
model z = x1 x2 ;
run;
quit;

%macro reg(dep = , indep = , dataset = );
proc reg data = &dataset;
model &dep = &indep;
run;
quit;
%mend reg;
%reg(dep=y, indep = x, dataset = one);
%reg(dep=z, indep = x1 x2, dataset = two);

/* ttest - ���ؾȵ�*/

data sideways;
input x1-x10 trt $;
datalines;
4 6 5 7 5 7 6 4 3 5 trt1
6 5 5 8 7 6 7 8 6 7 trt2
run;
data ttest;
set sideways;
x=x1; OUTPUT;
x=x2; OUTPUT;
x=x3; OUTPUT;
x=x4; OUTPUT;
x=x5; OUTPUT;
x=x6; OUTPUT;
x=x7; OUTPUT;
x=x8; OUTPUT;
x=x9; OUTPUT;
x=x10; OUTPUT;
DROP x1-x10;
run;
proc print data = ttest;
run;

/* ���� */

data data1;
input y x @@;
cards;
4 8 9 12 5 10
run;
data data2;
input z z1 z2 @@;
cards;
12 7 3 15 8 3 17 5 2 16 4 2
run;

%macro reg(dataset = , dep=, indep= );
title1 "ȸ�ͺм�";
title2 "�������� : &dep, ������ : &indep";
proc reg data=&dataset;
model &dep = &indep;
run;
quit;
%mend; 
%reg(dataset = data1 , dep= y, indep=x );
%reg(dataset =data2 , dep=z, indep= z1 z2);

%macro simple(dset=, var=, stat=);
proc means data=&dset &stat;
title "Proc Means with statistics : &stat";
title2 "��Response Variable = &var";
var &var;
run;
%mend simple;
%simple (dset=data2, var=z2, stat=MEAN STD N);
%simple (dset=data1, var=y, stat=MAX MIN N);

%macro subject (var1=, crit=, ds_in=, ds_out=, compare= );
data &ds_out;
set &ds_in;
if &compare &crit then output;
run;
title "<�����ͼ� �̸� : &ds_out>";
proc print data=&ds_out;
run;

%mend subject;

data one;
input x1 x2 x3 y @@;
cards;
0.3 2 3 79 1.5 3 3 56 0.5 5 2 42 1.0 10 1 72
0.8 4 1 52 0.3 5 3 74 0.5 9 3 30 1.2 4 2 35
1.5 0 2 42 1.0 6 3 51 1.5 3 5 65 0.0 3 5 73
run;
%subset (var1=x1, crit=1, ds_in=one, ds_out=result1, compare=<);
%subset (var1=y, crit=75, ds_in=one, ds_out=result2, compare=>=);

/* ��ũ�� �ۼ��� 
   1. %macro name(�����̸� = , �����̸�2=, ....)��
   2. ��ũ�� ó���ϰ� ���� ���� �ۼ�. &���.
   3. %mend ����ؼ� &�� ���� */






 
