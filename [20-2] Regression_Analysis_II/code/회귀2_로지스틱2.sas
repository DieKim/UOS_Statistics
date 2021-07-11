/* ����1 Donner ������ */

/* ������ �Է� */
data donner2;
set "C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\Donner2.sas7bdat";
run; quit;
proc print; run; 

/* ������ƽ ȸ��; ��������(Surv)�� ����(gender)�� ����(age)�� ����  */
proc logistic data=donner2;
class gender(ref="0");
model surv(ref="0")=gender age;
output out=out p=p;
run; quit;

/* ���� ������ƽ � */
proc sort; by age surv gender; run;
proc gplot data=out;
plot p*age=gender;
symbol1 v=dot i=join c=blue;
symbol2 v=dot i=join c=blue;
run;

/* ������ƽ ȸ��; gender=0 ��� 1�� ȿ���� �˱����� �ڵ� */
proc logistic data=donner2;
class gender (ref="0");
model surv=gender age/tech=newton;
run; quit;

/* ������ƽ ȸ��; �������ù� �� stepwise, �ݺ��� NR */
proc logistic data=donner2;
class gender (ref="0");
model surv=gender age/tech=newton selection=stepwise;
run; quit;

/* ������ƽ ȸ��; ��ȣ�ۿ� �߰� �� age�� ���� ����� ���ϱ� */
proc logistic data=donner2;
class gender (ref="0");
model surv=gender | age/tech=newton;
oddsratio gender/at (age=10 20 30);
run; quit; 


/* ����2 ingots ������ */

/* ������ �Է� */
data ingots; 
input Heat Soak r n @@; 
datalines; 
7 1.0 0 10 14 1.0 0 31 27 1.0 1 56 51 1.0 3 13 
7 1.7 0 17 14 1.7 0 43 27 1.7 4 44 51 1.7 0 1 
7 2.2 0 7 14 2.2 2 33 27 2.2 0 21 51 2.2 0 1 
7 2.8 0 12 14 2.8 0 31 27 2.8 1 22 51 4.0 0 1 
7 4.0 0 9 14 4.0 0 19 27 4.0 1 16 
; run; quit;

/* ������ƽ ȸ�� */
proc logistic data = ingots; 
model r / n = Heat Soak; 
run; quit;

/* ������ �Է�; �ٸ� ������� */
data ingots2; 
input Heat Soak NotReady Freq @@; 
datalines; 
7 1.0 0 10 14 1.0 0 31 14 4.0 0 19 27 2.2 0 21 51 1.0 1 3 
7 1.7 0 17 14 1.7 0 43 27 1.0 1 1 27 2.8 1 1 51 1.0 0 10 
7 2.2 0 7 14 2.2 1 2 27 1.0 0 55 27 2.8 0 21 51 1.7 0 1 
7 2.8 0 12 14 2.2 0 31 27 1.7 1 4 27 4.0 1 1 51 2.2 0 1 
7 4.0 0 9 14 2.8 0 31 27 1.7 0 40 27 4.0 0 15 51 4.0 0 1 
; run; quit;

/* �ٽ� ������ƽ ȸ�� */
proc logistic data=ingots2;
model notready=heat soak; freq freq;
run; quit;


/* ����3 �������� ������ */

/* ������ �Է� */
data dp2;
set "C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\dp.sas7bdat";
tot = deathn + deathy;
run; quit;
proc print; quit;

/* ������ƽ ȸ�� */
proc logistic data=dp2;
class race (ref="Black");
model deathy/tot = race aggrav; 
run; quit;

/* ������ ����Ȯ�� �׷��� */
proc logistic data=dp2;
class race (ref="Black");
model deathy/tot = race aggrav;
effectplot / at(race=all) noobs;
run; quit;

/* ���л����, �������, 95% wald �ŷڱ��� */
proc logistic data=dp2; 
class race(ref="Black");
model deathy/tot=race aggrav/covb rsquare clparm=wald;
run; quit;

/* �������ù�; forward, backward, stepwise */
proc logistic data=dp2;
class race(ref="Black");
model deathy/tot=race aggrav/selection=backward;
run; quit;

/* ���հῩ; ȣ����-���� ���� */
proc logistic data=dp2;
class race(ref="Black");
model deathy/tot=race aggrav/lackfit;
run; quit;

/* ��� ������ ���� ����ȭ �ݺ��� by NR */
proc logistic data=dp2;
class race(ref="Black");
model deathy/tot=race aggrav/tech=newton;
run; quit;

/* ��������� �𵨸� */
proc logistic data=dp2;
class race(ref="Black");
model deathy=race aggrav;
run; quit;


/* ����4 ���� ��� ������ */

/* ������ �Է� */
data smoke; 
input cancer smoke @@; 
cards; 
1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 
0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 
0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 
1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 
0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 
0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 
0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 
; run; quit;

/* ����ǥ, �����, ������� */
proc freq data=smoke;
tables smoke*cancer/relrisk;
run; quit;

/* ������ƽ ȸ�� */
proc logistic data=smoke;
class smoke;
model cancer=smoke;
run; quit;

/* ������ �߰� ���� */
data smoke2;
input cancer smoke @@;
cards;
1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 
0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 
0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 
0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 
0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 
1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 
0 0 0 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 
1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 
; run; quit;

/* �߰��� �������� ����ǥ, �����, ������� */
proc freq data=smoke2;
tables smoke*cancer/relrisk;
run; quit;


/* ����5 CLASS ������ */

/* ������ �Է� */
data class;
set "C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\class.sas7bdat";
run; quit;

/* ������ƽ ȸ�� by Lasso, ���� AIC */
proc hpgenselect data=class;
model sex(event="��") = height weight age / dist = binary;
selection method = lasson (choose = AIC) details = all;
run; quit;

/* ������ƽ ȸ�� by Lasso, ���� cv */
proc hpgenselect data=class; 
model sex(event="��") = height weight age / dist=binary; 
selection method=lasso(choose=validate) details = all; 
partition fraction(validate = 0.1); 
run; quit;
