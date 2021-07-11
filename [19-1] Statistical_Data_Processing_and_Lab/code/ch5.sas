/* ��5��-4 ppt */

data test1;
input a x y @@;
select(a);
when(1) z = x+y;
when(2) z = x-y;
when(3) z = x*y;
when(4) z = x/y;
otherwise z = y/x; /* otherwise ���� ������ ����, otherwise�� �ۼ��� a=5,6�� �� ����ó�� */
end;
datalines; 
1 2 3 2 3 4 3 4 5 4 5 10 5 10 5 6 3 9 2 10 5
run;
 
data test2;
input a x y @@;
select(a+1);
when(1) do; /* ���๮ 2���̻� �̹Ƿ� do-end */
z = x+y;
zz = z*z;
end;
when(3) z= x*y;
otherwise; /* a+1�� 1,3�� �ƴϸ� z ���� */
end;
datalines;
0 1 2 1 2 3 2 3 4 5 4 3
run;

data test3;
input a b x y @@;
select(a);
when(1) do;
select(b);
when(-1) do;
c = x**3;
d = y**3;
end; /* do-end */
when(-2) c = x*x;
when(-3) d = y*y;
otherwise;
end; /* select-end */
end; /* do-end */
when(2) c = x*y;
when(3) d = x/y;
otherwise;
end; /* select-end */
datalines;
1 -1 1 2 1 -2 2 3 2 -1 3 4 3 -2 4 3 1 -3 3 4
run;

data namja;
set saram;
where sex = "male"; /* where - ���ϴ� ������ �б� */
run;

data namja; 
set saram;
if sex = "male"; /* if�� data�ܰ迡���� ��밡��. where�� �� ȿ���� */
run;

data metro; 
set saram;
where city in ('seoul', 'busan');
run;

data division; /* �и� 0�̸� ������ ���ϴ� ���α׷� */
input x y @@;
if y=0 then goto noway; /* label ���� - ������ ���� ��Ģ�� ����(32����) */
z=x/y;
noway: q = x+y; /* label���� �ݷ�(:)���� ���� �̸��� ���� */
datalines;
1 2 2 0 2 1
run;

data division;
input x y @@;
if y=0 then goto noway;
z = x/y;
return; /* goto + return = data�ܰ� ó������ */
noway: q = x+y;
datalines;
1 2 2 0 2 1
run;

data division;
input x y @@;
if y = 0 then link modify;
z = x/y; c = 'ok';
return; /* link�� �ȸ��� return�� data�ܰ� ó������ �̵� */
modify: x = x+1; y = y+1; /* y=0�̸� 1�� ���ؼ� 0���� Ż�� */
return; /* data�ܰ� �� ���� return�� �����ص� ������ ���. link�� ���� return�̹Ƿ� link���� ���ķ� �̵� */
datalines;
1 2 2 0 
run;

data division;
input x y @@;
if y=0 then return; /* y=0�̸� data�ܰ� ó������. z�� ���� */
z = x/y;
datalines;
1 2 2 0 2 1
run;
	
/* ��5��-5 ppt */

proc sort data = a;
by descending x y; /* x�� ��������, y�� �ø�����(����Ʈ) */
run;
proc sort data = b;
by descending x y;
run;
data test;
merge a b; /* merge - ���η� ����. ���� ���� vs ���� set - ���η� ����. ���� ���� */
by descending x y; /* ���� x,y�� �������� ����. proc sort �ܰ� �ʼ� */
run;

data phone; /* ���� ���� �����ϴ� ���α׷� */
input name $ area $ number;
datalines;
Sung 02 4169679
Moon 02 7976155
Oh 0341 876322
KETEL 02 3122868
Moon 02 7976155
Sung 02 4169679
run;
proc sort data = phone;
by name; /* ���� ���� �����Ϸ��� ���� ������ �̿��� �־���� */
run;
data phone;
set phone;
if oldname = name then delete; /* ù��° �������� oldname�� ������ */
oldname = name ; /* ���� ��� ù��° �������� Sung�� oldname���� �����. */
retain oldname; /* oldname ���� ���. �ٷ� �� �ܰ踸 ���. ���๮�� �ƴ� �������� ��ġ ��� ����. */
run;

