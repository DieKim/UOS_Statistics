/* 9�� : SQL procedure */

/* 1. PROC SQL : sas���ν����� data step�� �Ϻ� ��� ���� ����. ������ ������ ó�� �� �м� ����  
       - ��� ��跮 ����/���� �ۼ� 
       - ������ �˻�, ����, ����
       - ��/Į�� �߰�, ����, ���� */

/* 2. PROC SQL �⺻ ����
proc sql options;
select Į����
from ���̺��
where �˻� ����
group by Į������ ������ �м�
order by ����ȭ ; 
quit; 
->�� �����ݷ� 3��

select * : ��ü Į�� ����
select a,b,c : �޸�(,)�� ����
select A label='����', B format=����, ���� as C from ���̺�� : ex) sum(A) as B from table

where name in ("Kim", "Dahee") : "kim"�̳� "Dahee"�� ������ �ุ ����
where name like "KimDahee" : "KimDahee" �� �ุ ����

order by a b [desc] : a�� ��������, b�� ������������ ����

group by, order by : sort �ܰ� ���� �ʿ�x. �׳� by�� �ƴ϶� ���� �ٸ�. ������ ���

proc sql ~~~;
run; : ��� ���డ��
quit; : �ִ°� ���� */

/* �⺻ ���� */
title1 '*** sqlug1: User guide chapter 1 examples***';
data employee;
input empnum empname $ empyears empcity $ 20-34
emptitle $ 36-45 empboss;
cards;
101 Herb 28 Ocean City president .
201 Betty 8 Ocean City manager 101
213 Joe 2 Virginia Beach salesrep 201
214 Jeff 1 Virginia Beach salesrep 201
215 Wanda 10 Ocean City salesrep 201
216 Fred 6 Ocean City salesrep 201
301 Sally 9 Wilmington manager 101
314 Marvin 5 Wilmington salesrep 301
318 Nick 1 Myrtle Beach salesrep 301
401 Chuck 12 Charleston manager 101
417 Sam 7 Charleston salesrep 401
;
run;
proc print data = employee;
run;
proc sql;
title2 "City and years of service";
select empname, empcity, empyears
from employee /* sas���ϸ� ���� */
where emptitle = "salesrep" ; /* �˻� ���� */
quit;

/* �����ܰ踦 �ϳ��� sql�� ǥ���ϱ� */
proc sql;
title2 "city and years of service";
title3 "Computed with proc sql";
select empcity, sum(empyears) as totyears /* empyears�� ����  totyears��� ���ο� Į������ */
from employee
where emptitle='salesrep'
group by empcity /* empcity�� ���� �з� */
order by totyears; /* totyears �������� */
quit; 

title2 "city and years of service";
title3 "Computed with proc sql";
proc summary data = employee; /* from table employee */
where emptitle='salesrep'; /* where emptitle = 'salesrep' */
class empcity; /* group by empcity */
var empyears; /* sum("empyears") */
output out=sumyears sum=totyears; /* sum(empyears) as "totyears" */
run; /* �־��� ���� �Ͽ� sum(A) as B�� proc summary ������ �̿� */
proc sort data = employee;
by totyears; /* order by totyears */
run;
proc print data = sumyears noobs; /* proc sql�� print �������� ���� */
var empcity totyears; /* select empcity, totyears */
where _type_=1; /* _type_������ class�� �з������� ����� ����� �ڵ�����. _type_=0�� ��ü�ڷ�, _type_=1�� �з������� 1���϶� �� ���� ���� */
run;

/* view�� ���� : view�� ������ ���̺�� ���� ���̺���� �޸� �ڷḦ �����ϰ� ���� ����.
 ->create view _viewname_ as ~~; */

proc sql;
title2 'Employees who reside in ocean city';
title3 " ";
create view ocity as
select empname, empcity, emptitle, empyears
from employee
where empcity='Ocean City';
proc print data = ocity; /* create���� print�ȵ�. ���� proc print */
sum empyears; /* empyears�� �հ赵 ��� */
run;

