/* ����1 Warpbreaks */

/* ������ �Է� */
data warpbreaks;
set "C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\warpbreaks.sas7bdat";
run; quit;
proc print; run;

/* ���Ƽ�ȸ�͸��� ���� */
proc genmod data=warpbreaks;
class wool tension;
model breaks=wool tension/dist=poi;
run; quit;

/* goodness of fit ���� by Deviance */
data dev_pval;
dev=210.3919;
df=50;
p_value=1-probchi(dev,df);
run;

proc print data=dev_pval;
title1 "Deviance statistic and p_value";
run; quit;

/* ����Ȯ�� Ȯ�� ���, �� ������ ���� ���� */
proc genmod data=warpbreaks;
class wool tension;
model breaks= wool | tension/dist=poi;
run; quit;

/* �ٽ� goodness of fit ���� by Deviance */
data dev_pval2;
dev=182.3051;
df=48;
p_value=1-probchi(dev,df);
run;

proc print data=dev_pval2;
title1 "Deviance statistic and p_value";
run; quit;  

/* �����׺����� �����ϰ� ���� ���� */
proc genmod data=warpbreaks;
class wool tension;
model breaks=wool | tension/dist=negbin;
run; quit;

/* goodness of fit ���� */
data dev_pval3;
dev=53.5064;
df=48;
p_value=1-probchi(dev,df);
run;

proc print data=dev_pval3;
title1 "Deviance statistic and p_value";
run; quit;  

/* ����� ���Ǽ� ����; �쵵�� ���� */
proc genmod data = warpbreaks; 
class wool tension; 
model breaks = wool tension /type3 dist = poi; /* Full model */ 
output out = full_model resdev = full_dev; 
run; quit;

proc genmod data = warpbreaks; 
class wool tension; 
model breaks = / type3 dist = poi; /* Only ���� model */ 
output out = int_model resdev = int_dev; 
run; quit;

data dev; 
merge full_model int_model; 
full_dev2 = full_dev**2; 
int_dev2 = int_dev**2; 
diff_dev = int_dev2 - full_dev2; /* Full �𵨰� ���� ���� ���� */
run; quit;
proc means data = dev sum; 
var diff_dev; 
output out = dev_out sum = sum; 
run; quit;

data lrt_pval; 
set dev_out; 
LRT = sum; 
df = 2; 
p_value = 1 - probchi(LRT,df); 
run;
proc print data=lrt_pval; 
title1 "LR test statistic and p-value"; 
run; quit;


/* ����2 Bike */

/* ������ �ҷ����� */
proc import datafile="C:\Users\USER\Desktop\����\3�г� 2�б�\ȸ�ͺм�2\SAS\bike.csv"
out=bike dbms=csv replace; getnames=yes;
run; quit;

/* �������� ������׷� */
proc sgplot data = bike; 
scatter X = dteday Y = cnt; /* �ð��� ���� �뿩 �� ������ */
run; quit;

proc univariate data = bike; 
histogram cnt; /* �뿩 �� ������׷� */
run; quit;

/* ���Ƽ�ȸ�͸��� */
proc genmod data = bike; 
class season yr mnth hr holiday weekday workingday weathersit; 
model cnt = season -- windspeed / dist = Poi type3; 
run; quit;

/* ���Ƽ�ȸ�͸��� + �������ù� */
proc hpgenselect data = bike; 
class season yr mnth hr holiday weekday workingday weathersit; 
model cnt = season -- windspeed / dist = poisson; 
selection method = stepwise(choose = aicc); 
run; quit;

/* �ٸ� ���� �Ͽ��� ���� ���� */
proc genmod data = bike; 
class season yr mnth hr holiday weekday workingday weathersit; 
model cnt = season -- windspeed / dist = negbin; 
run; quit;

/* ������ȸ�͸��� + �������� */
proc hpgenselect data = bike; 
class season yr mnth hr holiday weekday workingday weathersit;
model cnt = season -- windspeed / dist = negativebinomial; 
selection method = lasso(choose = aic); 
run;

/* mnth ������ ���� ���̺��� ���� �� �������� */
proc glmmod data = bike outdesign = design NOPRINT; 
class mnth; 
model cnt = season -- windspeed; 
run; quit;

proc hpgenselect data = design; 
class col2 col3 col4 col16 col17 col18 col19 col20; 
model cnt = col2 -- col24/ dist = negativebinomial; 
selection method = lasso(choose = bic); 
run; quit;

/* �ٸ� ������� ���̺��� ���� �� �������� */
data bike3; 
array dummies(12) mnth1 - mnth12 (12*0); 
set bike; if mnth ne . then dummies(mnth) = 1; 
output; if mnth ne . then dummies(mnth) = 0; 
run; quit;

proc hpgenselect data = bike3(drop = weathersit); 
class season yr hr holiday weekday workingday; 
model cnt = mnth1 -- windspeed; 
selection method = stepwise(choose = bic); 
run; quit;
