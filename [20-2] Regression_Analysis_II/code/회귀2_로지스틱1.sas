/* ����1 �Ż��� ������ ������ */

/* ������ �Է� */ 
data baby;
input bwght gage @@;
cards;
1 40 1 40 1 37 1 41 1 40 1 38 1 40 1 40 1 38 1 40 1 40 1 42 1 39
1 40 1 36 1 38 1 39 0 38 0 35 0 36 0 37 0 36 0 38 0 37
; run;
proc sort ; by descending bwght descending gage; run;
proc print; run;

/* ������ Ȯ�� */
proc gplot data=baby;
plot bwght * gage;
symbol v=dot i=none C=red;
run; quit;

/* ������ƽ ȸ��; �⺻ */
proc logistic data=baby;
model bwght=gage;
run; quit;

/* ������ƽ ȸ��; ���ؿ� ���� */
proc logistic data=a descending;
model bwght=gage;
run;
proc logistic data=a ;
model bwght(descending)=gage;
run;
proc logistic data=a;
model bwght(event='1')=gage;
run;
proc logistic data=a;
model bwght(ref='0')=gage;
run;

/* ������ƽ � */
proc logistic data=baby;
model bwght(ref="0")=gage;
output out=out lower=lower p=p upper=upper;
run; quit;

proc sort; by gage; run; /* �������� */
proc print; run;
proc gplot data=out;
plot (bwght p)*gage/overlay;
symbol1 v=star i=none C=red; /* ������ */
symbol2 v=circle i=join C=blue; /* ������ƽ � */
run; quit;

/* ����Ȯ���� �ŷڱ��� */
proc logistic data=baby;
model bwght(ref="0")=gage;
output out=out lower=lower p=p upper=upper/alpha=0.1; /* 90% �ŷڱ��� */
run; quit;

proc sort; by gage; run;
proc gplot data=out;
plot (lower p upper)*gage/overlay;
symbol1 v=none i=spline C=blue; /* �ŷ����� */
symbol2 v=none i=spline C=black; /* ����Ȯ��(������ƽ �) */
symbol3 v=none i=spline C=blue; /* �ŷڻ��� */
run; quit;

/* �з� by ������ƽ */
proc logistic data=baby;
model bwght(ref="0")=gage;
output out=out lower=lower p=p upper=upper;
run; quit;

data classfication;
set out;
if p>0.5 then Pr=1;
else Pr=0;
proc sort; by gage bwght;
proc print;
var gage bwght p Pr;
run;

proc freq;
tables bwght*Pr/nopercent norow nocol;
run; quit;

/* ���հῩ; Lack of Fit by ȣ����-���� ���� */
proc logistic data=baby;
model bwght(ref="0")=gage/lackfit;
run; quit;

/* ��������; ��������, �Ǿ���� */
proc logistic data=baby;
model bwght(ref="0")=gage;
output out=out reschi=pearson resdev=deviance p=p;
run; quit;
proc print; run;


/* ����2 �������� ������ */

/* ������ �Է� */
data death;
input Aggrav Race$ DeathY DeathN @@;
sum=deathy+deathn;
percent=deathy/sum; 
cards;
1 White 2 60 1 Black 1 181 2 White 2 15 2 Black 1 21
3 White 6 7 3 Black 2 9 4 White 9 3 4 Black 2 4
5 White 9 0 5 Black 4 3 6 White 17 0 6 Black 4 0
; run;
proc print; run;

/* ������ �������� ���� Ȯ���� �׷��� Ȯ�� */
proc gplot data=death;
plot percent*aggrav=race; /* race�� Ȯ�� ���� */
symbol1 v=circle i=join C=blue;
symbol2 v=star i=join C=red;
run; quit;

/* ������ƽ ȸ�͸��� ���� */
proc logistic data=death;
class race(ref="Black");
model deathy/sum=race aggrav;
output out=out lower=lower p=p upper=upper;
run; quit; 

/* �����, �ŷڱ��� Ȯ�� */
proc gplot data=out; /* ������  ����� */
plot p*aggrav=race/overlay;
symbol1 v=none i=spline C=blue;
symbol2 v=none i=spline C=red;
run; quit;

proc gplot data=out; /* �ŷڱ��� ���� */
plot (lower p upper)*aggrav/overlay;
symbol1 v=none i=spline C=black;
symbol2 v=none i=spline C=red;
symbol3 v=none i=spline C=black;
run; quit;

/* ���հῩ �� �������� */
proc logistic data=death;
class race(ref="Black");
model deathy/sum=race aggrav/lackfit;
output out=out p=p reschi=pearson resdev=deviance;
run; quit; 
proc print; run;