/* Į�� ���� */
data paper;
input author$ section$ title$ time TIME5. duration; /* �Է����� */
format time TIME5.; /* �������->���� fix in data step */
label title='Paper Title';
cards;
KIM TEST Plan 9:35 35
LEE TEST Start 8:30 20
PARK TEST Color 15:20 45
;
run;

title1 "  ";
proc sql;
select *
from paper; /* ��� Į�� ��� = proc print */

proc sql;
select author, title, time, duration, time + duration*60 as endtime 
from paper;
/* endtime�� ��������� �ο����ؼ� ����Ʈ�� �ʴ����� ��µɰ���. �д����� ���������ϱ� *60�� �ؼ� �ʴ����� ������. sas�� �ð��� �ʴ����� �ν�. */

proc sql;
select author, title, time, duration label='how long it takes', time + duration*60 as endtime format=time5.
from paper;
/* duration��� �� ���. endtime ���� time5.�÷� ����. sas�� �ð��� �ʴ����� �ν���. �д����� �ν��Ϸ��� *60�������. */

proc sql;
select author, title, time, duration label = 'how long it takes', time + duration*60 format =time5.
from paper
where time < '12:00't; /* time�� �ð����������� '�ð�'t ���·� �˻�

/* table�� ���� : create������ ��� �� ��. ���̺귯�� Ȥ�� select * from ���� Ȯ�� */

create table p2 like paper; /* paper�� Į�� �̸��� ������ table ����. �ο�(������) ����. */

create table p3 as 
select *
from paper
where time > '12:00't; /* where ������ �����ϴ� �ο츦 ������ table ���� */

create table count(section CHAR(20), paper NUM); quit; /* Ư�� Į���� ������ table ���� */

/* ������ �����ϱ� : �߰��ϴ� Į���� ������ values ���� ���� �����ؾ���. ���̺� �����ϴ� Į������ �߰��ϴ� Į���� ������ ������ ������. 
   insert into~values;
  create table~insert into~select~from
  create table~insert into~values */ 

proc sql;
insert into paper(author, title, time)
values('jost','Foreign','11:15't);
select * from paper; /* ������ ������ paper ��� output ��� */

proc sql;
create table counts(section CHAR(20), papers NUM); /* ���̺� ����. ������ ������ ���� */
insert into counts /* ������ �������� */
select section, COUNT(*) from paper /* paper���� sectionĮ���� COUNT�Լ��� ���� ī��Ʈ�� ����� �ο�� ���� */
group by section; /* section Į�� ���� ���� �׷�ȭ �Ǿ� �����Ƿ� section ���� ���� ���������� ���� ī��Ʈ �� */
select * from counts; /* ��� ��� */

proc sql;
create table counts(section CHAR(20), papers NUM);
insert into counts 
values('TESTING',3)
values('',1);
select * from counts; /* ���� ������ ���� ���� by insert into-values('','',''); */

/* ������ �����ϱ� : delete from~where ;*/

proc sql;
delete from counts
where section is null;
select * from counts;

proc sql;
delete from counts
where papers=(select min(papers) from counts); /* where �������� select �� ���. papers���� ���� ���� ���� ���� */
select * from counts;

/* 8��: ��ũ�� �Լ� */

/* ��ũ�� �Լ��� %��, ��ũ�� ������ &�� ��� */

/* ��ũ�� ����
1. �ڵ� ��ũ�� ���� : sysdate,sysdata9.sysday,systime,sysscp,sysver
2. ����� ���� ��ũ�� ���� : %let���� ����
-�̹� �����ϴ� ������ ���ο� ���������� ��ü
-���ڵ� ���ڷ� ���� 
-��ҹ��� �����ؼ� ���� 
-����ǥ�� ������ ����
-�յ� ������ ����
-���� �����ϰ� �״�� ���� */

/* ��ũ�� ���� ���� */