proc sort nodupkey; /* data�ܰ��� retain�� ���� ����. ���� ���� ���� */
by name;
run;
proc sort nodup;
by name;
run;
proc sort noduplicates data = phone;
by name;
run;
proc print data = phone;
run;

data xequal0;
input x @@;
if x=0 then count + 1; /* count + 1 = count + (x=0) */
datalines;
0 4 0 9 0 5
run; /* x=0�� �ƴ� �������� count �� ����(count �ʱⰪ�� 0) */

data xequal0;
input x @@;
count = 0;
if x=0 then count = count + 1;
datalines;
0 4 0 9 0 5
run; /*�߸��� �ڵ�. ���� �ϳ��ϳ� �����غ��� count ���� ��� 0���� ���ϴϱ� �ȵ�. */
proc print data = xequal0;
run;

data phone;
input name $ area $ number $;
label area = "Area Code" number = "Phone Number"; /* label�� ��ĭ���� �ִ� 256�� */
cards;
Sung (02) 416-9679
Moon (032) 797-6155
run;
proc print; /* label ��� x */
run;
proc print data = phone label; /* label ����� ���� �� �ɼ� */
run;

data; /* ���� ���� number�� ���� �� ���ڰ� ��. ����-> �α�â�� �ڵ����� _error_=1 ��� */
input number code;
cards;
561105 1024511
270911 2025649
27a888 2307543
456983 1098324
run;
data; /* ���� ����� ���� ���� */
input number code;
if _error_ = 1 then stop;
cards;
561105 1024511
270911 2025649
27a888 2307543
456983 1098324
run;

data list;
input a b;
file print; /* data�ܰ� ���â ���, file����� put������ ¦�� */
if _N_=1 then put @21 'a' @31 'b' @40 '_N_' / @19 25*'-';
put @20 a @30 b @41 _N_; /* put������ ��� ���� ���� */
cards;
100 200
23 345
776 15
run; /* _N_=1�϶� if���� ������ ���� ��� + put ���� ������� �Ѵ� ���� */
data choose1;
set list;
file print;
if _N_=1 then put @21 'a' @31 'b' @40 'N' / @19 25*'-';
put @20 a @30 b @41 _N_;
if _N_=2 then delete;
run; /* put ������ ���� ����ż� ���� 3�� �� ���� */
proc print data = choose1;
run; /* 2��° ���� ���� */
data choose2;
set list;
file print;
if _N_=1 then put @21 'a' @31 'b' @40 'N' / @19 25*'-';
if _N_=2 then delete;
put @20 a @30 b @41 _N_;
run; /* ���� ���ź��� ����ż� _N_=2 ����._N_ = 1, 3 �� ���� */
proc print data = choose2;
run; /* 2��° ���� ���� */ 
/* ��, file print�� ��°� proc print�� ��� ���̰� ����. (put���� �������� ����) */
/* �ڵ����� _ERROR_�� _N_�� data �ܰ迡�� ����. proc �ܰ迡�� ��� �� �� */

proc print data = one;
var _all_; /* data = one�� ��� ���� ���. �ڵ����� ���� */
run;
data;
input a b;
file print;
put _all_; /* data�ܰ迡�� _all_�� ������ put ����� �Բ� ���, �ڵ����� ��� */
cards;
100 200
12d 300
300 234
run;

/* �нǰ� �Է� ��� 
1. ����/��� -> ��ħǥ(.)
2. ��,���� -> ��ĭ �Ǵ� ��ħǥ(.)
    �нǰ� ��� ���
1. ���� -> ��ħǥ(.)   ---> options missing=' '�� ���� ��ĭ���� ��� ���� 
2. ���� -> ��ĭ  */

data a;
input name $ sex;
cards;
Nolboo 0
sabangee .
. 1
run;
proc print data = a;
run;
data b;
input name $ sex;
infile datalines missover; /* �нǰ� ó�� */
cards;
Nolboo 0
sabangee .
. 1
run;
proc print data = b;
run;
data;
input name $ 1-8 sex 10;
datalines;
Nolboo   0
sabangee .
         1 
