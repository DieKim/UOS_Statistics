/* 1�� */
data project_a;
barx= 65; mu=64; var=8; n=25;
Z=(barx-mu)/(sqrt(var)/sqrt(n));
num=probit(0.975); 
if (abs(Z)>abs(num)) then h="�͹����� �Ⱒ";
else h="�͹����� ä��";
scope=2*(1-cdf('normal',Z,0,1));
label num="�Ⱒ��";
label scope="����Ȯ��";
label h="ä�ÿ���";
run;
proc print data = project_a label;
run;

data project_b;
barx= 65; mu=64; var=8; n=25;
Z=(barx-mu)/(sqrt(var)/sqrt(n));
num=probit(0.95);
if (Z>num) then h="�͹����� �Ⱒ";
else h="�͹����� ä��";
scope=1-cdf('normal',Z,0,1);
label num="�Ⱒ��";
label scope="����Ȯ��";
label h="ä�ÿ���";
run;
proc print data = project_b label;
run;

data project_c;
barx= 65; mu=64; var=10; n=25;
T=(barx-mu)/(sqrt(var)/sqrt(n));
num=tinv(0.975,n-1);
if (abs(T)>abs(num)) then h="�͹����� �Ⱒ";
else h="�͹����� ä��";
scope=2*(1-cdf('T',T,n-1));
label num="�Ⱒ��";
label scope="����Ȯ��";
label h="ä�ÿ���";
run;
proc print data = project_c label;
run;

data project_d;
barx= 65; mu=64; var=10; n=25;
T=(barx-mu)/(sqrt(var)/sqrt(n));
num=tinv(0.95,n-1);
if (T>num) then h="�͹����� �Ⱒ";
else h="�͹����� ä��";
scope=cdf('T',T,n-1);
label num="�Ⱒ��";
label scope="����Ȯ��";
label h="ä�ÿ���";
run;
proc print data = project_d label;
run;

/* 2�� */
data project_e(drop=i);
do i=1 to 100;
sample= rand("normal",5,2);
output;
end;
run;
proc univariate data=project_e normal plots;
histogram sample/normal;
run;