data order_fact;
input customer_id @4 order_date DATE9.
@14 delivery_date DATE9. order_id order_type product_id
total_retail_price DOLLAR7.;
format order_date DATE9. delivery_date DATE9.;
cards;
63 11JAN2003 11JAN2003 1230058123 1 220101300017 $16.50
5 15Jan2003 19JAN2003 1230080101 2 230100500026 $247.50
45 20JAN2003 22JAN2003 1230106883 2 240600100080 $28.30
41 28JAN2003 28JAN2003 1230147441 1 240600100010 $32.00
;
run;
footnote1 "created &systime &sysday, &sysdate9";
footnote2 "on the sysscp system using release &sysver"; /* ���ڿ� �ȿ��� ��ũ�� ���� ����Ϸ��� �����ǥ ����� */
proc print data = order_fact noobs;
run;

options symbolgen; /* ��ũ�� ������ ����� ������ �α�â ��� */
options symbolgen mprint mlogic; /* mprint�� ������ �� ����� �뵵. ��𿡼� ������ ������ �α�â���� Ȯ�� ���� */

%put _automatic_; /* �ڵ���ũ�κ��� ���� �α�â ��� */
%put _user_; /* �����������ũ�κ��� ���� �α�â ��� */
%put _all_; /* ��� ��ũ�κ����� ���� ���� �α�â ��� */

/* ��ũ�� �Լ� */

/* proc plot(sgplot) */
data one;
do x=-3 to 3 by 0.1;
y=x**2;
output; /* do ������ run�� �� �����ϱ� output�������� �߰��� ��� �ʿ� */ 
end;
run;
proc plot data = one;
title "plot of y=x**2";
plot y*x;
run;

%macro draw(lower, upper, incr, func);
data one;
do x=&lower to &upper by &incr;
y=&func;
output;
end;
proc plot data = one;
title "plot of y=&func";
plot y*x;
run;
%mend draw;
%draw(lower=-3, upper=3, incr=0.1, func=x**2);
%draw(lower=0, upper=4, incr=0.05, func=exp(-x));

/* proc reg */
data one;
input y x @@;
datalines;
3 9 1 8 3 12
;
run;
data two;
input z x1 x2 @@;
datalines;
16 3 8 12 5 3 20 4 6 17  79
;
run;
proc reg data = one;
model y = x;
run;
quit;
proc reg data = two;
model z= x1 x2;
run;
quit;

%macro reg(dset, dep, indep);
proc reg data = &dset;
model &dep=&indep;
run;
quit;
%mend reg;
%reg(dset=one, dep=y, indep=x);
%reg(dset=two, dep=z, indep=x1 x2);

/* ttest */

data sideways;
input x1-x10 trt $;
cards;
4 6 5 7 5 7 6 4 3 5  trt1
6 5 5 8 7 9 7 8 6 7 trt2
;
run;
data ttest;
set sideways;
x= x1; output;
x= x2; output;
x= x3; output;
x= x4; output;
x= x5; output;
x= x6; output;
x= x7; output;
x= x8; output;
x= x9; output;
x= x10; output;
drop x1-x10;
run;
proc print data =ttest;
run;

%macro tr(num=);
%do j=1 %to &num;
x=x&j; output;
%end;
drop x1-x&num;
%mend tr;
data ttest;
set sideways;
%tr(num=10);
run;

proc ttest data = ttest; /* proc ttest�� ���� �����ͼ� ���� ttest ����. �����ͼ� ����� �������� ��ũ�� �Լ� �̿� */
class trt;
var x;
run;

/* proc reg */
data data1;
input y x @@;
cards;
4 8 9 12 5 10
;
run;
data data2;
input z z1 z2 @@;
cards;
12 7 3 15 8 3 17 5 2 16 4 2 
;
run;
%macro reg(dset, dep, indep);
title1 " ȸ�ͺм� ";
title2 " �������� : &dep, ������ : &indep ";
proc reg data = &dset;
model &dep=&indep;
run;
quit;
%mend reg;
%reg (dset=data1, dep=y, indep=x);
%reg (dset=data2, dep=z, indep=z1 z2);