run;
proc print;
run;

/* data�ܰ� ���� ���� 
if string = " " then delete
if num = . then delete */
/* Ư�� ���� ���� ó�� 
if response = 9 then response = .
if response = 99 then response = */
/* Ư�� ���ڿ� �Ǵ� Ư�� ������ ����� ���� ���� ó��
if string = " I am null " then string = ""
if num > 100 then num =. */

/* �Ͽ��л�м� : �� ���������� 5���� ��� ǰ��(A,B,C,D,E) ��.. 
    �� ǰ������ 7�׷��� 12��� ��������� ���� ��Ȯ���� ����. */
data apple;
input variety $ yield @@;
datalines;
A 13 B 27 C 40 D 17 E 36
A 19 B 31 C 44 D 28 E 32
A 39 B 36 C 41 D 41 E 34
A 38 B 29 C 37 D 45 E 29
A 22 B 45 C 36 D 15 E 25
A 25 B 32 C 38 D 13 E 31
A 10 B 44 C 35 D 20 E 30
run;
data apple;
do variety = "A", "B","C","D","E"; /* A->B->C->D->E->A->B->C... �ݺ� */
input yield @@; 
output; /* input ������ output ��� */
end;
cards;
13 27 40 17 36
19 31 44 28 32
39 36 41 41 34
38 29 37 45 29
22 45 36 15 25
25 32 38 13 31
10 44 35 20 30
run;
proc print data = apple;
run;

/* ��ƾ���漳�� : ����ȸ�翡�� 4������ �ֹ��� A,B,C,D �� ���� �ڵ��� ���� ���Ϸ� ��.
    ����� �������� �ڵ��� �𵨿� ���� ���̰� �� �� �����Ƿ� �������� �ڵ��� ���� ��Ϻ����� ���
    ��ƾ��������� ������. */

data gasoline;
do driver=1 to 4; /* ������� 1�� ���ؼ� �ڵ��� �� 1,2,3,4 �� ������� 2�� ���ؼ� �ڵ��� �� 1,2,3,4 �ݺ� */
do car=1 to 4;
input gas $ km @@;
output; /* input ������ output ��� */ 
end;
end;
cards;
D 15.5 B 33.9 C 13.2 A 29.1
B 16.3 C 26.6 A 19.4 D 22.8
C 10.8 A 31.3 D 17.1 B 30.3
A 14.7 D 34.0 B 19.7 C 21.6
run;
proc print data = gasoline;
run;

/* ����ȭ��ϼ��� : �� ǰ���� �ῡ ���� 3���� �������� ȿ�� �� �м�. ������ ���� ���̰� ���� �� �����Ƿ�
���� �ٸ� ���� 4������ ���� �����ϰ� ������ 3����Ͽ� 100�˾� ���� �ɰ� �������� �Ѹ� �� ���� ���� ���� ������ ���� */

data soybean;
do insecide=1 to 3;
do block=1 to 4; /* ���� �ٸ� 4������ ������ ��� ���� */
input seedings @@;
output; /* input ���� output */
end;
end;
datalines;
56 49 65 60
84 78 94 93
80 72 83 85
run;

/* ȸ�ͺм� : ����� ����׿� ��ġ�� ���� �м��� ���� �α׸� ���� ������� ������� �Լ��� ���� ȸ�ͺм� */

data linear;
input sales ad;
logsales=LOG(sales);
datalines;
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

/* ȸ�ͺм�-�ݺ����� : ���� ���Ͽ� ���� ������ �ܷ��� �ۼ�Ƽ�� ����. ��� �ð��� ���� ������ �����߼� ����
    �̶� �ڷῡ�� ��� �ð��� ���� �ܷ� ���ҷ��� ���� ȸ���� ����ġ ������ ���� */

data cholorine;
infile datalines missover; /* ����Ƚ���� �ٸ��ϱ� */
input elapsed chlorpct @;
output;
do until(cholrpct=.);
input chlorpct @;
if chlorpct=. then return;
output;
end;
cards;
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
 