/* proc means */

%macro simple(dset, var, stat);
proc means data = &dset &stat;
var &var;
run;
%mend simple;
%simple (dset=data2, var=z2, stat=MEAN STD N);
%simple (dset=data1, var=y, stat=MAX MIN N);

/* %macro subset */

data one;
input x1 x2 x3 y @@;
cards;
0.3 2 3 79 1.5 3 3 56 0.5 5 2 42 1.0 10 1 72
0.8 4 1 52 0.3 5 3 74 0.5 9 3 30 1.2 4 2 35
1.5 0 2 42 1.0 6 3 51 1.5 3 5 65 0.0 3 5 73
;
run;

%macro subset(var1, crit, ds_in, ds_out, compare);
data &ds_out;
set &ds_in;
if &var &compare &crit then output;
run;
title " <�����ͼ¸� : &ds_out> ";
proc print data=&ds_out;
run;
%mend subset;

%subset (var1=x1, crit=1, ds_in=one, ds_out=result1, compare=<);
%subset (var1=y, crit=75, ds_in=one, ds_out=result2, compare=>=);


/* 7-2�� */

/* informat ���� 
<$>informat<w>.<d>
1. $8. outdoors -> outdoors
2. 5. 12345 -> 12345
3. comma7. dollar7. $12,345 -> 12345
4. comma7. dollarx7. $12.345($12,345) -> 12345(12.345)
5. percent3. 15% -> 0.15
6. MMDDYY6./8./10 010160 -> 0
7. DDMMYY6.8.10. 31/12//60 -> 365
8. date7. 31DEC59 -> -1
9. date9. 31DEC1959 -> -1 8?

/* informat ���� 

1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%

=> input @1 cust_type4. @6 offer_date MMDDYY8. 
    @15 item $8. @24 discount percent3.;

�̶� sas�ý��� ������ ��¥�� Ư�� ������ �����ϰ� ����.

1960�� 1�� 1�� = 0

ex) 2007�� 3�� 2�� 
(2007-1960)*365.25 + 31 + 28 + 22 + 2 = xxxxx.xx
�̷������� ��갪 ������ �Ҽ��� ������ ������ ���ؼ� �Է�. */

data one;
input @1 cust_type 4. @6 offer_date MMDDYY8.
@15 item $8. @24 discount PERCENT3.;
format offer_date YYMMDD10.; /* data �ܰ迡�� format ������ ���ϸ� ��������� ���������� fix �� */
cards;
1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%
run;

proc print data = one;
format offer_date9.; /* proc �ܰ迡�� format ������ ���ϸ� �ش� ���ν��� �������� �Ͻ������� ���� */
run;

/* proc transpose ���� : ��� ���� ��ġ. ������ ���� �ٲٴ� ����
proc  transpose data = 
                            out =
                        name =  ��ġ�� �������� ������        
                  pre/suffix =  ������ ��/�ڿ� �ٴ� ����      ;
by ���غ���. ��� ��ġ �ȵ�. �̸� ���� �ʿ� ;
var ����Ʈ�� ���ں����� ��ġ. ���ں����� Ư�� ��ġ ���� �����Ҷ� ;
id �������� ���������� ����ϰ���� �� ;
run; */

data original;
input x y z @@;
cards;
12 19 14
21 15 19
33 27 82
14 32 99
;
run;
proc transpose data = original out=transposed;
run;
title 'original data';
proc print data = original;
run;
title 'transposed data';
proc print data = transposed;
run;

data old;
input subject time x @@;
cards;
1 2 12 1 4 15 1 7 19 2 2 17 2 7 14 3 2 21 3 4 15 3 7 18
;
run;
proc sort data =old;
by subject;
run;
proc transpose data = old out = new prefix = value; /* ������ ���λ�� ����. ���⼭�� Ư�� ID ���忡�� ������ ������ �տ� ���� */
by subject; /* by���� ��ü�� ��ġ���� ���� */
id time; /* time ������ ���������� ���� */
run;
proc print data = new;
run;

data origin;
input employee_id qtr1-4 paid_by $20-40;
cards;
120265 . . . 25 Cash or Check
120267 15 15 15 15 Payroll Deduction
120269 20 20 20 20 Payroll Deduction
120270 20 10 5 . Cash or Check
120271 20 20 20 20 Payroll Deduction
run;
proc transpose data = origin out=trans;
run; /* var���� �����Ƿ� ���ڸ� ��ġ. ���ں����� ��ġ��Ű���� var���� �߰� */

proc sort data = origin;
by employee_id;
run;
proc transpose data= origin out=trans2;
by employee_id; /* by������ ���� sorting �Ǿ� �־�� �� */
run;
proc print data = trans2 noobs;
run;
proc transpose data = origin out=trans3;
by employee_id;
var qtr1-qtr4;
run;
proc print data = trans3;
run;

/* ������ �ٲٱ� : out=data(rename=(col1=new_col)) �ɼ� ���
 proc transpose data = origin out = rotate(rename=(col1=amount)) name = period;
 by employee_id;
 run; */

proc freq data = rotate; /* �󵵼� ���� �����ִ� ���ν��� */
tables period;
run; /* _name_�� ���������� ����Ʈ ��(name of former variable)�� �״�� */

proc freq data = rotate;
where amount NE .;
tables period;
label period=' ';
run;

data q;
input a b c @@;
label a="customer ID";
label b="order_month" c="sale_amount";
cards;
5 5 478.00 5 6 126.80 5 9 52.50 5 12 33.80 10 3 32.60
10 4 250.80 10 5 79.80 10 6 12.20 10 7 163.29
;
run;
proc transpose data = q out = x;
run;
proc print data = x noobs;
run; /* ��ġ�� ������ �¿��� label �ɼ��� ��� label ��µ� */
proc transpose data=q out=y;
by a;
id b; /* ���ں����� "_������"�� ���������� ��. */
run;

/* 7-1�� */

/* �ּ� ���� */ 
* �ּ����� ;

/* options ���� 
number/nonumber : ������ ��ȣ
date/nodate : ��¥ ��� 
ls : 64~256
pageno=n : ��������� ���� ��ȣ
ps=n : ������ ���� �ִ� ����. ���� ps=60
errors=n : ����Ʈ 20
missing='chracter' : ���ں��� ������ ��� ����. ����Ʈ (.).
center/nocenter : outputâ ��µ� �� ���Ĺ��. put���� ��¿��� ���� x 
notes/nonotes : �����޽��� logâ ��� ���� �ɼ�. nonotes�ϸ� �۾� �ҿ� �ð� ����.
formdlim : ������ ������ ���� �ɼ� */

proc options; run; /* ���� �ý��� �������� �α�â ��� */
options nonumber nodate ls=80 formdlim='-'; /* formdlim�� ������ ���� �ɼ�. �ѱ��� �ƴ� ���� 1�� ���� ���� */
options number date ls=132 formdlim='';  /* ����Ʈ */

/* run; : run������ ������ ��μ� �� �� �ܰ� ���� */

/* title, footnote ���� : �ѹ� �����Ǹ� ��� �μ� ��. */

/* endsas ���� : ���α׷� ������ ������ ���ÿ� sas �ý��� ���� */

/* filename ���� : �ܺ� �ƽ�Ű���� �о���̴� ���� ����. ����� ���̺귯�� ��Ģ�� ����. 8����. */

filename child '��a:\family\children\eldest.txt'; /* ���ϸ���� ���� */
data teens;
infile child; /* eldest.txt ������ teens�� ���� */
input sex age ;
run;

filename child 'a:\family\children';
data teens;
infile teens(eldest.txt); /* ��θ�(���ϸ�) */
input sex age;
run;

data teens;
infile 'a:\family\children\eldest.txt';
input sex age;
run;

filename child 'a:\family\children\eldest.txt';
libname myfolder 'c:\teenage';
data myfolder.teens;
infile child;
input sex age;
run;

/* %include ���� : �ܺ� ���� �״�� �о���϶� ��� */

data scatter;
input x y @@;
cards;
 1 2 3 4 5 6 0 1 2 3
 ;
 run;
/* ������ ���� �ܺ� sas���α׷� ���� plot.sas�� �����Ѵٰ� ����.
 proc plot ;
 plot y*x;
 quit; */

 data scatter;
input x y @@;
cards;
 1 2 3 4 5 6 0 1 2 3
 ;
 run;
 %include "E:\�������\�ǽ�\plot.sas"; /* ���� �Ȱ��� */

 filename myfolder "E:\�������\�ǽ�";
data scatter;
input x y @@;
cards;
 1 2 3 4 5 6 0 1 2 3
 ;
 run;
 %include myfolder(plot.sas); /* Ȯ���ڸ� �����ϸ� .sas�� �ν� */

  filename myfolder "E:\�������\�ǽ�\plot.sas";
  data scatter;
input x y @@;
cards;
 1 2 3 4 5 6 0 1 2 3
 ;
 run;
 %include myfolder;

 /* �߸��� ���� : �����Ͷ��� �ڿ� �ٷ� �����ϸ� ���ڿ��� �ν��ϹǷ� �� ��.*/
 data scatter ;
 input x y;
 datalines;
 %include "c:\work\data.txt";
 run; /* ����!*/

 /* ��������� ���� �ڷῡ datalines ������ �߰��ؼ� �����ؼ� ��°�� ���� */

 /* ������޽ý��� ODS : sas ������� ���� 
 -listing : outputâ �ؽ�Ʈ ���. ����Ʈ. ������ �۲�
 -printer : �μ�� ��� . ������ �۲� 
 -pdf : adobe ����. pdf ���
 -html : �������� �Խÿ� html ���
 -rtf : ���� ������ ���Կ� ��� */

 data ;
 input x $;
 cards;
 sung
 moon
;
run;

ods pdf file = '���' ;
ods html file = '���';
proc print;
run; /* ����ϰ����ϴ� ���� */
ods pdf close;
ods html close;

/* by ���� :1) �ڷḦ ����ȭ�ϰų� 2)���� ���� ���� ������ �м��� �� ���.
           sort ���� -> ����ȭ
  �� �� ��� ���� -> ������ �м�. sort �ܰ� ���� �ʼ� */

DATA accident;
INPUT country $ city $ month number;
DATALINES;
Korea Seoul 1 5024
France Paris 2 1200
Korea Seoul 2 4214
France Paris 3 2354
Korea Busan 3 1347
Korea Seoul 4 6635
Korea Busan 4 987
France Paris 4 3308
Korea Seoul 5 3375
Korea Busan 5 334
France Paris 5 893
RUN;
PROC PRINT DATA=accident;
RUN; 
PROC SORT DATA=accident; /* sort -> ����ȭ. country �������� �� ����� city �ټ��� */
BY country city;
RUN;
PROC PRINT DATA=accident;
BY country; /* sort �̿��� ���ν���. country �� ���� ������ ��� */
RUN;
PROC PRINT DATA=accident;
BY country city; /* sort �̿��� ���ν���. country, city �� ���� ������ ��� */
RUN; 
PROC PRINT DATA=accident;
BY city;
RUN; /* city�� �ֿ켱 ������ �ƴϹǷ� ���� */

/* class : �з����� ���� 
    model : �м����� ����.
  �� ������ �Բ� ���̸� ������ class������� ����� */

/* id ���� : obs ��� ����ڰ� ���� Ȯ�ο� ���� ����. obs ��� �ȵ�. */
proc print data= accident;
id country;
var _all_; /* id ������ �ٽ� ���Ե����Ƿ� 2�� ��� */
run;

/* label ���� : 256�ڱ��� ���� ����. ���� �������� �ᵵ �ǰ� �Ѱ��� �� �ᵵ ��. */

proc print label; /* �ɼ� ���� */
run;

proc print split='*'; /* label ���� ���� ���� */
label numer="*a*b*c";
run;

/* output out= keyword= ; */

/* quit ���� : plot, anova, glm, reg, sql �� ��ȭ�� ���� �������� ���. */

/* where ���� : ������ �����ϴ� ���� ����. 
 2�� �̻� ���� ������ where~; where also~; Ȥ�� where ~and~; */

/* ������ �Է� ������ */

/* �Ͽ��л�м� : 5������ ������� ��Ȯ��  ���� */

data apple;
input variety $ yield;
cards;
A 13
A 19
A 39
?
E 25
E 31
E 30
;
run;
proc print ;
run;
data apple;
input variety $ yield @@;
cards;
A 13 B 27 C 40 D 17 E 36
A 19 B 31 C 44 D 28 E 32
A 39 B 36 C 41 D 41 E 34
A 38 B 29 C 37 D 45 E 29
A 22 B 45 C 36 D 15 E 25
A 25 B 32 C 38 D 13 E 31
A 10 B 44 C 35 D 20 E 30
;
run;
proc print;
run;
data apple;
do variety = 'A','B','C','D','E';
input yield @@;
output; /* do���� �ݺ��ǹǷ� �߰��� output���� �ʿ� */
end;
cards;
13 27 40 17 36
19 31 44 28 32
39 36 41 41 34
38 29 37 45 29
22 45 36 15 25
25 32 38 13 31
10 44 35 20 30
;
run;

/* ��ƾ���漳�� : 4���� �ֹ����� ���� �ڵ��� ���� ��. �������� �ڵ��� �� ��Ϻ��� */

data gasoline;
do driver 1 to 4;
 do model 1 to 4;
 input gas $ km @@;
 output;
 end;
end;
cards;
D 15.5 B 33.9 C 13.2 A 29.1
B 16.3 C 26.6 A 19.4 D 22.8
C 10.8 A 31.3 D 17.1 B 30.3
A 14.7 D 34.0 B 19.7 C 21.6
run;

/* ����ȭ��ϼ��� : �� ǰ���� �ῡ���� 3���� ������ ȿ�� ��. ���� ���ȭ�ؼ� ������ ���� �� */

data soybean;
do insecide= 1 to 3;
do block= 1 to 4;
input seedings @@;
output;
end;
end;
cards;
56 49 65 60
84 78 94 93
80 72 83 85
run;

/* ȸ�ͺм� : ����� ����׿� ��ġ�� ���� �м�. �α׿� ���� �Լ� */

data linear;
input sales ad;
logsales = log(sales);
cards;
2.5 1.0
2.6 1.6
2.7 2.5
5.0 3.0
5.3 4.0
9.1 4.6
14.8 5.0
17.5 5.7
23.0 6.0
28.0 7.0
run;

/* ȸ�ͺм�(�ݺ�����) : �����Ͽ� ���� ���� �ܷ��� �ۼ�Ƽ��. ����ȸ���� ����ġ ���� ���� */

data chlorine;
infile datalines missover; /* ������ ���͵� �Է�����Ʈ �������� �Ѿ�� ���� */
input elapsed chlorpct @;
output;
do until(chlorpct=.) /* ����ġ�� ���ö����� �ݺ� */;
input chlorpct @; /* ����ȸ���� ����ġ �����ϱ� */
if chlorpct=. then return; /* ����ġ�� ������ �ٽ� ó������ */
output; /* end������ ���� ��� */
end;
datalines;
8 0.49 0.49
12 0.46 0.46 0.45 0.43
16 0.44 0.43 0.43
20 0.42 0.42 0.43
24 0.42 0.40 0.40
28 0.41 0.40
32 0.41 0.40
36 0.41 0.38
40 0.39
run;





 






